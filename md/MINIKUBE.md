# CAMI: Running with Minikube

## Guides 

- [From Docker Compose to Minikube](https://medium.com/skillshare-team/from-docker-compose-to-minikube-d94cbe97acda)
- [Translate a Docker Compose File to Kubernetes Resources](https://kubernetes.io/docs/tasks/configure-pod-container/translate-compose-kubernetes/)

## Setup 

> Need to create updated k8s files for the `docker-compose.yml`? You might need to setup `kompose` first
> `brew install kompose`

### Minikube

```shell
# Setup minikube (included in Brewfile)
brew install minikube

# Start cluster
.minikube/bin/start
```

### CRI-O Driver (optional)

The CRI-O driver is a lightweight container runtime that is designed to work with Kubernetes. It is an alternative to the Docker Engine.

```shell
# Update package lists
sudo apt update

# Install dependencies (adjust as needed for your Ubuntu version)
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common

# Add the CRI-O repository key
curl -fsSL https://download.opensuse.org/repositories/devel:/CRI:/CRI-O:/stable/xUbuntu_$(lsb_release -rs)/Release.key | sudo apt-key add -

# Add the CRI-O repository
echo "deb https://download.opensuse.org/repositories/devel:/CRI:/CRI-O:/stable/xUbuntu_$(lsb_release -rs)/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list

# Update package lists again
sudo apt update

# Install CRI-O
sudo apt install -y cri-o

# Start and enable CRI-O
sudo systemctl enable crio
sudo systemctl start crio

# Install crictl
curl -LO "https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.27.0/crictl-linux-amd64.tar.gz" # Use the latest release
sudo tar xzf crictl-linux-amd64.tar.gz -C /usr/local/bin
rm crictl-linux-amd64.tar.gz

# Start Minikube with the CRI-O driver
minikube start --driver=cri-o

# Verify that the CRI-O driver is being used
kubectl get nodes -o wide

# Check the status of the CRI-O service
sudo systemctl status crio
```

#### Key Considerations

- *Dependencies:* CRI-O has quite a few dependencies. Make sure you install them correctly. The commands above are a good starting point, but you might need to adjust them based on your specific Ubuntu version.
- *CRI-O Version Compatibility:* Ensure that the CRI-O version you install is compatible with the Kubernetes version that Minikube uses. Using the stable repository usually takes care of this.
- `crictl` Configuration: While not strictly required for Minikube, `crictl` can be very useful for debugging and inspecting containers running under CRI-O. You might want to configure it to point to the CRI-O socket.
Troubleshooting: If you run into issues, check the CRI-O logs (`journalctl -u crio`) and the Minikube logs (`minikube logs`).

This process is a bit more involved than using the Docker driver, but it's the correct approach if you want to run Minikube without Docker Engine in WSL2.  It gives you a more direct interaction with CRI-O, which is valuable for understanding container runtimes in Kubernetes.
