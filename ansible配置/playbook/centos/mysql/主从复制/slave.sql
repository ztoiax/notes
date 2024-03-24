stop slave;

CHANGE MASTER TO
MASTER_HOST = '192.168.110.4',
MASTER_USER = 'root',
MASTER_PASSWORD = '',
-- 在master上执行show master status;查看MASTER_LOG_FILE、MASTER_LOG_POS
MASTER_LOG_FILE='centos7-3.000028',
MASTER_LOG_POS=421;

start slave;
