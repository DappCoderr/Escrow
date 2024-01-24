// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow{
    address public payer;
    address public receiver;
    address public arbiter;
    bool public isApproved;

    enum State{Created, Locked, Released, InDispute};
    State public state;

    emit Approved(uint);

    constructor(address payable _receiver, address _arbiter){
        payer = msg.sender;
        receiver = _receiver;
        arbiter = _arbiter;
        state = State.Created;
    }

    function release() external payable{
        require(msg.sender == arbiter);
        uint balance = address(this).balance;
        (bool sent, ) = receiver.call{value:balance}("");
        require(sent, "Failed to send ether");
        isApproved = true;
        state = State.Released;
        emit Approved(balance);
    }
}