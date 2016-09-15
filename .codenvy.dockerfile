FROM gcr.io/stacksmith-images/ubuntu:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=express \
    BITNAMI_APP_VERSION=4.14.0 \
    PATH=/opt/bitnami/node/bin:$PATH
ENV DISABLE_UPDATE_CHECK=1

# Additional modules required
ADD node-6.5.0-0-linux-x64.tar.gz /tmp
RUN harpoon install /tmp/node-6.5.0-0-linux-x64
ADD express-generator-4.13.4-0-linux-x64.tar.gz /tmp
RUN harpoon install /tmp/express-generator-4.13.4-0-linux-x64

# Install express
ADD express-4.14.0-0-linux-x64.tar.gz /tmp
RUN harpoon --log-level trace8 unpack /tmp/express-4.14.0-0-linux-x64 --projectsDirectory=/projects --projectName=myApp

EXPOSE 3000

# Eclipse Che dependencies

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN bitnami-pkg install java-1.8.0_91-0 --checksum 64cf20b77dc7cce3a28e9fe1daa149785c9c8c13ad1249071bc778fa40ae8773
ENV PATH=/opt/bitnami/java/bin:$PATH

# ExpressJS
ENV BITNAMI_APP_NAME=express

LABEL che:server:3000:ref=nodejs che:server:3000:protocol=http

# MongoDB
RUN bitnami-pkg install mongodb-3.2.7-1 --checksum 98d972ec5f6a34b3fc7a82e76600d9ac6c209537d93402e3b29de9e066440b14
ENV PATH=/opt/bitnami/mongodb/sbin:/opt/bitnami/mongodb/bin:$PATH

# Eclipse Che
USER bitnami
WORKDIR /projects

ENV TERM=xterm
ENV DATABASE_URL=mongodb://localhost:27017/my_project_development

COPY rootfs /

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]
