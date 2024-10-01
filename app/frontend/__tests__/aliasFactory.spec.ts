import { viteAliasConfigFromFactory } from '../utils/aliasFactory'
import { describe, it, xit, expect } from '@jest/globals'
import find from 'lodash.find'
import path from 'path'

describe('aliasFactory', () => {
  const aliases = viteAliasConfigFromFactory()

  it('configures the @components alias', () => {
    const matcher = {
      find: '@/components',
      replacement: path.resolve(__dirname, '../../frontend/components'),
    }
    expect(find(aliases, matcher)).toBeDefined()
  })

  xit('configures the @lib alias', () => {
    const matcher = {
      find: '@/lib',
      replacement: path.resolve(__dirname, '../../frontend/components/lib'),
    }
    expect(find(aliases, matcher)).toBeDefined()
  })

  it('configures the @views alias', () => {
    const matcher = {
      find: '@/views',
      replacement: path.resolve(__dirname, '../../frontend/views'),
    }
    expect(find(aliases, matcher)).toBeDefined()
  })

  xit('configures the @entrypoints alias', () => {
    const matcher = {
      find: '@/entrypoints',
      replacement: path.resolve(__dirname, '../../frontend/entrypoints'),
    }
    expect(find(aliases, matcher)).toBeDefined()
  })

  it('configures the @hooks alias', () => {
    const matcher = {
      find: '@/hooks',
      replacement: path.resolve(__dirname, '../../frontend/hooks'),
    }
    expect(find(aliases, matcher)).toBeDefined()
  })

  it('configures the @pages alias', () => {
    const matcher = {
      find: '@/pages',
      replacement: path.resolve(__dirname, '../../frontend/pages'),
    }
    expect(find(aliases, matcher)).toBeDefined()
  })

  it('configures the @routes alias', () => {
    const matcher = {
      find: '@/routes',
      replacement: path.resolve(__dirname, '../../frontend/routes'),
    }
    expect(find(aliases, matcher)).toBeDefined()
  })

  it('configures the @features alias', () => {
    const matcher = {
      find: '@/features',
      replacement: path.resolve(__dirname, '../../frontend/features'),
    }
    console.debug({ aliases })
    expect(find(aliases, matcher)).toBeDefined()
  })
})
