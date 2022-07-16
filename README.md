<h1 align="center">
<a href="https://github.com/ate47/mc_ci">
<img src="docs/logo.png" alt="Logo" width="100" height="100">

**Minecraft CI 🚀**
</a>

</h1>

<div align="center">

Project to test/sync ci to all my mods

[Test project on CurseForge](https://www.curseforge.com/minecraft/mc-mods/ci-test-mod)

</div>

- [Minecraft CI](#minecraft-ci)
  - [`project.json` schema](#projectjson-schema)
  - [Scripts](#scripts)
  - [Sync process](#sync-process)

# Minecraft CI

I'm a Powershell user, so my scripts are with [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7).

## `project.json` schema

Config file to store the projects.

```json
{
  "projects": [
    {
      "id": "user/repository",
      "branches": ["branch1", "branch2"]
    }
  ]
}
```

## Scripts

- `list_project.ps1`: Print a list of the projects.
- `update_project.ps1 -Id "user/repo" (-Editor "text-editor-cmd")`: Create or update a project, will open a file with an editor to select which branch to sync.
- `delete_project.ps1 -Id "user/repo"`: Delete a project.
- `get_project.ps1 -Id "user/repo"`: Get a project.
- `update_sync_commit.ps1 (-Editor "text-editor-cmd") (-Message "commit message")`: Set the sync commit message.
- `init.ps1`: Init the project.json file, done by default with the other scripts.
- `sync.ps1`: Sync the projects. [See Sync process](#sync-process-)

## Sync process

all files in the `common.github` directory will be sync into the branches/projects with one commit with the message described in `sync_commit_message.txt`.

By default it should be used using the `.github/workflows/sync.yml` workflow, but you can run the command to sync by using this command:

```powershell
scripts/sync.ps1 `
    -IKnowWhatImDoing `
    -File "config/project.json"`
    -GitUser 'username for the sync commit'`
    -GitMail 'mail for the sync commit'`
    -GitPushUser 'Github username'`
    -GitPassword 'Github password or token'
```

The names are pretty much self explaining, but:

- `-IKnowWhatImDoing`: Mandadory, admit it'll be your fault.
- `-File`: project.json file, by default `"config/project.json"`.
- `-GitUser`: username for the sync commit.
- `-GitMail`: mail for the sync commit.
- `-GitPushUser`: Github username to push the sync commit.
- `-GitPassword`: Github password or token to push the sync commit.
