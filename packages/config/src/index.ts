export type KerberosNetwork = {
  key: string;
  name: string;
  chainId?: number;
  nativeCurrency?: string;
  rpcUrl?: string;
  contracts: {
    portfolioFactory?: `0x${string}`;
    marketRouter?: `0x${string}`;
    developmentOracleRegistry?: `0x${string}`;
  };
  notes: string;
};

export const networks: KerberosNetwork[] = [
  {
    key: "local",
    name: "Local Anvil",
    chainId: 31337,
    nativeCurrency: "ETH",
    rpcUrl: "http://127.0.0.1:8545",
    contracts: {},
    notes: "Development only."
  },
  {
    key: "robinhood-chain",
    name: "Robinhood Chain",
    chainId: 4663,
    nativeCurrency: "ETH",
    contracts: {},
    notes:
      "Chain ID and native asset are referenced by the attached whitepaper. RPC URLs and deployed addresses are intentionally omitted."
  }
];

export function getNetwork(key: string): KerberosNetwork | undefined {
  return networks.find((network) => network.key === key);
}
