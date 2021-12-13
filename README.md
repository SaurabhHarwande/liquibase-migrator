# Liquibase Migrator
Liquibase Migrator is a simple shell script which builds on Liquibase and provides a wrapper that eases the process of managing migrations using Liquibase.

Liquibase migrator is also available as Docker Image. Please check out the [docker repository](https://hub.docker.com/r/saurabhh/liquibase-migrator) for more details.

Some environment variables need to be setup before we can use the liquibase migrator
They are as follows 
```
MIGRATIONS_BASE_DIRECTORY=DatabaseMigrations //The base directory in container to be moutned
MIGRATIONS_STORE_DIRECTORY=Migrations //Folder which will hold migrations
MIGRATIONS_AUTHOR="liquibase-migrator-auto-generated" //default author name for tags
MIGRATIONS_FORMAT=yaml //default migrations format to use
MIGRATIONS_MASTERLOG_FILE=master-change-log.yaml //Master log file name
DB_SNAPSHOT_FILE=db-snapshot.yaml //Snapshot file name
DB_TYPE=postgresql //Database provider to use
DB_NAME=site-management-db //Name of database to run migrations against
DB_URL=jdbc:postgresql://local-postgres:5432/site-management-db //Database connection string
DB_USERNAME=admin //Database username
DB_PASSWORD=admin //Database password
```
# Commands
## initialize
Initializes a database for us in specified format.
### Example usage
```
docker run --rm --env-file .\docker.development.env -v ${pwd}:/liquibase-migrator/DatabaseMigrations --network postgres-network saurabhh/liquibase-migrator initialize
```
## generate
Generate a new differential migration script by comparing snapshot to the current database state.
### Example usage
```
docker run --rm --env-file .\docker.development.env -v ${pwd}:/liquibase-migrator/DatabaseMigrations --network postgres-network saurabhh/liquibase-migrator generate <migration-name>
```
## update
Update apply the latest migration scripts to the database. If a tag is passed as second paramter the database will be updated only upto the mentioned tag.
### Example usage
```
docker run --rm --env-file .\docker.development.env -v ${pwd}:/liquibase-migrator/DatabaseMigrations --network postgres-network saurabhh/liquibase-migrator update [<migration-name>]
```
## rollback
Rolls back all the changes made after the specified tag.
### Example usage
```
docker run --rm --env-file .\docker.development.env -v ${pwd}:/liquibase-migrator/DatabaseMigrations --network postgres-network saurabhh/liquibase-migrator rollback <migration-name>
```
## *
If the command doesnot match any of the above. The parameters are passed as is to the liquibase executable.
### Example usage
```
docker run --rm --env-file .\docker.development.env -v ${pwd}:/liquibase-migrator/DatabaseMigrations --network postgres-network saurabhh/liquibase-migrator [liquibase-arguments]
```