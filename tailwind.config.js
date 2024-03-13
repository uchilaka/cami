/** @type {import('tailwindcss').Config} */

// Import rails tailwind config
const { content, theme, plugins } = require('./config/tailwind.config')

module.exports = {
  content: [
    ...content,
    // './app/views/**/*.{html,html.erb,erb}',
    // './app/views/devise/**/*.{html,html.erb,erb}',
    './app/frontend/components/**/*.{vue,js,ts,jsx,tsx}',
    './app/frontend/**/*.{vue,js,ts,jsx,tsx}',
    './app/**/*.{vue,js,ts,jsx,tsx}',
  ],
  theme,
  plugins,
}
