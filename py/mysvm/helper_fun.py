from __future__ import  division
import numpy as np
import scipy as sp
import scipy.io
import os


def merge_features(filename):
    '''
        return features in merged array from filename
    '''

    assert os.path.exists(filename),"file %s not exist"%(filename)
    
    all_data = scipy.io.loadmat(filename) # load file
    
    features_name = ['diff_x','AR_coef','mean_x','range','var_x','wav_coef','wavcoef_n'] 
    #features_name = ['diff_x','mean_x','range','var_x']
    win_len = len(all_data['mean_x'][0]) # length of window
    
    list_of_features = [] # array to return
    
    for i in xrange(win_len):
        tmp = []
        
        for feature in features_name:
            if feature=='wav_coef' or feature=='wavcoef_n' or feature=='AR_coef':
                for j in xrange(len(all_data[feature])):
                    tmp.append( all_data[feature][j][i] )
            else:
                tmp.append(all_data[feature][0][i])
                
        list_of_features.append(tmp)
    return list_of_features




