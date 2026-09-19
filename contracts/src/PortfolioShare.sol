// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "./interfaces/IERC20.sol";
import {Errors} from "./libraries/Errors.sol";

contract PortfolioShare is IERC20 {
    string public name;
    string public symbol;
    uint8 public constant decimals = 18;
    uint256 public override totalSupply;
    address public owner;
    address public minter;

    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;

    event MinterConfigured(address indexed minter);

    constructor(string memory shareName, string memory shareSymbol, address initialOwner) {
        if (initialOwner == address(0)) revert Errors.ZeroAddress();
        name = shareName;
        symbol = shareSymbol;
        owner = initialOwner;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert Errors.NotOwner();
        _;
    }

    modifier onlyMinter() {
        if (msg.sender != minter) revert Errors.NotMinter();
        _;
    }

    function setMinter(address newMinter) external onlyOwner {
        if (minter != address(0)) revert Errors.AlreadyConfigured();
        if (newMinter == address(0)) revert Errors.ZeroAddress();
        minter = newMinter;
        emit MinterConfigured(newMinter);
    }

    function transfer(address to, uint256 value) external override returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external override returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external override returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        if (allowed != type(uint256).max) {
            allowance[from][msg.sender] = allowed - value;
        }
        _transfer(from, to, value);
        return true;
    }

    function mint(address to, uint256 value) external onlyMinter {
        _mint(to, value);
    }

    function burn(address from, uint256 value) external onlyMinter {
        _burn(from, value);
    }

    function _mint(address to, uint256 value) internal {
        if (to == address(0)) revert Errors.ZeroAddress();
        totalSupply += value;
        balanceOf[to] += value;
        emit Transfer(address(0), to, value);
    }

    function _burn(address from, uint256 value) internal {
        balanceOf[from] -= value;
        totalSupply -= value;
        emit Transfer(from, address(0), value);
    }

    function _transfer(address from, address to, uint256 value) internal {
        if (to == address(0)) revert Errors.ZeroAddress();
        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
    }
}
