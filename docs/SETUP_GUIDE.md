# Setup Guide

This project includes a comprehensive environment bootstrap script called `startup.sh`.
The script installs Node.js, Docker, and an extensive suite of developer tools.
It will also install recommended VS Code extensions and open the React DevTools page in your default browser. Recent updates add linting plugins such as `eslint-plugin-unicorn` and security scanning with `owasp-dependency-check`.
The script is idempotent and can be executed multiple times safely.

```bash
./startup.sh
```

After running the script you can verify the installation with:

```bash
./verify.sh
```

For containerised development use:

```bash
docker-compose up --build
```

Refer to `docs/TROUBLESHOOTING.md` if you encounter issues.
