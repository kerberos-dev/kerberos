// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IMarketAdapter} from "./interfaces/IMarketAdapter.sol";
import {IDevelopmentOracleRegistry} from "./interfaces/IDevelopmentOracleRegistry.sol";
import {PortfolioTypes} from "./libraries/PortfolioTypes.sol";
import {Errors} from "./libraries/Errors.sol";

contract MarketRouter {
    address public owner;
    IDevelopmentOracleRegistry public oracleRegistry;
    mapping(address => bool) public allowedAdapter;

    event AdapterUpdated(address indexed adapter, bool allowed);
    event OracleRegistryUpdated(address indexed oracleRegistry);
    event ExecutionRouted(
        address indexed requester,
        address indexed adapter,
        bytes32 indexed expectedActionHash,
        bytes32 observedActionHash,
        bytes32 sourceId,
        bytes result
    );

    constructor(address initialOwner, address oracleRegistry_) {
        if (initialOwner == address(0) || oracleRegistry_ == address(0)) revert Errors.ZeroAddress();
        owner = initialOwner;
        oracleRegistry = IDevelopmentOracleRegistry(oracleRegistry_);
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert Errors.NotOwner();
        _;
    }

    function setAdapter(address adapter, bool allowed) external onlyOwner {
        if (adapter == address(0)) revert Errors.ZeroAddress();
        allowedAdapter[adapter] = allowed;
        emit AdapterUpdated(adapter, allowed);
    }

    function setOracleRegistry(address nextRegistry) external onlyOwner {
        if (nextRegistry == address(0)) revert Errors.ZeroAddress();
        oracleRegistry = IDevelopmentOracleRegistry(nextRegistry);
        emit OracleRegistryUpdated(nextRegistry);
    }

    function route(
        address adapter,
        bytes calldata adapterData,
        bytes32 expectedActionHash,
        bytes32 sourceId
    ) external returns (bytes memory result) {
        if (!allowedAdapter[adapter]) revert Errors.AdapterNotAllowed();

        (bytes32 expectedFromSource,) = oracleRegistry.resolve(sourceId);
        if (expectedFromSource != expectedActionHash) revert Errors.UntrustedSource();

        bytes32 observedActionHash = keccak256(abi.encode(adapter, adapterData, msg.sender));
        result = IMarketAdapter(adapter).execute(adapterData);

        emit ExecutionRouted(
            msg.sender,
            adapter,
            expectedActionHash,
            observedActionHash,
            sourceId,
            result
        );
    }
}
