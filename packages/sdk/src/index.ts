import type { Address, Hex, PublicClient, WalletClient } from "viem";
import { encodeFunctionData, keccak256, toBytes } from "viem";
import { marketRouterAbi, portfolioFactoryAbi, portfolioVaultAbi } from "@kerberos/abi";

export type PortfolioMetadata = {
  name: string;
  symbol: string;
  strategyURI: string;
  asset: Address;
  manager: Address;
};

export function hashExpectedAction(description: string): Hex {
  return keccak256(toBytes(description));
}

export function encodeCreatePortfolio(metadata: PortfolioMetadata): Hex {
  return encodeFunctionData({
    abi: portfolioFactoryAbi,
    functionName: "createPortfolio",
    args: [metadata]
  });
}

export async function createPortfolio(params: {
  walletClient: WalletClient;
  account: Address;
  factory: Address;
  metadata: PortfolioMetadata;
}) {
  return params.walletClient.writeContract({
    address: params.factory,
    abi: portfolioFactoryAbi,
    functionName: "createPortfolio",
    account: params.account,
    args: [params.metadata],
    chain: params.walletClient.chain
  });
}

export async function addLiquidity(params: {
  walletClient: WalletClient;
  account: Address;
  vault: Address;
  assets: bigint;
}) {
  return params.walletClient.writeContract({
    address: params.vault,
    abi: portfolioVaultAbi,
    functionName: "addLiquidity",
    account: params.account,
    args: [params.assets],
    chain: params.walletClient.chain
  });
}

export async function routeExecution(params: {
  walletClient: WalletClient;
  account: Address;
  router: Address;
  adapter: Address;
  adapterData: Hex;
  expectedActionHash: Hex;
  sourceId: Hex;
}) {
  return params.walletClient.writeContract({
    address: params.router,
    abi: marketRouterAbi,
    functionName: "route",
    account: params.account,
    args: [params.adapter, params.adapterData, params.expectedActionHash, params.sourceId],
    chain: params.walletClient.chain
  });
}

export async function readPortfolioCreatedEvents(params: {
  publicClient: PublicClient;
  factory: Address;
  fromBlock?: bigint;
  toBlock?: bigint;
}) {
  return params.publicClient.getLogs({
    address: params.factory,
    event: portfolioFactoryAbi[1],
    fromBlock: params.fromBlock,
    toBlock: params.toBlock
  });
}
