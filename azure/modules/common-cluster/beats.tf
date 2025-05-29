module "beats" {
  source = "../../sub-modules/kubernetes-resources/eck-beats"

  cluster_name     = module.aks_cluster.name
  cluster_endpoint = module.aks_cluster.cluster_oidc_issuer_url
  env              = var.environment_short

  elastic = local.elastic

  depends_on = [module.aks_cluster, module.eck_operator]
}
