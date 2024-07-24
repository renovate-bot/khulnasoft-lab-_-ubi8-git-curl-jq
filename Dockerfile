# Use the Universal Base Image 8 as the base image
FROM registry.access.redhat.com/ubi8/ubi

# Maintain metadata
LABEL maintainer="Red Hat, Inc."
LABEL com.redhat.component="ubi8-container"
LABEL com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI"
LABEL summary="Provides the latest release"
LABEL description="The Universal Base Image"
LABEL io.k8s.display-name="Red Hat Universal Base"
LABEL io.openshift.expose-services=""
LABEL io.openshift.tags="base rhel8"
LABEL release="1020"
LABEL distribution-scope="public"
LABEL vendor="Red Hat, Inc."

# Set environment variables
ENV container oci
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Copy necessary files
ADD file:/path/to/local/tls-ca-bundle.pem /tmp/tls-ca-bundle.pem
ADD multi:57820a0f1aec3e967cc65e8adc5d3392cc14753a345b8a5b0c353b1fbd2d4dd5 /etc/yum.repos.d/
ADD content_manifests/ubi8-container-8.10-1020.json /root/buildinfo/content_manifests/ubi8-container-8.10-1020.json
ADD Dockerfile-ubi8-8.10-1020 /root/buildinfo/Dockerfile-ubi8-8.10-1020

# Move and remove files as specified
RUN /bin/sh -c mv -f /etc/yum.repos.d/ubi.repo /etc/yum.repos.d/ubi.repo.bak && \
    /bin/sh -c rm -f '/etc/yum.repos.d/repo-37086.repo' && \
    /bin/sh -c rm -f /tmp/tls-ca-bundle.pem && \
    /bin/sh -c mv -fZ /tmp/ubi.repo /etc/yum.repos.d/ubi.repo && \
    /bin/sh -c rm -rf /var/log/* && \
    /bin/sh -c mkdir -p /var/log/rhsm

# Update the system and install necessary packages
RUN dnf -y install && \
    yum -y update && \
    yum -y install git curl jq && \
    yum clean all

# Set the working directory (optional)
WORKDIR /workspace

# Set the entrypoint (optional)
CMD ["/bin/bash"]

# Expose a port (optional)
# EXPOSE 8080

# Example: Run a script (optional)
# CMD ["your-command"]
