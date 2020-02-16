pragma solidity ^0.6.0;

import './SafeMath.sol';
import './TexTEGRITY.sol';

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

  function listBookForSale(string memory _title, string memory _bookMeta, uint256 _amount) OnlyFullWhiteListed public {
      TexTEGRITY book = new TexTEGRITY(_title, msg.sender, _bookMeta, _amount);
      __addBook(address(book), msg.sender, _bookMeta, block.timestamp, true);
  }

  function whiteListAuthor(address _author, string memory _author_name) OnlyOwner public {
    author_whitelist[_author] = AuthorListing(true, false, 0, _author_name);
  }

  function blackListAuthor(address _author) OnlyOwner public {
    author_whitelist[_author].isListed = false;
    author_whitelist[_author].isActive = false;
  }

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

  }

}
