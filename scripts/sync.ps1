param(
    [switch]
    $IKnowWhatImDoing,

    $File = "config/project.json"
)

if (!$IKnowWhatImDoing) {
    Write-Error "You must add the -IKnowWhatImDoing parameter to start this operation."
    return $null
}

$emojis = @{
    news = "`u{1F4F0}"
    sync = "`u{1F503}"
    construction = "`u{1F3D7}`u{FE0F}"
    fire = "`u{1F525}"
    gear = "`u{2699}`u{FE0F}"
    rocket = "`u{1F680}"
    champagne = "`u{1F37E}"
}

$prevPwd = $PWD

try {
    $base = (Get-Item $PSScriptRoot).parent
    Set-Location ($base.Fullname)

    $Projects = scripts/init.ps1 -File $File

    $CommitMessage = [string](Get-Content "config/sync_commit_message.txt")
    
    Write-Host "$($emojis.news) Using commit message: '$CommitMessage'."
    Write-Host ""

    foreach ($Project in ($Projects.projects)) {
        Write-Host "$($emojis.sync) -- Sync project $($Project.id)..."
        
        $url = "https://github.com/$($Project.id)"
        $dir = "tmp/$($Project.id)"

        try {
            # clone the directory
            git clone $url $dir

            foreach ($BranchRef in ($Project.branches)) {
                $Branch = $BranchRef.Split("/")[-1]
                Write-Host "$($emojis.construction) ---- Checkout to branch $Branch"
                # checkout the branch and reset to it
                git checkout $Branch
                git reset -hard
                Write-Host "$($emojis.fire) ------ Remove .github directory"
                Remove-Item -Force -Recurse "$dir/.github"
                Copy-Item "common.github" "$dir/.github" -Recurse
                Write-Host "$($emojis.gear) ------ Create sync commit"
                # sync the config
                git add "$dir/.github"
                git commit -m $CommitMessage
                Write-Host "$($emojis.rocket) ------ Push commit..."
                # push the config
                git push
                Write-Host "$($emojis.champagne) ---- Sync of branch $Branch done!"
                Write-Host "-------------------------------------------"
            }
            Write-Host "$($emojis.champagne) -- Sync of project $($Project.id) done!"
            Write-Host "-------------------------------------------"
        } finally {
            # clear space
            Remove-Item -Force -Recurse $dir
        }
    }
    Write-Host "$($emojis.champagne) -- CI Sync done!"
} finally {
  $prevPwd | Set-Location
}
