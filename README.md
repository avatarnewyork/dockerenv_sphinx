# dockerenv_sphinx
docker sphinx 2.0.4 (centos 6.0)

## Description
This image runs sphinx 2.0.4.  It has been tested working with mysql5.0.  

## Usage
* create your sphinx.conf.source file.  Edit this file and replace the standard mysql connection strings with docker link variables instead.  For example, using the docker compose web.yml file below: 

```yml
web:
  image: avatarnewyork/dockerenv-apache:php53
  volumes:
    - /var/www/website/public:/var/www/html
    - /var/www/website:/var/www
  ports:
    - "80"
  links:
    - db
    - sphinx
db:
  image: avatarnewyork/dockerenv-mysql:mysql50
  volumes:
    - /var/mysql/lib:/var/lib/mysql
  ports:
    - "3306"
sphinx:
  image: avatarnewyork/dockerenv-sphinx
  links:
    - db
  ports:
    - "9312"
  volumes:
    - /var/www/website/sphinx:/etc/sphinx
```

The source inside my sphinx.conf.source file would look like this:

```sphinx
source main
{
	type                 = mysql

	sql_host             = $WEB_DB_1_PORT_3306_TCP_ADDR
	sql_user             = dbusername
	sql_pass             = dbpassword
	sql_db               = dbname
	sql_port             = $WEB_DB_1_PORT_3306_TCP_PORT
	mysql_connect_flags = 32
}
```

When you start the container, [run.sh](https://github.com/avatarnewyork/dockerenv_sphinx/blob/master/run.sh) will search and replace any variables with the appropriate link values and copy them over to the real sphinx.conf file and start sphinx (which uses the sphinx.conf file, not the sphinx.conf.source file).

### Other Environment Variables
the `run.sh` script will support any environment variables.  This means you can substitute ANY environment variable defined in your `sphinx.conf.source` file will a corasponding environment variable defined in your docker compose yml file.

#### Example:
Add $DB_NAME variable to substitute 

yml
```yaml
sphinx:
  image: avatarnewyork/dockerenv-sphinx
  links:
    - db
  ports:
    - "9312"
  volumes:
    - /var/www/website/sphinx:/etc/sphinx
  environment:
    - DB_NAME: mydbname
```

sphinx.conf.source
```sphinx
source main
{
	type                 = mysql

	sql_host             = $WEB_DB_1_PORT_3306_TCP_ADDR
	sql_user             = dbusername
	sql_pass             = dbpassword
	sql_db               = $DB_NAME
	sql_port             = $WEB_DB_1_PORT_3306_TCP_PORT
	mysql_connect_flags = 32
}
```
