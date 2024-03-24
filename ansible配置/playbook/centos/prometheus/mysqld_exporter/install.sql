CREATE USER 'mysqld_exporter'@'127.0.0.1' IDENTIFIED BY '12345678';
grant all on *.* to 'mysqld_exporter'@'127.0.0.1' IDENTIFIED BY '12345678';
FLUSH PRIVILEGES;
