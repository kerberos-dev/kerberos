// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IMarketAdapter {
    function execute(bytes calldata data) external returns (bytes memory result);
}
