import type { Preview } from '@storybook/react'
import { initialize, mswLoader } from 'msw-storybook-addon'
import { http, HttpResponse, delay } from 'msw'
import mockFeaturesResponse from '../spec/fixtures/feature_flags.json'

/*
 * Initializes MSW
 * See https://github.com/mswjs/msw-storybook-addon#configuring-msw
 * to learn how to customize it
 */
initialize()

import 'tailwindcss/tailwind.css'
import 'flowbite/dist/flowbite.css'

const preview: Preview = {
  tags: ['autodocs'],
  parameters: {
    controls: {
      matchers: {
        color: /(background|color)$/i,
        date: /Date$/i,
      },
    },
    msw: {
      handlers: [
        http.get('http://localhost:6006/api/features?format=json', async () => {
          await delay(150)
          return HttpResponse.json(mockFeaturesResponse)
        }),
      ],
    },
  },
  loaders: [mswLoader],
}

export default preview
