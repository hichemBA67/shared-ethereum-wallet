pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "./Allowance.sol";

contract SharedWallet is Allowance {
    using SafeMath for uint;

    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _address, uint _amount);
    
    mapping(address => uint) public fundsWithdrawn;
    mapping(address => uint) public fundsSent;

    function renounceOwnership() public override onlyOwner {
        revert("Renounce ownership unavailble");
    }

    function receiveMoney() public payable {
        fundsSent[msg.sender] = fundsSent[msg.sender].add(msg.value);
        emit MoneyReceived(msg.sender, msg.value);
    }

    function viewBalance() public view returns(uint) {
        return address(this).balance;
    }

    function viewAllowance(address _address) public view onlyOwner returns(uint) {
        return allowance[_address];
    }

    function viewMyAllowance() public view returns(uint) {
        return allowance[msg.sender];
    }

    
    function withdrawFundsToOtherAdress(address payable _to, uint _amount) public ownerOrAllowed(_amount){
        require(address(this).balance >= _amount, "Not enough funds stored in this Smart Contract");
        if(owner() != msg.sender){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    function withdrawFunds(uint _amount) public ownerOrAllowed(_amount) {
        require(address(this).balance >= _amount, "Not enough funds stored in this Smart Contract");
        if(owner() != msg.sender){
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(msg.sender, _amount);
        payable(msg.sender).transfer(_amount);
    }

    receive() external payable {
        receiveMoney();
    }

}