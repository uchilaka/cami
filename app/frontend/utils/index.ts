import { APPLICATION_SHORT_NAME } from '@/utils/constants'

export * from './types'

export const nsEventName = (suffix: string) => `${APPLICATION_SHORT_NAME.toLowerCase()}:${suffix}`
