import 'flowbite'
import 'trix'
import '@rails/actiontext'

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

window.addEventListener('DOMContentLoaded', () => {
  console.debug('DOM fully loaded and parsed')
  mountIfContainerIsLoaded('home', Home)
  mountIfContainerIsLoaded('dashboard', Dashboard)
  mountIfContainerIsLoaded('account-summary-modal-container', AccountSummaryModal)
})

window.addEventListener('load', () => {
  console.debug('Page is fully loaded')
})
