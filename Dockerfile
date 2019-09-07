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
# Volumes:
#  * /etc/letsencrypt - directory for certbot data files.
#  * /var/log/letsencrypt - directory for certbot log files.
#
# Linux capabilities required:
#  * None

VOLUME [ "/etc/letsencrypt", "/var/log/letsencrypt" ]

# Add the certbot package.
RUN apk add --update --no-cache certbot

# Create the crontab to run the certbot renewal.
RUN mkdir -p /etc/crontab \
 && echo "# Run certbot renewal twice daily between 1am and 2am and between 1pm and 2pm." >/etc/crontab/root \
 && echo "# min	hour	day	month	weekday	command" >>/etc/crontab/root \
 && echo "0	1,13	*	*	*	python3 -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew" >>/etc/crontab/root

# Run the cron daemon in the foreground on container startup
CMD ["/usr/sbin/crond", "-f", "-d8"]
