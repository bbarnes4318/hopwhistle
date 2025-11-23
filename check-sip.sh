#!/bin/bash
echo "=== SIP Server Diagnostics ==="
echo ""

# 1. Check if Kamailio container is running
echo "1. Checking Kamailio container status..."
docker ps | grep kamailio || echo "❌ Kamailio container NOT running!"
echo ""

# 2. Check if port 5060 is open
echo "2. Checking if port 5060 is listening..."
netstat -tuln | grep 5060 || echo "❌ Port 5060 NOT listening!"
echo ""

# 3. Check Kamailio logs
echo "3. Recent Kamailio logs (last 20 lines)..."
docker logs kamailio --tail 20 2>&1 || echo "❌ Cannot read Kamailio logs!"
echo ""

# 4. Try SIP OPTIONS ping to the server
echo "4. Testing SIP connectivity with OPTIONS..."
timeout 2 bash -c "echo -e 'OPTIONS sip:167.71.173.83:5060 SIP/2.0\r\nVia: SIP/2.0/UDP 127.0.0.1:5060\r\nFrom: <sip:test@167.71.173.83>\r\nTo: <sip:167.71.173.83>\r\nCall-ID: test-123\r\nCSeq: 1 OPTIONS\r\nContent-Length: 0\r\n\r\n' | nc -u 167.71.173.83 5060" || echo "No response from SIP server"
echo ""

# 5. Check docker-compose config
echo "5. Checking which Kamailio service is configured..."
grep -r "kamailio" infra/docker/docker-compose*.yml | grep -v "#" | head -5
echo ""

echo "=== Diagnostics Complete ==="
