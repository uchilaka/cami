import type { CompilerOptions } from 'typescript'
import path from 'path'
import { parse } from 'comment-json'
import fs from 'fs'
import omit from 'lodash.omit'
import uniqBy from 'lodash.uniqby'

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

type SupportedTsPathPattern = Record<string, string[]>

export const aliasFactory = () => {
  const pathsToProcess = omit(compilerOptions.paths as SupportedTsPathPattern, ['@/*']) as SupportedTsPathPattern
  return Object.entries(pathsToProcess).map<AliasSet>(([find, [replacement]]) => {
    const findWithoutAsterisk = find.replace(/\*$/, '')
    const replacementEndsWithSlash = replacement.endsWith('/')
    const replacementWithoutAsterisk = path.resolve(__dirname, `../../../${replacement.replace(/\*$/, '')}`)
    const altFind = findWithoutAsterisk.replace(/^@\//, '@')
    return { aliases: [findWithoutAsterisk, altFind], replacement: `${replacementWithoutAsterisk}${replacementEndsWithSlash ? '/' : ''}` }
  })
}

export const viteAliasConfigFromFactory = () =>
  uniqBy(
    aliasFactory().reduce<ModuleAlias[]>(
      (acc, { aliases, replacement }) => [...acc, ...aliases.map((find) => ({ find, replacement }))],
      [],
    ),
    'find',
  )
