/* eslint-disable no-undef */
import { defineConfig } from 'vite'
import path from 'path'
import FullReload from 'vite-plugin-full-reload'
import RubyPlugin from 'vite-plugin-ruby'
// TODO: Replace with https://github.com/vitejs/vite-plugin-react/tree/main/packages/plugin-react
import ViteReact from '@vitejs/plugin-react-refresh'

interface AliasSet {
  aliases: string[]
  replacement: string
}

interface ModuleAlias {
  find: string
  replacement: string
}

const aliasSet: AliasSet[] = [
  {
    aliases: ['@/lib', '@lib'],
    replacement: path.resolve(__dirname, './app/frontend/components/lib/'),
  },
  {
    aliases: ['@/components', '@components'],
    replacement: path.resolve(__dirname, './app/frontend/components/'),
  },
  {
    aliases: ['@/entrypoints', '@entrypoints'],
    replacement: path.resolve(__dirname, './app/frontend/entrypoints'),
  },
  {
    aliases: ['@/views', '@views'],
    replacement: path.resolve(__dirname, './app/frontend/views'),
  },
]

const aliasConfig = aliasSet.reduce<ModuleAlias[]>(
  (acc, { aliases, replacement }) => [...acc, ...aliases.map((find) => ({ find, replacement }))],
  [],
)

export default defineConfig({
  // Recommended plugins: https://vite-ruby.netlify.app/guide/plugins.html
  plugins: [ViteReact(), RubyPlugin(), FullReload(['config/routes.rb', 'app/views/**/*'], { delay: 250 })],
  define: {
    __dirname: JSON.stringify(path.resolve('./')),
  },
  resolve: {
    alias: aliasConfig,
  },
})
/* eslint-enable no-undef */
