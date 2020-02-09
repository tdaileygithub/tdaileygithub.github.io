job "mnist" {
  datacenters = ["dc1"]
  type = "batch"
  group "mnist" {
    count = 1
    task "mnist" {
      driver = "docker"
      config {
        image = "127.0.0.1:5050/root/mnist:v0.0.14"
      }
      resources {
        cpu    = 1000        # 1000 MHz
        memory = 2048        # 2048 MB
        network {
          mbits = 100
          port "http" {
              static = 80
          }
        }
      }
      service {
        name = "nginx"
        tags = [ "nginx", "web" ]
        port = "http"
        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}