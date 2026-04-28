# Limitations

This cookbook manages Prometheus and Alertmanager from upstream release archives or source builds.

## Upstream Support

Prometheus publishes precompiled archives for Prometheus and Alertmanager from the official download page and GitHub releases. As of April 28, 2026, the cookbook defaults to:

* Prometheus 3.11.2 `linux-amd64` and `linux-arm64`
* Alertmanager 0.32.0 `linux-amd64` and `linux-arm64`

The upstream projects also publish Docker images and archives for other operating systems. This cookbook only supports Linux systemd hosts.

## Platform Support

Supported platforms are modern systemd Linux distributions declared in `metadata.rb`:

* AlmaLinux 8+
* Amazon Linux 2023+
* CentOS Stream 9+
* Debian 12+
* Fedora
* Oracle Linux 8+
* Red Hat Enterprise Linux 8+
* Rocky Linux 8+
* Ubuntu 20.04+

Legacy init systems are not supported. The cookbook no longer manages runit, upstart, or SysV init services.

## Installation Constraints

The default binary installation path uses official Linux tarballs for `amd64` or `arm64`. Override `architecture`, `binary_url`, `checksum`, and `file_extension` when using another upstream artifact or a private mirror.

Source installs require build tooling, Git, and the upstream Go build chain expected by the selected Prometheus or Alertmanager version. Source builds are retained for compatibility but binary installs are the primary supported path.

Prometheus and Alertmanager are not installed from operating system package repositories by these resources.
