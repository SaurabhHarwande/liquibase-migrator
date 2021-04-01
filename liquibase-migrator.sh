#!/bin/sh
echo ${@}
case ${1} in
    initialize)
        #Add a check if snapshot already exists before initializing. I we override a snapshot we will lose a change step
        liquibase --logLevel debug --classpath ${DB_DRIVER} --url ${DB_URL} --username ${DB_USERNAME} --password ${DB_PASSWORD} --outputFile ./${MIGRATIONS_BASE_FOLDER}/${DB_SNAPSHOT_FILE}.${MIGRATIONS_FORMAT} snapshot --snapshotFormat ${MIGRATIONS_FORMAT}
        ;;
    generate)
        liquibase --referenceUrl ${DB_URL} --referenceUsername ${DB_USERNAME} --referencePassword ${DB_PASSWORD} --url \"offline:${DB_TYPE}?snapshot=./${MIGRATIONS_BASE_FOLDER}/${DB_SNAPSHOT_FILE}.${MIGRATIONS_FORMAT}\" --changeLogFile ./${MIGRATIONS_BASE_FOLDER}/${MIGRATIONS_STORE_FOLDER}/${2}.${MIGRATIONS_FORMAT} diffChangeLog
        liquibase --outputFile ${DB_SNAPSHOT_FILE}.${MIGRATIONS_FORMAT} snapshot --snapshotFormat ${MIGRATIONS_FORMAT}
        ;;
    update)
        liquibase --logLevel debug --classpath ${DB_DRIVER} --url ${DB_URL} --username ${DB_USERNAME} --password ${DB_PASSWORD} --changeLogFile ./${MIGRATIONS_BASE_FOLDER}/db-change-log.${MIGRATIONS_FORMAT} update
        ;;
    rollback)
        echo "code to rollback to a certain state"
        ;;
    *)
        liquibase ${@}
        ;;
esac