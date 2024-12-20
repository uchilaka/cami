import { InvoiceSearchProps } from './api'

export function composeFilterQueryParams(searchProps: Partial<InvoiceSearchProps>) {
  const params = new URLSearchParams()
  for (const [key, value] of Object.entries(searchProps)) {
    if (value) {
      if (typeof value === 'object') {
        Object.entries(value).forEach(([filterKey, filterSortTerm]) => {
          if (filterSortTerm) {
            params.append(`s[][field]`, filterKey)
            if (filterSortTerm.direction) {
              params.append(`s[][direction]`, filterSortTerm.direction)
            }
          }
        })
      } else {
        params.append(key, value)
      }
    }
  }
  return params
}
