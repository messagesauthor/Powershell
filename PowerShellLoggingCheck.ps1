# Check PowerShell Logging Status
Write-Host "=== POWERSHELL LOGGING STATUS ===" -ForegroundColor Cyan
Write-Host ""

# Check ScriptBlock Logging
$scriptBlockPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$scriptBlockEnabled = $false

if (Test-Path $scriptBlockPath) {
    $scriptBlockValue = Get-ItemProperty -Path $scriptBlockPath -Name "EnableScriptBlockLogging" -ErrorAction SilentlyContinue
    if ($scriptBlockValue -and $scriptBlockValue.EnableScriptBlockLogging -eq 1) {
        $scriptBlockEnabled = $true
        Write-Host "ScriptBlock Logging: ENABLED (via Group Policy)" -ForegroundColor Red
    } else {
        Write-Host "ScriptBlock Logging: DISABLED (via Group Policy)" -ForegroundColor Green
    }
} else {
    Write-Host "ScriptBlock Logging: NOT CONFIGURED (Default: Limited logging only)" -ForegroundColor Yellow
}

# Check Module Logging
$modulePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging"
$moduleLoggingEnabled = $false

if (Test-Path $modulePath) {
    $moduleValue = Get-ItemProperty -Path $modulePath -Name "EnableModuleLogging" -ErrorAction SilentlyContinue
    if ($moduleValue -and $moduleValue.EnableModuleLogging -eq 1) {
        $moduleLoggingEnabled = $true
        Write-Host "Module Logging:     ENABLED (via Group Policy)" -ForegroundColor Red
    } else {
        Write-Host "Module Logging:     DISABLED (via Group Policy)" -ForegroundColor Green
    }
} else {
    Write-Host "Module Logging:     NOT CONFIGURED (Default: Off)" -ForegroundColor Green
}

# Check Transcription Logging
$transcriptionPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
$transcriptionEnabled = $false

if (Test-Path $transcriptionPath) {
    $transcriptionValue = Get-ItemProperty -Path $transcriptionPath -Name "EnableTranscripting" -ErrorAction SilentlyContinue
    if ($transcriptionValue -and $transcriptionValue.EnableTranscripting -eq 1) {
        $transcriptionEnabled = $true
        Write-Host "Transcription:      ENABLED (via Group Policy)" -ForegroundColor Red
    } else {
        Write-Host "Transcription:      DISABLED (via Group Policy)" -ForegroundColor Green
    }
} else {
    Write-Host "Transcription:      NOT CONFIGURED (Default: Off)" -ForegroundColor Green
}

# Check if any logging is enabled via Group Policy
$anyGPLoggingEnabled = $scriptBlockEnabled -or $moduleLoggingEnabled -or $transcriptionEnabled

Write-Host ""
if ($anyGPLoggingEnabled) {
    Write-Host "OVERALL STATUS: POWER SHELL LOGGING IS ENABLED VIA GROUP POLICY" -ForegroundColor Red
} else {
    Write-Host "OVERALL STATUS: POWER SHELL LOGGING IS DISABLED (Default state)" -ForegroundColor Green
}

# Additional info about default behavior
Write-Host ""
Write-Host "=== ADDITIONAL INFORMATION ===" -ForegroundColor Cyan
Write-Host "• Default ScriptBlock Logging: Automatically logs some 'suspicious' scripts even when disabled" -ForegroundColor Gray
Write-Host "• Module Logging: Completely off by default unless enabled via GPO" -ForegroundColor Gray
Write-Host "• Transcription: Completely off by default unless enabled via GPO" -ForegroundColor Gray
Write-Host "• Operational logs (basic PowerShell events) are always recorded" -ForegroundColor Gray

# Check current session transcription
Write-Host ""
if ($Host.Name -eq "ConsoleHost" -or $Host.Name -like "*ISE*") {
    try {
        $transcripting = Test-Path -Path (Get-ChildItem -Path "$env:USERPROFILE\*" -Include "*Transcript*" -ErrorAction SilentlyContinue | Select-Object -First 1)
        if ($transcripting) {
            Write-Host "Note: Transcript files found in user profile (may be from manual Start-Transcript)" -ForegroundColor Yellow
        }
    } catch {
        # Ignore errors
    }
}