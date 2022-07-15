param(
    # Force projects json create, might overwrite the previous file
    [switch]
    $Force
)

$prevPwd = $PWD

try {
    $base = (Get-Item $PSScriptRoot).parent
    Set-Location ($base.Fullname)


    if (!(Test-Path "config/project.json") -or $Force) {
        @{
            "projects" = @()
        } | ConvertTo-Json > config/project.json
    }

    return Get-Content config/project.json | ConvertFrom-Json
} finally {
  $prevPwd | Set-Location
}
