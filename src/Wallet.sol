// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


contract Wallet {

    address public owner;

    event Deposit(address indexed ownerOfTheWallet, uint256 amount);
    event Withdraw(address indexed ownerOfTheWallet, uint256 amount);
    event Send(address indexed sender, address indexed receiver, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value>0, "Must be bigger than 0");
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public payable {
        require(owner==msg.sender, "Only owner can withdraw");
        require(address(this).balance > amount, "Balance must be bigger than amount");

        (bool success, ) = payable(owner).call{value: amount}("");

        require(success, "Failed to withdraw");

        emit Withdraw(owner, amount);
    }

    function send(uint256 amount, address payable receiver) public payable {
        require(owner==msg.sender, "Only owner can send money");
        require(address(this).balance > amount, "Balance must be bigger than amount");

        (bool success, ) = receiver.call{value: amount}("");

        require(success, "Failed the transaction");

        emit Send(owner, receiver, amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable{
        emit Deposit(owner, msg.value);
    }
}