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
import AccountSummaryModal from '@/features/AccountSummary/AccountSummaryModal'

function mountIfContainerIsLoaded(containerId, Component) {
  const domContainer = document.querySelector(`#${containerId}`)
  if (domContainer) {
    const component = createRoot(domContainer)
    component.render(createElement(Component))
  }
}

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
