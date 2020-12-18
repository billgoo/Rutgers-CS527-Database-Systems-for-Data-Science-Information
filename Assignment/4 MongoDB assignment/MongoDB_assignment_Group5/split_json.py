# -- encoding: utf-8 --

"""
@author: Yan Gu
@Date:
"""

import sys
import json

import get_rawcsv_list

result_data = []

# split data
column_name, raw_data = get_rawcsv_list.get_raw_csv()

for row in raw_data:
    temp = {
        "geo_accession": row[1],
        "probe": {column_name[i]: row[i + 2] for i in range(len(column_name))}
    }
    result_data.append(temp)

count = 0
while count * 5 < len(result_data):
    with open('C:\\Users\\95236\\Desktop\\MongoDB_assignment_Group5\\result_table\\mongo_expr{}.json'.format(count), 'w') as jsonfile:
        json.dump(result_data[count * 5:(count + 1) * 5], jsonfile, ensure_ascii=True, indent=2)
    count += 1
    print(count)

print("done")
