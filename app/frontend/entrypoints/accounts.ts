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

  document.querySelectorAll('.action--view-account-summary').forEach((el: Element | HTMLElement) => {
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
})
