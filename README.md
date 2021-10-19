# A Quick scan and validate all softwares in the system and figure out whitelisted according to the organization  compliance software list.

## Features

- Compare Installed Software with pre WhiteListed Software List
- Generate report in the CSV Format
- Email the report 

## Quickstart

- Download the power script folder 
- Unzip the downloaded folder
- Locate the bat file ` ScanInstallSoftware.bat`
- Open the bat file and follow the instructions

## Use full Commands 
Follow the commands listed below. It will show you all the parameters details with examples

```powershell
get-help .\ScanInstalledSoftwars.ps1 -full
``` 

## Note 
You need to enable unsigned scripts before executing this powershell script 

Start Windows PowerShell with the "Run as Administrator" option. Only Administrators  can change the execution policy
Enable running unsigned scripts by entering

This will allow running unsigned scripts and signed scripts from the Internet.

```powershell
Set-Executionpolicy RemoteSigned

```

## How to Contribute

To become a contributor, please follow our [contributing guide](Contributing.md).

## License

[MIT](LICENSE)
