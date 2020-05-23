pragma solidity ^0.4.23;

import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v1.6.0/contracts/token/ERC20/StandardToken.sol";
import "https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v1.6.0/contracts/ownership/Ownable.sol";

contract SEI is StandardToken,Ownable{
    string public name = "SEI Token v0.2";
    string public symbol = "SEI0.2";
    uint public decimals = 18;
    
    struct Pesonal_data{
        uint256 amount;
        uint term;
        uint256 locktime;
        uint256 tokenAmount;
    }
    
    uint256 public remaining_token = 0;
    
    mapping(address=>Pesonal_data) public memolized_data;
    
    constructor(uint _initial_supply) public {
        totalSupply_ = _initial_supply;
        remaining_token = _initial_supply;
    }
    
    function lockDrop(uint _term) public payable checkAmount {
        //Pesonal_data data = Pesonal_data(msg.value,_term,blocktime.add(_term days));
        Pesonal_data memory data = Pesonal_data(msg.value,_term,block.timestamp.add(5 minutes),msg.value);
        memolized_data[msg.sender] = data;
        
    }
    
    function unlockDrop() public checkTime {
        msg.sender.transfer(memolized_data[msg.sender].amount);
        balances[msg.sender] = memolized_data[msg.sender].tokenAmount;
        remaining_token = remaining_token - memolized_data[msg.sender].tokenAmount;
    }
    
    modifier checkTime(){
        require(memolized_data[msg.sender].locktime < block.timestamp);
        _;
    }
    
    modifier checkAmount(){
        require(msg.value > 0);
        _;
    }
}

