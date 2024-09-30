const path = require("path");
/** @type {import('tailwindcss').Config} */
module.exports = {
  purge: [
    './app/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    // Add other paths containing your views and JavaScript files
  ],
  content: [
    path.join(__dirname, "./index.html"),
    path.join(__dirname, "./src/**/*.{js,jsx,ts,tsx,html,svelte,vue}"),
  ],

  variants: {
    extend: {
      backgroundImage: ['responsive'],
    },
  },
  
  // other Tailwind CSS options
  theme: {
    
    extend: {

      screens: {
          'ssm': '400px',  // => @media (min-width: 400px) { ... }
          'sm': '640px',  // => @media (min-width: 640px) { ... }
          'lg': '1024px', // => @media (min-width: 1024px) { ... }
          'xl': '1280px', // => @media (min-width: 1280px) { ... }
          '2xl': '1536px' // => @media (min-width: 1536px) { ... }
      },
      
      fontFamily: { inter: "Inter", "excluded-italic": "ExcludedItalic" },
      backgroundImage: {
        "header": "url('/assets/homepage/header.gif')",
        "desk-header": "url('/assets/homepage/header-desktop.gif')",
        "mens-pexels-erik-mclean": "url('/assets/men/pexels-erik-mclean.png')",
        "mens-pexels-elle-hughes": "url('/assets/men/pexels-elle-hughes.png')",
        "mens-pexels-lucas-monteiro": "url('/assets/men/pexels-lucas-monteiro.png')",
        "mens-pexels-garrett-morrow": "url('/assets/men/pexels-garrett-morrow.png')",
        "mens-pexels-ray-piedra": "url('/assets/men/pexels-ray-piedra.png')",
        "mens-vintage": "url('/assets/men/men-vintage.png')",
        "mens-hype-jpg-685kb-medium-1":
          "url(/assets/homepage/mens-hype-jpg-685kb-medium-1.png)",
        "dresses":
          "url(/assets/homepage/black-maxi-dress-white-female-jpg-medium-492kb-1.png)",
        "mens-shoes-sneaker-jpg-378kb-medium-1":
          "url(/assets/homepage/mens-shoes-sneaker-jpg-378kb-medium-1.png)",
        "vintage":
          "url(/assets/homepage/pexels-displaced-by-design.png)",

        "pexels-zack-jarosz-168771911":
          "url(/assets/homepage/d732097300897809d1fe26cb65a41ca3d0d551bf.png)",
        "mens-hoodies-107kb-jpg-small-1":
          "url(/assets/homepage/e47846b4d1535cdfd17007ce4700347d8de4734c.png)",
        "womens-graphics-tee-106kb-small-jpg-1":
          "url(/assets/homepage/42e3f6dd3de7e32503d3eef6cc6d89909394723a.png)",

        "t-bg-untitled-design-21jordan-logo-1":
          'url("/assets/homepage/UntitledDesign21.svg")',
        "jordan-logo-1":
          "url(/assets/homepage/jordan-logo-1.png)",
        "untitled-design-71":
          "url(/assets/homepage/untitled-design-71.png)",
      },
    },
  },
  
  plugins: [],
  mode: "jit", // Just-In-Time mode for Tailwind CSS
};