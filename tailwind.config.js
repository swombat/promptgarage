const path = require('path');
const { execSync } = require("child_process");
const glob  = require('glob').sync

if (!process.env.THEME) {
  throw "tailwind.config.js: missing process.env.THEME"
  process.exit(1)
}
  
const themeConfigFile = execSync(`bundle exec bin/theme tailwind-config ${process.env.THEME}`).toString().trim()
let themeConfig = require(themeConfigFile)

// *** Uncomment these if required for your overrides ***

// const defaultTheme = require('tailwindcss/defaultTheme')
// const colors = require('tailwindcss/colors')

// *** Add your own overrides here ***

// themeConfig.theme.extend.fontFamily.sans = ['Custom Font Name', ...themeConfig.theme.extend.fontFamily.sans]
// themeConfig.theme.extend.fontSize['2xs'] = '.75rem'
// themeConfig.content.push('./app/additional/path')
// themeConfig.plugins.push(require('additional-tailwind-plugin'))

themeConfig.safelist = [
  'bg-blue-100',
  'bg-blue-200',
  'bg-blue-300',
  'bg-blue-400',
  'bg-blue-500',
  'bg-blue-600',
  'bg-blue-700',
  'bg-blue-800',
  'bg-blue-900',
  'border-blue-100',
  'border-blue-200',
  'border-blue-300',
  'border-blue-400',
  'border-blue-500',
  'border-blue-600',
  'border-blue-700',
  'border-blue-800',
  'border-blue-900',
];


module.exports = themeConfig