# Blast software for Platforma Backend

This package is the catalogue of all supported versions of blast software.

Unlike most other software packages, it keeps entrypoint descriptors for all blast versions
published earlier.

As we do not maintain/build the blast itself, the version of this package is not bound to any
specific version of blast, but newer blast version publications produce newer descriptors
(*.sw.json files) in this package.

## How to release new version of blast

1. Update `package.json`:
   1. Add new artifact for fresh version of blast.
   2. Add entrypoints for newly added version of blast.
   3. Update default version of blast commands if needed (entrypoints without version suffix).
   4. Change version of blast built by default in `pkg:build` and `publish:packages` scripts.
2. Check packaegs and descriptors are built normally
  ```bash
  npm run pkg:build
  ```
3. Commit all descriptors generated in `dist` directory.
4. Bump `<minor>` version part in `package.json`.
