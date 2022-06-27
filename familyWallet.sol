
pragma solidity ^0.8.0;

//using safe math 

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "hardhat/console.sol";

interface ERC20 {
    function totalSupply() external view returns (uint _totalSupply);
    function balanceOf(address _owner) external view returns (uint balance);
    function transfer(address _to, uint _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint _value) external returns (bool success);
    function approve(address _spender, uint _value) external returns (bool success);
    function allowance(address _owner, address _spender) external view returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

}

contract familyWallet  {
    // define the super owner of the wallet (aka mom)
    // add owners to wallet (aka kids)
    // set allowance for the owners (pocket money)
    // remove owners (dramatic disown)
    address public _superOwner ;
    mapping (address => uint) public _allowances;
    mapping (address => bool)  public _validOwners;

    //setting superowner
    constructor() public {
        _superOwner = msg.sender;
        _validOwners[_superOwner] = true;
    }
    modifier onlySuperOwner() {
        require(msg.sender == _superOwner);
        _;
    }
    modifier onlyValidOwners() {
        require(_validOwners[msg.sender] == true);
        _;
    }
    //adding owner to the family wallet
    function addOwner(address _address) public onlySuperOwner{ 
        _validOwners[_address] = true;
    }
    //remove owner from family wallet
    function removeOwner(address _address) public onlySuperOwner {
        _validOwners[_address] = false;
    }
    function addMoney() public payable onlySuperOwner {
        _allowances[msg.sender] += msg.value;
    }
    //transfer money from the super owner to the individual owner
    function giveAllowance(address _address, uint allowance) onlySuperOwner public {
        require(_allowances[_superOwner] > allowance); 
        _allowances[_address] += allowance;
        _allowances[_superOwner] -= allowance;
    } 
