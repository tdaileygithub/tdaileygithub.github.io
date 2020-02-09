job "nginx" {
  datacenters = ["dc1"]
  type = "service"
  group "nginx" {
    count = 1
    task "nginx" {
      driver = "docker"
      config {
        image = "nginx"
        volumes = [
          "/var/nfs/share:/usr/share/nginx/html"
        ]
      }
      resources {
        cpu    = 100         # 100 MHz
        memory = 128         # 128 MB
        network {
          mbits = 10
          port "http" {
              static = 80
          }
        }
      }
      service {
        name = "nginx"
        tags = [ "nginx", "web", "urlprefix-/nginx" ]
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