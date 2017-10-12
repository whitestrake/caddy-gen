FROM abiosoft/caddy:latest
LABEL maintainer "Whitestrake <docker@whitestrake.net>"
RUN apk --no-cache add openssl && \
  wget -qO - https://api.github.com/repos/jwilder/docker-gen/releases/latest | grep "browser_download_url" | grep "alpine" | cut -d '"' -f 4 | xargs wget -qO - | tar zxf - -C /usr/bin && \
  apk del openssl
COPY docker-gen.cfg /etc/docker-gen.cfg
COPY Caddyfile.tmpl /etc/Caddyfile.tmpl
COPY docker-gen.sh /usr/bin/docker-gen.sh
RUN chmod +x /usr/bin/docker-gen.sh && \
  echo -e ":2015\non startup docker-gen.sh &" > /etc/Caddyfile
