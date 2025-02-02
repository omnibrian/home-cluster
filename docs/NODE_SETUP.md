# Node Setup

K3s installation steps on a fresh installation of Alma Linux.

## Local Steps

**Note:** This is assuming running from an account that is not the root account and is able to use `sudo`

```bash
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE=644 sh -s - --disable=traefik --secrets-encryption --flannel-backend=none --disable-network-policy
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --permanent --zone=trusted --add-source=10.42.0.0/16
sudo firewall-cmd --permanent --zone=trusted --add-source=10.43.0.0/16
sudo firewall-cmd --reload
```

## Remote Steps

From a remote maintenance machine that have `kubectl` and `cilium-cli` installed.

### Configure `kubectl` Access

```bash
scp <k3s_host>:/etc/rancher/k3s/k3s.yaml ~/.kube/config.k3s   # or use `~/.kube/config` if no other k8s clusters are configured
export KUBECONFIG=~/.kube/config.k3s  # optional if using `~/.kube/config` instead
cilium install --set=ipam.operator.clusterPoolIPv4PodCIDRList="10.42.0.0/16"
cilium status --wait
```
