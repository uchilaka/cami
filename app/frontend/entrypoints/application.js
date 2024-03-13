import './main.scss';

import { createElement } from 'react';
import { createRoot } from 'react-dom/client';
import App from '@/components/views/home';

const renderHomeComponent = () => {
  const domContainer = document.querySelector('#home');
  if (domContainer) {
    const home = createRoot(domContainer);
    home.render(createElement(App));
  }
};

window.addEventListener('DOMContentLoaded', () => {
  console.debug('DOM fully loaded and parsed');
  renderHomeComponent();
});

window.addEventListener('load', () => {
  console.debug('Page is fully loaded');
});
