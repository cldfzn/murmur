FROM ubuntu:trusty
MAINTAINER Alex Johnson <alex@cldfzn.com>

# Add mumble ppa and install necessary packages for murmur
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7F05CF9E && \
    echo "deb http://ppa.launchpad.net/mumble/release/ubuntu $(lsb_release -cs) main" \
        > /etc/apt/sources.list.d/mumble-release.list && \
    apt-get -qq update && \
    apt-get -qqy install mumble-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add configuration files
ADD mumble-server.ini /config/mumble-server.ini

# Set permissions for config directory
RUN chown mumble-server:mumble-server -R /config

USER mumble-server
VOLUME ["/config"]
EXPOSE 6502 64738/tcp 64738/udp
CMD ["murmurd", "-fg", "-ini", "/config/mumble-server.ini"]
