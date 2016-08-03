FROM gcr.io/stacksmith-images/debian-buildpack:jessie-r0

MAINTAINER Bitnami <containers@bitnami.com>

RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ENV BITNAMI_IMAGE_VERSION=8.0.35-r1 \
    BITNAMI_APP_NAME=tomcat \
    BITNAMI_APP_USER=tomcat

RUN bitnami-pkg install java-1.8.0_91-0 --checksum 64cf20b77dc7cce3a28e9fe1daa149785c9c8c13ad1249071bc778fa40ae8773
ENV PATH=/opt/bitnami/java/bin:$PATH

RUN bitnami-pkg unpack tomcat-8.0.35-0 --checksum d86af6bade1325215d4dd1b63aefbd4a57abb05a71672e5f58e27ff2fd49325b
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/data /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH
ENV TOMCAT_HOME=/opt/bitnami/$BITNAMI_APP_NAME

# ExpressJS template
RUN bitnami-pkg install node-6.3.0-0 --checksum f2997c421e45beb752673a531bf475231d183c30f7f8d5ec1a5fb68d39744d5f

ENV PATH=/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH \
    NODE_PATH=/opt/bitnami/node/lib/node_modules

ENV BITNAMI_APP_NAME=express
ENV BITNAMI_IMAGE_VERSION=4.13.4-r4

RUN npm install -g express-generator@4

EXPOSE 3000

LABEL che:server:3000:ref=nodejs che:server:3000:protocol=http

RUN harpoon initialize $BITNAMI_APP_NAME
CMD ["harpoon", "start", "--foreground", "tomcat"]
