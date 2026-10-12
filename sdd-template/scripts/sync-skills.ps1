<#
.SYNOPSIS
    Sincroniza las skills del sdd-template hacia la carpeta global de opencode.

.DESCRIPTION
    Fuente versionada : <repo>\sdd-template\skills\
    Destino global    : $env:USERPROFILE\.config\opencode\skills\
    Copia <skill>\SKILL.md por cada skill (transversal, de stack y sdd-boot).
    Es el paso de "despliegue": edita siempre en el framework y luego sincroniza.

    Nota: requiere autorización del usuario antes de escribir (regla del framework).

.PARAMETER Only
    Sincroniza solo las skills indicadas (por nombre de carpeta). Ej: -Only security,testing

.PARAMETER Force
    Sobrescribe sin preguntar (por defecto también sobrescribe, pero lo reporta).

.EXAMPLE
    .\sync-skills.ps1 -WhatIf
    .\sync-skills.ps1
    .\sync-skills.ps1 -Only security,clean-code,sdd-boot -Force
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string[]]$Only,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$frameworkRoot = Split-Path -Parent $PSScriptRoot
$source        = Join-Path $frameworkRoot 'skills'
$destination   = Join-Path $env:USERPROFILE '.config\opencode\skills'

if (-not (Test-Path -LiteralPath $source)) {
    throw "No se encontró la carpeta de skills fuente: $source"
}

if (-not (Test-Path -LiteralPath $destination)) {
    if ($PSCmdlet.ShouldProcess($destination, 'Crear carpeta de skills global')) {
        New-Item -ItemType Directory -Force -Path $destination | Out-Null
    }
}

$skills = Get-ChildItem -LiteralPath $source -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md')
}

if ($Only) {
    $skills = $skills | Where-Object { $Only -contains $_.Name }
}

if (-not $skills) {
    Write-Warning 'No hay skills que coincidan para sincronizar.'
    return
}

$copied = 0
foreach ($skill in $skills) {
    $targetDir  = Join-Path $destination $skill.Name
    $targetFile = Join-Path $targetDir 'SKILL.md'
    $exists     = Test-Path -LiteralPath $targetFile

    if (-not (Test-Path -LiteralPath $targetDir)) {
        if ($PSCmdlet.ShouldProcess($targetDir, 'Crear carpeta de skill')) {
            New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
        }
    }

    if ($PSCmdlet.ShouldProcess($targetFile, $(if ($exists -and -not $Force) { 'Sobrescribir skill' } else { 'Copiar skill' }))) {
        Copy-Item -LiteralPath (Join-Path $skill.FullName 'SKILL.md') -Destination $targetFile -Force
        $copied++
        Write-Host ("  [ok] {0}{1}" -f $skill.Name, $(if ($exists) { ' (actualizada)' } else { '' })) -ForegroundColor Green
    }
}

Write-Host ""
Write-Host ("Sincronizadas {0} skill(s) en {1}" -f $copied, $destination) -ForegroundColor Cyan
Write-Host "Reinicia opencode para que tome los cambios." -ForegroundColor Yellow
