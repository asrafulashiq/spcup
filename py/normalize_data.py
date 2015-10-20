import numpy as np
import scipy as sp
import scipy.io

grids = ['A','B','C','D','E','F','G','H'];

filename = '../mat/me/features/GridA.mat'

dat = scipy.io.loadmat(filename)

feature_name = [i for i in dat]


