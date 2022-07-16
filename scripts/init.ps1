param(
    # Force projects json create, might overwrite the previous file
    [switch]
    $Force,
    $File = "config/project.json"
)

$prevPwd = $PWD

try {
    $base = (Get-Item $PSScriptRoot).parent
    Set-Location ($base.Fullname)


    if (!(Test-Path $File) -or $Force) {
        @{
            "projects" = @()
        } | ConvertTo-Json > $File
    }

    return Get-Content $File | ConvertFrom-Json
} finally {
  $prevPwd | Set-Location
}
