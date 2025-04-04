import { ChangeEvent } from 'react'
import { StateCreator } from 'zustand'
import { Account } from '../types'

export interface AccountSlice {
  accountsMap: Record<string, Account>
  selectedAccountsMap: Record<string, boolean>
  /**
   * Reduces the list of accounts to a map of accounts with the account ID as the key
   * @param accounts Account[]
   * @returns void
   */
  setAccounts: (accounts: Account[]) => void
  setSelectedAccounts: (selectedAccountIds: string[]) => void
  handleAccountSelectionChange: (ev: ChangeEvent<HTMLInputElement>) => void
}

export const createAccountSlice: StateCreator<AccountSlice> = (set, _get) => ({
  accountsMap: {},
  selectedAccountsMap: {},
  setAccounts: (accounts: Account[]) =>
    set((slice) => {
      const accountsMap = accounts.reduce(
        (acc, account) => {
          acc[account.id] = account
          return acc
        },
        {} as Record<string, Account>,
      )
      return {
        ...slice,
        accountsMap,
      }
    }, true),
  setSelectedAccounts: (selectedAccountIds: string[]) =>
    set((slice) => {
      const selectedAccountsMap = selectedAccountIds.reduce(
        (acc, accountId) => ({ ...acc, [accountId]: true }),
        {} as Record<string, boolean>,
      )
      return {
        ...slice,
        selectedAccountsMap,
      }
    }),
  handleAccountSelectionChange: (ev: ChangeEvent<HTMLInputElement>) =>
    set((slice) => {
      const { accountsMap, selectedAccountsMap: currentMap, ...otherStuff } = slice
      const { accountId } = ev.currentTarget.dataset
      const { checked } = ev.currentTarget

      if (accountId) {
        switch (accountId) {
          case 'all':
            return {
              ...otherStuff,
              selectedAccountsMap: {
                ...currentMap,
                ...Object.entries(accountsMap).reduce(
                  (latestMap, [id, _account]) => ({
                    ...latestMap,
                    [id]: checked,
                  }),
                  {},
                ),
              },
            }

          default:
            return {
              ...otherStuff,
              selectedAccountsMap: {
                ...currentMap,
                [accountId]: checked,
              },
            }
        }
      }
      return slice
    }),
})
