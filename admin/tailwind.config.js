/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        background: {
          primary: '#08090D',
          secondary: '#11131A',
        },
        surface: {
          DEFAULT: '#171A24',
          elevated: '#1E2230',
        },
        accent: {
          primary: '#7957FF',
          secondary: '#278BFF',
        },
        vayro: {
          border: '#292C39',
          borderSubtle: '#1D202B',
          textPrimary: '#F5F5F7',
          textSecondary: '#9A9DAC',
          textMuted: '#6B6E7D',
          success: '#00D26A',
          error: '#F85149',
          warning: '#FFB020',
        },
      },
    },
  },
  plugins: [],
}
