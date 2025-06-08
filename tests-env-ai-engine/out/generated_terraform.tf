provider "kubernetes" {
  config_path = "~/.kube/config"
}
resource "kubernetes_deployment" "risk_engine" {
  metadata {
    name = "risk-engine"
    labels = {
      app = "risk-engine"
    }
  }
spec {
    replicas = 1
selector {
  match_labels = {
    app = "risk-engine"
  }
}

template {
  metadata {
    labels = {
      app = "risk-engine"
    }
  }

  spec {
    container {
      image = "ghcr.io/tinnova-dev/risk-engine:latest"
      name  = "risk-engine"

      resources {
        limits = {
          cpu    = "0.5"
          memory = "512Mi"
        }
        requests = {
          cpu    = "0.2"
          memory = "256Mi"
        }
      }
    }

    termination_grace_period_seconds = 30
  }
}

}
timeouts {
    create = "5m"
    delete = "2m"
  }
}
resource "kubernetes_deployment" "authentication" {
  metadata {
    name = "authentication"
    labels = {
      app = "authentication"
    }
  }
spec {
    replicas = 1
selector {
  match_labels = {
    app = "authentication"
  }
}

template {
  metadata {
    labels = {
      app = "authentication"
    }
  }

  spec {
    container {
      image = "ghcr.io/tinnova-dev/authentication:latest"
      name  = "authentication"

      resources {
        limits = {
          cpu    = "0.5"
          memory = "512Mi"
        }
        requests = {
          cpu    = "0.2"
          memory = "256Mi"
        }
      }
    }

    termination_grace_period_seconds = 30
  }
}

}
timeouts {
    create = "5m"
    delete = "2m"
  }
}
resource "kubernetes_deployment" "transaction_credit_auth" {
  metadata {
    name = "transaction-credit-auth"
    labels = {
      app = "transaction-credit-auth"
    }
  }
spec {
    replicas = 1
selector {
  match_labels = {
    app = "transaction-credit-auth"
  }
}

template {
  metadata {
    labels = {
      app = "transaction-credit-auth"
    }
  }

  spec {
    container {
      image = "ghcr.io/tinnova-dev/transaction-credit-auth:latest"
      name  = "transaction-credit-auth"

      resources {
        limits = {
          cpu    = "0.5"
          memory = "512Mi"
        }
        requests = {
          cpu    = "0.2"
          memory = "256Mi"
        }
      }
    }

    termination_grace_period_seconds = 30
  }
}

}
depends_on = [kubernetes_deployment.risk_engine]
timeouts {
    create = "5m"
    delete = "2m"
  }
}
resource "kubernetes_deployment" "credit_card" {
  metadata {
    name = "credit-card"
    labels = {
      app = "credit-card"
    }
  }
spec {
    replicas = 1
selector {
  match_labels = {
    app = "credit-card"
  }
}

template {
  metadata {
    labels = {
      app = "credit-card"
    }
  }

  spec {
    container {
      image = "ghcr.io/tinnova-dev/credit-card:latest"
      name  = "credit-card"

      resources {
        limits = {
          cpu    = "0.5"
          memory = "512Mi"
        }
        requests = {
          cpu    = "0.2"
          memory = "256Mi"
        }
      }
    }

    termination_grace_period_seconds = 30
  }
}

}
depends_on = [kubernetes_deployment.authentication, kubernetes_deployment.transaction_credit_auth]
timeouts {
    create = "5m"
    delete = "2m"
  }
}
resource "kubernetes_deployment" "pix" {
  metadata {
    name = "pix"
    labels = {
      app = "pix"
    }
  }
spec {
    replicas = 1
selector {
  match_labels = {
    app = "pix"
  }
}

template {
  metadata {
    labels = {
      app = "pix"
    }
  }

  spec {
    container {
      image = "ghcr.io/tinnova-dev/pix:latest"
      name  = "pix"

      resources {
        limits = {
          cpu    = "0.5"
          memory = "512Mi"
        }
        requests = {
          cpu    = "0.2"
          memory = "256Mi"
        }
      }
    }

    termination_grace_period_seconds = 30
  }
}

}
depends_on = [kubernetes_deployment.risk_engine]
timeouts {
    create = "5m"
    delete = "2m"
  }
}
Definindo um tempo de vida para os recursos (TTL)
resource "time_rotating" "ttl" {
  rotation_days = 1  # Define um TTL de 1 dia
}
Outputs para informar quando os recursos serão destruídos
output "resources_expiration" {
  value = time_rotating.ttl.rotation_rfc3339
}