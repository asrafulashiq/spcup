import numpy as np
import scipy as sp
import scipy.io

filename = 'feature_n/features.mat'

data = scipy.io.loadmat(filename)
inputs = data['inputs']
feature_number = len(inputs[0]) # number of features per vector

norma_val = 10 # normalize value

#max_value = np.zeros(feature_number) # maximum value of ith feature
f_value = np.zeros((feature_number,len(inputs) ))

#n_inputs = np.zeros((len(inputs,feature_number))) # normalize inputs

## find maximum values of each feature
for i in xrange(feature_number):
    max_value = np.max( [ abs(k[i]) for k in inputs ] )
    mean = np.mean([ (k[i]) for k in inputs ])
    weight = np.sqrt( np.var( [ (k[i]) for k in inputs ] ) )#norma_val/max_value # normalize between +- 10
    f_value[i] = np.array([ (k[i]-mean)/weight for k in inputs ])
    
n_inputs = zip( *f_value[:] )
scipy.io.savemat('feature_n/normal_features.mat',mdict={'inputs':n_inputs,'targets':data['targets']})


########
filename = 'feature_n/features_test.mat'

data = scipy.io.loadmat(filename)
inputs = data['inputs']
feature_number = len(inputs[0]) # number of features per vector

norma_val = 10 # normalize value

max_value = np.zeros(feature_number) # maximum value of ith feature
f_value = np.zeros((feature_number,len(inputs) ))

#n_inputs = np.zeros((len(inputs,feature_number))) # normalize inputs

## find maximum values of each feature
for i in xrange(feature_number):
    max_value[i] = np.max( [ abs(k[i]) for k in inputs ] )
    weight = norma_val/max_value[i] # normalize between +- 10
    f_value[i] = np.array([ k[i]*weight for k in inputs ])
    
n_inputs = zip( *f_value[:] )
scipy.io.savemat('feature_n/normal_features_test.mat',mdict={'inputs':n_inputs,'targets':data['targets']})