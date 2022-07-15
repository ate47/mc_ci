param(
    [string]    
    $Message,
    [string]
    $Editor = "vim"
)

$prevPwd = $PWD

try {
    $base = (Get-Item $PSScriptRoot).parent
    Set-Location ($base.Fullname)

    if ($null -eq $Message -or "" -eq $Message) {
        . "$Editor" "config/sync_commit_message.txt"
    } else {
        $Message > config/sync_commit_message.txt
    }

    return Get-Content config/sync_commit_message.txt
} finally {
  $prevPwd | Set-Location
}
