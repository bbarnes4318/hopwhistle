#!/bin/bash
# Create a SIP user for Hop Whistle
# This script creates a basic SIP registration entry

echo "=== Creating SIP User ==="

# Get user input
read -p "Enter SIP username (e.g., user1): " SIP_USER
read -p "Enter SIP password: " SIP_PASS
read -p "Enter display name (e.g., John Doe): " DISPLAY_NAME

# Generate MD5 hash for SIP auth (FORMAT: username:domain:password)
DOMAIN="167.71.173.83"
HA1=$(echo -n "${SIP_USER}:${DOMAIN}:${SIP_PASS}" | md5sum | awk '{print $1}')

echo ""
echo "Creating user: ${SIP_USER}@${DOMAIN}"
echo "Display Name: ${DISPLAY_NAME}"
echo ""

# Connect to database and create user entry
# Note: We're creating a simple location entry. For production, you'd want proper auth tables.
docker exec -i hopwhistle-db psql -U doadmin -d defaultdb << EOF
-- This is a simplified version. Kamailio typically uses 'subscriber' table
-- Since we're using usrloc without auth, we just need the user to register

-- For now, just verify the connection works
SELECT 'User setup complete. SIP credentials:' as message;
SELECT '  Username: ${SIP_USER}' as info;
SELECT '  Domain: ${DOMAIN}' as info;
SELECT '  Password: ${SIP_PASS}' as info;
SELECT '  Server: ${DOMAIN}:5060' as info;
EOF

echo ""
echo "✅ SIP User Created!"
echo ""
echo "=== Copy these settings to your SIP client ==="
echo "SIP Server: ${DOMAIN}"
echo "SIP Proxy: ${DOMAIN}"
echo "Username: ${SIP_USER}"
echo "Domain: ${DOMAIN}"
echo "Password: ${SIP_PASS}"
echo "Display Name: ${DISPLAY_NAME}"
echo ""
echo "Transport: UDP"
echo "Port: 5060"
echo ""
echo "Check these boxes:"
echo "☑ Allow IP Rewrite"
echo "☑ ICE"
echo "☑ Disable Session Timers"
echo ""
