# 🛍️ Project Walkthrough
## *Threat Hunting at Scale with PowerShell Remoting*

---

## 🔹 **Step 1: Launch Remote Servers**
Run the pre-configured lab setup script to simulate three remote Windows Server containers.

```powershell
.\start-servers.ps1
```

> 💡 *This script starts alpha-svr1, alpha-svr2, and alpha-svr3.*

---

## 🔹 **Step 2: Load Server List and Credentials**

```powershell
[string[]]$AlphaServers = Get-Content -Path 'C:\sec401\labs\5.4\alpha-servers.txt'
$creds = Get-Credential
```

- `$AlphaServers`: Stores the list of remote systems
- `$creds`: Prompts for and stores secure credentials used for remoting

---

## 🔹 **Step 3: Get OS Info Remotely**

```powershell
Invoke-Command -Authentication Basic -Credential $creds -ComputerName $AlphaServers -Command {
    Get-CimInstance Win32_OperatingSystem | Select-Object CSName, Caption
} | Format-Table
```

🌟 *This verifies connectivity and gathers basic OS info.*

---

## 🔹 **Step 4: Search for Malicious Executables**

```powershell
Invoke-Command -Authentication Basic -Credential $creds -ComputerName $AlphaServers -Command {
    Get-ChildItem C:\Windows\*.exe
} | Format-Table
```

- Found `broker.exe` **only on `alpha-svr3.local`**
- On other systems, found a file named `proxy.exe`

---

## 🔹 **Step 5: Compare File Hashes**

Enter interactive session on `alpha-svr3.local`:

```powershell
Enter-PsSession -Authentication Basic -Credential $creds -ComputerName alpha-svr3.local
```

Then run:

```powershell
Get-FileHash C:\Windows\broker.exe -Algorithm SHA256
Get-FileHash C:\Windows\proxy.exe -Algorithm SHA256
```

✔️ *Hashes matched → confirmed same file with different names*

---

## 🔹 **Step 6: Check for Persistence – Admin Accounts**

```powershell
Invoke-Command -Authentication Basic -Credential $creds -ComputerName $AlphaServers -Command {
    Get-LocalGroupMember -Group "Administrators"
} | Format-Table
```

- Detected suspicious account: `Adninistrator` (misspelled)
- Present on both `alpha-svr3` and `alpha-svr1`

---

## 🔹 **Step 7: Check for Persistence – New Services**

```powershell
Invoke-Command -Authentication Basic -Credential $creds -ComputerName $AlphaServers -Command {
    Get-WinEvent -FilterHashtable @{LogName='System'; ID=7045} -MaxEvents 3
} | Format-List
```

- Event ID 7045 = *New service installed*
- Helps detect stealthy persistence methods used by APT groups

---

## 🏁 Final Findings

| IOC | Host(s) Affected | Notes |
|-----|------------------|-------|
| `broker.exe` | alpha-svr3 | Found only here |
| `proxy.exe` | alpha-svr1, alpha-svr2 | Same hash as `broker.exe` |
| `Adninistrator` account | alpha-svr3, alpha-svr1 | Likely attacker backdoor |
| New service events (7045) | All hosts | Reviewed for persistence |

---

## 🧠 Skills Demonstrated

- PowerShell scripting & automation
- PowerShell Remoting
- Threat hunting methodology
- IOC detection and hash analysis
- Persistence detection via account and service review
- Scalable incident response

Add full project walkthrough
