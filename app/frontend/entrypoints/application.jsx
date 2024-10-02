import 'flowbite'
import 'trix'
import '@rails/actiontext'
import '@hotwired/turbo-rails'

import './main.scss'

import { createElement } from 'react'
import { createRoot } from 'react-dom/client'
import Home from '@views/Home'
import Dashboard from '@views/Dashboard'
import AccountSummaryModal from '@components/AccountSummaryModal'

function mountIfContainerIsLoaded(containerId, Component) {
  const domContainer = document.querySelector(`#${containerId}`)
  if (domContainer) {
    const component = createRoot(domContainer)
    component.render(createElement(Component))
  }
}

/**
 * We'll only enable Turbo drive features discretely, depending on the page.
 * https://github.com/hotwired/turbo-rails?tab=readme-ov-file#navigate-with-turbo-drive
 */
Turbo.session.drive = false

// TODO: Use turbo event instead
window.addEventListener('DOMContentLoaded', () => {
  console.debug('DOM fully loaded and parsed')
  mountIfContainerIsLoaded('home', Home)
  mountIfContainerIsLoaded('dashboard', Dashboard)
  mountIfContainerIsLoaded('account-summary-modal-container', AccountSummaryModal)
})

// TODO: Use turbo event instead
window.addEventListener('load', () => {
  console.debug('Page is fully loaded')
})
