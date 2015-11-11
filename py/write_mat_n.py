##
#   load .mat files and write the contens to a 
#   .mat file.
#    the files has two fields - 'inputs' and 'targets'  
#   'inputs' is a numpy array of tuples
#   'targets' is from 0 to 7 (for grid 'A' to 'H')

import scipy.io
import numpy as np
import os.path
import re
import random

inputs = []
targets = []

def init():
    inputs = []
    targets = []

def loadMat(file):
    '''
     load matfile named 'file' ..
    '''
    return scipy.io.loadmat(file)

def load_local_features(data,target_value):
    ''' load local features from data '''
    feature_name = []

    # extract the local feature name
    for i in data:
        if not re.match(r'__*',i) and i!='F' :
            if not re.match(r'(global)|(respons)|d\d',i): # skipping global feature
                feature_name.append(i)
    print feature_name
    # normalize 
    
    input  = zip( *[ data[i][0] for i in feature_name ])
    #print input    
    
    target =  [[target_value] for i in xrange(len(input))] 

    inputs.extend(input)
    targets.extend(target)

def write_to_file(filename):
    '''
        write inputs and targets to a filename .mat file
     '''
    #np.savez(filename,inputs,targets)
    scipy.io.savemat(filename, mdict = {'inputs':inputs,'targets':targets} )


grids = ['A','B','C','D','E','F','G','H','I'];
init()

## test and train files

count = 12

feat = dict()

for grid in grids:
    feat[grid]=[]
    for i in xrange(1,count):
        filename = '../mat/me/features2000/{0}{1}.mat'.format(grid,i)
        if os.path.exists(filename):
            feat[grid].append(filename)
        else:
            print filename,' does not exist'
 
percent = .6
train_file = {}
test_file = {}

#for key in feat:
#    train_file[key] = []
#    test_file[key] = []
#    l = feat[key]
#    random.shuffle(l)
#    #print l
#    index = int( len(l)*percent )
#    
#    train_file[key] = l[:index]
#    test_file[key] = l[index:]
 
#test_hour = 1

for key in feat:
    train_file[key] = []
    test_file[key] = []
    l = feat[key]
    random.shuffle(l)
    test_file[key] = [l.pop()]
    train_file[key] = l
#    #print l
#    index = int( len(l)*percent )
#    
#    train_file[key] = l[:index]
#    test_file[key] = l[index:]


    
    
    
for key in train_file:
    filenames = train_file[key]
    #print key
    target = ord(key)-ord('A')
    for filename in filenames:
        if os.path.exists(filename):
            load_local_features(
                loadMat(filename), target
            )
        
file_to_save = 'feature_n/features.mat'
write_to_file(file_to_save)

## save test files 
inputs = []
targets = []
for key in test_file:
    target = ord(key) - ord('A')
    filenames = test_file[key]
    for filename in filenames:
        if os.path.exists(filename):
            load_local_features(
                loadMat(filename), target
            )
    
file_to_save = 'feature_n/features_test.mat'
write_to_file(file_to_save)
