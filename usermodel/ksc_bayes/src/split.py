#!/user/bin/env python
# Author : comaple.zhang
# Create Time : 20140305
# Usage : to split the data to fit the :train,and test data set
# Example : python split.py input trainOutput testOutput


import argparse
import sys
import os
import random

SPLIT_RATE = 0.8

def GetParse():
	parse = argparse.ArgumentParser(description = "To split the data set to Train and Test")
	parse.add_argument('-i',action='store',help="the input path to split")
	parse.add_argument('-p',action='store',help="the prefix of the splited file name ")
	parse.add_argument('-r',action='store',help="the precent of the splite rate",default="0.8")
	return parse
def CheckArgs(parse,argv) :
	options = parse.parse_args(argv[1:])
	if options.i :
		return options
	parse.print_help()
	return None	
		
def SplitFile(input,output_train,output_test):
	trainOutFile = file(output_train,'w')
	testOutFile = file(output_test,'w')
	inputFile = file(input,'r')
	i = 0
	j = 0
	for line in inputFile :
		line = line.strip()
		rd = random.random()
		outfile = testOutFile
		if rd < SPLIT_RATE :
			outfile = trainOutFile
			i += 1
		outfile.write(line+'\n')
		j += 1
	inputFile.close()
	trainOutFile.close()
	testOutFile.close()
	print output_train,"\n"+output_test
	print 'test set :',j-i,'train set :',i
		

if __name__ == '__main__' :
	parse = GetParse()
	options = CheckArgs(parse,sys.argv)
	if options:
		input = options.i
		output_train = options.p + '_train'
		output_test = options.p + '_test'	
		SPLIT_RATE = float(options.r)
		SplitFile(input,output_train,output_test)	
