<div align="center">
  <img width=60 src="/public/elkana-logo.svg" alt="The farm elkana logo" />
</div>

# About dGilli/farm-elkana-www

The website for the Farm Elkana lodge. An edge-deployed Cloudflare Worker that wraps an AI built frontend application.

Requirements:
* Node.js v22
* Cloudflare account with CLI authorization (e.g., wrangler login)

We're using a Makefile and the built-in make utility to create a simple time saving command line interface. You can run `make help` from terminal to get a list of available commands.

The `make update` command creates symlinks that overwrite the necessary files so the frontend application can run in Cloudflare Workers.

