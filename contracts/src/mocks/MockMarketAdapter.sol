// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IMarketAdapter} from "../interfaces/IMarketAdapter.sol";

contract MockMarketAdapter is IMarketAdapter {
    bytes public lastData;

    event MockExecuted(address indexed caller, bytes data);

    function execute(bytes calldata data) external returns (bytes memory result) {
        lastData = data;
        emit MockExecuted(msg.sender, data);
        return abi.encode(bytes32("MOCK_RESULT"), data);
    }
}
