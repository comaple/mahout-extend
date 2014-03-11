#!/user/bin/env python


# Usage : to process the field to 归一化数据  which u give, fit_field.py <input file>
# Output : print the result to the console

import sys
import os

fieldList={1:100,3:300,7:1000,8:1000}

def getData(filepath) :
	data=[]
	if ( not os.path.exists(filepath)):
		print "the file path is not exist"
		sys.exit(1)
	fin = open(filepath, 'r')
	for line in fin :
		data.append(line.strip().split('\t'))
	if data :
		return data	
	else :
		return None

def main(argv) :
	print "start......"
	if len(argv) < 2 :
		print "please check u arguments input,please use like this : fit_field.py <input file>"
		sys.exit(2)
	data=getData(argv[1])
	if data:
		for d in data :
			for key in fieldList.keys() :
				field_value = int(d[key])
				field_max = int(fieldList.get(key))
				if field_value >= field_max :
					d[key]=str(100)
				else :
					d[key]=str(field_value*100/field_max)
		for dl in data :
			print dl

if __name__ == '__main__':
	main(sys.argv)
