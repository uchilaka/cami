import { Modal } from 'flowbite'
import { emitLoadAccountEvent } from '@/utils/events'

console.debug('JavaScript from accounts.ts is loaded.')

/**
 * Turbo handbook: https://turbo.hotwired.dev/handbook/introduction
 * Doc on Turbo Drive (evolves Turbolinks): https://turbo.hotwired.dev/handbook/drive
 * Doc on the Turbo rails gem: https://github.com/hotwired/turbo-rails
 * Doc on Turbolinks vs. Turbo config: https://dev.to/coorasse/from-turbolinks-to-turbo-31jl
 */
document.addEventListener('turbo:load', () => {
  console.debug('Turbo has loaded accounts.ts')
  /**
   * Turbo events reference: https://turbo.hotwired.dev/reference/events
   */
  document.addEventListener('turbo:click', (ev) => {
    console.debug('A Turbo link was clicked', { ev })
  })

  document.querySelectorAll<HTMLElement>('.action--view-account-summary').forEach((el) => {
    el.addEventListener('click', ({ target }) => {
      const { resourceId: accountId, modalTargetAsync, modalToggleAsync } = (target as HTMLElement).dataset
      console.debug('View account summary was clicked', { accountId, modalTargetAsync, modalToggleAsync, target })
      if (accountId) {
        emitLoadAccountEvent(accountId, el)
        // Open the account modal
        const modalEl = document.querySelector<HTMLElement>(`#${modalTargetAsync}`)
        const modal = new Modal(modalEl)
        modal.toggle()
      }
    })
  })

  document.querySelectorAll<HTMLElement>('.action--manage-account').forEach((el) => {
    el.addEventListener('click', ({ target }) => {
      const { appStore } = document
      const { modalTargetAsync, externalResourceUrl, resourceId } = (target as HTMLElement).dataset
      console.debug('Manage account was clicked', { modalTargetAsync, resourceId, externalResourceUrl, target })
      if (!appStore) throw new Error('App store is not defined')
      if (!resourceId) throw new Error('Resource ID is not defined')
      // Should show the offsite link warning modal
      const modalEl = document.querySelector<HTMLElement>(`#${modalTargetAsync}`)
      const modal = new Modal(modalEl)
      appStore.getState().setSelectedAccounts([resourceId])
      modal.toggle()
    })
  })
})
