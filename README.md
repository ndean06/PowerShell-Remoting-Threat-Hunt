# 🛡️ Threat Hunting at Scale with PowerShell Remoting

This project simulates an enterprise-level threat hunting and incident response investigation using PowerShell Remoting. The goal was to detect signs of attacker persistence, analyze suspicious files, and identify unauthorized administrator accounts across multiple Windows Server hosts.

---

## 🎯 Objectives

- Use PowerShell Remoting to perform scalable investigations
- Detect renamed or hidden malware executables
- Perform hash-based file verification (e.g., `proxy.exe` and `broker.exe`)
- Identify unauthorized local admin accounts
- Discover persistence through newly installed services (Event ID 7045)

---

## 🧰 Tools & Technologies Used

- PowerShell Remoting (`Invoke-Command`, `Enter-PSSession`)
- Windows Event Log (`Get-WinEvent`)
- `Get-FileHash`, `Get-LocalGroupMember`
- PowerShell ISE
- Windows Server containers (simulated hosts)
- Windows 11 Enterprise (VM)

---

## 🗂️ Repository Structure



---

## 📖 Full Project Walkthrough

For a detailed step-by-step breakdown of how I conducted this investigation, including all commands used and analysis techniques:

👉 [View the full project walkthrough](walkthrough.md)





