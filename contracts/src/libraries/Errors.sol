// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library Errors {
    error ZeroAddress();
    error ZeroAmount();
    error NotOwner();
    error NotMinter();
    error AlreadyConfigured();
    error AdapterNotAllowed();
    error TransferFailed();
    error InsufficientShares();
    error UntrustedSource();
}
