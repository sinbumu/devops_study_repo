#!/usr/bin/env bash
set -euo pipefail

echo "== Docker version =="
docker version

echo
echo "== Run Ubuntu latest and show release =="
docker run --rm ubuntu cat /etc/lsb-release || true

echo
echo "== Run Ubuntu 20.04 and show release =="
docker run --rm ubuntu:20.04 cat /etc/lsb-release || true

echo
echo "== Search nginx image =="
docker search nginx | head -n 10

echo
echo "== Run nginx on fixed host port 8080 =="
docker rm -f week10-nginx >/dev/null 2>&1 || true
docker run -d -p 8080:80 --name week10-nginx nginx

echo
echo "== docker ps =="
docker ps

echo
echo "== curl nginx =="
curl -I localhost:8080 || true

echo
echo "== exec md5sum =="
docker exec week10-nginx md5sum /etc/nginx/nginx.conf

echo
echo "== logs tail =="
docker logs --tail 20 week10-nginx

echo
echo "== inspect status =="
docker inspect --format='name={{.Name}} status={{.State.Status}} ip={{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' week10-nginx

echo
echo "== images =="
docker images

cat <<'MSG'

Lab command script finished.

Useful cleanup commands:
  docker stop week10-nginx
  docker start week10-nginx
  docker rm -f week10-nginx
  docker rmi ubuntu:20.04

MSG
