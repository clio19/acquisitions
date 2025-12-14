import 'dotenv/config';

import { neon, neonConfig } from '@neondatabase/serverless';
import { drizzle } from 'drizzle-orm/neon-http';

const isLocalDb =
  typeof process.env.DATABASE_URL === 'string' &&
  /(localhost|127\.0\.0\.1|neon-local)/.test(process.env.DATABASE_URL);

if (process.env.NODE_ENV === 'development' && isLocalDb) {
  // When running inside Docker Compose, use the Neon Local service name.
  // When running on the host, connect to the forwarded port on localhost.
  const isComposeHostname = /neon-local/.test(process.env.DATABASE_URL);

  neonConfig.fetchEndpoint = isComposeHostname
    ? 'http://neon-local:5432/sql'
    : 'http://localhost:5432/sql';
  neonConfig.useSecureWebSocket = false;
  neonConfig.poolQueryViaFetch = true;
}

const sql = neon(process.env.DATABASE_URL);

const db = drizzle(sql);

export { db, sql };
