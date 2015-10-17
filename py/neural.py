##
#   neural network in python
#   made usig pybrain module
#

# standart module
import numpy as np
import scipy as sp
import scipy.io
from matplotlib import pyplot as plt
import pybrain
from pybrain.structure import FeedForwardNetwork
from pybrain.structure import LinearLayer, SigmoidLayer

import sys
import os.path

from pybrain.datasets import ClassificationDataSet
from pybrain.utilities import percentError
from pybrain.tools.shortcuts import buildNetwork
from pybrain.supervised.trainers import BackpropTrainer
from pybrain.structure.modules import SoftmaxLayer
from pybrain.structure import FullConnection


from pylab import ion, ioff, figure, draw, contourf, clf, show, hold, plot
from scipy import diag, arange, meshgrid, where
from numpy.random import multivariate_normal




def load_data(filename):
    """
    load dataset for classification
    """
    assert os.path.exists(filename)==True
    dat = scipy.io.loadmat(filename)
    inputs = dat['inputs']
    #print len(inputs)
    targets = dat['targets']
    #print len(targets)
    assert len(inputs)==len(targets)

    global alldata
    global indim 
    global outdim

    indim = len(inputs[0])
    outdim = 1
    #print indim
    alldata = ClassificationDataSet(indim, outdim, nb_classes = 8)
    alldata.setField('input',inputs)
    alldata.setField('target',targets)

    assert len(alldata['input'])==len(alldata['target'])
    print type(alldata)



 
#filename = sys.argv[1]
filename = '../feature_data/pyfile/features.mat'
load_data(filename)

##### 
#    initializing and splitting data
#####
## divide training and testing data
proportion  = 0.25
tstdata_temp, trndata_temp = alldata.splitWithProportion(proportion)

## this is for some bugs in pybrain
tstdata = ClassificationDataSet(indim, outdim, nb_classes=8)
for n in xrange(0, tstdata_temp.getLength()):
    tstdata.addSample(
        tstdata_temp.getSample(n)[0], tstdata_temp.getSample(n)[1])

trndata = ClassificationDataSet(indim, outdim, nb_classes=8)
for n in xrange(0, trndata_temp.getLength()):
    trndata.addSample(
        trndata_temp.getSample(n)[0], trndata_temp.getSample(n)[1])

print type(trndata)
trndata._convertToOneOfMany()
tstdata._convertToOneOfMany()

print "Number of training patterns: ", len(trndata)
print "Input and output dimensions: ", trndata.indim, trndata.outdim
print "First sample (input, target, class):"
print trndata['input'][0], trndata['target'][0], trndata['class'][0]

#####
#    build the network
#####

n = FeedForwardNetwork()
inLayer = LinearLayer(indim)
hiddenLayer = SigmoidLayer(indim*2)
outLayer = LinearLayer(outdim)

n.addInputModule(inLayer)
n.addModule(hiddenLayer)
n.addOutputModule(outLayer)

in_to_hidden = FullConnection(inLayer, hiddenLayer)
hidden_to_out = FullConnection(hiddenLayer, outLayer)

n.addConnection(in_to_hidden)
n.addConnection(hidden_to_out)

n.sortModules()
print n


n.activate( alldata['input'][0] )

in_to_hidden.params

hidden_to_out.params

fnn = buildNetwork(trndata.indim, 3, trndata.outdim, outclass=SoftmaxLayer)

trainer = BackpropTrainer(
    fnn, dataset=trndata, momentum=0.1, verbose=True, weightdecay=0.01)

'''
ticks = arange(-3., 6., 0.2)
X, Y = meshgrid(ticks, ticks)
# need column vectors in dataset, not arrays
griddata = ClassificationDataSet(2, 1, nb_classes=3)
for i in xrange(X.size):
    griddata.addSample([X.ravel()[i], Y.ravel()[i]], [0])
# this is still needed to make the fnn feel comfy
griddata._convertToOneOfMany()
'''


for i in range(20):
    trainer.trainEpochs(1)
    trnresult = percentError(trainer.testOnClassData(),
                             trndata['class'])
    tstresult = percentError(trainer.testOnClassData(
        dataset=tstdata), tstdata['class'])

    print "epoch: %4d" % trainer.totalepochs, \
          "  train error: %5.2f%%" % trnresult, \
          "  test error: %5.2f%%" % tstresult

    '''out = fnn.activateOnDataset(griddata)
    out = out.argmax(axis=1)  # the highest output activation gives the class
    out = out.reshape(X.shape)
    figure(1)
    ioff()  # interactive graphics off
    clf()   # clear the plot
    hold(True)  # overplot on
    for c in [0, 1, 2]:
        here, _ = where(tstdata['class'] == c)
        plot(tstdata['input'][here, 0], tstdata['input'][here, 1], 'o')
    if out.max() != out.min():  # safety check against flat field
        contourf(X, Y, out)   # plot the contour
    ion()   # interactive graphics on
    draw()  # update the plot
'''



#if __name__ == '__main__':
 #   main()