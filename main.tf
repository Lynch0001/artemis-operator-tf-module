data "rancher2_cluster" "cluster" {
  name = var.cluster
}

data "rancher2_project" "artemis" {
  name = var.project
  cluster_id = data.rancher2_cluster.cluster.id
}

resource "rancher2_namespace" "artemis" {
  name = var.namespace
  project_id = data.rancher2_project.artemis.id
}

resource "helm_release" "artemis-operator" {
  depends_on = [rancher2_namespace.artemis]
  name       = "artemis-operator"
  chart      = "./charts/artemis-operator"
  namespace = rancher2_namespace.artemis.name
  values = [
    "./charts/artemis-operator/values.yaml",
    var.extra_values
  ]

  timeout = 300
}
