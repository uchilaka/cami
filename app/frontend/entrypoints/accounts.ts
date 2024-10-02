import { nsEventName, LoadAccountEventDetail } from '@/utils'

console.debug('JavaScript from accounts.ts is loaded.')

/**
 * Custom events
 */
export function emitLoadAccountEvent(accountId: string, source?: Element) {
  console.debug(`Will fire load event for account: ${accountId}`, { source })
  const event = new CustomEvent<LoadAccountEventDetail>(nsEventName('account:load'), {
    detail: {
      accountId,
    },
  })
  ;(source ?? document).dispatchEvent(event)
}

/**
 * Turbo handbook: https://turbo.hotwired.dev/handbook/introduction
 * Doc on Turbo Drive (evolves Turbolinks): https://turbo.hotwired.dev/handbook/drive
 * Doc on the Turbo rails gem: https://github.com/hotwired/turbo-rails
 * Doc on Turbolinks vs. Turbo config: https://dev.to/coorasse/from-turbolinks-to-turbo-31jl
 */
document.addEventListener('turbo:load', () => {
  console.debug('Turbo has loaded accounts.ts')
  // const accountSummaryModal = document.getElementById('account--summary-modal')
  // if (accountSummaryModal) {
  //   console.debug('Account summary modal is present')
  // }

  /**
   * Turbo events reference: https://turbo.hotwired.dev/reference/events
   */
  document.addEventListener('turbo:click', (ev) => {
    console.debug('A Turbo link was clicked', { ev })
  })

  document.querySelectorAll('.action--view-account-summary').forEach((el) => {
    el.addEventListener('click', ({ target }) => {
      const { resourceId: accountId } = target.dataset
      console.debug('View account summary was clicked', { accountId, target })
      emitLoadAccountEvent(accountId, el)
    })
  })
})
