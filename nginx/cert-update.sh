#!/bin/bash

systemctl stop nginx
docker run \
  --name docker-nginx \
  --rm \
  -p "80:80" \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /var/log/letsencrypt:/var/log/letsencrypt \
  deliverous/certbot certonly \
  --standalone \
  --non-interactive \
  --agree-tos \
  --renew-by-default \
  --preferred-challenges http \
  --email 'n4sekai5y@gmail.com' \
  -d 'spinnaker.qicoo.tokyo'
systemctl start nginx
