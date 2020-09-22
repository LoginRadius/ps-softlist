﻿
<#
  .SYNOPSIS
    Scan Installed Sofatware's list and Compare with WhiteListed Software 

  .DESCRIPTION
    This script scane all installed sofware and compare from the WhiteListed Software. This is usefull for a audit  .

  .PARAMETER Choice
    Specifies the result output. Supporting two type output: 
    [L] List The Output on the cmd Window
    [M] List and Create a CSV-based output file. Send CSV-based output fil in the Mail 

    (default is "L"):.

  .EXAMPLE
    C:\PS> .\ScaneInstalledSoftwars.ps1

  .EXAMPLE
    C:\PS> .\ScaneInstalledSoftwars.ps1
    Please Choose option
    [L] List Do you want to List 
    [M] Mail Do you want to send CSV file in the Email 

    (default is "L"): : M
    Please Enter WhiteList Software CSV Name: WhiteListSoftware.csv
    Please Enter your CSV Export Path: Result.csv
    Please Enter SMTP From Email Address: example@example.com
    Please Enter SMTP User Name: example@example.com
    Please Enter SMTP Password: 12345
#>


param ([string]$Choice, [string]$WhiteListSoftwareCSV, [string]$ExportCSVPath, [string]$SMTPUserName, [string]$SMTPPassword
, [string]$SMTPFromEmailAddress, [string]$SMTPToEmailAddress)

function Get-Data { }


# -------------------------------------------------------------------------------------------------------
# Author: Vijay Singh Shekhawat
# Date : 01-09-2020
# -------------------------------------------------------------------------------------------------------


$Choice = Read-Host -Prompt 'Please Choose option
[L] List Do you want to List 
[M] Mail Do you want to send CSV file in the Email 

(default is "L"): '

$SMTPUserName = "";
$SMTPPassword = "";

$WhiteListSoftwareCSV = Read-Host -Prompt 'Please Enter WhiteList Software CSV Name'

$ExportCSVPath =  Read-Host -Prompt 'Please Enter your CSV Export Path' # "E:\Development\Software Scaning\TestResult.csv";

if ($Choice -eq ""){
    $Choice="L"
}

if ($Choice.ToLower() -eq "m"){

    $SMTPUserName =  Read-Host -Prompt ' Please Enter SMTP User Name';
    $SMTPPassword = Read-Host -Prompt ' Please Enter SMTP Password';

    $SMTPFromEmailAddress = Read-Host -Prompt ' Please Enter SMTP From Email Address';
    $SMTPToEmailAddress = Read-Host -Prompt ' Please Enter SMTP To Email Address';

}

$Software = @()
$Export = @()



# Determine script location for PowerShell
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
 
Write-Host "Current script directory is $ScriptDir"

Import-Csv $ScriptDir\$WhiteListSoftwareCSV |`
    ForEach-Object {
        $Software += $_.Software

        write-host $_.Software
   }


$Result= Get-ItemProperty  HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate
Write-Host " ============= .:: Software WhiteListed ::. ============= "

foreach($R in $Result){

    if ($Software -contains $R.DisplayName){
    
        if ($Choice.ToLower()  -eq "l"){
            Write-Host "Software Name: " $R.DisplayName
        }

            $Where = [array]::IndexOf($Software, $R.DisplayName)

        }
}


Write-Host " ============= .:: Software Not WhiteListed ::. ============= "

foreach($R in $Result){

    
        if ($Choice.ToLower() -eq "l"){

            Write-Host "Software Name: " $R.DisplayName
        
        }

         $Export += $R.DisplayName
}


$Export | Out-File $ExportCSVPath


function ValidateEmail{
    param([string]$address)
    ($address -as [System.Net.Mail.MailAddress]).Address `
	-eq $address -and $address -ne $null
}

 function Send-ToEmail([string]$email, [string]$attachmentpath,[string]$SystemName){

    $message = new-object Net.Mail.MailMessage;
    $message.From = $SMTPFromEmailAddress;
    $message.To.Add($email);
    $message.Subject ="Software Scane Result for  - $($SystemName)";
    $message.Body = "Please Find Report in the attachment";
    $attachment = New-Object Net.Mail.Attachment($attachmentpath);
    $message.Attachments.Add($attachment);

    $smtp = new-object Net.Mail.SmtpClient("smtp.gmail.com", "587");
    $smtp.EnableSSL = $true;
    $smtp.Credentials = New-Object System.Net.NetworkCredential($SMTPUserName, $SMTPPassword);
    $smtp.send($message);
    write-host "Mail Sent" ; 
    $attachment.Dispose();
 }


if ($Choice.ToLower() -eq "m"){

Send-ToEmail  -email $SMTPToEmailAddress -attachmentpath $ExportCSVPath -systemname $(Get-WmiObject Win32_Computersystem).name ;

}