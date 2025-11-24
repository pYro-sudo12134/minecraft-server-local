# minecraft-server-local
I did it to play Minecraft with friends and make it loggable and traceable.

## What I used

- Docker Compose
- Docker(primarily the reason was to be able to tune GC upon which the server is run)
- Forge Server(1.20.1)
- Grafana
- Prometheus
- Jaeger
- Traefik
- dnsmasq
- JMX Exporter
- smallstep
- Alpine Linux(for backup and updating addresses)

## How to launch

- create `.htpasswd`(but be wary that i gave a sample file, you better change the credentials)
- install `root_ca.crt` in `certs`
- if you want, adjust the CMD in `Dockerfile`, so to use another GC.
- if you want to check, which GC you use, enter `jcmd <PID> VM.flags`, when you are in the container.
- run `docker-compose up`
