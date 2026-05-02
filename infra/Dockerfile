FROM jenkins/jenkins:lts

USER root

#
# Install all dependencies
#
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    curl \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

#
# Make python3 the default
#
RUN ln -sf /usr/bin/python3 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip

#
# Install Pulumi directly into /opt/pulumi (no cp needed)
#
RUN mkdir -p /opt/pulumi \
    && curl -fsSL https://get.pulumi.com | sh -s -- --install-root /opt/pulumi \
    && chmod -R 755 /opt/pulumi

ENV PATH="/opt/pulumi/bin:${PATH}"

#
# Rename the existing jenkins user/group to tcuser (UID 1000 stays the same)
#
RUN usermod -l tcuser jenkins \
    && groupmod -n tcuser jenkins \
    && usermod -c "tcuser" tcuser

#
# Fix ownership
#
RUN chown -R tcuser:tcuser /opt/pulumi \
    && chown -R tcuser:tcuser /var/jenkins_home /usr/share/jenkins/ref

USER tcuser

RUN python3 --version && pulumi version