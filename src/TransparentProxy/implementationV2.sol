// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title ImplementationV2.
 * @author Gaurang Bharadava
 * @notice This is simple ERC20 implementation built from scratch but incomplete implementation.
 * @notice This code is only for learning purpose, kindly do not use this in production.
 */
contract ImplementationV1 {
    string public name;
    string public symbol;

    uint256 totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function getName() external view returns (string memory) {
        return name;
    }

    function getSymbol() external view returns (string memory) {
        return symbol;
    }

    function mint(address _to, uint256 _amount) public {
        require(_to != address(0));
        require(_amount != 0);
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function transfer(address _to, uint256 _amount) public {
        require(_to != address(0));
        require(_amount != 0);
        require(balanceOf[msg.sender] >= _amount);
        balanceOf[_to] += _amount;
        balanceOf[msg.sender] -= _amount;
    }

    function approve(address _to, uint256 _amount) public {
        require(_to != address(0));
        require(_amount != 0);
        allowance[msg.sender][_to] += _amount;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public {
        require(_amount != 0);
        require(_to != address(0));
        require(allowance[_from][msg.sender] >= _amount);
        require(balanceOf[_from] >= _amount);
        allowance[_from][msg.sender] -= _amount;
        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;
    }

    function burn(uint256 _amount) public {
        require(_amount != 0);
        require(balanceOf[msg.sender] >= _amount);
        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;
    }

    function burnFrom(address _from, uint256 _amount) public {
        require(_from != address(0));
        require(_amount != 0);
        require(balanceOf[_from] >= _amount);
        require(allowance[_from][msg.sender] >= _amount);
        allowance[_from][msg.sender] -= _amount;
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }
}
