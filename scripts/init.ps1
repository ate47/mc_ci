param(
    # Force projects json create, might overwrite the previous file
    [switch]
    $Force
)

$prevPwd = $PWD

try {
    $base = (Get-Item $PSScriptRoot).parent
    Set-Location ($base.Fullname)


    if (!(Test-Path "project.json") -or $Force) {
        @{
            "projects" = @()
        } | ConvertTo-Json > project.json
    }

    return Get-Content .\project.json | ConvertFrom-Json
} finally {
  $prevPwd | Set-Location
}
