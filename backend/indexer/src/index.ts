import "dotenv/config";
import { Pool } from "pg";
import { createPublicClient, http, parseAbiItem } from "viem";

const databaseUrl = process.env.DATABASE_URL;
const rpcUrl = process.env.RPC_URL;
const factoryAddress = process.env.PORTFOLIO_FACTORY_ADDRESS as `0x${string}` | undefined;
const marketRouterAddress = process.env.MARKET_ROUTER_ADDRESS as `0x${string}` | undefined;
const startBlock = BigInt(process.env.INDEXER_START_BLOCK ?? "0");

if (!databaseUrl) throw new Error("DATABASE_URL is required");
if (!rpcUrl) throw new Error("RPC_URL is required");

const pool = new Pool({ connectionString: databaseUrl });
const client = createPublicClient({ transport: http(rpcUrl) });

const portfolioCreated = parseAbiItem(
  "event PortfolioCreated(address indexed manager,address indexed asset,address vault,address share,string name,string symbol,string strategyURI)"
);

const executionRouted = parseAbiItem(
  "event ExecutionRouted(address indexed requester,address indexed adapter,bytes32 indexed expectedActionHash,bytes32 observedActionHash,bytes32 sourceId,bytes result)"
);

async function indexPortfolioEvents() {
  if (!factoryAddress) return;
  const logs = await client.getLogs({
    address: factoryAddress,
    event: portfolioCreated,
    fromBlock: startBlock,
    toBlock: "latest"
  });

  for (const log of logs) {
    await pool.query(
      `insert into portfolio_created_events
        (tx_hash, block_number, manager, asset, vault, share, name, symbol, strategy_uri)
       values ($1,$2,$3,$4,$5,$6,$7,$8,$9)
       on conflict (tx_hash, vault) do nothing`,
      [
        log.transactionHash,
        Number(log.blockNumber),
        log.args.manager,
        log.args.asset,
        log.args.vault,
        log.args.share,
        log.args.name,
        log.args.symbol,
        log.args.strategyURI
      ]
    );
  }
}

async function indexRouterEvents() {
  if (!marketRouterAddress) return;
  const logs = await client.getLogs({
    address: marketRouterAddress,
    event: executionRouted,
    fromBlock: startBlock,
    toBlock: "latest"
  });

  for (const log of logs) {
    await pool.query(
      `insert into execution_routed_events
        (tx_hash, block_number, requester, adapter, expected_action_hash, observed_action_hash, source_id, result)
       values ($1,$2,$3,$4,$5,$6,$7,$8)
       on conflict (tx_hash, expected_action_hash) do nothing`,
      [
        log.transactionHash,
        Number(log.blockNumber),
        log.args.requester,
        log.args.adapter,
        log.args.expectedActionHash,
        log.args.observedActionHash,
        log.args.sourceId,
        log.args.result
      ]
    );
  }
}

async function main() {
  await indexPortfolioEvents();
  await indexRouterEvents();
  await pool.end();
}

main().catch(async (error) => {
  console.error(error);
  await pool.end();
  process.exit(1);
});
