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
            if not re.match(r'global*',i): # skipping global feature
                if not re.match(r'(qqq)',i) : 
                #if re.match(r'mean',i) or re.match(r'diff',i) or re.match(r'range',i):
                    feature_name.append(i)
    # normalize 
    
    
    input  = zip( *[ data[i][0] for i in feature_name ])

    target =  [[target_value] for i in xrange(len(input))] 

    inputs.extend(input)
    targets.extend(target)

def write_to_file(filename):
    '''
        write inputs and targets to a filename .mat file
     '''
    #np.savez(filename,inputs,targets)
    scipy.io.savemat(filename, mdict = {'inputs':inputs,'targets':targets} )



def main():
    grids = ['A','B','C','D','E','F','G','H'];
    init()

    for grid in grids:
        #filename = '../feature_data/matfile/{0}/{0}_P{1}.mat'\
        #.format(grid,i)
        filename = '../mat/me/features/Grid{0}.mat'\
            .format(grid)
        if os.path.exists(filename):
            load_local_features(
                loadMat(filename), ord(grid)-ord('A')
            )
    file_to_save = 'feature_data/features.mat'
    write_to_file(file_to_save)

if __name__ == '__main__':
    main()






 