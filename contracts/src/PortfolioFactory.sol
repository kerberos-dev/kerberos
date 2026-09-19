// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PortfolioShare} from "./PortfolioShare.sol";
import {PortfolioVault} from "./PortfolioVault.sol";
import {PortfolioTypes} from "./libraries/PortfolioTypes.sol";
import {Errors} from "./libraries/Errors.sol";

contract PortfolioFactory {
    address[] public portfolios;
    mapping(address => bool) public isPortfolio;

    event PortfolioCreated(
        address indexed manager,
        address indexed asset,
        address vault,
        address share,
        string name,
        string symbol,
        string strategyURI
    );

    function portfolioCount() external view returns (uint256) {
        return portfolios.length;
    }

    function createPortfolio(
        PortfolioTypes.PortfolioMetadata calldata metadata
    ) external returns (address vault, address share) {
        if (metadata.asset == address(0) || metadata.manager == address(0)) revert Errors.ZeroAddress();

        PortfolioShare shareToken = new PortfolioShare(metadata.name, metadata.symbol, address(this));
        PortfolioVault vaultContract =
            new PortfolioVault(metadata.asset, address(shareToken), metadata.manager, metadata.strategyURI);
        shareToken.setMinter(address(vaultContract));

        vault = address(vaultContract);
        share = address(shareToken);
        portfolios.push(vault);
        isPortfolio[vault] = true;

        emit PortfolioCreated(
            metadata.manager,
            metadata.asset,
            vault,
            share,
            metadata.name,
            metadata.symbol,
            metadata.strategyURI
        );
    }
}
