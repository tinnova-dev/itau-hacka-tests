```terraform
main.tf
Definição dos provedores
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}
provider "kubernetes" {
  # Configuração do provedor Kubernetes
}
Recurso para o serviço risk-engine (dependência comum)
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
      image = "risk-engine:latest"
      name  = "risk-engine"

      port {
        container_port = 8080
      }
    }
  }
}

}
# Definição do tempo de vida (TTL) para o recurso efêmero
  timeouts {
    create = "10m"
    delete = "5m"
  }
}
resource "kubernetes_service" "risk_engine" {
  metadata {
    name = "risk-engine"
  }
  spec {
    selector = {
      app = kubernetes_deployment.risk_engine.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }
  }
}
Recurso para o serviço authentication
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
      image = "authentication:latest"
      name  = "authentication"

      port {
        container_port = 8080
      }
    }
  }
}

}
# Definição do tempo de vida (TTL) para o recurso efêmero
  timeouts {
    create = "10m"
    delete = "5m"
  }
}
resource "kubernetes_service" "authentication" {
  metadata {
    name = "authentication"
  }
  spec {
    selector = {
      app = kubernetes_deployment.authentication.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }
  }
}
Recurso para o serviço transaction-credit-auth (depende de risk-engine)
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
      image = "transaction-credit-auth:latest"
      name  = "transaction-credit-auth"

      port {
        container_port = 8080
      }

      env {
        name  = "RISK_ENGINE_URL"
        value = "http://${kubernetes_service.risk_engine.metadata[0].name}"
      }
    }
  }
}

}
# Dependência explícita
  depends_on = [kubernetes_deployment.risk_engine]
# Definição do tempo de vida (TTL) para o recurso efêmero
  timeouts {
    create = "10m"
    delete = "5m"
  }
}
resource "kubernetes_service" "transaction_credit_auth" {
  metadata {
    name = "transaction-credit-auth"
  }
  spec {
    selector = {
      app = kubernetes_deployment.transaction_credit_auth.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }
  }
}
Recurso para o serviço credit-card (depende de authentication e transaction-credit-auth)
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
      image = "credit-card:latest"
      name  = "credit-card"

      port {
        container_port = 8080
      }

      env {
        name  = "AUTH_URL"
        value = "http://${kubernetes_service.authentication.metadata[0].name}"
      }

      env {
        name  = "TRANSACTION_CREDIT_AUTH_URL"
        value = "http://${kubernetes_service.transaction_credit_auth.metadata[0].name}"
      }
    }
  }
}

}
# Dependências explícitas
  depends_on = [
    kubernetes_deployment.authentication,
    kubernetes_deployment.transaction_credit_auth
  ]
# Definição do tempo de vida (TTL) para o recurso efêmero
  timeouts {
    create = "10m"
    delete = "5m"
  }
}
resource "kubernetes_service" "credit_card" {
  metadata {
    name = "credit-card"
  }
  spec {
    selector = {
      app = kubernetes_deployment.credit_card.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }
  }
}
Recurso para o serviço pix (depende de risk-engine)
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
      image = "pix:latest"
      name  = "pix"

      port {
        container_port = 8080
      }

      env {
        name  = "RISK_ENGINE_URL"
        value = "http://${kubernetes_service.risk_engine.metadata[0].name}"
      }
    }
  }
}

}
# Dependência explícita
  depends_on = [kubernetes_deployment.risk_engine]
# Definição do tempo de vida (TTL) para o recurso efêmero
  timeouts {
    create = "10m"
    delete = "5m"
  }
}
resource "kubernetes_service" "pix" {
  metadata {
    name = "pix"
  }
  spec {
    selector = {
      app = kubernetes_deployment.pix.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 8080
    }
  }
}
Configuração para tornar os recursos efêmeros (TTL)
resource "null_resource" "cleanup" {
  # Gatilho para destruir os recursos após um tempo determinado
  triggers = {
    expiration_time = timeadd(timestamp(), "2h") # Exemplo: 2 horas de vida
  }
# Dependências para garantir que todos os recursos sejam criados antes
  depends_on = [
    kubernetes_deployment.risk_engine,
    kubernetes_deployment.authentication,
    kubernetes_deployment.transaction_credit_auth,
    kubernetes_deployment.credit_card,
    kubernetes_deployment.pix
  ]
# Provisioner para destruir os recursos após o tempo definido
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Recursos efêmeros expirados, iniciando limpeza...'"
  }
}
```