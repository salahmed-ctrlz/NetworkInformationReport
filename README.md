# Network Information Report

A tool for "Network Engineers" to navigate through a device's Network Information faster.

## Prerequisites

- Windows Operating System: The script is designed to run on Windows OS.
- PowerShell: Ensure PowerShell is installed on your system.
- Linux Operating System: The script also works on Linux.
- Bash Shell: Ensure you have access to a Bash shell on your Linux system.

## Steps to Generate the Network Information Report

### Method 1: Using PowerShell (Windows)

1. **Download the Script:** Download the `network_info.ps1` script to your local machine.

2. **Open PowerShell:** Open PowerShell by searching for it in the Start menu and selecting the application.

3. **Navigate to the Script Directory (Optional):** If the script is not in the current directory, navigate to its location using the `cd` command:

    ```powershell
    cd C:\Path\To\Script\Directory
    ```

4. **Run the Script:** Execute the script by typing its name followed by `.ps1`:

    ```powershell
    .\network_info.ps1
    ```

5. **Review the Report:** After executing the script, it will generate an HTML report named `network_info.html`. This report contains various sections such as DNS information, default gateway, DHCP server status, routing table, ARP table, interface statistics, DNS resolution test results, traceroute, and more. The report will open automatically in your default web browser.

### Method 2: Using Batch File (Windows)

1. **Download the Scripts:** Download both the `network_info.ps1` script and the `run_network_info.bat` batch file to your local machine.

2. **Place Both Files Together:** Ensure that both files are in the same directory.

3. **Run the Batch File:** Double-click the `run_network_info.bat` file. This batch file will automatically locate and execute the PowerShell script.

4. **Review the Report:** Similar to the PowerShell method, the script will generate an HTML report named `network_info.html` and open it automatically in your default web browser.

## Linux Version

For Linux users, a bash script version of the network information tool is available. Follow the steps below to run the tool on Linux:

### Prerequisites

- Bash Shell: Ensure you have access to a Bash shell on your Linux system.

### Steps to Generate the Network Information Report

1. **Download the Script:** Download the `network_info.sh` script to your local machine.

2. **Make the Script Executable:** Open a terminal and navigate to the directory containing the script. Use the `chmod +x` command to make the script executable:

    ```bash
    chmod +x network_info.sh
    ```

3. **Run the Script:** Execute the script by typing `./` followed by the script name:

    ```bash
    ./network_info.sh
    ```

4. **Review the Report:** After executing the script, an HTML report named `network_info.html` will appear in the current directory. To view the report, right-click on the file, select "Open With," and choose any web browser you prefer.

By following these steps, both Windows and Linux users can benefit from the network information tool.
