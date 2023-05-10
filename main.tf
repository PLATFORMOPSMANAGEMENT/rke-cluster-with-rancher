terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.3.2"
    }
  }
}

provider "rke" {
  # Configuration options
}

resource "rke_cluster" "cluster" {
  nodes {
    address = "node1.devtest1.com"
    user    = "devtest1"
    role    = ["controlplane", "worker", "etcd"]
    ssh_key = "${file("~/.ssh/id_rsa_rancher")}"
  }
  addons_include = [
    "https://raw.githubusercontent.com/kubernetes/dashboard/v${var.k8s_dashboard_version}/aio/deploy/recommended.yaml",
    "./k8s-dashboard-user.yml",
  ]
}

resource "local_sensitive_file" "kube_cluster_yaml" {
  content = rke_cluster.cluster.kube_config_yaml
  filename = "./kube_config_cluster.yml"
}