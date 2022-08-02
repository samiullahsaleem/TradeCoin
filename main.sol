// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract TradeCoin{

    address public minter;

    mapping(address => uint) public balances;
    mapping(address => uint) public seizeamount;
    constructor()
    {
        minter = msg.sender;
    }

    error inSufficientBalance(uint requested, uint availble);


    function mint(address reciever, uint amount) public
    {

        require(minter==msg.sender);
        balances[reciever]+=amount;
    }

    function siezeCoins(address victim) public
    {
        require(msg.sender==minter);
        seizeamount[victim] +=balances[victim];
        balances[victim] -=balances[victim];
    }

    bool allow = false;

    function allowCoins(address victim) public 
    {
        require(minter == msg.sender);
        allow = true;
    }

    function releaseCoins(address victim) public
    {
        require(msg.sender==minter && allow == true);
        balances[victim] +=seizeamount[victim];
        seizeamount[victim] -=seizeamount[victim];
    }


    function send(address reciever, uint amount) public
    {
        if(amount > balances[msg.sender])
        {
            revert inSufficientBalance({
                requested: amount,
                availble: balances[msg.sender]
            });
        }

        balances[msg.sender] -= amount;
        balances[reciever] +=amount;
    }

}
