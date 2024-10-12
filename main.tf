data "rancher2_cluster" "cluster" {
  name = var.cluster_name
}

data "rancher2_project" "artemis" {
  name = var.project
  cluster_id = data.rancher2_cluster.cluster.id
}

data "rancher2_namespace" "artemis" {
  name = var.namespace
  project_id = data.rancher2_project.artemis.id
}

resource "helm_release" "artemis" {
  depends_on = [data.rancher2_namespace.artemis]
  name       = "artemis-operator"
  chart      = "./charts/artemis-operator"

  values = [
    "./charts/artemis-operator/values.yaml",
    var.extra_values
  ]

  timeout = 300
}
