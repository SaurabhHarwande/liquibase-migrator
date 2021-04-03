# Liquibase Migrator
Liquibase Migrator is a simple shell script which builds on Liquibase and provides a wrapper that eases the process of managing migrations using Liquibase.

Liquibase migrator is also available as Docker Image. Please check out the [docker repository](https://hub.docker.com/r/saurabhh/liquibase-migrator) for more details.

# Commands
## initialize
Initializes a database for us in specified format.
### Example usage
```
```
## generate
Generate a new differential migration script by comparing snapshot to the current database state.
### Example usage
```
```
## update
Update apply the latest migration scripts to the database. If a tag is passed as second paramter the database will be updated only upto the mentioned tag.
### Example usage
```
```
## rollback
Rolls back all the changes made after the specified tag.
### Example usage
```
```
## *
If the command doesnot match any of the above. The parameters are passed as is to the liquibase executable.
### Example usage
```
```