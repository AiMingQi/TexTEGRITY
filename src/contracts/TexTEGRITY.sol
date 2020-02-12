pragma solidity ^0.6.1;

contract TexTEGRITY {
    string textHash;

    //Write Function
    function set(string memory _textHash) public {
        textHash = _textHash;
    }

    //Read Function
    function get() public view returns (string memory) {
        return textHash;
    }
}
