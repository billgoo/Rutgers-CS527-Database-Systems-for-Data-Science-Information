import csv

def get_raw_csv():
    """
    :return: column_name: len(row) - 1
    :return: result: (col - 1) * (len(row) + 1)
    """
    result = []
    column_name = []
    with open('C:\\Users\\95236\\Desktop\\MongoDB_assignment_Group5\\GSE13355_expr_transpose.csv', newline='\r\n') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
        i = 0
        for row in spamreader:
            # print(', '.join(row))
            if len(row) < 54676:
                print(i)
            
            if i == 0:
                column_name[:] = row[1:]
            else:
                row[1:] = list(map(float, row[1:]))
                row.insert(0, i)
                if len(row) < 54677:
                    print(i)
                result.append(row)
            i += 1

    # print(len(result))
    print(len(column_name), len(result))
    return column_name, result


if __name__ == "__main__":
    get_raw_csv()
