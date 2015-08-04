CREATE TABLE example (
         id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
         title VARCHAR(255),
	 body TEXT,
	 FULLTEXT (title,body)
	 ) ENGINE=MyISAM;

insert into example (title, body) values("mr", "this is a mr");

insert into example (title, body) values("ms", "this is a ms");

insert into example (title, body) values("mrs", "this is a mrs");

