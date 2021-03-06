[CmdletBinding()]
Param ([Switch]$SelfHosted)
$psModPath = $env:PSModulePath.Split(";")[0]
if (!(Test-Path -Path $psModPath)) { New-Item -Path $psModPath -ItemType Directory | Out-Null }

If ($SelfHosted) { $psdFile = Import-PowerShellDataFile -Path ".\Scripts\Operations\Az.WvdOperations.psd1" }
Else { $psdFile = Import-PowerShellDataFile -Path ".\Operations\Az.WvdOperations.psd1" }
$desiredModulePath = "$psModPath\Az.WvdOperations\$($psdFile.ModuleVersion)\"
if (!(Test-Path -Path $desiredModulePath)) { New-Item -Path $desiredModulePath -ItemType Directory | Out-Null }

If ($SelfHosted) {
    Copy-Item -Path ".\Scripts\Operations\Az.WvdOperations.psd1" -Destination $desiredModulePath -Force
    Copy-Item -Path ".\Scripts\Operations\Az.WvdOperations.psm1" -Destination $desiredModulePath -Force
}
Else {
    Copy-Item -Path ".\Operations\Az.WvdOperations.psd1" -Destination $desiredModulePath -Force
    Copy-Item -Path ".\Operations\Az.WvdOperations.psm1" -Destination $desiredModulePath -Force
}

Write-Host ("Importing Module: Az.WvdOperations")
If (!(Get-InstalledModule Az -MinimumVersion 4.0.0)) {
    Write-Warning ("Az Module NOT installed, installing and importing")
    Install-Module Az -AllowClobber -Force
    Import-Module Az.WvdOperations -Force
}
Else { Import-Module Az.WvdOperations -Force }