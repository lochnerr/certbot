# Certbot Renewal Container in Docker on Alpine #

This repository contains the Dockerfile and associated assets for
building a Certbot Renewal Server in Docker on Alpine Linux.

This container simply runs a cron daemon in the foreground which
executes a Certbot renew twice each day.

### Building the container ###

Checkout the project:
```bash
git clone git@github.com:lochnerr/certbot.git
```

To build the image, run the following:
```bash
cd certbot
docker build -t certbot .
```

### Running the container ###

Create directory for the certbot data:
```bash
mkdir $(pwd)/certs
```

If desired, create a directory for the log files:
```bash
mkdir $(pwd)/log
```

If using certbot for the first time, you can register with something like the following command.
```bash
EMAIL="user@yourdomain.com"
sudo docker run -it --rm \
  -v $(pwd)/certs:/etc/letsencrypt \
  -v $(pwd)/log:/var/log/letsencrypt \
  certbot /usr/bin/certbot register -m $EMAIL --agree-tos --no-eff-email
```

To create an initial certificate in standalone mode, you can run something like the following.
```bash
# Add a site in standalone mode.
EMAIL="user@yourdomain.com"
SERVER="www.yourdomain.com"
sudo docker run -it --rm -p 80:80 \
  -v $(pwd)/certs:/etc/letsencrypt \
  -v $(pwd)/log:/var/log/letsencrypt \
  certbot /usr/bin/certbot certonly --non-interactive --keep-until-expiring \
    --standalone \
    --email $EMAIL --agree-tos \
    --rsa-key-size 4096 --must-staple --staple-ocsp --redirect --hsts --uir \
    -d $SERVER --dry-run
```

If the dry run completes successfully, you may run it without the dry-run option to create your 
certificates.

To create an initial certificate in webroot mode, you can run something like the following.
```bash
# Add a site in standalone mode.
EMAIL="user@yourdomain.com"
SERVER="www.yourdomain.com"
sudo docker run -it --rm -p 80:80 \
  -v $(pwd)/certs:/etc/letsencrypt \
  -v $(pwd)/log:/var/log/letsencrypt \
  -v /usr/share/nginx/html:/usr/share/nginx/html \
  certbot /usr/bin/certbot certonly --non-interactive --keep-until-expiring \
    --webroot --webroot-path /usr/share/nginx/html \
    --email $EMAIL --agree-tos \
    --rsa-key-size 4096 --must-staple --staple-ocsp --redirect --hsts --uir \
    -d $SERVER --dry-run
```

You then can run the container with:
```bash
# Run certbot renewal container.
sudo docker run -it --rm -p 80:80 \
  -v $(pwd)/certs:/etc/letsencrypt \
  -v $(pwd)/log:/var/log/letsencrypt \
  -v /usr/share/nginx/html:/usr/share/nginx/html \
  certbot
```

# Copyright 2019 Clone Research Corp. <lochner@clone1.com>
