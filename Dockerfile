FROM alpine:latest

LABEL MAINTAINER Richard Lochner, Clone Research Corp. <lochner@clone1.com> \
      org.label-schema.name = "certbot" \
      org.label-schema.description = "EFF Certbot Container" \
      org.label-schema.vendor = "Clone Research Corp" \
      org.label-schema.usage = "https://github.com/lochnerr/certbot" \
      org.label-schema.url = "https://certbot.eff.org/about/" \
      org.label-schema.vcs-url = "https://github.com/lochnerr/certbot.git"

# A simple certbot container.
#
# Force build with Alpine 3.13.2 and certbot 1.11.0.
#
# Volumes:
#  * /etc/letsencrypt - directory for certbot data files.
#  * /var/log/letsencrypt - directory for certbot log files.
#
# Linux capabilities required:
#  * None

VOLUME [ "/etc/letsencrypt", "/var/log/letsencrypt" ]

# Add the certbot package.
RUN apk add --update --no-cache certbot

# Copy the crontab to run the certbot renewal.
COPY crontab /etc/crontabs/root

# Copy the unit test script.
COPY bin/certbot-test /usr/local/bin

# Run the cron daemon in the foreground on container startup
CMD ["/usr/sbin/crond", "-f", "-d8"]

