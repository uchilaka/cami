/* eslint-disable no-undef */
import { defineConfig } from 'vite'
import path from 'path'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'
// TODO: Replace with https://github.com/vitejs/vite-plugin-react/tree/main/packages/plugin-react
import ViteReact from '@vitejs/plugin-react-refresh'
import { viteAliasConfigFromFactory } from './app/frontend/utils/aliasFactory'

/**
 * TODO: Weird error (see article). Not sure if this helps https://dev.to/boostup/uncaught-referenceerror-process-is-not-defined-12kg
 */
export default defineConfig({
  // Recommended plugins: https://vite-ruby.netlify.app/guide/plugins.html
  plugins: [ViteReact(), RubyPlugin(), FullReload(['config/routes.rb', 'app/views/**/*'], { delay: 250 })],
  define: {
    __dirname: JSON.stringify(path.resolve('./')),
    // 'process.env': env,
  },
  resolve: {
    alias: viteAliasConfigFromFactory(),
  },
  // TODO: Research how to use optimizeDeps in a way that doesn't break the app
  // optimizeDeps: {
  //   exclude: ['react', 'react-dom', 'react-router-dom', 'clsx'],
  // },
})
/* eslint-enable no-undef */
