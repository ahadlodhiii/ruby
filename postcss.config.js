// postcss.config.js
const { join } = require("path");
module.exports = {
  plugins: [
    require('tailwindcss'),
    require('autoprefixer'),
  ],
};