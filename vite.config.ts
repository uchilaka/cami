import { defineConfig } from 'vite';
import * as path from 'path';
import FullReload from 'vite-plugin-full-reload';
import RubyPlugin from 'vite-plugin-ruby';
// TODO: Replace with https://github.com/vitejs/vite-plugin-react/tree/main/packages/plugin-react
import ViteReact from '@vitejs/plugin-react-refresh';

export default defineConfig({
  // Recommended plugins: https://vite-ruby.netlify.app/guide/plugins.html
  plugins: [ViteReact(), RubyPlugin(), FullReload(['config/routes.rb', 'app/views/**/*'], { delay: 250 })],
  resolve: {
    alias: [
      {
        find: '@/lib',
        replacement: path.resolve(__dirname, './app/frontend/components/lib/')
      },
      {
        find: '@/components',
        replacement: path.resolve(__dirname, './app/frontend/components/')
      },
      {
        find: '@/entrypoints',
        replacement: path.resolve(__dirname, './app/frontend/entrypoints')
      }
    ]
  }
});
