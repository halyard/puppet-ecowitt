# @summary Configure ecowitt proxy
#
# @param hostname sets the hostname for proxy
# @param target sets the webhook target
class ecowitt (
  String $hostname,
  String $target,
  Integer $port = 8080,
) {
  $custom_file = "server {
    server_name ${hostname};
    listen *:${port} http2;
    listen [::]:${port} http2;

    add_header X-XSS-Protection          \"1; mode=block\" always;
    add_header X-Content-Type-Options    \"nosniff\" always;
    add_header Referrer-Policy           \"no-referrer-when-downgrade\" always;
    add_header Content-Security-Policy   \"default-src 'self' http: https: ws: wss: data: blob: 'unsafe-inline' 'unsafe-eval'; frame-ancestors 'self';\" always;

    location /webhook {
        proxy_pass                         ${target};
        proxy_http_version                 1.1;
        proxy_cache_bypass                 $http_upgrade;

        proxy_set_header Upgrade           $http_upgrade;
        proxy_set_header Connection        $connection_upgrade;
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header Forwarded         $proxy_add_forwarded;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host  $host;
        proxy_set_header X-Forwarded-Port  $server_port;

        proxy_connect_timeout              60s;
        proxy_send_timeout                 60s;
        proxy_read_timeout                 60s;

    }
}"

  nginx::site { $hostname:
    proxy_target => $target,
    port         => $port,
    custom_file  => $custom_file,
  }
}
