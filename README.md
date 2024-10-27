<div align="center">

<img src="https://raw.githubusercontent.com/omnibrian/home-cluster/main/docs/assets/kubernetes.png" align="center" width="144px" height="144px" />

### Brian's Homelab Cluster Configuration

_... deployed on Kubernetes using GitOps_ 🤖

</div>

<div align="center">

[![Kubernetes](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.meneley.ca%2Fkubernetes_version&stylfor-the-badge&logo=kubernetes&logoColor=white&color=blue&label=%20)](https://kubernetes.io)&nbsp;&nbsp;
[![Renovate](https://img.shields.io/github/actions/workflow/status/omnibrian/home-cluster/renovate.yaml?branch=main&label=&logo=renovatebot&style=for-the-badge&color=blue)](https://github.com/omnibrian/home-cluster/actions/workflows/renovate.yaml)

</div>

---

## 📖 Overview

This repo contains the configurations to run my homelab workloads on kubernetes. This is based on a single node cluster.

---

## ⛵ Kubernetes

My kubernetes cluster is deployed with [k3s](https://docs.k3s.io/) onto a single node. I am limited to a single computer that I can use as a server and building for a single node cluster ends up reducing some of the deployment complexity.

A lot of this setup is based on the work made available at [home-ops](https://github.com/onedr0p/home-ops).

### Core Components

- [cert-manager](https://github.com/cert-manager/cert-manager): Creates SSL certificates for services in the cluster.
- [cilium](https://github.com/cilium/cilium): Internal Kubernetes container networking interface.
- [external-dns](https://github.com/kubernetes-sigs/external-dns): Automatically syncs ingress DNS records to a DNS provider.
- [external-secrets](https://github.com/external-secrets/external-secrets): Managed Kubernetes secrets using [Vaultwarden](https://github.com/dani-garcia/vaultwarden).
- [ingress-nginx](https://github.com/kubernetes-ingress-nginx): Kubernetes ingress controller using NGINX as a reverse proxy and load balancer.
- [SOPS](https://github.com/getsops/sops): Managed secrets for Kubernetes committed to git.
- [spegel](https://github.com/spegel-org/spegel): Stateless cluster local OCI registry mirror.
- [volsync](https://github.com/backube/volsync): Backup and recovery of persistent volume claims.

### GitOps

[Flux](https://github.com/fluxcd/flux2) watches the clusters in the [kubernetes](./kubernetes/) folder and updates in git to the clusters.

[Renovate](https://github.com/renovatebot/renovate) watches the whole repository looking for dependency updates and automatically creates a PR to update them.

### Directories

Directory structure is based on the flux v2 suggested structure:

```console
├── apps
│   ├── base
│   ├── ghost
│   ├── production
│   └── staging
├── infrastructure
│   ├── configs
│   └── controllers
└── clusters
    ├── ghost
    ├── production
    └── staging
```

---

## Bootstrapping

```sh
CLUSTER_NAME=ghost
flux bootstrap github --owner=omnibrian --repository=home-cluster --private=false --personal=true --path=clusters/${CLUSTER_NAME}
```

or if the cluster's `flux-system` folder is already set up:

```sh
CLUSTER_NAME=ghost
kubectl apply -k clusters/${CLUSTER_NAME}/flux-system
```
