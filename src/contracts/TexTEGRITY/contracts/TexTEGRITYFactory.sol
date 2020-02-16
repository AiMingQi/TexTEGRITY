pragma solidity ^0.6.0;

import './math/SafeMath.sol';
import './TexTEGRITYBook.sol';

contract TexTEGRITYFactory {
  using SafeMath for uint256;

    modifier OnlyOwner {
      require(msg.sender == owner, "Owner Must Call this Function");
      _;
  }

  modifier OnlyFullWhiteListed {
      require(author_whitelist[msg.sender].isListed && author_whitelist[msg.sender].isActive, "You must be whitelisted to add publications");
      _;
  }

  modifier OnlyListed {
      require(author_whitelist[msg.sender].isListed, "Author must be listed");
      _;
  }

  struct Book {
      address contract_ref;
      address author;
      string bookMeta;
      uint256 added_on;
      bool is_viewable;
  }

  struct AuthorListing {
    bool isListed;
    bool isActive;
    uint256 listingSlots;
    string name;
  }

  uint256 listingSlotCost;
  address owner = msg.sender; // to-do: turn this into a multisig ref
  mapping(address => AuthorListing) author_whitelist;
  mapping(address => Book[]) books_by_author;

  constructor(uint256 _listing_cost) public {
    listingSlotCost = _listing_cost;
  }

  function __addBook(address _book_ref, address _author, string memory _bookMeta, uint256 _added_on, bool is_viewable) private {
      books_by_author[msg.sender].push(Book(_book_ref, _author, _bookMeta, _added_on, is_viewable));
  }

  // View Functions //

  function isAuthorListed(address _author) public view returns (bool) {
      return author_whitelist[_author].isListed;
  }

  function isAuthorActive(address _author) public view returns (bool) {
      return author_whitelist[_author].isActive;
  }

  function authorSlots(address _author) public view returns (uint256) {
      return author_whitelist[_author].listingSlots;
  }

  function listingCost() public view returns(uint256) {
      return listingSlotCost;
  }


  // Author Management //

  function whiteListAuthor(address _author, string memory _author_name) OnlyOwner public {
    author_whitelist[_author] = AuthorListing(true, false, 0, _author_name);

    emit AuthorWhitelisted(_author, _author_name);
  }

  function blackListAuthor(address _author) OnlyOwner public {
    author_whitelist[_author].isListed = false;
    author_whitelist[_author].isActive = false;

    emit AuthorBlacklisted(_author, author_whitelist[_author].name);
  }

  // Author Functions //
  function listBookForSale(string memory _title, string memory _bookMeta, uint256 _amount) OnlyFullWhiteListed public {
      author_whitelist[msg.sender].listingSlots = author_whitelist[msg.sender].listingSlots.sub(1);
      TexTEGRITYBook book = new TexTEGRITYBook(_title, msg.sender, _bookMeta, _amount);
      __addBook(address(book), msg.sender, _bookMeta, block.timestamp, true);

      if (author_whitelist[msg.sender].listingSlots <= 0) {
         author_whitelist[msg.sender].isActive = false;
      }

      emit BookListed(address(book), msg.sender, _amount);
  }

  // Author can Purchase Slots //
  function purchaseSlots() OnlyListed payable public returns(uint256){

      uint256 slot_number = msg.value.div(listingSlotCost);

      require(slot_number > 0, "Not enough for slot purchase");

      uint256 total_bill = slot_number.mul(listingSlotCost);

      author_whitelist[msg.sender].listingSlots = slot_number;
      author_whitelist[msg.sender].isActive = true;

      // return Remainder if non-even amount sent
      if (total_bill < msg.value) {
          msg.sender.transfer(msg.value.sub(total_bill));
      }

      emit SlotsPurchased(msg.sender, slot_number);

  }

  event AuthorWhitelisted(address _author, string _name);
  event AuthorBlacklisted(address _author, string _name);
  event SlotsPurchased(address _author, uint256 _number);
  event BookListed(address _contract_ref, address _author, uint256 _amount);


}
