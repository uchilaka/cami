import aliasFactory from '../utils/aliasFactory'
import { describe, test, it, expect } from '@jest/globals'

describe('aliasFactory', () => {
  it('should return an array of aliases', () => {
    const aliases = aliasFactory()
    expect(aliases).toEqual([])
  })
})
