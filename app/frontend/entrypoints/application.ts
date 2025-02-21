import '@hotwired/turbo-rails'
import '@rails/actiontext'
import 'flowbite'
import 'trix'
import '@/utils/tent'

import './main.scss'

import { createElement } from 'react'
import { createRoot } from 'react-dom/client'
import App from '@/routes/App'
import AppContextMenu from '@/features/AppContextMenu'
import AccountSummaryModal from '@/features/AccountManager/AccountSummaryModal'
import { createAppStoreWithDevtools } from '@/utils/store'
import { AppGlobalProps } from '@/utils'

function mountIfContainerIsLoaded(containerId: string, Component: any, props: AppGlobalProps) {
  const domContainer = document.querySelector(`#${containerId}`)
  if (domContainer) {
    const component = createRoot(domContainer)
    component.render(createElement(Component, props))
  }
}

const appStore = createAppStoreWithDevtools()

/**
 * TODO: Ensure this is the correct Turbo event (was: DOMContentLoaded)
 */
document.addEventListener('turbo:load', () => {
  console.debug('DOM fully loaded and parsed')
  mountIfContainerIsLoaded('app', App, { appStore })
  mountIfContainerIsLoaded('app-context-menu', AppContextMenu, { appStore })
  mountIfContainerIsLoaded('account-summary-modal-container', AccountSummaryModal, { appStore })
})
