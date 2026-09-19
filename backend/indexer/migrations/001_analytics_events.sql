-- Analytics/indexing only.
-- Do not use these tables as the source of truth for balances, ownership, or permissions.
-- Read contract state directly for authoritative data.

create table if not exists portfolio_created_events (
  id bigserial primary key,
  tx_hash text not null,
  block_number bigint not null,
  manager text not null,
  asset text not null,
  vault text not null,
  share text not null,
  name text not null,
  symbol text not null,
  strategy_uri text not null,
  indexed_at timestamptz not null default now(),
  unique (tx_hash, vault)
);

create table if not exists execution_routed_events (
  id bigserial primary key,
  tx_hash text not null,
  block_number bigint not null,
  requester text not null,
  adapter text not null,
  expected_action_hash text not null,
  observed_action_hash text not null,
  source_id text not null,
  result text not null,
  indexed_at timestamptz not null default now(),
  unique (tx_hash, expected_action_hash)
);
