import type { Metadata } from "next";
import "./styles.css";

export const metadata: Metadata = {
  title: "KERBEROS Protocol",
  description: "Experimental execution assurance and portfolio protocol MVP."
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
