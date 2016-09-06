FROM bitnami/express:4.14.0-r1

MAINTAINER Bitnami <containers@bitnami.com>

# Eclipse Che dependencies
USER root

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN bitnami-pkg install java-1.8.0_91-0 --checksum 64cf20b77dc7cce3a28e9fe1daa149785c9c8c13ad1249071bc778fa40ae8773
ENV PATH=/opt/bitnami/java/bin:$PATH

# ExpressJS
ENV BITNAMI_APP_NAME=express-che

RUN rm /app-entrypoint.sh

LABEL che:server:3000:ref=nodejs che:server:3000:protocol=http

# MongoDB
RUN bitnami-pkg unpack mongodb-3.2.7-1 --checksum 98d972ec5f6a34b3fc7a82e76600d9ac6c209537d93402e3b29de9e066440b14
ENV PATH=/opt/bitnami/mongodb/sbin:/opt/bitnami/mongodb/bin:$PATH

RUN harpoon initialize mongodb

# Eclipse Che
USER bitnami
WORKDIR /projects

ENV TERM=xterm
ENV DATABASE_URL=mongodb://localhost:27017/my_project_development

ENTRYPOINT ["/entrypoint.sh"]
CMD ["sudo", "env", "HOME=/root", "harpoon", "start", "--foreground", "mongodb"]
