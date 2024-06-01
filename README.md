# NetworkInformationReport
A tool for "Network Engineers" to navigate through a device's Network Information faster.

### Prerequisites:
1. **Windows Operating System**: The script is designed to run on Windows.
2. **PowerShell**: Ensure PowerShell is installed on your system.


### Steps to Generate the Network Information Report:

#### Method 1: Using PowerShell

1. **Download the Script**: Download the `network_info.ps1` script to your local machine.

2. **Open PowerShell**: Open PowerShell by searching for it in the Start menu and selecting the application.

3. **Navigate to the Script Directory (Optional)**: If the script is not in the current directory, navigate to its location using the `cd` command:
   ```powershell
   cd C:\Path\To\Script\Directory
   ```

4. **Run the Script**: Execute the script by typing its name followed by `.ps1`:
   ```powershell
   .\network_info.ps1
   ```

5. **Review the Report**: After executing the script, it will generate an HTML report named `network_info.html`. This report contains various sections such as DNS information, default gateway, DHCP server status, routing table, ARP table, interface statistics, DNS resolution test results, traceroute, and more. The report will open automatically in your default web browser.

#### Method 2: Using Batch File

1. **Download the Scripts**: Download both the `network_info.ps1` script and the `run_network_info.bat` batch file to your local machine.

2. **Place Both Files Together**: Ensure that both files are in the same directory.

3. **Run the Batch File**: Double-click the `run_network_info.bat` file. This batch file will automatically locate and execute the PowerShell script.

4. **Review the Report**: Similar to the PowerShell method, the script will generate an HTML report named `network_info.html` and open it automatically in your default web browser.

### Notes:
- **Customization**: You can customize the appearance of the report by modifying the CSS styles within the script.
- **Permissions**: Ensure that you have the necessary permissions to execute PowerShell scripts on your system. You may need to adjust the execution policy using the `Set-ExecutionPolicy` command.
- **Internet Connection**: Some sections of the report, such as DNS resolution test and traceroute, require an active internet connection to fetch data.

That's it! By following these steps, you can easily generate a comprehensive network information report using either PowerShell or a batch file for simplicity.
