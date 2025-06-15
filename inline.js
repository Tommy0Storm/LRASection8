const fs = require('fs');
let html = fs.readFileSync('schedule8-offline.html', 'utf8');

function inlineCSS(file) {
  const css = fs.readFileSync(file, 'utf8');
  const tag = `<link rel="stylesheet" href="${file}" />`;
  html = html.split(tag).join(`<style>\n${css}\n</style>`);
}

function inlineJS(file) {
  const js = fs.readFileSync(file, 'utf8');
  const tag = `<script src="${file}"></script>`;
  html = html.split(tag).join(`<script>\n${js}\n</script>`);
}

['stPageFlip.css', 'aos.css', 'animate.min.css'].forEach(inlineCSS);
[
  'wow.min.js',
  'page-flip.browser.js',
  'ScrollMagic.min.js',
  'gsap.min.js',
  'paged.polyfill.js',
  'lottie.min.js',
  'typed.umd.js',
  'fullpage.min.js',
  'openseadragon.min.js',
  'epub.min.js',
  'jquery.min.js',
  'turn.min.js',
  'anime.min.js',
  'lunr.min.js',
  'aos.js',
].forEach(inlineJS);

const hero = fs.readFileSync('hero-animation.json', 'utf8');
html = html.replace(/path: 'hero-animation.json'/g, `animationData: ${hero}`);

fs.writeFileSync('schedule8-single.html', html);
