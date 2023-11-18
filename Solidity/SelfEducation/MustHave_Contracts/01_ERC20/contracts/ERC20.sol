// SPDX-License-Identifier: NONE
pragma solidity ^0.8.0;

contract ERC20 {
    string private tName;
    string private tSymbol;
    uint8 constant private tDecimals = 18;
    address public tOwner;

    uint public tSupply;
    mapping(address => uint) private balances;
    mapping(address => mapping(address => uint)) private approvals;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Minted(uint256 indexed _value);
    event Burned(uint256 indexed _value);

    constructor(uint _initialAmount, string memory _name, string memory _sym) {
        tName = _name;
        tSymbol = _sym;
        tSupply = _initialAmount;
        balances[msg.sender] = _initialAmount;
        tOwner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == tOwner, "not an owner");
        _;
    }

    modifier validAddress(address _address) {
        require(address(0) != _address, "invalid address");
        _;
    }

    function mint(uint _amount) public onlyOwner {
        tSupply += _amount;
        unchecked { // if it didn't fail on previous line, it won't here also
            balances[msg.sender] += _amount;
        }
        emit Minted(_amount);
    }

    function burn(uint _amount) public onlyOwner {
        balances[msg.sender] -= _amount;
        unchecked { // if it didn't fail on previous line, it won't here also
            tSupply -= _amount;
        }
        emit Burned(_amount);
    }

    function name() public view returns (string memory) {
        return tName;
    }

    function symbol() public view returns (string memory) {
        return tSymbol;
    }

    function decimals() public pure returns (uint8) {
        return tDecimals;
    }

    function totalSupply() public view returns (uint256) {
        return tSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool success) {
        require(msg.sender != _to, "`from` == `to`");
        return _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool success) {
        require(_from != _to, "`from` == `to`");
        approvals[_from][msg.sender] -= _value;
        return _transfer(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(_value <= balances[msg.sender], "not enough tokens");
        approvals[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
       return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return approvals[_owner][_spender];
    }

    function _transfer(address _from, address _to, uint256 _value) private returns (bool success) {
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from,  _to, _value);
        return true;
    }
}
