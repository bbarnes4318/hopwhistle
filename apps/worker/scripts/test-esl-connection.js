import { Socket } from 'net';

const HOST = process.env.HOST || 'freeswitch';
const PORT = process.env.PORT || 8021;
const PASSWORD = process.env.PASSWORD || 'ClueCon';

console.log(`Connecting to ${HOST}:${PORT} with password '${PASSWORD}'...`);

const client = new Socket();

client.connect(Number(PORT), HOST, () => {
  console.log('✅ TCP Connection established');
});

client.on('data', data => {
  const msg = data.toString();
  console.log('📩 RECEIVED:\n', msg);

  if (msg.includes('Content-Type: auth/request')) {
    console.log(`Sending auth ${PASSWORD}...`);
    client.write(`auth ${PASSWORD}\n\n`);
  }
});

client.on('error', err => {
  console.error('❌ Connection error:', err.message);
});

client.on('close', () => {
  console.log('⚠️ Connection closed');
});
