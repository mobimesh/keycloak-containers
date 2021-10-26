FROM registry.access.redhat.com/ubi8-minimal

ENV KEYCLOAK_VERSION 15.0.0
ENV JDBC_POSTGRES_VERSION 42.2.5
ENV JDBC_MYSQL_VERSION 8.0.22
ENV JDBC_MARIADB_VERSION 2.5.4
ENV JDBC_MSSQL_VERSION 8.2.2.jre11

ENV LAUNCH_JBOSS_IN_BACKGROUND 1
ENV PROXY_ADDRESS_FORWARDING false
ENV JBOSS_HOME /opt/jboss/keycloak
ENV LANG en_US.UTF-8

ARG GIT_REPO=mobimesh/keycloak
ARG GIT_BRANCH
ARG KEYCLOAK_DIST=https://github.com/keycloak/keycloak/releases/download/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz

USER root

RUN microdnf update -y && microdnf install -y glibc-langpack-en gzip hostname java-11-openjdk-headless openssl tar which && microdnf clean all

ADD tools /opt/jboss/tools
RUN /opt/jboss/tools/build-keycloak.sh

USER 1000

COPY ./scripts /opt/radius/scripts
COPY ./cli /opt/radius/cli
COPY ./config /config

USER root
RUN mkdir /keycloak-conf
RUN chown -R  1000 /keycloak-conf
RUN chown -R  1000 /config
RUN chown -R  1000 /opt/radius
USER 1000
RUN /opt/radius/scripts/docker-radius.sh
RUN rm -rf /opt/jboss/keycloak/standalone/configuration/standalone_xml_history
EXPOSE 8080
EXPOSE 8443
EXPOSE 9990

ENTRYPOINT [ "/opt/radius/scripts/docker-radius-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]
