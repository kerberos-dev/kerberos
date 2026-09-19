// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20} from "./interfaces/IERC20.sol";
import {PortfolioShare} from "./PortfolioShare.sol";
import {Errors} from "./libraries/Errors.sol";

contract PortfolioVault {
    IERC20 public immutable asset;
    PortfolioShare public immutable share;
    address public immutable factory;
    address public manager;
    string public strategyURI;

    event LiquidityAdded(address indexed account, uint256 assets, uint256 shares);
    event LiquidityRemoved(address indexed account, uint256 assets, uint256 shares);
    event StrategyURIUpdated(string strategyURI);

    constructor(address asset_, address share_, address manager_, string memory strategyURI_) {
        if (asset_ == address(0) || share_ == address(0) || manager_ == address(0)) {
            revert Errors.ZeroAddress();
        }
        asset = IERC20(asset_);
        share = PortfolioShare(share_);
        factory = msg.sender;
        manager = manager_;
        strategyURI = strategyURI_;
    }

    modifier onlyManager() {
        if (msg.sender != manager) revert Errors.NotOwner();
        _;
    }

    function totalAssets() public view returns (uint256) {
        return asset.balanceOf(address(this));
    }

    function previewDeposit(uint256 assets) public view returns (uint256 shares) {
        uint256 supply = share.totalSupply();
        uint256 assetsBefore = totalAssets();
        if (supply == 0 || assetsBefore == 0) return assets;
        return (assets * supply) / assetsBefore;
    }

    function previewWithdraw(uint256 shares_) public view returns (uint256 assets) {
        uint256 supply = share.totalSupply();
        if (supply == 0) return 0;
        return (shares_ * totalAssets()) / supply;
    }

    function addLiquidity(uint256 assets) external returns (uint256 shares) {
        if (assets == 0) revert Errors.ZeroAmount();
        shares = previewDeposit(assets);
        if (shares == 0) revert Errors.ZeroAmount();
        if (!asset.transferFrom(msg.sender, address(this), assets)) revert Errors.TransferFailed();
        share.mint(msg.sender, shares);
        emit LiquidityAdded(msg.sender, assets, shares);
    }

    function removeLiquidity(uint256 shares_) external returns (uint256 assets) {
        if (shares_ == 0) revert Errors.ZeroAmount();
        assets = previewWithdraw(shares_);
        if (assets == 0) revert Errors.ZeroAmount();
        share.burn(msg.sender, shares_);
        if (!asset.transfer(msg.sender, assets)) revert Errors.TransferFailed();
        emit LiquidityRemoved(msg.sender, assets, shares_);
    }

    function setStrategyURI(string calldata nextStrategyURI) external onlyManager {
        strategyURI = nextStrategyURI;
        emit StrategyURIUpdated(nextStrategyURI);
    }
}
