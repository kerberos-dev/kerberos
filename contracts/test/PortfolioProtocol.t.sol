// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {PortfolioFactory} from "../src/PortfolioFactory.sol";
import {PortfolioVault} from "../src/PortfolioVault.sol";
import {PortfolioShare} from "../src/PortfolioShare.sol";
import {MarketRouter} from "../src/MarketRouter.sol";
import {DevelopmentOracleRegistry} from "../src/DevelopmentOracleRegistry.sol";
import {PortfolioTypes} from "../src/libraries/PortfolioTypes.sol";
import {TestToken} from "../src/mocks/TestToken.sol";
import {MockMarketAdapter} from "../src/mocks/MockMarketAdapter.sol";

contract PortfolioProtocolTest is Test {
    PortfolioFactory factory;
    TestToken asset;
    address manager = address(0xBEEF);
    address user = address(0xCAFE);

    function setUp() public {
        factory = new PortfolioFactory();
        asset = new TestToken();
        asset.faucet(user, 1_000 ether);
    }

    function testCreatePortfolio() public {
        (address vault, address share) = _createPortfolio();
        assertTrue(factory.isPortfolio(vault));
        assertEq(factory.portfolioCount(), 1);
        assertEq(address(PortfolioVault(vault).share()), share);
        assertEq(address(PortfolioVault(vault).asset()), address(asset));
    }

    function testAddAndRemoveLiquidity() public {
        (address vault, address share) = _createPortfolio();

        vm.prank(user);
        asset.approve(vault, 100 ether);

        vm.prank(user);
        uint256 minted = PortfolioVault(vault).addLiquidity(100 ether);

        assertEq(minted, 100 ether);
        assertEq(PortfolioShare(share).balanceOf(user), 100 ether);
        assertEq(asset.balanceOf(vault), 100 ether);

        vm.prank(user);
        uint256 returnedAssets = PortfolioVault(vault).removeLiquidity(40 ether);

        assertEq(returnedAssets, 40 ether);
        assertEq(PortfolioShare(share).balanceOf(user), 60 ether);
        assertEq(asset.balanceOf(user), 940 ether);
    }

    function testRouterAdapterFlow() public {
        DevelopmentOracleRegistry registry = new DevelopmentOracleRegistry(address(this));
        MarketRouter router = new MarketRouter(address(this), address(registry));
        MockMarketAdapter adapter = new MockMarketAdapter();

        bytes memory data = abi.encode("rebalance", uint256(100));
        bytes32 expected = keccak256("expected action");
        bytes32 sourceId = keccak256("trusted-strategy-request");

        registry.setSource(sourceId, expected, true);
        router.setAdapter(address(adapter), true);

        bytes memory result = router.route(address(adapter), data, expected, sourceId);
        (bytes32 marker, bytes memory returnedData) = abi.decode(result, (bytes32, bytes));

        assertEq(uint256(marker), uint256(bytes32("MOCK_RESULT")));
        assertEq(keccak256(returnedData), keccak256(data));
    }

    function _createPortfolio() internal returns (address vault, address share) {
        PortfolioTypes.PortfolioMetadata memory metadata = PortfolioTypes.PortfolioMetadata({
            name: "Kerberos Balanced Portfolio",
            symbol: "kBAL",
            strategyURI: "ipfs://example-strategy",
            asset: address(asset),
            manager: manager
        });

        return factory.createPortfolio(metadata);
    }
}
