// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Escrow{
    address public payer;
    address public receiver;
    address public arbiter;
    bool public isApproved;

    enum State{Created, Locked, Released, InDispute};
    State public state;

    event FundReleased(address indexed receiver, uint amount);
    event FundDeposited(address indexed payer, uint amount ) 

    constructor(address payable _receiver, address _arbiter){
        payer = msg.sender;
        receiver = _receiver;
        arbiter = _arbiter;
        state = State.Created;
    }

    modifier notInState(State _state) {
        require(state != _state, "Invalid state");
        _;
    }

    function deposit() payable external notInState(State.Locked){
        require(msg.sender == payer);
        emit FundDeposited(payer, msg.value)
        state = State.Locked;
    }

    function release() external payable{
        require(msg.sender == arbiter);
        uint balance = address(this).balance;
        (bool sent, ) = receiver.call{value:balance}("");
        require(sent, "Failed to send ether");
        isApproved = true;
        state = State.Released;
        emit FundReleased(receiver, balance);
    }
}