const whitepaperItems = [
  "Execution Records",
  "Establish -> Inspect -> Validate -> Resolve",
  "Source Trace",
  "Policy Engine",
  "Outcome Verification"
];

const portfolioItems = [
  "PortfolioFactory",
  "PortfolioVault",
  "PortfolioShare",
  "MarketRouter",
  "Development-only Oracle Registry"
];

export default function HomePage() {
  return (
    <main className="shell">
      <section className="hero">
        <p className="eyebrow">Experimental / Under Active Development / Not Audited</p>
        <h1>KERBEROS Protocol</h1>
        <p className="lede">
          Execution assurance concepts from the whitepaper, paired with a requested
          portfolio-first Web3 MVP that is explicitly labeled as an extension.
        </p>
        <div className="actions">
          <a href="/docs" aria-label="Open docs placeholder">Docs</a>
          <a href="https://github.com/" aria-label="GitHub placeholder">GitHub</a>
        </div>
      </section>

      <section className="grid">
        <article>
          <span>Whitepaper-supported</span>
          <h2>Intent to execution assurance</h2>
          <ul>
            {whitepaperItems.map((item) => (
              <li key={item}>{item}</li>
            ))}
          </ul>
        </article>
        <article>
          <span>Requested MVP extension</span>
          <h2>Portfolio-first protocol layer</h2>
          <ul>
            {portfolioItems.map((item) => (
              <li key={item}>{item}</li>
            ))}
          </ul>
        </article>
      </section>
    </main>
  );
}
