FROM debian:12-slim

# Install prerequisites
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 \
    ca-certificates \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Add Kamailio repository
RUN echo "deb http://deb.kamailio.org/kamailio60 bookworm main" > /etc/apt/sources.list.d/kamailio.list
RUN wget -O- https://deb.kamailio.org/kamailiodebkey.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/kamailio.gpg

# Install Kamailio and required modules
RUN apt-get update && apt-get install -y --no-install-recommends \
    kamailio \
    kamailio-outbound-modules \
    kamailio-tls-modules \
    kamailio-topoh-modules \
    kamailio-pike-modules \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Create kamailio user and group
RUN mkdir -p /var/run/kamailio \
    && chown -R kamailio:kamailio /var/run/kamailio

# Copy configuration files
COPY kamailio.cfg /etc/kamailio/kamailio.cfg
COPY dispatcher.list /etc/kamailio/dispatcher.list

# Expose ports
EXPOSE 5060/udp 5060/tcp 5061/tcp

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD kamctl ping || exit 1

# Run Kamailio
USER kamailio
CMD ["kamailio", "-DD", "-E", "-e"]
