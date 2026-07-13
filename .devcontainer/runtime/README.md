# Local Runtime Cache

Use this folder when the devcontainer cannot download runtime releases from GitHub.

Place a runtime archive matching the container architecture, for example:

- `ahri-tre-<version>-x86_64-unknown-linux-gnu.tar.gz`
- `ahri-tre-<version>-x86_64-unknown-linux-gnu.tar`
- `ahri-tre-<version>-x86_64-unknown-linux-gnu.tgz`

Optionally add an adjacent checksum file:

- `<archive>.sha256`
- `<archive>.sha256sum`

The installer checks this folder before calling GitHub APIs.

If your filename is non-standard, set these in `.devcontainer/.env`:

- `AHRI_TRE_RUNTIME_LOCAL_ARCHIVE=<archive file name>`
- `AHRI_TRE_RUNTIME_LOCAL_CHECKSUM=<checksum file name>`
