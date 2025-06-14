# Troubleshooting

- **npm install errors**: Run `npm cache clean --force` then `npm install --legacy-peer-deps`.
- **Docker not running**: Ensure the Docker daemon is started. On Linux run `sudo systemctl start docker`.
- **ESLint issues**: Run `npx eslint --fix .` to automatically fix problems.
- **Prettier format warnings**: Execute `npx prettier --write .`.
- **Verification script fails**: Ensure all dependencies are installed by running `./startup.sh` again.
