# CAMI > VSCode

## Example Workspace Config

```jsonp
{
  "folders": [
    {
      "path": ".",
      "name": "Rails"
    },
    {
      "path": "./app/views/",
      "name": "Rails/Views"
    },
    {
      "path": "./app/frontend/components/",
      "name": "Frontend/Components"
    },
    {
      "path": "./app/frontend/features/",
      "name": "Frontend/Features"
    },
    {
      "path": "./app/frontend/routes/",
      "name": "Frontend/Routes"
    },
    {
      "path": "./app/frontend/entrypoints/",
      "name": "Frontend/Entrypoints"
    },
    {
      "path": "./app/frontend/utils/",
      "name": "Frontend/Utils"
    },
    {
      "path": "./.storybook/",
      "name": "Storybook"
    },
  ],
  "settings": {
    "terminal.integrated.fontSize": 18,
    "window.zoomLevel": 0.125,
    "rubyLsp.rubyVersionManager": {
      "identifier": "asdf",
    },
    "rubyLsp.formatter": "auto",
    "rubyLsp.rubyExecutablePath": "${userHome}/.rbenv/shims/rubocop",
    "powershell.powerShellAdditionalExePaths": {
      "pwshInWSL": "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe",
    },
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "[typescript]": {
      "editor.codeActionsOnSave": {
        "source.fixAll.eslint": "explicit",
      },
    },
    "[typescriptreact]": {
      "editor.codeActionsOnSave": {
        "source.fixAll.eslint": "explicit",
      },
    },
  }
}
```
