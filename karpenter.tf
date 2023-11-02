resource "kubernetes_pod_disruption_budget" "karpenter" {
  metadata {
    name      = "karpenter"
    namespace = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "karpenter"

        "app.kubernetes.io/name" = "karpenter"
      }
    }

    max_unavailable = "1"
  }
}

resource "kubernetes_service_account" "karpenter" {
  metadata {
    name      = "karpenter"
    namespace = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }

    annotations = {
      "eks.amazonaws.com/role-arn" = "arn:aws:iam::305440451662:role/KarpenterControllerRole-karpenter-demo"
    }
  }
}

resource "kubernetes_secret" "karpenter_cert" {
  metadata {
    name      = "karpenter-cert"
    namespace = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }
}

resource "kubernetes_config_map" "config_logging" {
  metadata {
    name      = "config-logging"
    namespace = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  data = {
    "loglevel.webhook" = "error"

    zap-logger-config = "{\n  \"level\": \"debug\",\n  \"development\": false,\n  \"disableStacktrace\": true,\n  \"disableCaller\": true,\n  \"sampling\": {\n    \"initial\": 100,\n    \"thereafter\": 100\n  },\n  \"outputPaths\": [\"stdout\"],\n  \"errorOutputPaths\": [\"stderr\"],\n  \"encoding\": \"console\",\n  \"encoderConfig\": {\n    \"timeKey\": \"time\",\n    \"levelKey\": \"level\",\n    \"nameKey\": \"logger\",\n    \"callerKey\": \"caller\",\n    \"messageKey\": \"message\",\n    \"stacktraceKey\": \"stacktrace\",\n    \"levelEncoder\": \"capital\",\n    \"timeEncoder\": \"iso8601\"\n  }\n}\n"
  }
}

resource "kubernetes_config_map" "karpenter_global_settings" {
  metadata {
    name      = "karpenter-global-settings"
    namespace = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  data = {
    "aws.assumeRoleDuration" = "15m"

    "aws.clusterCABundle" = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1USXhOREl5TlRVek5Wb1hEVE15TVRJeE1USXlOVFV6TlZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBUHBGCjZDVXpjYWxMWnJvR0lGY1pIamQ4ZUVQUFZOS2t1dGlrVVc3bHN2dEVpYXhOUG4ycXdiNDJJdUkzOE8zRG4rQkgKZXlSUjNEUWdyMW5OYU84Y2NXMGZPck9wcXE4dllib0ozaURCbWkrbW50Z3FJc3BEK0syNDFXSkJaSnNubEVWRgpsVXI0U0haWU9DeVZncFV3QWtlMWY2WGhCTnl2d04zZ0VXczU1akRVWE0xeXdOT2RPSlZPR3BOYlk3VUR3UEFxCkJWeE9HZTA3MFJSVnlvTzRlaGNQR01PMm1Ob1ByeXd0aENHQk5KQjhHYWZxTGxMc01PVEFRTndaZ0tON25SSXIKdXhuN09laTNhOHNvS0Jva1FaMG1ORjFNc000aGlYbHZHc2dBUThPcmpQd1pOOU85d3g0dk43SzlINHF1U1VsTgpEemZodDdyRHpWVG5FQnE1VW0wQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZDalRiWjc1d2FRUjFZc2NYd3pOS3hpRC83c1ZNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRVRaUHQ4RlQyV1B4dmpXMXd1YgpKU0JvWnBWOVE4MmcweGFma2duQlB0UUdTMVpWcjZDc0h4SWJrUTB5VEtZUTB2Qk0rUDRFem8vM0lSSXU4WFZ0CkU4eC9ZcHZmZmFMQUxJQlRJQUlibXZiV256ZHp4MmNsMzhSa0IyTlFlOWgvWUZnODY3S2xCamVPaVA0SW1FY2QKOE1xOHFwRFI2NUdRN0QrTmJiRjRoRWpDQ2xjKzd0LzFITDJ0dC9LZS8vTXpPN0k3Z0JzOEc2dUpDMElqVS9IbgpWSGhWZEpCeTNMcnVHNVlFMWRUZTJnUGZBN05yTnl6Y016R1YycVA1K01HcTRKYmdjNXUyR0VtVjVCRU54MkFKCjVJazhNOEtuUHVpNzIvdG5uS0M1RkhLSUppTU5nZUtqc2JOSHkyanBQUTE2OEozS3U3ZzlGbUlTa2p1UEl5UXgKWHRZPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="

    "aws.clusterEndpoint" = "https://0495F696EDB1958CD57D8547A82326C3.gr7.us-east-2.eks.amazonaws.com"

    "aws.clusterName" = "karpenter-demo"

    "aws.enableENILimitedPodDensity" = "true"

    "aws.enablePodENI" = "false"

    "aws.isolatedVPC" = "false"

    "aws.vmMemoryOverheadPercent" = "0.075"

    batchIdleDuration = "1s"

    batchMaxDuration = "10s"

    clusterName = "karpenter-demo"

    "featureGates.driftEnabled" = "false"

    interruptionQueue = "karpenter-demo"
  }
}

resource "kubernetes_cluster_role" "karpenter_admin" {
  metadata {
    name = "karpenter-admin"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"

      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
    }
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "patch"]
    api_groups = ["karpenter.sh"]
    resources  = ["provisioners", "provisioners/status", "machines", "machines/status"]
  }

  rule {
    verbs      = ["get", "list", "watch", "create", "delete", "patch"]
    api_groups = ["karpenter.k8s.aws"]
    resources  = ["awsnodetemplates"]
  }
}

resource "kubernetes_cluster_role" "karpenter_core" {
  metadata {
    name = "karpenter-core"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["karpenter.sh"]
    resources  = ["provisioners", "provisioners/status", "machines", "machines/status"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["pods", "nodes", "persistentvolumes", "persistentvolumeclaims", "replicationcontrollers", "namespaces"]
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses", "csinodes"]
  }

  rule {
    verbs      = ["list", "watch"]
    api_groups = ["apps"]
    resources  = ["daemonsets", "deployments", "replicasets", "statefulsets"]
  }

  rule {
    verbs      = ["get", "watch", "list"]
    api_groups = ["admissionregistration.k8s.io"]
    resources  = ["validatingwebhookconfigurations", "mutatingwebhookconfigurations"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["policy"]
    resources  = ["poddisruptionbudgets"]
  }

  rule {
    verbs      = ["create", "delete", "update", "patch"]
    api_groups = ["karpenter.sh"]
    resources  = ["machines", "machines/status"]
  }

  rule {
    verbs      = ["update", "patch"]
    api_groups = ["karpenter.sh"]
    resources  = ["provisioners", "provisioners/status"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs      = ["create", "patch", "delete"]
    api_groups = [""]
    resources  = ["nodes"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["pods/eviction"]
  }

  rule {
    verbs          = ["update"]
    api_groups     = ["admissionregistration.k8s.io"]
    resources      = ["validatingwebhookconfigurations"]
    resource_names = ["validation.webhook.karpenter.sh", "validation.webhook.config.karpenter.sh"]
  }
}

resource "kubernetes_cluster_role" "karpenter" {
  metadata {
    name = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["karpenter.k8s.aws"]
    resources  = ["awsnodetemplates"]
  }

  rule {
    verbs          = ["update"]
    api_groups     = ["admissionregistration.k8s.io"]
    resources      = ["validatingwebhookconfigurations"]
    resource_names = ["validation.webhook.karpenter.k8s.aws"]
  }

  rule {
    verbs          = ["update"]
    api_groups     = ["admissionregistration.k8s.io"]
    resources      = ["mutatingwebhookconfigurations"]
    resource_names = ["defaulting.webhook.karpenter.k8s.aws"]
  }

  rule {
    verbs      = ["patch", "update"]
    api_groups = ["karpenter.k8s.aws"]
    resources  = ["awsnodetemplates", "awsnodetemplates/status"]
  }
}

resource "kubernetes_cluster_role_binding" "karpenter_core" {
  metadata {
    name = "karpenter-core"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "karpenter"
    namespace = "karpenter"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "karpenter-core"
  }
}

resource "kubernetes_cluster_role_binding" "karpenter" {
  metadata {
    name = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "karpenter"
    namespace = "karpenter"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "karpenter"
  }
}

resource "kubernetes_role" "karpenter" {
  metadata {
    name      = "karpenter"
    namespace = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  rule {
    verbs      = ["get", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps", "namespaces", "secrets"]
  }

  rule {
    verbs          = ["update"]
    api_groups     = [""]
    resources      = ["secrets"]
    resource_names = ["karpenter-cert"]
  }

  rule {
    verbs          = ["update", "patch", "delete"]
    api_groups     = [""]
    resources      = ["configmaps"]
    resource_names = ["karpenter-global-settings", "config-logging"]
  }

  rule {
    verbs          = ["patch", "update"]
    api_groups     = ["coordination.k8s.io"]
    resources      = ["leases"]
    resource_names = ["karpenter-leader-election", "webhook.configmapwebhook.00-of-01", "webhook.defaultingwebhook.00-of-01", "webhook.validationwebhook.00-of-01", "webhook.webhookcertificates.00-of-01"]
  }

  rule {
    verbs      = ["create"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["create"]
    api_groups = [""]
    resources  = ["configmaps"]
  }
}

resource "kubernetes_role" "karpenter_dns" {
  metadata {
    name      = "karpenter-dns"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  rule {
    verbs          = ["get"]
    api_groups     = [""]
    resources      = ["services"]
    resource_names = ["kube-dns"]
  }
}

resource "kubernetes_role" "karpenter_lease" {
  metadata {
    name      = "karpenter-lease"
    namespace = "kube-node-lease"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }

  rule {
    verbs      = ["delete"]
    api_groups = ["coordination.k8s.io"]
    resources  = ["leases"]
  }
}

resource "kubernetes_role_binding" "karpenter" {
  metadata {
    name      = "karpenter"
    namespace = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "karpenter"
    namespace = "karpenter"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "karpenter"
  }
}

resource "kubernetes_role_binding" "karpenter_dns" {
  metadata {
    name      = "karpenter-dns"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "karpenter"
    namespace = "karpenter"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "karpenter-dns"
  }
}

resource "kubernetes_role_binding" "karpenter_lease" {
  metadata {
    name      = "karpenter-lease"
    namespace = "kube-node-lease"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "karpenter"
    namespace = "karpenter"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "karpenter-lease"
  }
}

resource "kubernetes_service" "karpenter" {
  metadata {
    name      = "karpenter"
    namespace = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  spec {
    port {
      name        = "http-metrics"
      protocol    = "TCP"
      port        = 8000
      target_port = "http-metrics"
    }

    port {
      name        = "https-webhook"
      protocol    = "TCP"
      port        = 8443
      target_port = "https-webhook"
    }

    selector = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/name" = "karpenter"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "karpenter" {
  metadata {
    name      = "karpenter"
    namespace = "karpenter"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        "app.kubernetes.io/instance" = "karpenter"

        "app.kubernetes.io/name" = "karpenter"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/instance" = "karpenter"

          "app.kubernetes.io/name" = "karpenter"
        }

        annotations = {
          "checksum/settings" = "935e8507d112caaee46c10dab17238cba9a9cbe61e37254270b92ef9445325bd"
        }
      }

      spec {
        container {
          name  = "controller"
          image = "public.ecr.aws/karpenter/controller:v0.31.0@sha256:d29767fa9c5c0511a3812397c932f5735234f03a7a875575422b712d15e54a77"

          port {
            name           = "http-metrics"
            container_port = 8000
            protocol       = "TCP"
          }

          port {
            name           = "http"
            container_port = 8081
            protocol       = "TCP"
          }

          port {
            name           = "https-webhook"
            container_port = 8443
            protocol       = "TCP"
          }

          env {
            name  = "KUBERNETES_MIN_VERSION"
            value = "1.19.0-0"
          }

          env {
            name  = "KARPENTER_SERVICE"
            value = "karpenter"
          }

          env {
            name  = "WEBHOOK_PORT"
            value = "8443"
          }

          env {
            name  = "METRICS_PORT"
            value = "8000"
          }

          env {
            name  = "HEALTH_PROBE_PORT"
            value = "8081"
          }

          env {
            name = "SYSTEM_NAMESPACE"

            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }

          env {
            name = "MEMORY_LIMIT"

            value_from {
              resource_field_ref {
                container_name = "controller"
                resource       = "limits.memory"
              }
            }
          }

          resources {
            limits = {
              cpu = "1"

              memory = "1Gi"
            }

            requests = {
              cpu = "1"

              memory = "1Gi"
            }
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = "http"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
          }

          readiness_probe {
            http_get {
              path = "/readyz"
              port = "http"
            }

            initial_delay_seconds = 5
            timeout_seconds       = 30
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            capabilities {
              drop = ["ALL"]
            }

            run_as_user               = 65536
            run_as_group              = 65536
            run_as_non_root           = true
            read_only_root_filesystem = true
          }
        }

        dns_policy = "Default"

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        service_account_name = "karpenter"

        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "karpenter.sh/provisioner-name"
                  operator = "DoesNotExist"
                }
              }
            }
          }

          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/instance" = "karpenter"

                  "app.kubernetes.io/name" = "karpenter"
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        toleration {
          key      = "CriticalAddonsOnly"
          operator = "Exists"
        }

        priority_class_name = "system-cluster-critical"

        topology_spread_constraint {
          max_skew           = 1
          topology_key       = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"

          label_selector {
            match_labels = {
              "app.kubernetes.io/instance" = "karpenter"

              "app.kubernetes.io/name" = "karpenter"
            }
          }
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "1"
      }
    }

    revision_history_limit = 10
  }
}

resource "kubernetes_mutating_webhook_configuration" "defaulting_webhook_karpenter_k_8_s_aws" {
  metadata {
    name = "defaulting.webhook.karpenter.k8s.aws"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  webhook {
    name = "defaulting.webhook.karpenter.k8s.aws"

    client_config {
      service {
        namespace = "karpenter"
        name      = "karpenter"
        port      = 8443
      }
    }

    rule {
      operations = ["CREATE", "UPDATE"]
      scope      = "*"
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Fail"
    side_effects              = "None"
    admission_review_versions = ["v1"]
  }
}

resource "kubernetes_validating_webhook_configuration" "validation_webhook_karpenter_sh" {
  metadata {
    name = "validation.webhook.karpenter.sh"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  webhook {
    name = "validation.webhook.karpenter.sh"

    client_config {
      service {
        namespace = "karpenter"
        name      = "karpenter"
        port      = 8443
      }
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Fail"
    side_effects              = "None"
    admission_review_versions = ["v1"]
  }
}

resource "kubernetes_validating_webhook_configuration" "validation_webhook_config_karpenter_sh" {
  metadata {
    name = "validation.webhook.config.karpenter.sh"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  webhook {
    name = "validation.webhook.config.karpenter.sh"

    client_config {
      service {
        namespace = "karpenter"
        name      = "karpenter"
        port      = 8443
      }
    }

    failure_policy = "Fail"

    object_selector {
      match_labels = {
        "app.kubernetes.io/part-of" = "karpenter"
      }
    }

    side_effects              = "None"
    admission_review_versions = ["v1"]
  }
}

resource "kubernetes_validating_webhook_configuration" "validation_webhook_karpenter_k_8_s_aws" {
  metadata {
    name = "validation.webhook.karpenter.k8s.aws"

    labels = {
      "app.kubernetes.io/instance" = "karpenter"

      "app.kubernetes.io/managed-by" = "Helm"

      "app.kubernetes.io/name" = "karpenter"

      "app.kubernetes.io/version" = "0.31.0"

      "helm.sh/chart" = "karpenter-v0.31.0"
    }
  }

  webhook {
    name = "validation.webhook.karpenter.k8s.aws"

    client_config {
      service {
        namespace = "karpenter"
        name      = "karpenter"
        port      = 8443
      }
    }

    rule {
      operations = ["CREATE", "UPDATE"]
      scope      = "*"
    }

    rule {
      operations = ["CREATE", "UPDATE"]
    }

    failure_policy            = "Fail"
    side_effects              = "None"
    admission_review_versions = ["v1"]
  }
}

