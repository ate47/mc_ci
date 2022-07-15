<h1 align="center">
<a href="https://github.com/ate47/mc_ci">
<img src="docs/logo.png" alt="Logo" width="100" height="100">

**Minecraft CI**
</a>
</h1>

<div align="center">


Project to test/sync ci to all my mods

[Test project on CurseForge](https://www.curseforge.com/minecraft/mc-mods/ci-test-mod)

</div>

- [Minecraft CI](#minecraft-ci)
  - [`project.json` schema](#projectjson-schema)
  - [Scripts](#scripts)

# Minecraft CI

I'm a Powershell user, so my scripts are with [Powershell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7).

## `project.json` schema

Config file to store the projects.

```json
{
    "projects": [
        {
            "id": "user/repository",
            "branches": [
                "branch1",
                "branch2"
            ]
        }
    ]
}
```

## Scripts

- `list_project.ps1`: Print a list of the projects
- `update_project.ps1 -Id "user/repo" (-Editor "text-editor-cmd")`: Create or update a project, will open a file with an editor to select which branch to sync.
- `delete_project.ps1 -Id "user/repo"`: Delete a project
- `get_project.ps1 -Id "user/repo"`: Get a project
- `init.ps1`: Init the project.json file, done by default with the other scripts.
