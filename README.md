# Adminer for Azure SQL Server and MySQL

This docker image contains the recommended installation software by Azure SQL Server for connecting PHP PDO to the cloud database servers.

To use this docker image, `docker run -p 8000:80 joshbmarshall/azureadminer`

Or you can use the following docker-compose:
```
  version: "3.2"
  services:
    adminer:
      image: joshbmarshall/azureadminer
      restart: always
      ports:
        - "8000:80"
```
Visit the interface at https://localhost:8000 if using the above port configuration.
To connect to an Azure database, look at the PHP PDO connection string in the Azure portal for the database.
It has the host and username. You'll need the password as well.
