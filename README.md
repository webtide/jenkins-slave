# Jenkins CI/CD Infrastructure for Jetty Project

This repository provides Docker images and Kubernetes deployments for the [Eclipse Jetty](https://jetty.org/) project's continuous integration infrastructure.

## Overview

- **Jenkins Agent**: Ubuntu 24.04-based build agent with Java 21, Maven, Node.js, and container tools
- **Nexus Repository**: Kubernetes deployment with security controls and Docker registry
- **Supporting Services**: Nginx build cache, WebSocket test suite, and ingress configurations

## Quick Start

### Build Jenkins Agent
```bash
# Local development build
./build-agent.sh

# Production build with registry push
./build.sh
```

### Deploy to Kubernetes
```bash
# Deploy Nexus Repository Manager
kubectl apply -f nexus/

# Deploy Jenkins ingress (requires existing Jenkins master)
kubectl apply -f jenkins/

# Deploy build cache
kubectl apply -f nginx-build-cache/
```

## Nexus Repository Services

| URL | Repository | Access |
|-----|-----------|--------|
| https://repository.webtide.net/repository/release-staging/ | Maven release staging | Public |
| https://repository.webtide.net/repository/maven-build-cache/ | Maven build cache | Public |
| https://repository.webtide.net/repository/maven-snapshots/ | Maven snapshots | Public |
| https://repository.webtide.net/repository/docker-local/ | Docker images (raw path) | Public |
| https://docker.repository.webtide.net | Docker registry (OCI) | Public |

All other `/repository/*` paths on `repository.webtide.net` return 404.

## Key Features

- **Multi-architecture builds** with buildah (Docker-free CI)
- **Secure repository access** with path-based restrictions
- **Automatic SSL certificates** via Let's Encrypt and cert-manager
- **Pre-configured Jetty integration** with mirrored repository

## Components

| Directory | Purpose |
|-----------|---------|
| `slave-image/` | Main Jenkins build agent Docker image |
| `jenkins/` | Kubernetes ingress and SSL for Jenkins master |
| `nexus/` | Nexus Repository Manager with security controls |
| `nginx-build-cache/` | WebDAV-enabled Maven build cache |
| `autobahn-testsuite/` | WebSocket testing container |
| `kubedock/` | Kubernetes utilities |

## Requirements

- **Kubernetes cluster** with Traefik ingress and cert-manager
- **Docker registry** access (Docker Hub + private Nexus)
- **DNS configuration** for `*.webtide.net` domains

## Documentation

See [.github/copilot-instructions.md](.github/copilot-instructions.md) for detailed architecture, conventions, and deployment procedures.

---

**License**: This infrastructure code is part of the Eclipse Jetty project.
**Maintainer**: Olivier Lamy <olamy@apache.org>