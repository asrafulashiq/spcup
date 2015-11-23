import helper_fun
from helper_audio import *

# get all features

grids = ['A','B','C','D','E','F','G','H','I'];
#count = 2

inputs = []
targets = []

for grid in grids:
    
    filename = '../../mat/me/audio_features/{0}.mat'.format(grid)
    if os.path.exists(filename):
            
        feat = merge_features(filename)
        length = len(feat)
        tar_num = ord(grid)-ord('A')
        tar = np.array([ tar_num for i in xrange(length) ])
            
        inputs.extend(feat)
        targets.extend(tar)
            
    else:
        print filename,' does not exist'


file_to_save = 'audio_features.mat'
scipy.io.savemat(file_to_save,mdict={'inputs':np.array(inputs),'targets':np.array(targets)})