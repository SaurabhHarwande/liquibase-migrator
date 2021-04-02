#!/bin/sh
#TODO: Implement(google if possible) a simple command to read inline parameter and use them to override ENVIRONMENT variables.
case ${1} in
    initialize)
        #TODO: Check if snapshot already exists
        #Copy over master change log
        cp \
            ./${MIGRATIONS_MASTERLOG_FILE} \
            ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_MASTERLOG_FILE}
        #Create base snapshot
        liquibase \
            --classpath ${DB_DRIVER} \
            --url ${DB_URL} \
            --username ${DB_USERNAME} \
            --password "${DB_PASSWORD}" \
            --outputFile ./${MIGRATIONS_BASE_DIRECTORY}/${DB_SNAPSHOT_FILE} \
            snapshot \
            --snapshotFormat ${MIGRATIONS_FORMAT}
        #Sync initial change log to database
        liquibase \
            --classpath ${DB_DRIVER} \
            --url ${DB_URL} \
            --username ${DB_USERNAME} \
            --password ${DB_PASSWORD} \
            --changeLogFile ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_MASTERLOG_FILE} \
            changeLogSync
        ;;
    generate)
        #TODO: Check if changelog already exists
        #Generate new change log file
        liquibase \
            --classpath ${DB_DRIVER} \
            --referenceUrl ${DB_URL} \
            --referenceUsername ${DB_USERNAME} \
            --referencePassword ${DB_PASSWORD} \
            --url \"offline:${DB_TYPE}?snapshot=./${MIGRATIONS_BASE_DIRECTORY}/${DB_SNAPSHOT_FILE}\" \
            --changeLogFile ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_STORE_FOLDER}/${2}.${MIGRATIONS_FORMAT} \
            diffChangeLog
        liquibase \
            --classpath ${DB_DRIVER} \
            --url ${DB_URL} \
            --username ${DB_USERNAME} \
            --password ${DB_PASSWORD} \
            --outputFile ./${MIGRATIONS_BASE_DIRECTORY}/${DB_SNAPSHOT_FILE} \
            snapshot \
            --snapshotFormat ${MIGRATIONS_FORMAT}
        liquibase \
            --classpath ${DB_DRIVER} \
            --url ${DB_URL} \
            --username ${DB_USERNAME} \
            --password ${DB_PASSWORD} \
            --changeLogFile ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_MASTERLOG_FILE} \
            changeLogSync
        liquibase \
            --classpath ${DB_DRIVER} \
            --url ${DB_URL} \
            --username ${DB_USERNAME} \
            --password ${DB_PASSWORD} \
            tag ${2}
        ;;
    update)
        #TODO: Add a if else for running update/updateToTag commands
        liquibase \
            --classpath ${DB_DRIVER} \
            --url ${DB_URL} \
            --username ${DB_USERNAME} \
            --password ${DB_PASSWORD} \
            --changeLogFile ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_MASTERLOG_FILE} \
            update
        ;;
    rollback)
        #Rollback the database to a mentioned tag
        liquibase \
            --classpath ${DB_DRIVER} \
            --url ${DB_URL} \
            --username ${DB_USERNAME} \
            --password ${DB_PASSWORD} \
            --changeLogFile ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_MASTERLOG_FILE} \
            rollback ${2}
        ;;
    *)
        liquibase ${@}
        ;;
esac