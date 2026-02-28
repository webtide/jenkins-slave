# Nexus Repository Kubernetes Deployment

This directory contains Kubernetes manifests to deploy Sonatype Nexus Repository Manager 3 to a Kubernetes cluster with proper security, persistence, and ingress configuration.

## Files Overview

### Core Nexus Deployment
- **`deployment-nexus.yaml`** - Main Nexus deployment with:
  - Sonatype Nexus3 container (v3.89.1)
  - Resource limits (8-12GB RAM, 3 CPU cores)
  - Security context (non-root user 1004:200)
  - Node selector for dedicated nexus nodes
  - Persistent volume mounts for data persistence

### Storage Configuration
- **`pv-volume-nexus.yaml`** - PersistentVolume definition:
  - 140GB local storage capacity
  - HostPath storage at `/app/nexus-storage/nexus-data`
  - ReadWriteOnce access mode
  
- **`pv-volume-claim-nexus.yaml`** - PersistentVolumeClaim:
  - Claims 120GB from the persistent volume
  - Used by the Nexus deployment for data persistence

### Network Services
- **`service-nexus.yaml`** - LoadBalancer service:
  - Exposes Nexus on ports 8081 (Maven) and 8082 (Docker proxy)
  - NodePorts 31001 and 31002 for external access
  
- **`service-nexus-cluster-ip.yaml`** - Internal ClusterIP service:
  - Alternative internal-only service configuration
  - Maps to different target ports (9081, 9082)

### Security & Access Control
- **`deny-service.yaml`** - Nginx-based deny service:
  - Returns 404 for blocked repository paths
  - Used in conjunction with ingress path-based routing
  
- **`deny-service-deployment.yaml`** - Deployment for deny service:
  - Lightweight nginx:alpine container
  - ConfigMap with nginx configuration for blocking access
  - Low resource footprint (32-64MB RAM, 25-50m CPU)

### SSL/TLS & Ingress
- **`nexus-cert.yaml`** - Certificate resource:
  - Let's Encrypt TLS certificate for `repository.webtide.net`
  - Managed by cert-manager with letsencrypt-prod issuer
  
- **`nexus-ingress.yaml`** - Ingress configuration:
  - Traefik ingress controller setup
  - HTTPS redirect and TLS termination
  - Path-based routing with security rules:
    - Allows access to `/repository/release-staging/`
    - Blocks all other `/repository/` paths (routed to deny-service)
    - Allows root and non-repository paths

## Prerequisites

Before deploying, ensure your cluster has:

1. **Traefik Ingress Controller** installed and configured
2. **cert-manager** installed with letsencrypt-prod ClusterIssuer
3. **Namespace** created: `kubectl create namespace nexus`
4. **Node Labels** applied to target nodes: `kubectl label node <node-name> nexus=true`
5. **Storage Directory** created on nodes: `/app/nexus-storage/nexus-data` with proper permissions

## Deployment Instructions

### 1. Prepare the Environment
```bash
# Create namespace
kubectl create namespace nexus

# Label nodes for Nexus deployment
kubectl label node <your-node-name> nexus=true

# Create storage directory on the labeled node(s)
sudo mkdir -p /app/nexus-storage/nexus-data
sudo chown 1004:200 /app/nexus-storage/nexus-data
```

### 2. Deploy Storage Resources
```bash
# Create persistent volume and claim
kubectl apply -f pv-volume-nexus.yaml
kubectl apply -f pv-volume-claim-nexus.yaml
```

### 3. Deploy Nexus Application
```bash
# Deploy the main Nexus application
kubectl apply -f deployment-nexus.yaml

# Create services
kubectl apply -f service-nexus.yaml
kubectl apply -f service-nexus-cluster-ip.yaml
```

### 4. Deploy Security Components
```bash
# Deploy deny service for path blocking
kubectl apply -f deny-service-deployment.yaml
kubectl apply -f deny-service.yaml
```

### 5. Configure SSL and Ingress
```bash
# Create TLS certificate
kubectl apply -f nexus-cert.yaml

# Deploy ingress with path-based security
kubectl apply -f nexus-ingress.yaml
```

### 6. Verify Deployment
```bash
# Check all resources
kubectl get all -n nexus

# Check persistent volumes
kubectl get pv,pvc -n nexus

# Check ingress and certificates
kubectl get ingress,certificates -n nexus

# Check Nexus logs
kubectl logs -n nexus deployment/nexus-server -f
```

## Access Information

- **External URL**: https://repository.webtide.net
- **Internal Service**: `nexus-service.nexus.svc.cluster.local:8081`
- **Allowed Repository Path**: `/repository/release-staging/`
- **Blocked Paths**: All other `/repository/*` paths return 404

## Security Features

- **Path-based Access Control**: Only `/repository/release-staging/` is publicly accessible
- **TLS Encryption**: Automatic HTTPS with Let's Encrypt certificates
- **Non-root Containers**: Runs with security context (user 1004:200)
- **Resource Limits**: Prevents resource exhaustion
- **Network Policies**: Services isolated within nexus namespace

## Maintenance

- **Data Persistence**: Nexus data is stored in `/app/nexus-storage/nexus-data` on the host
- **Backup Strategy**: Backup the persistent volume data directory
- **Updates**: Update the image version in `deployment-nexus.yaml` and apply
- **Scaling**: Currently configured for single replica (nexus doesn't support horizontal scaling)

## Troubleshooting

- **Storage Issues**: Verify host path permissions and node labels
- **Ingress Issues**: Check Traefik controller and certificate status
- **Access Denied**: Review ingress path rules and deny-service configuration
- **Resource Issues**: Monitor pod resource usage and adjust limits if needed