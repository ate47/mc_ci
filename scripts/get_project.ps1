param(
    # Project id
    [string]
    $Id
)

if ($null -eq $Id -or "" -eq $Id) {
    Write-Error "Bad Id"
    return $null
}


$prevPwd = $PWD

try {
    $base = (Get-Item $PSScriptRoot).parent
    Set-Location ($base.Fullname)

    $Projects = scripts/init.ps1

    foreach ($Project in ($Projects.projects)) {
        if ($Project.id -eq $Id) {
            return $Project
        }
    }

    return $null
} finally {
  $prevPwd | Set-Location
}
