# Jenkins CI/CD Infrastructure for Jetty Project

This repository contains Docker images, Kubernetes deployments, and CI/CD tooling for the Jetty project's Jenkins infrastructure.

## Build Commands

### Jenkins Slave Agent Image
```bash
# Build the main Jenkins agent image
./build.sh                    # Build with timestamp tag and push to registry
./build-agent.sh              # Build locally without pushing
docker build --tag=jetty-build-agent:latest slave-image/
```

### Other Components
```bash
# Autobahn WebSocket test suite
cd autobahn-testsuite && make build
cd autobahn-testsuite && make publish

# Nginx build cache
cd nginx-build-cache && docker build -t nginx-build-cache .
```

### Testing Individual Components
```bash
# Test run Jenkins agent locally
./run.sh

# Verify Docker image builds
docker images jettyproject/*

# Check Kubernetes deployments
kubectl get all -n jenkins-master
kubectl get all -n nexus
```

## Architecture Overview

### Core Components
- **`slave-image/`** - Main Jenkins agent Docker image with Java 21, Maven, Node.js, and build tools
- **`jenkins/`** - Kubernetes ingress and SSL configuration for Jenkins master
- **`nexus/`** - Complete Nexus Repository Manager deployment with security controls
- **`nginx-build-cache/`** - WebDAV-enabled Nginx for Maven build caching
- **`kubedock/`** - Kubernetes deployment utilities
- **`autobahn-testsuite/`** - WebSocket testing container for Jetty

### Jenkins Agent Features
- **Multi-JDK Support**: Java 21 default, extensible via SDKMAN
- **Build Tools**: Maven 3.9.12, Node.js, npm, buildah (instead of Docker)
- **Container Integration**: kubectl, buildah for container operations
- **Jetty Integration**: Pre-cloned Jetty project mirror in `/home/jenkins/jetty.project.git`

### Nexus Repository Security Model
- **Public Access**: Only `/repository/release-staging/` path accessible via `repository.webtide.net`
- **Docker Registry**: Dedicated `docker.repository.webtide.net` hostname for Docker operations
- **Path Blocking**: All other `/repository/*` paths return 404 via deny-service
- **SSL/TLS**: Automatic Let's Encrypt certificates via cert-manager

### Kubernetes Deployment Pattern
- **Namespace Separation**: `jenkins-master`, `nexus` namespaces for isolation
- **Ingress Strategy**: Traefik-based with automatic SSL termination
- **Storage**: Persistent volumes with node affinity using labels
- **Security**: Non-root containers, resource limits, network policies

## Key Conventions

### Docker Image Naming
- **Tagging**: Uses timestamp format `DD-MM-YYYY-HH-MM` for production builds
- **Registry**: `jettyproject/` namespace for public images, private Nexus at `10.0.0.12:8083`
- **Versioning**: Latest + timestamped tags for rollback capability

### Kubernetes Resource Organization
```
<component>/
├── deployment-<service>.yaml    # Main application deployment
├── service-<service>.yaml       # LoadBalancer service
├── <service>-cert.yaml         # Let's Encrypt certificate
├── <service>-ingress.yaml      # Traefik ingress with routing
├── pv-volume-<service>.yaml    # Persistent volume (if needed)
└── pv-volume-claim-<service>.yaml
```

### Jenkins Pipeline Integration
- **Automated Builds**: `Jenkinsfile-slave-image` handles weekly builds and deployment
- **Dynamic Updates**: Pipeline updates Kubernetes cloud templates with new image versions
- **Credential Management**: Uses Jenkins credential store for Docker Hub and Nexus access

### Build Script Patterns
- **`build.sh`**: Production build with registry push and timestamping
- **`build-agent.sh`**: Development build without deployment
- **`run.sh`**: Local testing with DNS and volume mounts

### Network Configuration
- **Internal DNS**: Uses `10.0.0.1` DNS server with `piratecode.org` search domain
- **Load Balancer IPs**: Reserved IPs (e.g., `10.0.0.50` for Jenkins)
- **Service Discovery**: Kubernetes ClusterIP services for internal communication

### Security Practices
- **Container Security**: Non-root users (uid 1001, jetty user)
- **Network Isolation**: Namespace-based separation
- **Access Control**: Ingress-level path restrictions and deny services
- **Certificate Management**: Automated Let's Encrypt with cert-manager
- **Registry Authentication**: Separate credentials for Docker Hub and private Nexus

### File Permissions and Ownership
- **Jenkins Agent**: `/home/ubuntu` (uid 1001) for workspace
- **Nexus Data**: `/app/nexus-storage/nexus-data` owned by `1004:200`
- **Persistent Volumes**: Host path storage with proper node labeling

This infrastructure supports the Eclipse Jetty project's continuous integration needs with security, scalability, and maintainability as primary concerns.