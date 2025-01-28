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
      "name": "Components"
    },
    {
      "path": "./app/frontend/features/",
      "name": "Features"
    },
    {
      "path": "./app/frontend/routes/",
      "name": "Routes"
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
    "terminal.integrated.fontSize": 15,
    "window.zoomLevel": 0.125,
    "rubyLsp.rubyVersionManager": {
      "identifier": "asdf"
    }
  }
}
```
