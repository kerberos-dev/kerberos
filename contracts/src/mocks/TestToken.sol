// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PortfolioShare} from "../PortfolioShare.sol";

contract TestToken is PortfolioShare {
    constructor() PortfolioShare("Test Asset", "TST", msg.sender) {}

    function faucet(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
