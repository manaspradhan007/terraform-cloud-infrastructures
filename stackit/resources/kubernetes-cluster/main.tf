##############################################
# Deploy Stackit Kubernetes Cluster
##############################################

variable "nodepools" {
  type = list(object({
    name               = string
    machine_type       = string
    minimum            = string
    maximum            = string
    availability_zones = list(string)
    os_name            = string
    os_version         = string
    volume_size        = number
    volume_type        = string
  }))
}

resource "stackit_ske_cluster" "cluster" {
  project_id = var.project_id
  name       = var.cluster_name
  node_pools = var.nodepools
  extensions = {
    dns = {
      enabled = true,
      zones   = var.zones
    }
    acl = {
      allowed_cidrs = var.allowed_cidrs_list
      enabled       = var.acl_enabled
    }
  }
  maintenance = {
    enable_kubernetes_version_updates    = var.enable_kubernetes_version_updates
    enable_machine_image_version_updates = var.enable_machine_image_version_updates
    start                                = var.start
    end                                  = var.end
  }
}