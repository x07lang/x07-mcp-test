import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { getServer } from '../_shared/mcp_fixture.js';

async function main() {
  const server = getServer();
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch(error => {
  console.error('Stdio fixture server error:', error);
  process.exit(1);
});

