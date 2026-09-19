// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Errors} from "./libraries/Errors.sol";

/// @notice Honest development-only source registry for demos and local tests.
/// @dev Do not use this as a production oracle or source-of-truth registry.
contract DevelopmentOracleRegistry {
    address public owner;

    struct SourceValue {
        bytes32 value;
        uint64 updatedAt;
        bool trusted;
    }

    mapping(bytes32 => SourceValue) public sources;

    event SourceSet(bytes32 indexed sourceId, bytes32 value, bool trusted);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address initialOwner) {
        if (initialOwner == address(0)) revert Errors.ZeroAddress();
        owner = initialOwner;
        emit OwnershipTransferred(address(0), initialOwner);
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert Errors.NotOwner();
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner == address(0)) revert Errors.ZeroAddress();
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function setSource(bytes32 sourceId, bytes32 value, bool trusted) external onlyOwner {
        sources[sourceId] = SourceValue(value, uint64(block.timestamp), trusted);
        emit SourceSet(sourceId, value, trusted);
    }

    function resolve(bytes32 sourceId) external view returns (bytes32 value, uint64 updatedAt) {
        SourceValue memory source = sources[sourceId];
        if (!source.trusted) revert Errors.UntrustedSource();
        return (source.value, source.updatedAt);
    }
}
