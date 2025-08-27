FROM swift:noble

RUN touch /var/mail/ubuntu && \
    chown ubuntu /var/mail/ubuntu && \
	userdel -r ubuntu && \
    apt-get update && \
    apt-get install -y libadwaita-1.0 libadwaita-1-dev
