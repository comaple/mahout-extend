#!/user/bin/env python
# Author : comaple.zhang
# Create Time : 20140226
# Example : python caculate.py  kp_userpreference_processed.txt
# Comment : T - 1 , F - 0
# Usage : to process the field which u give, fit_field.py <input file>
# Output : print the result to the console

import sys
import os

#fieldList={1:20,2:0.5,3:0.5,4:1,5:1}
fieldList={1:1,2:0.5,3:0.5,4:1}
is_active=60

def myformat(x):
    return ('%.2f' % x).rstrip('0').rstrip('.')

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
	#print "start......"
	if len(argv) < 2 :
		print "please check u arguments input,please use like this : fit_field.py <input file>"
		sys.exit(2)
	data=getData(argv[1])
	if data:
		count=0
		index=0
		result={}
		for d in data :
			value = 0
			for key in fieldList.keys() :
				value += float(d[key]) * float(fieldList.get(key))
			value=myformat(value)
			index += 1
		#	d.append(value)
			length=len(d)
			if float(value) >= is_active :
				d.append('1')
			else :
				d.append('0')
			d[0] ,d[length]=d[length],d[0]
			d[length]=str('#'+d[length])	
		for dl in data :
			print '\t'.join(dl)
if __name__ == '__main__':
	main(sys.argv)
