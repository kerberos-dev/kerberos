// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library PortfolioTypes {
    struct PortfolioMetadata {
        string name;
        string symbol;
        string strategyURI;
        address asset;
        address manager;
    }

    struct ExecutionRecord {
        address requester;
        address adapter;
        bytes32 expectedActionHash;
        bytes32 observedActionHash;
        bytes32 sourceId;
    }
}
