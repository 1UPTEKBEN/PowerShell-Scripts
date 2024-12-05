## CHECK ALL SCRIPTS BEFORE RUNNING THEM!

## FoldersOver50MB.ps1
For doing Drive Audits Over 50MB, Handy for OES Servers

## KeepAlive.ps1
To bypass GPO Sleep/Timeout Settings - Keeps the PC "alive"

## AD-ComputerAliveOrDead.ps1
Helps determine if systems are inactive (based on ping responses). \
Must be run on the Domain Controller for it to function. 
Pings each machine connected via Active Directory (AD) and outputs the results to a CSV, indicating whether the system is "dead" or "alive".
This is a niche use case, but it is handy for auditing old domains to identify connected systems.

## AuditLogon.ps1
Exports a CSV containing Systems & Users login to computers connected to the domain, 
audit logon must be turned on each machine for this to work. 
"Invoke-GPUpdate -Force -AsJob -RandomDelayInMinutes 0" can be used to force each domain connnect PC to enable the GPO Faster.
