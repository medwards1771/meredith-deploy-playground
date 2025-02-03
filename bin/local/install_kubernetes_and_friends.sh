#!/bin/bash

# `e`	        Exit script immediately if any command returns a non-zero exit status
# `u`	        Exit script immediately if an undefined variable is used
# `x`           Display each command as executed, preceded by +
# `o pipefail`	Ensure chained commands (for example, cmd | othercmd) return a non-zero status if any of the commands fail
set -euxo pipefail

instance=$1
SERVER_PUBLIC_IP=$(grep "^${instance}-deploy-playground:" bin/local/webserver.txt | cut -d' ' -f2)

scp bin/local/kubernetes-and-friends/install_kube_packages.sh ubuntu@${SERVER_PUBLIC_IP}:/tmp/install_kube_packages.sh
scp bin/local/kubernetes-and-friends/configure_cgroup.sh ubuntu@${SERVER_PUBLIC_IP}:/tmp/configure_cgroup.sh
scp bin/local/kubernetes-and-friends/containerd-config.toml ubuntu@${SERVER_PUBLIC_IP}:/tmp/containerd-config.toml
scp bin/local/kubernetes-and-friends/initialize_cluster.sh ubuntu@${SERVER_PUBLIC_IP}:/tmp/initialize_cluster.sh
scp bin/local/kubernetes-and-friends/kubeadm-config.yaml ubuntu@${SERVER_PUBLIC_IP}:/tmp/kubeadm-config.yaml
scp bin/local/kubernetes-and-friends/install_pod_network_plugin.sh ubuntu@${SERVER_PUBLIC_IP}:/tmp/install_pod_network_plugin.sh
scp bin/local/kubernetes-and-friends/create_node_port_service.sh ubuntu@${SERVER_PUBLIC_IP}:/tmp/create_node_port_service.sh
scp bin/local/kubernetes-and-friends/flaskr-node-port-service.yaml ubuntu@${SERVER_PUBLIC_IP}:/tmp/flaskr-node-port-service.yaml

ssh ubuntu@${SERVER_PUBLIC_IP} << 'EOF'
set -euxo pipefail

echo "========= Install Kubernetes and friends ========="
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

echo "========= Check for prerequisites ========="
if ! which docker &> /dev/null; then
  echo "You must install docker to proceed"
exit 1
fi

echo "========= Install kube packages ========="
mv /tmp/install_kube_packages.sh .
./install_kube_packages.sh
rm install_kube_packages.sh

echo "========= Configure cgroup ========="
mv /tmp/configure_cgroup.sh .
./configure_cgroup.sh
rm configure_cgroup.sh

echo "========= Initialize cluster ========="
mv /tmp/initialize_cluster.sh .
./initialize_cluster.sh
rm initialize_cluster.sh

echo "========= Install pod network plugin ========="
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#pod-network
# A container network interface (CNI) based pod network add-on is required for pods to communicate with each other. Cluster DNS (CoreDNS) will not start up before a network is installed.
mv /tmp/install_pod_network_plugin.sh .
./install_pod_network_plugin.sh
rm install_pod_network_plugin.sh

echo "========= Pause to let K8s clock new calico-system namespace ========="
sleep 5

echo "========= Expose web service to host network via node port ========="
mv /tmp/create_node_port_service.sh .
./create_node_port_service.sh
rm create_node_port_service.sh

echo "========= Grant cluster access to docker registry ========="
echo "****************************************************************************************************"
echo "ssh onto server and run command in bin/local/kubernetes-and-friends/kubectl_create_docker_secret.txt"
echo "****************************************************************************************************"
EOF
