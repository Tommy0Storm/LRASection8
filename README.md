# LRASection8

This project provides an interactive reference for Schedule 8 of the Labour Relations Act. The included `schedule8-masterpiece.html` page features a rich flipbook section for a book-like reading experience and search capabilities.

## Setup

Run the `startup.sh` script to install recommended tooling and libraries. The script now supports Linux, macOS and Windows (via Chocolatey) and installs Node.js, Docker and a host of developer utilities including GitBook and Docusaurus.

```bash
./startup.sh
```

After setup you can validate the environment with:

```bash
./verify.sh
```

See `docs/SETUP_GUIDE.md` for a detailed walkthrough of the environment setup.

To develop in a container run:

```bash
docker build -t lrasection8 .
```

You can also spin up the project using Docker Compose:

```bash
docker-compose up --build
```

After running the script you can open `schedule8-masterpiece.html` in your browser.

Alternatively start a local server:

```bash
npm start
```

Then open `http://localhost:8080/schedule8-masterpiece.html` in your browser.

Interactive reference for Section 8 of the South African Labour Relations Act.

## Features
- Animated hero section powered by [anime.js](https://animejs.com/)
- Page flip preview using [Turn.js](https://turnjs.com/) inside the hero document
- Quick text search across sections using [lunr.js](https://lunrjs.com/)
- Responsive design with professional typography
- Setup script `startup.sh` installs required libraries and developer tooling
- Startup script also installs tools like **pnpm**, **gulp-cli**, **commitizen**,
  **typedoc**, **esbuild**, **turbo**, **lerna**, **vercel**, and **netlify-cli** for a streamlined modern workflow
- Additional book libraries (PageFlip, ScrollMagic, Paged.js), epub.js for eBook rendering, OpenSeadragon for high-resolution images, FullPage.js for smooth transitions, and Typed.js for animated text

## Setup
Run `./startup.sh` to install dependencies. The script detects your OS (Linux, macOS or Windows) and installs Node.js, Docker and all project packages. It now installs the latest testing frameworks, debugging tools and linting utilities. The script is idempotent so it can be executed repeatedly.
Section 8 of the LRA for Disciplinary hearings
This project now includes interactive Schedule 8 content with an animated flipbook and search functionality. Run `startup.sh` to install recommended development dependencies and debugging tools.

Interactive guide to Section 8 of the Labour Relations Act.

This project offers a unique digital experience for employers and chairpersons to explore Schedule 8.

## Features

- Responsive interface with animated sections
- Flipbook view powered by PageFlip for book-like navigation
- Animated subtitle using Typed.js to draw attention
- Scroll animations via WOW.js and Animate.css
- Enhanced reading experience using ScrollMagic and Lottie animations
- Print friendly pages generated with Paged.js
- Works offline as a PWA

Open `schedule8-masterpiece.html` in a modern web browser to begin. For an all-in-one page with no external dependencies, open `schedule8-offline.html`.
And for quick reference to the complete Labour Relations Act, open `lra-full.html`.

## Packaging the Gift

Run `./package_gift.sh` to produce `gift-package.zip` containing the offline
HTML pages and supporting assets. Share this archive to provide a
self-contained reference that works without an internet connection.
