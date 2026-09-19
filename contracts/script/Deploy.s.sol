// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PortfolioFactory} from "../src/PortfolioFactory.sol";
import {MarketRouter} from "../src/MarketRouter.sol";
import {DevelopmentOracleRegistry} from "../src/DevelopmentOracleRegistry.sol";

interface Vm {
    function envUint(string calldata key) external returns (uint256);
    function addr(uint256 privateKey) external returns (address);
    function startBroadcast(uint256 privateKey) external;
    function stopBroadcast() external;
}

contract Deploy {
    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function run() external returns (PortfolioFactory factory, DevelopmentOracleRegistry registry, MarketRouter router) {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerKey);
        vm.startBroadcast(deployerKey);
        factory = new PortfolioFactory();
        registry = new DevelopmentOracleRegistry(deployer);
        router = new MarketRouter(deployer, address(registry));
        vm.stopBroadcast();
    }
}
