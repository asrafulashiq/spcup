
## helper library
## standard library
from __future__ import  division
import numpy as np
import scipy as sp
import scipy.io
import os


from sklearn import preprocessing,cross_validation,svm,grid_search
from sklearn.grid_search import GridSearchCV

### get inputs and targets

filename = 'features.mat'
allf = scipy.io.loadmat(filename)
inputs = allf['inputs']
targets = allf['targets'][0]


### preprocessing

inputs_scaled = preprocessing.scale(inputs)

### cross validation

#kftotal = cross_validation.KFold(
#        len(inputs),n_folds = 10, shuffle=False
#    )


#print cross_validation.cross_val_score( clf,inputs_scaled,targets, cv = kftotal, n_jobs = 1 )*100


### rbf

#C_range = np.logspace(-2, 10, 13)
#gamma_range = np.logspace(-9, 3, 13)
#param_grid = dict(gamma=gamma_range, C=C_range)

#grid = GridSearchCV(svm.SVC(), param_grid=param_grid, cv=kftotal)



X_train, X_test, y_train, y_test = cross_validation.train_test_split(inputs,targets,test_size=0.4,random_state=0)

scaler = preprocessing.StandardScaler().fit(X_train)
X_train_transformed = scaler.transform(X_train)

X_test_transformed = scaler.transform(X_test)

clf = svm.SVC(kernel='rbf',C=0.4,gamma=2).fit(X_train,y_train)



pr = clf.predict(X_test)
tar = y_test        
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

print clf.score(X_test,y_test)*100









