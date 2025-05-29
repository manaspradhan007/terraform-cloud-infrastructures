module "eck_operator" {
  source     = "../../sub-modules/kubernetes-resources/eck-operator"
  depends_on = [module.aks_cluster]
}
