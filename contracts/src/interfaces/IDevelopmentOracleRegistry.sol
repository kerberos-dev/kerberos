// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IDevelopmentOracleRegistry {
    function resolve(bytes32 sourceId) external view returns (bytes32 value, uint64 updatedAt);
}
