<div align="center">
  <img width=60 src="/public/elkana-logo.svg" alt="The farm elkana logo" />
</div>

# About dGilli/farm-elkana-www

The website for the Farm Elkana lodge. It uses an edge-deployed Cloudflare Worker that wraps an AI built frontend application.

Requirements:
* Node.js v22
* A Cloudflare account with CLI authorization (i.e., wrangler login)
* A preferred container runtime (e.g., Docker, Podmand)
* The jq command-line

We're using a Makefile and the built-in make utility to create a simple time saving command line interface. You can run `make help` from terminal to get a list of available commands.

## Running Tests

The `make test` command accepts three optional variables:

* `url`: Base URL the dev server is served from (e.g. `url=http://localhost:5174`)
* `skip`: Comma-separated list of project names to exclude (e.g. `skip="webkit,Mobile Safari"`).
* `args`: Extra flags forwarded directly to `playwright test` (e.g. `args="--update-snapshots"`).

## Image Processing

Use `make media/transform` to generate responsive image variants. It takes a source image and produces resized copies in multiple widths and formats using ImageMagick inside a container.

```shell
src=media/img/photo.jpg; make media/transform src=$src widths="400 800 1600" formats="avif jpg" && rm $src
```

This creates 6 files (e.g., `photo_400w.jpg`, `photo_800w.avif`, etc.) and removes the original. **Run transforms one at a time** — the container volume mount can conflict under parallel execution.

