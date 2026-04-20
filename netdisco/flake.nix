{ config, pkgs, ... }:

{
  # Docker oder Podman muss aktiviert sein
  virtualisation.docker.enable = true;

  # Netdisco via Docker Compose oder direkt als Systemd-Service
  virtualisation.oci-containers.containers."netdisco-postgresql" = {
    image = "postgres:16-alpine";
    environment = {
      POSTGRES_USER = "netdisco";
      POSTGRES_PASSWORD = "yourpassword";
      POSTGRES_DB = "netdisco";
    };
    volumes = [ "/var/lib/netdisco/pgdata:/var/lib/postgresql/data" ];
  };

  virtualisation.oci-containers.containers."netdisco-backend" = {
    image = "netdisco/netdisco:latest-backend";
    dependsOn = [ "netdisco-postgresql" ];
    volumes = [ 
      "/var/lib/netdisco/config:/home/netdisco/config"
      "/var/lib/netdisco/mibs:/home/netdisco/mibs"
    ];
    environment = {
      NETDISCO_DB_HOST = "netdisco-postgresql";
      NETDISCO_DB_USER = "netdisco";
      NETDISCO_DB_PASS = "yourpassword";
    };
  };

  virtualisation.oci-containers.containers."netdisco-web" = {
    image = "netdisco/netdisco:latest-web";
    ports = [ "5000:5000" ];
    dependsOn = [ "netdisco-backend" ];
    # ... gleiche Volumes und Env wie beim Backend
  };
}
