import { InvoiceSearchProps } from './api'

/**
 * @deprecated Perhaps too much ad-hoc complexity. The goal is to implement an abstraction for Ransack search (instead).
 */
export function composeSortQueryParams(searchProps: Partial<InvoiceSearchProps>, otherParams?: URLSearchParams): URLSearchParams {
  const params = otherParams ?? new URLSearchParams()
  for (const [key, value] of Object.entries(searchProps)) {
    if (value) {
      if (typeof value === 'object') {
        Object.entries(value).forEach(([filterKey, direction]) => {
          if (direction) {
            params.append(`s[][field]`, filterKey)
            params.append(`s[][direction]`, direction)
          } else {
            // TODO: Perhaps clear the filter from params (instead of doing nothing)
          }
        })
      } else {
        params.append(key, value)
      }
    }
  }
  return params
}
