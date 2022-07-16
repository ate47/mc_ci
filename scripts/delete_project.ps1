param(
    # Project id
    [string]
    $Id,
    $File = "config/project.json"
)

if ($null -eq $Id -or "" -eq $Id) {
    Write-Error "Bad Id"
    return $null
}

$prevPwd = $PWD

try {
    $base = (Get-Item $PSScriptRoot).parent
    Set-Location ($base.Fullname)

    $Projects = scripts/init.ps1 -File $File

    $ProjectsArray =@($Projects.projects | % {
        $Project = $_

        if (($Project.id) -ne $Id) {
            $Project
        }
    })
    if ($null -eq $ProjectsArray -or $null -eq $ProjectsArray[0]) {
        @{
            "projects" =  @()
        } | ConvertTo-Json -Depth 100 > $File
    } else {
        @{
            "projects" =  @($ProjectsArray)
        } | ConvertTo-Json -Depth 100 > $File
    }
} finally {
  $prevPwd | Set-Location
}
