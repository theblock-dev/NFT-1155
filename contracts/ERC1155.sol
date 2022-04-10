//SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

contract ERC1155 {

    mapping(uint256 => mapping(address => uint256)) internal _balances;
    mapping(address => mapping(address => bool)) internal _operatorApprovals;

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approvd);
    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);

    function balanceOf(address account, uint256 id) public view returns(uint256) {
        require(account != address(0), "ERC1155: address zero is not a valid owner");
        return _balances[id][account];        
    }

    function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view returns(uint256[] memory){
        require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
        uint256[] memory batchBalances = new uint256[](accounts.length);

        for(uint256 i=0;i<accounts.length;i++){
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }
        return batchBalances;
    }

    function isApprovedForAll(address owner, address operator) public view returns(bool) {
        return _operatorApprovals[owner][operator];

    }

    function setApprovalForAll(address operator, bool approved) public {
         require(msg.sender != operator, "ERC1155: setting approval status for self");
         _operatorApprovals[msg.sender][operator] = approved;
         emit ApprovalForAll(msg.sender, operator, approved);
    }

    function safeTransferFrom(address from, address to, uint256 id, uint256 amount) public {
        require(from == msg.sender || isApprovedForAll(from,msg.sender), "caller is not owner nor approved");
        require(to != address(0), "ERC1155: transfer to the zero address");
        _transfer(from, to, id, amount);
        emit TransferSingle(msg.sender, from, to, id, amount);
        require(_checkOnERC1155Received(), "Receiver is not implemeneted");
    }

    function _transfer(address from, address to, uint256 id, uint256 amount) private {
        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "insufficient balance for transfer");
        

        _balances[id][from] = fromBalance - amount;
        _balances[id][to] += amount;
    }

    function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts) public  {
        require(from == msg.sender || isApprovedForAll(from,msg.sender), "caller is not owner nor approved");
        require(to != address(0), "ERC1155: transfer to the zero address");
        require(ids.length == amounts.length, "ERC1155: accounts and ids length mismatch");

        for(uint256 i=0; i< ids.length; i++){
            uint256 id = ids[i];
            uint256 amount = amounts[i];
            _transfer(from, to, id, amount);
        }

        emit TransferBatch(msg.sender, from, to, ids, amounts);
        require(_checkOnBatchERC1155Received(), "Receiver is not implemeneted");
    
    }

    //this is just a dummy implementation
    function _checkOnERC1155Received() private pure returns(bool) {
        return true;
    }

    function _checkOnBatchERC1155Received() private pure returns(bool) {
        return true;
    }

    function supportsInterface(bytes4 interfaceId) public pure virtual returns(bool){
        return (interfaceId == 0xd9b67a26);
    }



}