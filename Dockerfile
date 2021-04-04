FROM alpine:3.13.3
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ liquibase
#TODO: Move ENV variable out of docker file after development
ENV MIGRATIONS_BASE_DIRECTORY=DatabaseMigrations
ENV MIGRATIONS_STORE_SIRECTORY=Migrations
ENV MIGRATIONS_AUTHOR="Saurabh Harwande"
ENV MIGRATIONS_FORMAT=yaml
ENV MIGRATIONS_MASTERLOG_FILE=master-change-log.${MIGRATIONS_FORMAT}
ENV DB_SNAPSHOT_FILE=db-snapshot.${MIGRATIONS_FORMAT}
ENV DB_TYPE=postgresql
ENV DB_NAME=postgres3
ENV DB_URL=jdbc:${DB_TYPE}://local-postgres.dns.podman:5432/${DB_NAME}
ENV DB_USERNAME=postgres
ENV DB_PASSWORD=RandomTown
WORKDIR /liquibase-migrator
COPY ./DefaultDatabaseConnectors/* ./DefaultDatabaseConnectors/
COPY ./master-change-log.yaml .
COPY ./liquibase-migrator.sh /usr/local/bin/liquibase-migrator
#This should be removed. Only using it for development
ENTRYPOINT ["liquibase-migrator"]