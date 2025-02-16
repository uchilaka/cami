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
      "path": "./app/frontend/components/",
      "name": "Frontend/Components"
    },
    {
      "path": "./app/frontend/features/",
      "name": "Frontend/Features"
    },
    {
      "path": "./app/frontend/routes/",
      "name": "Fronend/Routes"
    },
    /**
      * Rendered at the route tree: /pages/...
      * and require updates to the PagesController actions
      * and a file in /app/views/pages/... with a corresponding
      * DOM container target (by ID) to render the correct page
      */
    {
      "path": "./app/frontend/views/",
      "name": "Views"
    },
    {
      "path": "./app/frontend/entrypoints/",
      "name": "Entrypoints"
    },
    {
      "path": "./app/frontend/utils/",
      "name": "Utils"
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
