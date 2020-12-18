# -- encoding: utf-8 --

"""
@author: Yan Gu
@Date:
"""

import sys
import csv

import get_rawcsv_list


TB = "probe_{id}"

# split data
column_name, raw_data = get_rawcsv_list.get_raw_csv()
probe_map = {}
col_count = 0
# mapping_rows = [["probe_name", "table_name"]]
mapping_rows = []
while col_count * 1000 < len(column_name):
    probe_map[str(col_count)] = column_name[col_count * 1000: (col_count + 1) * 1000]
    for i in probe_map[str(col_count)]:
        mapping_rows.append([i, TB.format(id=str(col_count))])
    col_count += 1
print(len(mapping_rows))

with open('C:\\Users\\95236\\Desktop\\MongoDB_assignment_Group5\\result_table\\probe_mapping1.csv', 'w', newline='') as csvfile:
    spamwriter = csv.writer(csvfile, delimiter=',',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    for row in mapping_rows:
        spamwriter.writerow(row)

col_count = 0
while col_count * 1000 < len(column_name):
    # temp = [["geo_id"] + probe_map[str(col_count)]]
    temp = []
    for row in raw_data:
        temp.append([row[0]] + row[col_count * 1000 + 2: (col_count + 1) * 1000 + 2])
    print(col_count, len(temp), len(temp[0]))
    with open('C:\\Users\\95236\\Desktop\\MongoDB_assignment_Group5\\result_table\\probe_{}.csv'.format(str(col_count)), 'w', newline='') as csvfile:
        spamwriter = csv.writer(csvfile, delimiter=',',
                                quotechar='\"', quoting=csv.QUOTE_NONNUMERIC)
        for row in temp:
            spamwriter.writerow(row)
    col_count += 1

