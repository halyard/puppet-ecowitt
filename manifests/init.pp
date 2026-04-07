# @summary Configure ecowitt proxy
#
# @param hostname sets the hostname for proxy
# @param target sets the webhook target
# @param port sets the local port
class ecowitt (
  String $hostname,
  String $target,
  Integer $port = 8080,
) {
  $custom_file = "server {
    server_name ${hostname};
    listen *:${port};
    listen [::]:${port};

    location /webhook {
        proxy_pass                         ${target};
    }
}"

  nginx::insecuresite { $hostname:
    proxy_target => $target,
    port         => $port,
    custom_file  => $custom_file,
  }
}
