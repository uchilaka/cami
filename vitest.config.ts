import { defineConfig } from 'vitest/config'

import fs from 'fs'
import path from 'path'
import { parse } from 'comment-json'
import type { CompilerOptions } from 'typescript'

const tsConfigFile = path.join(path.resolve('./'), 'tsconfig.json')
const tsConfig = parse(fs.readFileSync(tsConfigFile).toString(), undefined, true) as Record<string, unknown>
const { paths } = tsConfig!.compilerOptions as CompilerOptions

console.debug(`Paths detected in TSConfig file: ${tsConfigFile}`, { paths })

export default defineConfig({
  test: {
    environment: 'jsdom', // or 'node'
    globals: true,
  },
  resolve: {
    alias: {
      '@': path.resolve('./app/frontend'),
      '@/components': path.resolve('./app/frontend/components'),
      '@/features': path.resolve('./app/frontend/features'),
      '@/hooks': path.resolve('./app/frontend/hooks'),
      '@/lib': path.resolve('./app/frontend/lib'),
      '@/pages': path.resolve('./app/frontend/pages'),
      '@/routes': path.resolve('./app/frontend/routes'),
      '@/views': path.resolve('./app/frontend/views'),
      '@views': path.resolve('./app/frontend/views'),
    },
  },
})
