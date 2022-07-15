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

    $ProjectsArray =@($Projects.projects | % {
        $Project = $_

        if (($Project.id) -ne $Id) {
            $Project
        }
    })
    if ($null -eq $ProjectsArray -or $null -eq $ProjectsArray[0]) {
        @{
            "projects" =  @()
        } | ConvertTo-Json -Depth 100 > config/project.json
    } else {
        @{
            "projects" =  @($ProjectsArray)
        } | ConvertTo-Json -Depth 100 > config/project.json
    }
} finally {
  $prevPwd | Set-Location
}
