import helper_fun
from helper_fun import *

# get all features

grids = ['A','B','C','D','E','F','G','H','I'];
count = 12

inputs = []
targets = []

for grid in grids:
    
    for i in xrange(1,count):
        filename = '../../mat/me/win_2000/{0}/{0}P{1}.mat'.format(grid,i)
        if os.path.exists(filename):
            
            feat = merge_features(filename)
            length = len(feat)
            tar_num = ord(grid)-ord('A')
            tar = np.array([ tar_num for i in xrange(length) ])
            
            inputs.extend(feat)
            targets.extend(tar)
            
        else:
            print filename,' does not exist'


file_to_save = 'features.mat'
scipy.io.savemat(file_to_save,mdict={'inputs':np.array(inputs),'targets':np.array(targets)})