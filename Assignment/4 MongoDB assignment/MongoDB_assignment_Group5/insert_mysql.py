# -- encoding: utf-8 --

"""
@author: Yan Gu
@Date:
"""

import sys

from loguru import logger

import get_rawcsv_list
from database_manager import DatabaseManager


# sql dict for all sql query
CREATE_INFO = """
    CREATE TABLE IF NOT EXISTS `GSE13355`.`expr`(
    `geo_id` INT UNSIGNED AUTO_INCREMENT NOT NULL COMMENT 'index',
    `geo_accession` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`geo_id`),
    UNIQUE INDEX (`geo_id`)
    )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
"""
CREATE_MAPPING = """
    CREATE TABLE IF NOT EXISTS `GSE13355`.`probe_mapping`(
    `probe_name` VARCHAR(500) NOT NULL COMMENT 'column name',
    `table_name` VARCHAR(200) NOT NULL,
    PRIMARY KEY (`probe_name`),
    UNIQUE INDEX (`probe_name`)
    )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
"""
CREATE_PROBE = """
    CREATE TABLE IF NOT EXISTS `GSE13355`.`{tb}`(
    `geo_id` INT UNSIGNED NOT NULL COMMENT 'index',
    {col}
    PRIMARY KEY (`geo_id`),
    UNIQUE INDEX (`geo_id`),
    CONSTRAINT `{tb}geo_idfk_1` FOREIGN KEY (`geo_id`) REFERENCES `GSE13355`.`expr`(`geo_id`)
    )ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
"""

INSERT_INFO = """INSERT INTO `GSE13355`.`expr` ( `geo_id`, `geo_accession` ) VALUES ( {}, '{}' )"""
INSERT_MAPPING = """INSERT INTO `GSE13355`.`probe_mapping` ( `probe_name`, `table_name` ) VALUES ( '{}', '{}' )"""
INSERT_TABLE = """INSERT INTO `GSE13355`.`{tb}` ( `geo_id`, {col} ) VALUES ( {id}, {val} )"""

TB = "probe_{id}"

# split data
column_name, raw_data = get_rawcsv_list.get_raw_csv()
probe_map = {}
col_count = 0
while col_count * 1000 < len(column_name):
    probe_map[str(col_count)] = column_name[col_count * 1000: (col_count + 1) * 1000]
    col_count += 1
print(len(probe_map))


# connect to RDS
mydb = DatabaseManager()

# init table
mydb.cursor.execute(CREATE_INFO)
mydb.cursor.execute(CREATE_MAPPING)
for k, v in probe_map.items():
    mydb.cursor.execute(
        CREATE_PROBE.format(
            tb=TB.format(id=k),
            col=' '.join(["`" + i + "` DOUBLE NOT NULL COMMENT 'column name'," for i in v])
        )
    )
mydb.conn.commit()
logger.info("Create table")

# insert info
for row in raw_data:
    mydb.cursor.execute(INSERT_INFO.format(str(row[0]), row[1]))
mydb.conn.commit()

# insert mapping
for k, v in probe_map.items():
    for i in v:
        mydb.cursor.execute(INSERT_MAPPING.format(i, TB.format(id=k)))
    mydb.conn.commit()
    logger.info("insert {k} mapping".format(k=k))
mydb.conn.commit()
logger.info("insert mapping")

# insert row
cc = 0
for row in raw_data:
    col_count = 0
    while col_count * 1000 < len(column_name):
        temp_col = ", ".join(["`" + i + "`" for i in probe_map[str(col_count)]])
        temp_data = ", ".join(row[col_count * 1000 + 2: (col_count + 1) * 1000 + 2])
        mydb.cursor.execute(
            INSERT_TABLE.format(
                tb=TB.format(str(col_count)),
                col=temp_col,
                id=row[0],
                val=temp_data
            )
        )
        col_count += 1
    cc += 1
    mydb.conn.commit()
    if cc % 5 == 0:
        logger.info("insert {0} row".format(cc))
mydb.conn.commit()
logger.info("insert row")

mydb.conn.commit()
logger.info("Write successfully!")

mydb.cursor.close()
mydb.conn.close()
