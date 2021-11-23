import XLSX

xf = XLSX.readxlsx("../data/data/processed/GDP by Industry.xlsx")

display(XLSX.sheetnames(xf))

sh = xf["2019clean"]

display(sh)