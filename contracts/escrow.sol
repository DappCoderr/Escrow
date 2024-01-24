// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

contract Escrow{
    address public payer;
    address public receiver;
    address public arbiter;
    State public state; 

    enum State{Created, Locked, Released, InDispute}

    constructor(address _receiver, address _arbiter){
        payer = msg.sender;
        receiver = _receiver;
        arbiter = _arbiter;
        state = State.Created;
    }
}