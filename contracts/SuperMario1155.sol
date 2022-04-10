//SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;
import "./ERC1155.sol";

contract SuperMario1155 is ERC1155 {

    string public name;
    string public symbol;
    uint256 public tokenId;
    
    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function uri(uint256 _tokenId) public view returns(string memory){
        return _tokenURIs[_tokenId];
    }

    function mint(uint256 amount, string memory tokenURI) public {
        require(msg.sender != address(0), "minting to zero address not allowed");
        tokenId += 1;
        _balances[tokenId][msg.sender] += amount;
        _tokenURIs[tokenId] = tokenURI;
        emit TransferSingle(msg.sender, address(0), msg.sender, tokenId, amount);
    }

    function supportsInterface(bytes4 interfaceId) public pure override returns(bool) {
        return (interfaceId == 0xd9b67a26 || interfaceId == 0x0e89341c);
    }


}