import pandas as pd

file=open('C:\\Users\\95236\\Desktop\\MongoDB_assignment_Group5\\GSE13355_expr_transpose.csv','w')

df = pd.read_csv('C:\\Users\\95236\\Desktop\\MongoDB_assignment_Group5\\GSE13355_expr.csv',header= None)
data = df.values
# data = df.as_matrix()
data = list(map(list,zip(*data)))
data = pd.DataFrame(data)
data.to_csv(file, header=0, index=0)

