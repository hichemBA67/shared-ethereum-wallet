pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Allowance is Ownable{

    using SafeMath for uint;

     event AllowanceChanged(address indexed _forWho, address indexed _byWhom, uint _oldAmount, uint _newAmount);

    mapping(address => uint) public allowance;

    modifier ownerOrAllowed(uint _amount) {
        require(owner() == msg.sender || allowance[msg.sender] >= _amount, "Not enough funds");
        _;
    }

    //  Changes allowance to certain value
    function changeAllowance(address _address, uint _amount) public onlyOwner {
        emit AllowanceChanged(_address, msg.sender, allowance[_address], _amount);
        allowance[_address] = _amount;
    }
    //  Increases allowance by certain value
    function increaseAllowance(address _address, uint _amount) public onlyOwner {
        emit AllowanceChanged(_address, msg.sender, allowance[_address], allowance[_address].add(_amount));
        allowance[_address] = allowance[_address].add(_amount);
    }
    //  Decreases allowance by certain value
    function decreaseAllowance(address _address, uint _amount) public onlyOwner {
        emit AllowanceChanged(_address, msg.sender, allowance[_address], allowance[_address].sub(_amount));
        allowance[_address] = allowance[_address].sub(_amount);
    }
    // Reduces allowance (Internal)
    function reduceAllowance(address _address, uint _amount) internal {
        emit AllowanceChanged(_address, msg.sender, allowance[_address], allowance[_address].sub(_amount));
        allowance[_address] = allowance[_address].sub(_amount);
    }
}



