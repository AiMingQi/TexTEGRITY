pragma solidity ^0.5.2;

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
