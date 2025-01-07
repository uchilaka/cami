import { InvoiceSearchProps } from '@/features/InvoiceManager/api'
import { composeSortQueryParams } from '@/features/InvoiceManager/utils'

describe('InvoiceManager utils', () => {
  describe('composeFilterQueryParams', () => {
    describe('with all supported fields', () => {
      const payload: Partial<InvoiceSearchProps> = {
        s: {
          account: 'asc',
          status: 'desc',
        },
        q: 'Alvin',
      }

      it('should return a URLSearchParams object with the correct query params', () => {
        const result = composeSortQueryParams(payload)
        expect(decodeURI(result.toString())).toEqual(
          ['s[][field]=account', 's[][direction]=asc', 's[][field]=status', 's[][direction]=desc', 'q=Alvin'].join('&'),
        )
      })
    })

    describe('with only the query field', () => {
      const payload: Partial<InvoiceSearchProps> = {
        q: 'Alvin',
      }

      it('should return a URLSearchParams object with the correct query params', () => {
        const result = composeSortQueryParams(payload)
        expect(decodeURI(result.toString())).toEqual('q=Alvin')
      })
    })

    describe('with only the sort field', () => {
      const payload: Partial<InvoiceSearchProps> = {
        s: {
          account: 'asc',
        },
      }

      it('should return a URLSearchParams object with the correct query params', () => {
        const result = composeSortQueryParams(payload)
        expect(decodeURI(result.toString())).toEqual('s[][field]=account&s[][direction]=asc')
      })
    })

    describe('with no fields', () => {
      const payload: Partial<InvoiceSearchProps> = {}

      it('should return an empty URLSearchParams object', () => {
        const result = composeSortQueryParams(payload)
        expect(decodeURI(result.toString())).toEqual('')
      })
    })

    describe('with empty fields', () => {
      const payload: Partial<InvoiceSearchProps> = {
        s: {},
      }

      it('should return an empty URLSearchParams object', () => {
        const result = composeSortQueryParams(payload)
        expect(decodeURI(result.toString())).toEqual('')
      })
    })

    describe('with empty sort direction field', () => {
      const payload: Partial<InvoiceSearchProps> = {
        s: {
          account: null,
        },
      }

      it('should return a URLSearchParams object with the correct query params', () => {
        const result = composeSortQueryParams(payload)
        expect(decodeURI(result.toString())).toEqual('')
      })
    })
  })
})
