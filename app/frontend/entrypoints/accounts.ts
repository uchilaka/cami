console.debug('JavaScript from accounts.ts is loaded.')

export function fireLoadAccountEvent(accountId) {
  console.debug(`Will fire load event for account: ${accountId}`)
}

/**
 * Turbo handbook: https://turbo.hotwired.dev/handbook/introduction
 * Doc on the Turbo rails gem: https://github.com/hotwired/turbo-rails
 * Doc on Turbolinks vs. Turbo config: https://dev.to/coorasse/from-turbolinks-to-turbo-31jl
 */
document.addEventListener('turbo:load', () => {
  console.debug('Turbo has loaded accounts.ts')
  // const accountSummaryModal = document.getElementById('account--summary-modal')
  // if (accountSummaryModal) {
  //   console.debug('Account summary modal is present')
  // }
})
