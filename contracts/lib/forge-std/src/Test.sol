// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface Vm {
    function expectRevert(bytes4 selector) external;
    function prank(address sender) external;
}

contract Test {
    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function assertEq(uint256 left, uint256 right) internal pure {
        require(left == right, "assertEq(uint256)");
    }

    function assertEq(address left, address right) internal pure {
        require(left == right, "assertEq(address)");
    }

    function assertTrue(bool value) internal pure {
        require(value, "assertTrue");
    }
}
