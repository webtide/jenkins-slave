# Jenkins Ingress Setup - Backup & Restore Guide

## Files Overview ✅ (No credentials stored)
All configuration files contain only public settings and can be safely backed up:

- **cert-manager.yaml** - Let's Encrypt ClusterIssuer (public email addresses)
- **jenkins-cert.yaml** - SSL Certificate request (public domain)  
- **jenkins-ingress.yaml** - Ingress routing configuration (public)
- **metallb-config.yaml** - IP pool configuration (private network ranges)

## MicroK8s Addons Required
Enable these addons in this order:
```bash
microk8s enable community
microk8s enable dns  
microk8s enable helm
microk8s enable cert-manager
microk8s enable metallb
microk8s enable traefik
```

## Restore Steps (Complete Cluster Rebuild)
```bash
# 1. Enable required addons (see above)

# 2. Configure MetalLB IP pool
microk8s kubectl apply -f metallb-config.yaml

# 3. Apply cert-manager ClusterIssuer
microk8s kubectl apply -f cert-manager.yaml

# 4. Apply certificate (will be pending until ingress is ready)
microk8s kubectl apply -f jenkins-cert.yaml

# 5. Apply ingress (triggers certificate validation)
microk8s kubectl apply -f jenkins-ingress.yaml

# 6. Reserve Traefik IP (optional but recommended)
microk8s kubectl patch service traefik -n traefik -p '{"spec":{"loadBalancerIP":"10.0.0.50"}}'
```

## Verification Commands
```bash
# Check Traefik LoadBalancer IP
microk8s kubectl get service -n traefik traefik

# Check certificate status (should become Ready)
microk8s kubectl get certificate -n jenkins-master

# Check ingress status  
microk8s kubectl get ingress -n jenkins-master

# Test HTTPS connectivity
curl -I https://jenkins.webtide.net
```

## Critical Requirements
- **DNS**: External router must point `jenkins.webtide.net` → `10.0.0.50`
- **Jenkins Service**: Must exist as `jenkins-service` in `jenkins-master` namespace
- **Network**: MicroK8s cluster must have access to the internet for Let's Encrypt validation

## Expected Results
- **URL**: https://jenkins.webtide.net (fully secured)
- **IP**: 10.0.0.50 (reserved via MetalLB)
- **Certificate**: Auto-renewing Let's Encrypt SSL
- **Redirect**: HTTP → HTTPS automatic

## Adding Additional Services
Use `jenkins-ingress.yaml` as template:
1. Change `name`, `host`, `secretName`, and `service` references
2. All services share the same IP (10.0.0.50) with host-based routing
3. Each service gets its own SSL certificate automatically