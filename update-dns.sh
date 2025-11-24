#!/bin/bash
CURRENT_IP=$(curl -s https://api.ipify.org)

if [[ ! $CURRENT_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid IP: $CURRENT_IP"
    exit 1
fi

curl -s "https://www.duckdns.org/update?domains=minecraft-local1&token=af846d76-de72-4d8d-88be-1c5d83a2e3f7&ip=$CURRENT_IP"

LAST_IP=$(grep -oE 'address=/[^/]+/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' /etc/dnsmasq.conf | grep -v '127.0.0.1' | head -1 | cut -d'/' -f3)

if [ "$CURRENT_IP" != "$LAST_IP" ]; then
    echo "IP changed from $LAST_IP to $CURRENT_IP"

    cat > /tmp/dnsmasq_update.conf << EOF
port=53
listen-address=0.0.0.0
bind-interfaces
user=root
cache-size=1000
local-ttl=300

address=/minecraft.server/$CURRENT_IP
address=/mc.local/$CURRENT_IP
address=/ytrechko.server/$CURRENT_IP
address=/traefik.local/$CURRENT_IP
address=/jaeger.local/$CURRENT_IP
address=/prometheus.local/$CURRENT_IP
address=/grafana.local/$CURRENT_IP
address=/jmx-exporter.local/$CURRENT_IP
address=/dnsmasq.local/$CURRENT_IP

address=/minecraft-local1.duckdns.org/$CURRENT_IP
address=/minecraft-hamachi.local/25.35.181.13

server=8.8.8.8
server=1.1.1.1
EOF

    mv /tmp/dnsmasq_update.conf /etc/dnsmasq.conf

    curl -s -X POST --unix-socket /var/run/docker.sock "http://v1.41/containers/dnsmasq/restart" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        echo "DNS updated to $CURRENT_IP and dnsmasq restarted successfully"
    else
        echo "DNS updated to $CURRENT_IP but could not restart dnsmasq via API"
        echo "Trying alternative container name..."
        
        curl -s -X POST --unix-socket /var/run/docker.sock "http://v1.41/containers/cfg-dnsmasq-1/restart" > /dev/null 2>&1
        
        if [ $? -eq 0 ]; then
            echo "DNS updated to $CURRENT_IP and dnsmasq restarted using alternative name"
        else
            echo "Could not restart dnsmasq automatically"
            echo "Please restart manually: docker restart dnsmasq"
        fi
    fi
else
    echo "IP unchanged: $CURRENT_IP"
fi