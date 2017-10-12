# caddy-gen

Traefik-like reverse proxying based on:
- Caddy web server (see [caddyserver.com](https://caddyserver.com))
- Abiosoft's Caddy container (see [abiosoft/caddy](https://github.com/abiosoft/caddy-docker))
- docker-gen (see [jwilder/docker-gen](https://github.com/jwilder/docker-gen))

First run caddy-gen, via compose:

```
  caddy-gen:
    image: whitestrake/caddy-gen
    volumes:
      - /path/to/certs:/root/.caddy
      - /var/run/docker.sock:/var/run/docker.sock
    ports:
      - 80:80/tcp
      - 443:443/tcp
```

The first mount preserves LetsEncrypt certificates in the folder `/path/to/certs` on your Docker host. The second mount allows docker-gen to monitor Docker for container changes.

Next, include some env vars in your other services to tell docker-gen to include them in the proxy configuration:

```
  whoami:
    image: emilevauge/whoami:latest
    environment:
      CADDY_HOST: "whoami.example.com"
      CADDY_PROXY_PARAMS: "transparent,websocket"
      CADDY_BASIC_AUTH: "/:foo:bar,/dir:user:badpassword"
```

As long as your server is accessible at `whoami.example.com`, you'll be up and running with HTTPS in seconds.

### Environmental variables:

Set these on any container you want proxied.

| Variable | Description |
| --- | --- |
| `CADDY_HOST` | Required; tells Caddy what to use as a site label when reverse proxying your container. |
| `CADDY_DISABLE_TLS` | Optional; if set to any value, Caddy will serve your site at port 2015 instead of configuring HTTPS. |
| `CADDY_BASIC_AUTH` | Optional; takes the format `[path]:[user]:[pass]`, where [path] is the directory to protect. Declare multiple by separating them with commas. |
| `CADDY_PROXY_PARAMS` | Optional; a comma-separated list of subdirectives for the `proxy` directive, such as `transparent` or `websocket`; see [http.proxy](https://caddyserver.com/docs/proxy). |
