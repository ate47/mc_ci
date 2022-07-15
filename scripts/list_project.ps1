param(
)

$prevPwd = $PWD

try {
    $base = (Get-Item $PSScriptRoot).parent
    Set-Location ($base.Fullname)

    $Projects = scripts/init.ps1

    foreach ($Project in ($Projects.projects)) {
        Write-Host "---- $($Project.id)"
        Write-Host "Branches: $($Project.branches -join ", ")"
    }
} finally {
  $prevPwd | Set-Location
}
