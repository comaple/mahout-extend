#!/user/bin/env python

#  python caculate.py  kp_userpreference_processed.txt
# Usage : to process the field which u give, fit_field.py <input file>
# Output : print the result to the console

import sys
import os

#fieldList={1:20,2:1,3:1,4:1,5:1}
fieldList={1:1,2:0.5,3:0.5,4:1}
#statistic={1:"0-1",2:"1-20",3:"20-25",4:"25-50",5:"50-75",6:"75-100",7:"100-125",8:"125-150",9:"150-175",10:"175-200",11:"200-250",12:"250-300",13:"300-max"}
statistic={1:"0-1",2:"1-20",3:"20-25",4:"25-50",5:"50-75",6:"75-100",7:"100-125",8:"125-150",9:"150-175",10:"175-200",11:"200-250",12:"250-300",13:"300-max",14:"50-60"}
statistics=False
is_active=75

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
	if len(argv) < 2 :
		print "please check u arguments input,please use like this : fit_field.py <input file>"
		sys.exit(2)
	data=getData(argv[1])
	if data:
		count=0
		index=0
		result={}
		for sk in statistic.keys() :
			result.setdefault(sk,0)
		for d in data :
			value = 0
			for key in fieldList.keys() :
				value += float(d[key]) * float(fieldList.get(key))
			value=myformat(value)
			index += 1
			if statistics is True :
				for skey in statistic.keys() :
					kv = statistic.get(skey).split('-')
					min = float(kv[0])
					max = kv[1]
					if kv[1] == 'max' :
						max=sys.maxint
					max=int(max)
					if float(value) >= min  and  float(value) < max :
						v = result.get(skey) + 1
						result[skey] = v	
			d.append(value)
	#		if float(value) >= is_active :
	#			d[0] = 'T'
	#		else :
	#			d[0] = 'F'
#		for dl in data :
#			print '\t'.join(dl)
		if statistics is True :
			for r in result.keys() :
				print str(statistic[r]) + "\t" + str(result.get(r))
		else :
			for dl in data :
				print '\t'.join(dl)
if __name__ == '__main__':
	main(sys.argv)
