# AWS Account Resource Limits

This document outlines the resource constraints for this AWS account.

## EKS Cluster Limits

### Service Roles
- **Cluster Service Role**: `eksClusterRole`
- **Node Service Role**: `AmazonEKSNodeRole`

### Pod Resource Limits
- **Maximum CPU per Pod**: 256 millicores (0.256 CPU)
- **Maximum Memory per Pod**: 512 MiB
- **Maximum Pods per Namespace**: 3 pods

### Cluster Resource Caps
- **Cumulative CPU Cap per Cluster**: 2000 millicores (2 CPUs)
- **Cumulative Memory Cap per Cluster**: 4096 MiB (4 GiB)

### Account-Level Resource Caps
- **Maximum Account-Wide CPU Cap**: 6000 millicores (6 CPUs)
- **Maximum Account-Wide Memory Cap**: 12288 MiB (12 GiB)

## Current Configuration

### Dev Environment
- **Instance Type**: t3.small (2 vCPU, 2 GiB RAM)
- **Node Count**: 1 node (min: 1, max: 2)
- **Total Resources**: ~2000m CPU, ~2048 MiB RAM
- **Fits within**: Single cluster limits (2000m CPU cap)

### Stage Environment
- **Instance Type**: t3.small (2 vCPU, 2 GiB RAM)
- **Node Count**: 2 nodes (min: 1, max: 2)
- **Total Resources**: ~4000m CPU, ~4096 MiB RAM
- **Fits within**: Single cluster limits (4096 MiB RAM cap)

## Recommendations

1. **Use t3.small instances** - They provide 2 vCPU (2000m) and 2 GiB RAM per node
2. **Limit to 1-2 nodes** - To stay within cluster resource caps
3. **Set pod resource limits** - Ensure pods request max 256m CPU and 512Mi memory
4. **Monitor usage** - Account-wide limit is 6 CPUs across all clusters

## Pod Resource Request Template

```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "128m"
  limits:
    memory: "512Mi"
    cpu: "256m"
```

This ensures each pod stays within the 256m CPU and 512Mi memory limits.
