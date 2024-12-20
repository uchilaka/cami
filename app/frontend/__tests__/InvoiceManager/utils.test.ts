import { InvoiceSearchProps } from '@/features/InvoiceManager/api'
import { composeFilterQueryParams } from '@/features/InvoiceManager/utils'

describe('InvoiceManager utils', () => {
  describe('composeFilterQueryParams', () => {
    describe('with all supported fields', () => {
      const payload: Partial<InvoiceSearchProps> = {
        s: {
          account: { field: 'account', direction: 'asc' },
          status: { field: 'status', direction: 'desc' },
        },
        q: 'Alvin',
      }

      it('should return a URLSearchParams object with the correct query params', () => {
        const result = composeFilterQueryParams(payload)
        expect(decodeURI(result.toString())).toEqual(
          ['s[][field]=account', 's[][direction]=asc', 's[][field]=status', 's[][direction]=desc', 'q=Alvin'].join('&'),
        )
      })
    })
  })
})
