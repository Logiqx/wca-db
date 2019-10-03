# Performance Tips

## MariaDB

It's faster than MySQL for most operations.

Regardless of whether you choose to use MySQL or MariaDB the rest of this document applies.



## Server Configuration

#### Buffer Pool Size

TODO

Note about it saving on shutdown

#### Log File Size

TODO

#### Temporary Table Size

TODO

#### Flush Method

TODO

#### Example

```ini
[mysqld]
innodb_buffer_pool_size        = 2G
innodb_log_file_size           = 512M
tmp_table_size                 = 512M
max_heap_table_size            = 512M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method            = O_DIRECT_NO_FSYNC
```

An example of the benefits is to reduce database load time from ~10:00 to ~1:15.

Queries are also a lot faster.



### ???

-- innodb_doublewrite
-- https://dba.stackexchange.com/questions/49646/bulk-insert-buffer-size-and-innodb?rq=1
-- https://dba.stackexchange.com/questions/21583/how-can-i-optimize-this-mysql-table-that-will-need-to-hold-5-million-rows/21594#21594
-- https://www.percona.com/blog/2014/05/23/improve-innodb-performance-write-bound-loads/



## Indices

BLAH

Reference - [Optimization and Indexes](https://dev.mysql.com/doc/refman/8.0/en/optimization-indexes.html)



### Multi-Column

BLAH



#### Unnecessary Indices

BLAH



### Primary Key

https://dev.mysql.com/doc/refman/8.0/en/glossary.html#glos_clustered_index

Influences storage so adding a PK requires the whole table to be re-organised.

Index extensions - appended to secondary keys:

https://dev.mysql.com/doc/refman/8.0/en/index-extensions.html



## Custom Schema

Knowing about indices and their implications it is possible to create a custom database which performs better than the standard database.

Specifically focused on data size, data types and the cluster indices.

Does not require standard database to be indexed.

Reference - [Optimizing Database Structure](https://dev.mysql.com/doc/refman/8.0/en/optimizing-database-structure.html)



### Database

Create a dedicated database which can be used as a direct replacement for the standard database:

```sql
CREATE DATABASE IF NOT EXISTS `wcastats`
DEFAULT CHARACTER SET=utf8mb4 DEFAULT COLLATE=utf8mb4_unicode_ci;
```

Note the default character set and collation, avoiding the need to specify them for every single table and / or field.



### Tables

You can view the default engines using the following SQL.

```sql
SHOW ENGINES;
```

The default engine InnoDB is the best all-round engine.



#### Integer Types

<https://dev.mysql.com/doc/refman/8.0/en/integer-types.html>



#### Primary Keys

Use AUTOINCREMENT and take the opportunity to have the data pre-sorted in the clustered index.



#### Table / Index Sizes

You can check the size of the database an tables using the information schema:

```sql
SELECT ROUND(sum(data_length / 1024 / 1024), 2) AS data_length_mb
FROM information_schema.tables
WHERE table_schema='wca'
ORDER BY data_length desc;

SELECT table_name, ROUND(data_length / 1024 / 1024, 2) AS data_length_mb
FROM information_schema.tables
WHERE table_schema='wca'
ORDER BY data_length desc;
```

Knowing the compression key block size:

```sql
SELECT table_name, database_name, index_name,
	ROUND(stat_value *
		CASE
			WHEN table_name LIKE '%16' THEN 16384
			WHEN table_name LIKE '%8' THEN 8192
			WHEN table_name LIKE '%4' THEN 4096
			WHEN table_name LIKE '%2' THEN 2048
			WHEN table_name LIKE '%1' THEN 1024
            WHEN database_name = 'wcastats' THEN 8192
			ELSE @@innodb_page_size
		END / 1024 / 1024, 2) size_in_mb
FROM mysql.innodb_index_stats
WHERE stat_name = 'size' AND database_name IN ('wca', 'wcastats') AND table_name like 'Results%'
ORDER BY table_name, database_name, size_in_mb DESC;
```



#### Record Ordering

<https://dev.mysql.com/doc/refman/8.0/en/optimization-indexes.html>



#### Data Compression

<https://dev.mysql.com/doc/refman/8.0/en/innodb-row-format.html#innodb-row-format-compressed>

<https://dev.mysql.com/doc/refman/8.0/en/innodb-table-compression.html>

Speeds up inserts due to temporary tables fitting in memory and less I/O

```sql
SHOW GLOBAL STATUS LIKE 'created_tmp_%tables'
```





#### Query Execution Plans

<https://dev.mysql.com/doc/refman/8.0/en/execution-plan-information.html>





## Queries

### Attempts

Rather than using UNION ALL you can join to a table containing the values 1 to 5.

MariaDB has a Sequence engine which can perform this task.

```sql
SELECT * FROM seq_1_to_5;
```

The sequence engine doesn't exist in MySQL so you need to create a physical table:

```sql
DROP TABLE IF EXISTS seq_1_to_5;
CREATE TABLE seq_1_to_5 (seq TINYINT NOT NULL);
INSERT INTO seq_1_to_5 (seq) VALUES (1), (2), (3), (4), (5);
```

Note: The above SQL is harmless in MariaDB and the Sequence engine will be un-affected. 



### Common Table Expressions

TODO



### Window Functions

TODO