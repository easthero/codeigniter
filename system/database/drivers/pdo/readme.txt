PDO driver for SQLite3 by Xintrea

This driver tested on CodeIgniter 1.7.1

For connect to SQLite3 database, use next steps.

1. Create directory /pdo in /database/drivers and copy to this directory 
   driver *.php files

2. Create SQLite3 database file, and put him to any directory.
   My database file is [APPPATH]/db/base.db

3. In application database config [APPPATH]/config/database.php
   set next settings:

...
$db['default']['hostname'] = '';
$db['default']['username'] = '';
$db['default']['password'] = '';
$db['default']['database'] = 'sqlite:'.APPPATH.'db/base.db';
$db['default']['dbdriver'] = 'pdo';
...


This is all.

My contact: xintrea@gmail.com
