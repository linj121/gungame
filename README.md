<div align="center">
  <h1><code>l4d2 Gun Game Plugin</code></h1>
  <p>
    <strong>Grant players random weapons upon kills</strong>
  </p>
  <p style="margin-bottom: 0.5ex;">
    <img
        src="https://img.shields.io/github/downloads/linj121/gungame/total"
    />
    <img
        src="https://img.shields.io/github/last-commit/linj121/gungame"
    />
    <img
        src="https://img.shields.io/github/issues/linj121/gungame"
    />
    <img
        src="https://img.shields.io/github/issues-closed/linj121/gungame"
    />
    <img
        src="https://img.shields.io/github/repo-size/linj121/gungame"
    />
    <img
        src="https://img.shields.io/github/actions/workflow/status/linj121/gungame/main.yml"
    />
  </p>
</div>

## Requirements ##

- Sourcemod and Metamod

## Installation ##

1. Grab the latest release from the release page and unzip it in your sourcemod folder.
2. Restart the server or type `sm plugins load gungame` in the console to load the plugin.
3. The config file will be automatically generated in cfg/sourcemod/

## Configuration ##

- You can modify the phrases in addons/sourcemod/translations/gungame.phrases.txt.
- Once the plugin has been loaded, you can modify the cvars in cfg/sourcemod/gungame.cfg.

## Usage ##

Players will get a random primary weapon (or gnome and cola bottles) upon killing a zombie (common infected or all infected, based on cvar `sm_only_sp_infected`)

## Docs ##

- Get infected name: https://forums.alliedmods.net/showthread.php?t=302727