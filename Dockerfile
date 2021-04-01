FROM alpine:3.13.3
RUN apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ liquibase
COPY ./liquibase-migrator.sh /usr/local/bin/liquibase-migrator
WORKDIR /liquibase-migrator
#This should be removed. Only using it for development
COPY ./postgresql-42.2.19.jar .
ENV MIGRATIONS_BASE_DIRECTORY=DatabaseMigrations
ENV MIGRATIONS_STORE_SIRECTORY=Migrations
ENV MIGRATIONS_FORMAT=yaml
ENV MIGRATIOS_BASE_FILE=db-migrations.${MIGRATIONS_FORMAT}
ENV DB_SNAPSHOT_FILE=db-snapshot
ENV DB_TYPE=postgresql
ENV DB_NAME=postgres3
ENV DB_URL=jdbc:${DB_TYPE}://local-postgres.dns.podman:5432/${DB_NAME}
ENV DB_USERNAME=postgres
ENV DB_PASSWORD=*****
ENV DB_DRIVER=postgresql-42.2.19.jar
ENTRYPOINT ["liquibase-migrator"]