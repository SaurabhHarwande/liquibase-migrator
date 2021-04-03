#!/bin/sh
#TODO: Implement(google if possible) a simple command to read inline parameter and use them to override ENVIRONMENT variables.
#TODO: Research if there is any way to shorten the below command and store the DB details, classpath etc. in simple variables and use them instead.
case ${1} in
    initialize)
        #TODO: Check if snapshot already exists
        if [ -f ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_MASTERLOG_FILE} ]
        then
            echo "A migration project has already been initialized. No scripts will be executed."
        else
            #Copy over master change log
            cp \
                ./${MIGRATIONS_MASTERLOG_FILE} \
                ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_MASTERLOG_FILE}
            #Create base snapshot
            liquibase \
                --classpath ${DB_DRIVER} \
                --url ${DB_URL} \
                --username ${DB_USERNAME} \
                --password ${DB_PASSWORD} \
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
        fi
        ;;
    generate)
        if [ -z ${2} ]
        then
            echo "Please provide a migration name."
        elif [ -f ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_STORE_SIRECTORY}/${2}.${MIGRATIONS_FORMAT} ]
        then
            echo "A migration with name ${2} already exists. No scripts will be executed."
        else
            #Generate new change log file
            liquibase \
                --classpath ${DB_DRIVER} \
                --referenceUrl ${DB_URL} \
                --referenceUsername ${DB_USERNAME} \
                --referencePassword ${DB_PASSWORD} \
                --url "offline:${DB_TYPE}?snapshot=./${MIGRATIONS_BASE_DIRECTORY}/${DB_SNAPSHOT_FILE}" \
                --changeLogFile ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_STORE_SIRECTORY}/${2}.${MIGRATIONS_FORMAT} \
                --changeSetAuthor "${MIGRATIONS_AUTHOR}" \
                diffChangeLog
            #Append a tag change set to the mgirations file
            printf -- "- changeSet:\n" >> ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_STORE_SIRECTORY}/${2}.${MIGRATIONS_FORMAT}
            printf -- "    id: migration-name-${2}\n" >> ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_STORE_SIRECTORY}/${2}.${MIGRATIONS_FORMAT}
            printf -- "    author: ${MIGRATIONS_AUTHOR}\n" >> ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_STORE_SIRECTORY}/${2}.${MIGRATIONS_FORMAT}
            printf -- "    changes:\n" >> ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_STORE_SIRECTORY}/${2}.${MIGRATIONS_FORMAT}
            printf -- "    - tagDatabase:\n" >> ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_STORE_SIRECTORY}/${2}.${MIGRATIONS_FORMAT}
            printf -- "        tag: ${2}\n" >> ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_STORE_SIRECTORY}/${2}.${MIGRATIONS_FORMAT}
            #Sync the database snapshot
            liquibase \
                --classpath ${DB_DRIVER} \
                --url ${DB_URL} \
                --username ${DB_USERNAME} \
                --password ${DB_PASSWORD} \
                --outputFile ./${MIGRATIONS_BASE_DIRECTORY}/${DB_SNAPSHOT_FILE} \
                snapshot \
                --snapshotFormat ${MIGRATIONS_FORMAT}
            #Add entries to the database changelog tables
            liquibase \
                --classpath ${DB_DRIVER} \
                --url ${DB_URL} \
                --username ${DB_USERNAME} \
                --password ${DB_PASSWORD} \
                --changeLogFile ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_MASTERLOG_FILE} \
                changeLogSync
        fi
        ;;
    update)
        if [ -z ${2} ]
        then
            #No tagname passed. Run a simple update.
            liquibase \
                --classpath ${DB_DRIVER} \
                --url ${DB_URL} \
                --username ${DB_USERNAME} \
                --password ${DB_PASSWORD} \
                --changeLogFile ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_MASTERLOG_FILE} \
                update
        else
            #Tagname passed as second parameter. Run the updateToTag command.
            liquibase \
                --classpath ${DB_DRIVER} \
                --url ${DB_URL} \
                --username ${DB_USERNAME} \
                --password ${DB_PASSWORD} \
                --changeLogFile ./${MIGRATIONS_BASE_DIRECTORY}/${MIGRATIONS_MASTERLOG_FILE} \
                updateToTag ${2}
        fi
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
        #If commands don't match, pass the inputs as parameters to the liquibase cli
        liquibase ${@}
        ;;
esac