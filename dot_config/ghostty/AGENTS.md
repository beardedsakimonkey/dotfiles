# Repository Guidelines

## Project Structure & Module Organization

This repository contains Ghostty custom shaders. Root-level `*.glsl` files are
the shader sources loaded by `config`.

Tests live under `tests/`. The WebGL harness is `tests/shader-harness.html`, fixture definitions are in `tests/fixtures/cases.mjs`, and committed golden PNGs are in `tests/goldens/`. Real screenshot fixtures (PNG + JSON metadata pairs) are committed in `tests/screenshots/`; see `tests/screenshots/README.md` for the capture checklist. Test artifacts and diffs are written to `tests/artifacts/` and should not be committed.

## Build, Test, and Development Commands

There is no build step for the shaders; Ghostty loads the GLSL files directly.

```sh
bun install
```

Installs the local test dependency pinned in `bun.lock`.

```sh
bunx playwright install chromium
```

Installs the browser used by the shader snapshot harness.

```sh
bun run test:shader
```

Renders `text-gradient.glsl` against all synthetic fixtures and compares the output to `tests/goldens/`.

```sh
bun run test:shader:update
```

Refreshes golden PNGs after intentional shader output changes.

```sh
bun run test:screenshot
```

Renders `text-gradient.glsl` (with `SHADOW_STRENGTH` patched to 0) over real
screenshots in `tests/screenshots/` and counts artifact pixels: pixels matching
their cell's dominant (ground-truth background) color that the shader changed.
Each case's `maxArtifactPixels` threshold is a ratchet; refresh with
`bun tests/run-screenshot-artifacts.mjs --update-thresholds` and drive it toward 0.
`--case=<name>` filters, `--report` writes overlays/reports for passing cases too.

```sh
bun tests/tools/ingest-screenshot.mjs tests/screenshots/<name>.png
```

Fills a new screenshot's JSON metadata (cell grid auto-detection) and writes a
`tests/artifacts/<name>-grid.png` overlay for verifying the detected grid.

## Coding Style & Naming Conventions

Use 4-space indentation in GLSL and 2-space indentation in JavaScript fixtures and harness code. Prefer `const float` configuration knobs near the top of shader files, with uppercase names such as `GRADIENT_STRENGTH`. Use lower camel case for helper functions, for example `colorDistance` or `estimatedColumnCenterX`. Keep comments short and focused on non-obvious shader behavior.

## Testing Guidelines

Add or update snapshot fixtures when changing background estimation, glyph masking, cursor dimension assumptions, or row/column sampling. Fixture names and golden filenames should be kebab-case, such as `vertical-bar-cell-background`. When tests fail, inspect `tests/artifacts/*-actual.png` and `*-diff.png` before updating goldens.

When changing `estimateCellBackground`, also run `bun run test:screenshot` and inspect `tests/artifacts/*-artifacts.png` (background pixels the shader wrongly changed) and `*-estimation.png` (red = wrong background estimate under a background pixel, blue = under an ink pixel). The debug wrapper in `tests/shader-harness.html` (`makeFragmentSource`, mode `cellBackground`) calls `estimateCellBackground` directly; keep it in sync if the function's signature changes.

## Agent-Specific Instructions

Do not commit `node_modules/` or `tests/artifacts/`. Avoid unrelated formatting churn in shader files; small visual changes can produce broad snapshot diffs.

Local Ghostty documentation is bundled at `/Applications/Ghostty.app/Contents/Resources/ghostty/doc/`; prefer `ghostty.1.md` for CLI/config options. To validate a config file, use the equals form:

```sh
ghostty +validate-config --config-file=./path/to/config
```

This build rejects the space-separated form with `error.ValueRequired`. `error: SentryInitFailed` may still print on success; check the exit code.
