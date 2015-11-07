from __future__ import division
import scipy.io
import numpy as np
import scipy as sp
import sys
import random
from sklearn import svm

allf = scipy.io.loadmat('feature_n/features.mat')
inputs = allf['inputs']
targets = allf['targets']

assert len(inputs)==len(targets)
#percent = 0.75 # default 75% train data

#if len(sys.argv)>1:
#    percent = float(sys.argv[1])

X = np.array(inputs) #np.array([ z[i][0] for i in xrange(train_last_index) ])
Y = np.array([int(i) for i in targets])  #np.array([ int(z[i][1]) for i in xrange(train_last_index) ])

assert len(X)==len(Y)

clf = svm.SVC()
clf.fit(X,Y)

testf = scipy.io.loadmat('feature_n/features_test.mat')
inp = testf['inputs']
tar = np.array([int(i) for i in testf['targets'] ])

total_test = {}
match_test = {}
error = {}
other_match = {}

for i in xrange(9):
    total_test[i]=0
    error[i]=0
    match_test[i]=0
    other_match[i]={}
    for j in xrange(8):
        if i!=j:
            other_match[i][j]=0

pr = clf.predict(inp)            
            
for i in xrange(9):

    index = tar==i
    m = np.sum(tar==i)
    n = np.sum(pr[index]==i)
    print '######'
    print chr(i+ord('A'))," : "
    print "total :",m
    print "matched :",n
    print "efficiency :",round(n*1./m*100,2),"%"

    print "details :"    
    for j in xrange(9):
        tmp = np.sum(pr[index]==j)
        print chr(j+ord('A'))," - ",tmp,"  ",round(tmp/m*100.0,2),"%"  

print 

d = pr-tar
s = np.sum(pr!=tar)
print 'Error percent :',s/len(d)*100