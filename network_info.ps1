# Function to get IP information and interface status
function Get-IpInfo {
    $interfaces = Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notlike '127.*'}
    $ipInfoHtml = "<h2>IP Information and Interface Status</h2><table class='info-table'><tr><th>Interface</th><th>Status</th><th>IPv4</th><th>Netmask</th><th>Broadcast</th></tr>"
    foreach ($interface in $interfaces) {
        $interfaceStatus = (Get-NetAdapter -InterfaceIndex $interface.InterfaceIndex).Status
        $netmask = (Get-NetIPConfiguration -InterfaceAlias $interface.InterfaceAlias).IPv4Address.PrefixLength
        $broadcast = [System.Net.IPAddress]::Parse((($interface.IPAddress -split '\.')[0..2] -join '.') + '.255').ToString()
        $ipInfoHtml += "<tr><td>$($interface.InterfaceAlias)</td><td>$interfaceStatus</td><td>$($interface.IPAddress)</td><td>$($netmask)</td><td>$broadcast</td></tr>"
    }
    $ipInfoHtml += "</table>"
    return $ipInfoHtml
}

# Function to get Default Gateway
function Get-DefaultGateway {
    $gateway = Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1 -ExpandProperty NextHop
    $gatewayHtml = "<h2>Default Gateway</h2><p>$gateway</p>"
    return $gatewayHtml
}

# Function to check if DHCP server is present and get its IP if exists
function Check-DhcpServer {
    $dhcpServer = Get-NetIPConfiguration | Where-Object {$_.Dhcp -eq 'Enabled'} | Select-Object -First 1 -ExpandProperty DhcpServer
    if ($dhcpServer) {
        $dhcpServerHtml = "<h2>DHCP Server</h2><p>True, IP Address: $dhcpServer</p>"
    } else {
        $dhcpServerHtml = "<h2>DHCP Server</h2><p>False</p>"
    }
    return $dhcpServerHtml
}

# Function to get DNS information
function Get-DnsInfo {
    $dnsServers = Get-DnsClientServerAddress | Where-Object {$_.ServerAddresses} | Select-Object -ExpandProperty ServerAddresses
    $dnsInfoHtml = "<h2>DNS Information</h2><ul>"
    foreach ($dns in $dnsServers) {
        $dnsInfoHtml += "<li>$dns</li>"
    }
    $dnsInfoHtml += "</ul>"
    return $dnsInfoHtml
}

# Function to get Routing Table
function Get-RoutingTable {
    $routingTable = Get-NetRoute | Select-Object -Property DestinationPrefix, InterfaceAlias, NextHop, RouteMetric, AddressFamily
    $routingTableHtml = "<h2>Routing Table</h2><table class='info-table'><tr><th>Destination Prefix</th><th>Interface Alias</th><th>Next Hop</th><th>Route Metric</th><th>Address Family</th></tr>"
    foreach ($route in $routingTable) {
        $routingTableHtml += "<tr><td>$($route.DestinationPrefix)</td><td>$($route.InterfaceAlias)</td><td>$($route.NextHop)</td><td>$($route.RouteMetric)</td><td>$($route.AddressFamily)</td></tr>"
    }
    $routingTableHtml += "</table>"
    return $routingTableHtml
}

# Function to get ARP Table
function Get-ArpTable {
    $arpTable = Get-NetNeighbor -AddressFamily IPv4 | Select-Object -Property IPAddress, LinkLayerAddress, State, InterfaceAlias
    $arpTableHtml = "<h2>ARP Table</h2><table class='info-table'><tr><th>IP Address</th><th>MAC Address</th><th>State</th><th>Interface Alias</th></tr>"
    foreach ($arpEntry in $arpTable) {
        $arpTableHtml += "<tr><td>$($arpEntry.IPAddress)</td><td>$($arpEntry.LinkLayerAddress)</td><td>$($arpEntry.State)</td><td>$($arpEntry.InterfaceAlias)</td></tr>"
    }
    $arpTableHtml += "</table>"
    return $arpTableHtml
}

# Function to get Interface Statistics
function Get-InterfaceStatistics {
    $interfaceStats = Get-NetAdapterStatistics
    $interfaceStatsHtml = "<h2>Interface Statistics</h2><table class='info-table'><tr><th>Interface Name</th><th>Bytes Received</th><th>Bytes Sent</th><th>Packets Received</th><th>Packets Sent</th></tr>"
    foreach ($stat in $interfaceStats) {
        $interfaceStatsHtml += "<tr><td>$($stat.Name)</td><td>$($stat.BytesReceived)</td><td>$($stat.BytesSent)</td><td>$($stat.PacketsReceived)</td><td>$($stat.PacketsSent)</td></tr>"
    }
    $interfaceStatsHtml += "</table>"
    return $interfaceStatsHtml
}

# Function to perform DNS Resolution Test
function Perform-DnsResolutionTest {
    $domains = @("google.com", "example.com", "yahoo.com")
    $dnsTestResultsHtml = "<h2>DNS Resolution Test</h2><ul>"
    foreach ($domain in $domains) {
        $result = Test-Connection -ComputerName $domain -Count 1 -Quiet
        if ($result) {
            $dnsTestResultsHtml += "<li class='success'>$domain - Resolved Successfully</li>"
        } else {
            $dnsTestResultsHtml += "<li class='failure'>$domain - Failed to Resolve</li>"
        }
    }
    $dnsTestResultsHtml += "</ul>"
    return $dnsTestResultsHtml
}

# Function to perform Traceroute
function Perform-Traceroute {
    $tracerouteResults = tracert google.com
    $tracerouteHtml = "<h2>Traceroute to google.com</h2><table class='info-table'><tr><th>Hop</th><th>Hostname</th><th>IP Address</th><th>RTT1</th><th>RTT2</th><th>RTT3</th></tr>"
    $hopCount = 1
    foreach ($hop in $tracerouteResults) {
        $hopInfo = $hop -split '\s+', 5
        $hopHtml = "<tr><td>$hopCount</td><td>$($hopInfo[1])</td><td>$($hopInfo[4])</td>"
        $rtts = $hop -replace '\s+ms', '' -split '\s+'
        foreach ($rtt in $rtts[3..5]) {
            $hopHtml += "<td>$rtt</td>"
        }
        $hopHtml += "</tr>"
        $tracerouteHtml += $hopHtml
        $hopCount++
    }
    $tracerouteHtml += "</table>"
    return $tracerouteHtml
}

# Function to get Bandwidth Usage (Requires additional configurations)
function Get-BandwidthUsage {
    # Add your bandwidth usage retrieval logic here
    $bandwidthUsageHtml = "<h2>Bandwidth Usage</h2><p>Bandwidth usage information will be displayed here once configured.</p>"
    return $bandwidthUsageHtml
}

# Function to get Firewall Rules (Requires additional permissions)
function Get-FirewallRules {
    # Add your firewall rules retrieval logic here
    $firewallRulesHtml = "<h2>Firewall Rules</h2><p>Firewall rules information will be displayed here once configured.</p>"
    return $firewallRulesHtml
}

# Function to get VPN Connection Status (Requires additional configurations)
function Get-VpnConnectionStatus {
    # Add your VPN connection status retrieval logic here
    $vpnConnectionStatusHtml = "<h2>VPN Connection Status</h2><p>VPN connection status information will be displayed here once configured.</p>"
    return $vpnConnectionStatusHtml
}

# Function to get Syslog Messages (Requires additional configurations)
function Get-SyslogMessages {
    # Add your syslog messages retrieval logic here
    $syslogMessagesHtml = "<h2>Syslog Messages</h2><p>Syslog messages will be displayed here once configured.</p>"
    return $syslogMessagesHtml
}

# Create the HTML report
function Create-HtmlReport {
    $scriptPath = $PSScriptRoot
    if (-not $scriptPath) {
        $scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
    }
    
    $htmlContent = @"
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
        $(Get-InterfaceStatistics)
    </div>
    <div class='section'>
        $(Perform-DnsResolutionTest)
    </div>
    <div class='section'>
        $(Perform-Traceroute)
    </div>
    <div class='section'>
        $(Get-BandwidthUsage)
    </div>
    <div class='section'>
        $(Get-FirewallRules)
    </div>
    <div class='section'>
        $(Get-VpnConnectionStatus)
    </div>
    <div class='section'>
        $(Get-SyslogMessages)
    </div>
    <div class='section'>
        <p>Device IP Address: $(hostname)</p>
    </div>
    <div class='section'>
        <p>Internet Status: $(if (Test-Connection -ComputerName google.com -Count 1 -Quiet) { "Connected" } else { "Not Connected" })</p>
    </div>
    <div class='section'>
        <p>Find me on: <a href="https://github.com/salahmed-ctrlz" target="_blank">Github</a>, <a href="https://www.linkedin.com/in/salah-eddine-medkour/" target="_blank">LinkedIn</a></p>
    </div>
</body>
</html>
"@

    $filePath = Join-Path $scriptPath "network_info.html"
    Set-Content -Path $filePath -Value $htmlContent
    Invoke-Item -Path $filePath
}

# Run the main function
Create-HtmlReport
