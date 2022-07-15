param(
  # Project id
  [string]
  $Id,

  $Editor = "vim"
)

if ($null -eq $Id -or "" -eq $Id) {
    Write-Error "Bad Id"
    return $null
}

$prevPwd = $PWD
$TmpFile = "tmp/branches_$(Get-Random).txt"

try {
    $base = (Get-Item $PSScriptRoot).parent
    Set-Location ($base.Fullname)

    $Edited = $false
    $Branches = $null

    $Projects = scripts/init.ps1
    
    $ProjectsArray = @(($Projects.projects | % {
        $Project = $_

        if (($Project.id) -eq $Id) {
            $Branches = $Project.branches
        } else {
            $Project
        }
    }))

    # Fetch the heads
    $Url = "https://github.com/$($Id)"

    $Heads = git ls-remote --heads $Url | % {
        ($_ -split "\s+")[1]
    }

    # Create tmp directory if required
    New-Item -Type Directory tmp  -ErrorAction Ignore > $null

    # Write the branches file
    "# Remove the '#' in front of the branches you want to sync.
$(($Heads | % {
        $Branch = $_

        # If the branch was already selected, we keep it
        if ($Branch -in $Branches) {
            "$Branch"
        } else {
            "#$Branch"
        }
    } )-join "`n")" > $TmpFile
    
    # Open the editor to edit the branh
    . "$Editor" $TmpFile
    
    # Return the branches
    $Created = [PSCustomObject]@{
        "id" = $Id
        "branches" = @(Get-Content $TmpFile | % {
            $Line = $_
    
            if (!($Line.StartsWith("#") -or $Line.Length -eq 0)) {
                [string]$Line
            }
        })
    }
    if ($null -eq $ProjectsArray -or $null -eq $ProjectsArray[0]) {
        ConvertTo-Json ([PSCustomObject]@{
            "projects" =  @($Created)
        })  -Depth 100 > config/project.json
    } else {
        ConvertTo-Json ([PSCustomObject]@{
            "projects" =  @($ProjectsArray) + $Created
        })  -Depth 100 > config/project.json
    }
} finally {
  $prevPwd | Set-Location
  Remove-Item $TmpFile -Force -ErrorAction Ignore > $null
}
