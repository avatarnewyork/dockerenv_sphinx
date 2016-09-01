# dockerenv_sphinx
## Available tags / branches
latest: docker sphinx 2.0.4 (centos 6.0)
2.2: docker sphinx 2.2.11 (centos 6.0)

## Description
### latest
This image runs sphinx 2.0.4.  This version has been tested with mysql 5.0

### 2.2
This image runs sphinx 2.2.11 when used with the 2.2 tag.  The 2.2 version It has been tested working with percona 5.6.  

### Version Differences
The 2.2 version differs in syntax.  One difference that tests have been updated for is how "weight" is handled.  You now must call the weight() function to retrieve the weight of a row.  Below is the syntax difference between versions 2.0.4 and 2.2.11.  Both return the following same results (below in xml) but the `weight()` function is required for the 2.2 version.

#### 2.0.11 syntax:
```bash
mysql -h 0 -P 9306 -X -e "select * from example where match('mrs')"
```

```xml
<resultset statement="select * from example where match('mrs')
" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <row>
    <field name="id">3</field>
    <field name="weight">2747</field>
  </row>
</resultset>
```

#### 2.2.11 syntax:
```bash
mysql -h 0 -P 9306 -X -e "select *, weight() as weight from example where match('mrs')"
```

```xml
<resultset statement="select *, weight() as weight from example where match('mrs')
" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <row>
    <field name="id">3</field>
    <field name="weight">2747</field>
  </row>
</resultset>
```

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
