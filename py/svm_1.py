from __future__ import division
import scipy.io
import numpy as np
import scipy as sp
import sys
import random
from sklearn import svm

allf = scipy.io.loadmat('feature_data/features.mat')
inputs = allf['inputs']
targets = allf['targets']

assert len(inputs)==len(targets)
percent = 0.75 # default 75% train data

if len(sys.argv)>1:
    percent = float(sys.argv[1])

z = zip(inputs,targets)
random.shuffle(z)

train_last_index = int( percent * len(z) )

# train inputs
X = np.array([ z[i][0] for i in xrange(train_last_index) ])
Y = np.array([ int(z[i][1]) for i in xrange(train_last_index) ])

assert len(X)==len(Y)

clf = svm.SVC()
clf.fit(X,Y)

test_x = np.array([ z[i][0] for i in xrange( train_last_index,len(z) )  ])
test_y = np.array([ int(z[i][1]) for i in xrange(train_last_index,len(z)) ])

pr = clf.predict(test_x)

d = abs(pr-test_y)

s = sum([1  for i in d if i!=0])

print 'Error percent :',s/len(d)*100

#<<<<<<< HEAD
###




#=======
for i in xrange(9):
    index = test_y==i
    m = np.sum(test_y==i)
    n = np.sum(pr[index]==i)
    print
    print i," : "
    print "total :",m
    print "matched :",n
    print "error :",np.abs(m-n)*1./m*100

    for j in xrange(9):
        if i!=j:
            tmp = np.sum(pr[index]==j)
            print j," - ",tmp
#>>>>>>> recording_test



