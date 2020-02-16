pragma solidity ^0.6.0;

import './math/SafeMath.sol';

contract TexTEGRITYBook {
    using SafeMath for uint256;

    string textHash;
    string title;
    address author;
    uint256 amount;
    address controller;
    uint256 addedOn;

    modifier OnlyController {
        require(msg.sender == controller, "Only Controller Can Modify");
        _;
    }

    modifier MustBeInStock {
        require(amount > 1, "Out of Stock");
        _;
    }

    constructor (string memory _title, address _author, string memory _textHash, uint256 _amount) public {
        title = _title;
        textHash = _textHash;
        author = _author;
        amount = _amount;
        controller = msg.sender;
        addedOn = block.timestamp;
    }

    // Sell Functions

    function sellOne() OnlyController MustBeInStock public {
        amount = amount.sub(1);
    }

    function reStock(uint256 _amount) OnlyController public {
        amount = amount.add(_amount);
    }


    // Public Read Functions
    function getMeta() public view returns (string memory) {
        return textHash;
    }

    function getAuthor() view public returns(address) {
        return author;
    }

    function getTitle() view public returns(string memory) {
        return title;
    }
}
