#!/bin/bash

# Function to get IP information and interface status
function Get-IpInfo {
    interfaces=$(ip addr show | grep 'inet ' | awk '{print $NF}')
    ipInfoHtml="<h2>IP Information and Interface Status</h2><table class='info-table'><tr><th>Interface</th><th>IPv4</th><th>Netmask</th><th>Broadcast</th></tr>"
    for interface in $interfaces; do
        interfaceStatus=$(ip link show $interface | grep -Po '(?<=state )[^ ]+')
        ipInfo=$(ip addr show dev $interface | grep 'inet ' | awk '{print $2}')
        ip=$(echo $ipInfo | cut -d '/' -f 1)
        netmask=$(echo $ipInfo | cut -d '/' -f 2)
        broadcast=$(ip addr show dev $interface | grep -Po '(?<=brd )[^ ]+')
        ipInfoHtml+="<tr><td>$interface</td><td>$ip</td><td>$netmask</td><td>$broadcast</td></tr>"
    done
    ipInfoHtml+="</table>"
    echo "$ipInfoHtml"
}

# Function to get Default Gateway
function Get-DefaultGateway {
    gateway=$(ip route | grep default | awk '{print $3}')
    gatewayHtml="<h2>Default Gateway</h2><p>$gateway</p>"
    echo "$gatewayHtml"
}

# Function to check if DHCP server is present and get its IP if exists
function Check-DhcpServer {
    if [ -f /var/lib/dhcp/dhclient.*.leases ]; then
        dhcpServer=$(grep -m 1 'dhcp-server-identifier' /var/lib/dhcp/dhclient.*.leases | awk '{print $NF; exit}')
        dhcpServerHtml="<h2>DHCP Server</h2><p>True, IP Address: $dhcpServer</p>"
    else
        dhcpServerHtml="<h2>DHCP Server</h2><p>False</p>"
    fi
    echo "$dhcpServerHtml"
}

# Function to get DNS information
function Get-DnsInfo {
    dnsServers=$(cat /etc/resolv.conf | grep 'nameserver' | awk '{print $2}')
    dnsInfoHtml="<h2>DNS Information</h2><ul>"
    for dns in $dnsServers; do
        dnsInfoHtml+="<li>$dns</li>"
    done
    dnsInfoHtml+="</ul>"
    echo "$dnsInfoHtml"
}

# Function to get Routing Table
function Get-RoutingTable {
    routingTable=$(ip route)
    routingTableHtml="<h2>Routing Table</h2><table class='info-table'><tr><th>Destination</th><th>Gateway</th><th>Genmask</th><th>Flags</th><th>Metric</th><th>Ref</th><th>Use</th><th>Iface</th></tr>"
    while read -r route; do
        routingTableHtml+="<tr><td>$(echo $route | awk '{print $1}')</td><td>$(echo $route | awk '{print $3}')</td><td>$(echo $route | awk '{print $2}')</td><td>$(echo $route | awk '{print $4}')</td><td>$(echo $route | awk '{print $5}')</td><td>$(echo $route | awk '{print $6}')</td><td>$(echo $route | awk '{print $7}')</td><td>$(echo $route | awk '{print $8}')</td></tr>"
    done <<< "$routingTable"
    routingTableHtml+="</table>"
    echo "$routingTableHtml"
}

# Function to get ARP Table
function Get-ArpTable {
    arpTable=$(arp -n)
    arpTableHtml="<h2>ARP Table</h2><table class='info-table'><tr><th>Address</th><th>HWtype</th><th>HWaddress</th><th>Flags</th><th>Mask</th>Iface</th></tr>"
    while read -r arpEntry; do
        arpTableHtml+="<tr><td>$(echo $arpEntry | awk '{print $1}')</td><td>$(echo $arpEntry | awk '{print $2}')</td><td>$(echo $arpEntry | awk '{print $3}')</td><td>$(echo $arpEntry | awk '{print $4}')</td><td>$(echo $arpEntry | awk '{print $5}')</td><td>$(echo $arpEntry | awk '{print $6}')</td></tr>"
    done <<< "$arpTable"
    arpTableHtml+="</table>"
    echo "$arpTableHtml"
}

# Function to perform DNS Resolution Test
function Perform-DnsResolutionTest {
    domains=("google.com" "example.com" "yahoo.com")
    dnsTestResultsHtml="<h2>DNS Resolution Test</h2><ul>"
    for domain in "${domains[@]}"; do
        if ping -c 1 -W 1 "$domain" >/dev/null; then
            dnsTestResultsHtml+="<li class='success'>$domain - Resolved Successfully</li>"
        else
            dnsTestResultsHtml+="<li class='failure'>$domain - Failed to Resolve</li>"
        fi
    done
    dnsTestResultsHtml+="</ul>"
    echo "$dnsTestResultsHtml"
}

# Function to perform Traceroute
function Perform-Traceroute {
    tracerouteResults=$(traceroute google.com)
    tracerouteHtml="<h2>Traceroute to google.com</h2><table class='info-table'><tr><th>Hop</th><th>RTT1</th><th>RTT2</th><th>RTT3</th><th>IP Address</th></tr>"
    hopCount=1
    while read -r hop; do
        hopInfo=$(echo $hop | awk '{print $1,$2,$3,$4,$5}')
        tracerouteHtml+="<tr><td>$hopCount</td><td>$(echo $hop | awk '{print $6}')</td><td>$(echo $hop | awk '{print $7}')</td><td>$(echo $hop | awk '{print $8}')</td><td>$(echo $hopInfo | awk '{print $NF}')</td></tr>"
        ((hopCount++))
    done <<< "$tracerouteResults"
    tracerouteHtml+="</table>"
    echo "$tracerouteHtml"
}

# Create the HTML report
function Create-HtmlReport {
    htmlContent="<!DOCTYPE html>
<html>
<head>
    <title>Network Information Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #1f1f1f;
            color: #ccc;
            text-align: center;
            margin: 0;
            padding: 0;
        }

        h1 {
            text-align: center;
            margin: 20px 0;
        }

        .section {
            text-align: center;
            margin: 40px auto;
            padding: 20px;
            border-radius: 10px;
            background-color: #292929;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            width: 80%;
            max-width: 800px;
            overflow-x: auto;
            transition: all 0.3s ease;
        }

        .section:hover {
            transform: scale(1.05);
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.8);
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0 auto;
        }

        .info-table th,
        .info-table td {
            border: 1px solid #555;
            padding: 8px;
            text-align: left;
        }

        .info-table th {
            background-color: #444;
        }

        .info-table td {
            background-color: #333;
        }

        .info-table th:first-child,
        .info-table td:first-child {
            border-left: none;
        }

        .info-table th:last-child,
        .info-table td:last-child {
            border-right: none;
        }

        ul {
            list-style: none;
            padding: 0;
        }

        ul li {
            margin: 5px 0;
        }

        .success {
            color: #66ff66;
        }

        .failure {
            color: #ff6666;
        }

        a {
            text-decoration: none;
            color: #aaa;
        }

        a:hover {
            color: #66ff66;
        }
    </style>
</head>
<body>
    <h1>Network Information Report</h1>
    <div class='section'>
        $(Get-DnsInfo)
    </div>
    <div class='section'>
        $(Get-DefaultGateway)
    </div>
    <div class='section'>
        $(Check-DhcpServer)
    </div>
    <div class='section'>
        $(Get-RoutingTable)
    </div>
    <div class='section'>
        $(Get-ArpTable)
    </div>
    <div class='section'>
        $(Perform-DnsResolutionTest)
    </div>
    <div class='section'>
        $(Perform-Traceroute)
    </div>
    <div class='section'>
        <p>Device IP Address: $(hostname)</p>
    </div>
    <div class='section'>
        <p>Internet Status: $(if ping -c 1 google.com >/dev/null; then echo "Connected"; else echo "Not Connected"; fi)</p>
    </div>
    <div class='section'>
        <p>Find me on: <a href="https://github.com/salahmed-ctrlz" target="_blank">Github</a>, <a href="https://www.linkedin.com/in/salah-eddine-medkour/" target="_blank">LinkedIn</a></p>
    </div>
</body>
</html>"

    echo "$htmlContent" > network_info.html
    xdg-open network_info.html || sensible-browser network_info.html || firefox network_info.html || chromium network_info.html || google-chrome network_info.html
}

# Run the main function
Create-HtmlReport
