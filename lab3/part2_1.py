#! /usr/bin/env python
# -*- encoding: UTF-8 -*-

"""
  Copyright (c) 2016, Weipeng He <weipeng.he@idiap.ch>

  Lab 3, Part 2, Task 1
"""

import numpy as np
import scipy.io.wavfile as wav
from python_speech_features import mfcc

from sklearn.mixture import GaussianMixture
import matplotlib.pyplot as plt

def experiment(train, test, ncomp):
    """
    do experiment with given training and test sets using the specified 
    number of components.
    train and test is array of array of array feature vectors
    i.e [[[mfcc per frame] per utterance] per person]
    return accuracy at frame level (per person) and utterance level
    """
    # train one model for each person
    models = [GaussianMixture(ncomp).fit(np.concatenate(p)) for p in train]

    # for each model, predict (log) probability of each frame
    prob = [[[np.concatentate((m.score_samples(d)[:,np.newaxis]
                for m in models), axis=1) for u in p] for p in test]

    
    


def main(train, test, kk):
    """main function"""

if __name__ == '__main__':
    main()

