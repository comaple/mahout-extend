#!/user/bin/env python
# Author : comaple.zhang
# Create Time : 20140303
# Usage : to train the model and test the future data input
# Training : NB.python 1 TrainingDataFile ModelFile
# Testing : NB.python 0 TestDataFile ModelFile OutFile

import sys
import os
import math

DefaultFreq = 0.1
TrainingDataFile = "train_input.txt"
ModelFile = "train.model"
TestDataFile = "data.test"
TestOutFile = "data.out"
ClassFeaDic = {}
ClassFreq = {}
WordDic = {}
ClassFeaProb = {}
ClassDefaultProb = {}
ClassProb = {}

def Dedup(items) :
	tempDic = {}
	for item in items:
		tempDic[item] = True
	return tempDic.keys()

def LoadData():
	i = 0
	infile = file(TrainingDataFile,'r')
	for sline in infile:
		sline=sline.strip()
		if len(sline) > 0:
			pos = sline.find('#')
			if pos > 0 :
				sline = sline[:pos].strip()
			words=sline.split('\t')
			if len(words) < 1 :
				print "Format error!" + sline
				break
			classid = int(words[0])
			if classid not in ClassFeaDic :
				ClassFeaDic[classid] = {}	
				ClassFeaProb[classid] = {}
				ClassFreq[classid] = 0
			ClassFreq[classid] += 1
			words = words[1:]
			for word in words:
				if len(word) < 1 :
					continue
				wid = int(word)
				if wid not in WordDic :
					WordDic[wid] = 1
				if wid not in ClassFeaDic[classid] :
					ClassFeaDic[classid][wid] = 1
				else :
					ClassFeaDic[classid][wid] += 1
			i += 1
	infile.close()
	print i, "instances loaded !"
	print len(ClassFreq) ,'classes !' ,len(WordDic) ,'words!'
		
def ComputeModel() :
	sum = 0.0
	for freq in ClassFreq.values() :
		sum += freq
	for classid in ClassFreq.keys() :
		ClassProb[classid] = (float)(ClassFreq[classid])/(float)(sum)
	for classid in ClassFeaDic.keys() :
		sum = 0.0
		for wid in ClassFeaDic[classid].keys() :
			sum += ClassFeaDic[classid][wid]
		newsum = (float)(sum + len(WordDic)*DefaultFreq)
		for wid in ClassFeaDic[classid].keys() :
			ClassFeaProb[classid][wid] = (float)(ClassFeaDic[classid][wid] + DefaultFreq)/newsum
		ClassDefaultProb[classid] = (float)(DefaultFreq) / newsum
	return
			
def SaveModel() :
	outfile = file(ModelFile,'w')
	for classid in ClassFreq.keys():
		outfile.write(str(classid))
		outfile.write(' ')
		outfile.write(str(ClassProb[classid]))
		outfile.write(' ')
		outfile.write(str(ClassDefaultProb[classid]))
		outfile.write(' ')
	outfile.write('\n')
	for classid in ClassFeaDic.keys() :
		for wid in ClassFeaDic[classid].keys():
			outfile.write(str(wid) + ' ' + str(ClassFeaProb[classid][wid]))
			outfile.write(' ')
		outfile.write('\n')
	outfile.close()

def LoadModel():
	global WordDic
	WordDic = {}
	global ClassFeaProb
	ClassFeaProb = {}
	global ClassDefaultProb
	ClassDefaultProb = {}
	global ClassProb
	ClassProb = {}
	infile = file(ModelFile, 'r')
	sline = infile.readline().strip()
	items = sline.split(' ')
	if len(items) < 6:
		print "Model format error!"
		return
	i = 0
	while i < len(items):
		classid = int(items[i])
		ClassFeaProb[classid] = {}
		i += 1
		if i >= len(items):
			print "Model format error!"
			return
		ClassProb[classid] = float(items[i])
		i += 1
		if i >= len(items):
			print "Model format error!"
			return
		ClassDefaultProb[classid] = float(items[i])
		i += 1
	for classid in ClassProb.keys():
		sline = infile.readline().strip()
		items = sline.split(' ')
		i = 0
		while i < len(items):
			wid  = int(items[i])
			if wid not in WordDic:
				WordDic[wid] = 1
			i += 1
			if i >= len(items):
				print "Model format error!"
				return
			ClassFeaProb[classid][wid] = float(items[i])
			i += 1
	infile.close()
	print len(ClassProb), "classes!", len(WordDic), "words!"

def Predict0():
	global WordDic
	global ClassFeaProb
	global ClassDefaultProb
	global ClassProb
	
	PrebLabelList = {}
	infile = file(TestDataFile,'r')
	scoreDic = {}
	for line in infile :
		line = line.strip()
		pos = line.find('#')
		uid = ''
		if pos > 0 :
			uid = line[pos+1:].strip()
			line = line[:pos].strip() 
		words = line.split('\t')
		if len(words) < 1 :
			print 'Format error,',line
			break
		for classid in ClassProb.keys():
			scoreDic[classid] = math.log(ClassProb[classid])
		for word in words :
			if len(word) < 1 :
				continue
			wid = int(word)
			if wid not in WordDic :
				continue
			for classid in ClassProb.keys() :
				if wid not in ClassFeaProb[classid] :
					scoreDic[classid] += math.log(ClassDefaultProb[classid])
				else :
					scoreDic[classid] += math.log(ClassFeaProb[classid][wid])
			maxProb = max(scoreDic.values())
			for classid in scoreDic.keys() :
				if maxProb == scoreDic[classid] :
					PrebLabelList[line+'\t'+ uid]=classid		
	infile.close()
	print len(PrebLabelList)
	return PrebLabelList		

def Predict():
	global WordDic
	global ClassFeaProb
	global ClassDefaultProb
	global ClassProb
	
	TrueLabelList = []
	PredLabelList = []
	infile = file(TestDataFile,'r')
	scoreDic = {}
	for sline in infile:
		sline = sline.strip()
		pos = sline.find('#')
		if pos > 0 :
			sline = sline[:pos].strip()
		words = sline.split('\t')
		if len(words) < 1 :
			print "Format error!"
			break
 		classid = int(words[0])
		TrueLabelList.append(classid)
		words = words[1:]
		for classid in ClassProb.keys():
			scoreDic[classid] = math.log(ClassProb[classid])
		for word in words :
			if len(word) < 1 :
				continue
			wid = int(word)
			if wid not in WordDic :
				continue
			for classid in ClassProb.keys() :
				if wid not in ClassFeaProb[classid] :
					scoreDic[classid] += math.log(ClassDefaultProb[classid])
				else :
					scoreDic[classid] += math.log(ClassFeaProb[classid][wid])
		maxProb = max(scoreDic.values())
		for classid in scoreDic.keys() :
			if scoreDic[classid] == maxProb :
				PredLabelList.append(classid)
	infile.close()
	print len(PredLabelList),len(TrueLabelList)
	return TrueLabelList,PredLabelList

def Evaluate(TrueList,PredList) :
	accuracy = 0
	i = 0
	if len(TrueList) <> len(PredList) :
		print 'TrueList is ',len(TrueList),'PredList is ',len(PredList)
		sys.exit(1)
	while i < len(TrueList)  :
		if TrueList[i] == PredList[i] :
			accuracy += 1
		i += 1
	accuracy = (float)(accuracy)/(float)(len(TrueList))
	print 'Accuracy :',accuracy
	



# main 
if len(sys.argv) < 4 :
	print "Usage incorrent, please use it in : \npython NB.python \n[1 trainfile modelfile] or \n[0 testinfile modelfile testoutfile]"
	sys.exit(1)
elif sys.argv[1] == '1' :
	print 'start training:'
	TrainingDataFile = sys.argv[2]
	ModelFile = sys.argv[3]
	LoadData()
	ComputeModel()
	SaveModel()
elif sys.argv[1] == '0' :
	print 'start testing:'
	TestDataFile = sys.argv[2]
	ModelFile = sys.argv[3]
	TestOutFile = sys.argv[4]
	LoadModel()
	TList,PList = Predict()
	outfile = file(TestOutFile,'w')
	i = 0 
	while i < len(TList) :
		outfile.write(str(TList[i]))
		outfile.write(' ')
		outfile.write(str(PList[i]))
		outfile.write('\n')
		i += 1
	outfile.close()
	Evaluate(TList,PList)
elif sys.argv[1] == '2' :
	print 'regular testing:'
	TestDataFile = sys.argv[2]
	ModelFile = sys.argv[3]
	TestOutFile = sys.argv[4]
	LoadModel()
	PList = Predict0()
	outfile = file(TestOutFile,'w')
	for uid,classid in PList.items() :
		outfile.write(uid + '\t' + str(classid) + '\n')
	outfile.close()
else :
	print 'arguments is incorrent.'
	sys.exit(1)
				
