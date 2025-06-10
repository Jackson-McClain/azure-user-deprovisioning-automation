# user_deprovisioning.ps1

# Connect to Microsoft Graph with proper scopes
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"

# Input CSV and log
$csvPath = ".\users_to_deprovision.csv"
$logPath = ".\deprovision-log.txt"
"[$(Get-Date)] Starting user deprovisioning..." | Out-File -FilePath $logPath

# Read list of users
$users = Import-Csv -Path $csvPath

foreach ($entry in $users) {
    $username = $entry.Username
    $userId = "$username@jacks90563gmail.onmicrosoft.com"

    try {
        $user = Get-MgUser -UserId $userId
        Write-Host "Processing user: $userId"
        "[$(Get-Date)] Processing $userId" | Out-File -Append -FilePath $logPath
    } catch {
        Write-Warning "User $userId not found."
        "[$(Get-Date)] User $userId not found." | Out-File -Append -FilePath $logPath
        continue
    }

        # Remove from groups
    try {
        $groups = Get-MgUserMemberOf -UserId $user.Id
        foreach ($group in $groups) {
            Remove-MgGroupMemberByRef -GroupId $group.Id -DirectoryObjectId $user.Id
            Write-Host "  -> Removed from group: $($group.AdditionalProperties.displayName)"
            "  -> Removed from group: $($group.AdditionalProperties.displayName)" | Out-File -Append -FilePath $logPath
        }
    } catch {
        Write-Warning "  -> Failed to remove from groups: $_"
        "  -> Failed to remove from groups: $_" | Out-File -Append -FilePath $logPath
    }

    # Disable account
    try {
        Update-MgUser -UserId $user.Id -AccountEnabled:$false
        Write-Host "  -> Disabled account"
        "  -> Disabled account" | Out-File -Append -FilePath $logPath
    } catch {
        Write-Warning "  -> Failed to disable account: $_"
    }

    Write-Host "✅ Finished processing $userId"
    "✅ Finished processing $userId" | Out-File -Append -FilePath $logPath
}

"[$(Get-Date)] Deprovisioning complete." | Out-File -Append -FilePath $logPath
