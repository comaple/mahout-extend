#!/usr/bin/env python
# Author : comaple.zhang
# Create Time : 20140226
# Usage: process_field.py  <in file> <out file> fieldindex length
# Output: out file processed bining 

import sys
import os

def genSet(data,length) :
        s=set()
        for d in data :
                s.add(d[field])
        list=[]
        for i in s :
                list.append(i)
        list.sort()
        dict={}
        index=0
        lable=1
        for item in list :
                if index % length is  0 :
                        lable += 1
                index += 1
                dict.setdefault(item,lable)
        return dict


if __name__ == '__main__':
	filePath = sys.argv[1]
#	foutPath = sys.argv[2]
	field = int(sys.argv[2])
	length= int(sys.argv[3])

	if ( not os.path.exists(filePath)):
		sys.exit(1)

	#fout = open(foutPath, 'w');
	fin = open(filePath, 'r');

	data=[]	
	for line in fin:
		data.append(line.split('\t'))
	data.sort(lambda x, y: int(float(x[field]) -float(y[field])))
	dict=genSet(data,length)
	lable=0
	for d in data :
		lable=dict.get(d[field])	
		d[field]=str(lable)
	for line in data :
		line[len(line)-1]=line[len(line)-1].strip()
		print '\t'.join(line)

