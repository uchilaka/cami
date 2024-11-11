import '@hotwired/turbo-rails'
import '@rails/actiontext'
import 'flowbite'
import 'trix'
import '@/utils/tent'

import './main.scss'

import { createElement } from 'react'
import { createRoot } from 'react-dom/client'
import Home from '@views/Home'
import Dashboard from '@views/Dashboard'
// import AccountSummaryModal from '@/features/AccountManager/AccountSummaryModal'

function mountIfContainerIsLoaded(containerId: string, Component: any) {
  const domContainer = document.querySelector(`#${containerId}`)
  if (domContainer) {
    const component = createRoot(domContainer)
    component.render(createElement(Component))
  }
}

/**
 * TODO: Ensure this is the correct Turbo event (was: DOMContentLoaded)
 */
document.addEventListener('turbo:load', () => {
  console.debug('DOM fully loaded and parsed')
  mountIfContainerIsLoaded('home', Home)
  mountIfContainerIsLoaded('dashboard', Dashboard)
  // mountIfContainerIsLoaded('account-summary-modal-container', AccountSummaryModal)
})
