import type { CompilerOptions } from 'typescript'
import path from 'path'
import { parse } from 'comment-json'
import fs from 'fs'

const tsConfigFile = path.join(path.resolve('./'), 'tsconfig.json')
const tsConfig = parse(fs.readFileSync(tsConfigFile).toString(), undefined, true) as Record<string, unknown>
const compilerOptions = tsConfig!.compilerOptions as CompilerOptions

interface AliasSet {
  aliases: string[]
  replacement: string
}

interface ModuleAlias {
  find: string
  replacement: string
}

export default function aliasFactory(): ModuleAlias[] {
  console.debug({ compilerOptions })
  return []
}
