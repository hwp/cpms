#! /usr/bin/env python
# -*- encoding: UTF-8 -*-

"""
  Copyright (c) 2016, Weipeng He <weipeng.he@idiap.ch>

  Lab 3, Part 2, Task 2
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
    models = [GaussianMixture(ncomp, covariance_type='diag', n_init=20) \
                    .fit(np.concatenate(p)) for p in train]

    # for each model, predict (log) probability of each frame
    prob = [[np.concatenate([m.score_samples(u)[:,np.newaxis]
                for m in models], axis=1) for u in p] for p in test]

    # classify frame by frame
    cls = [np.concatenate([np.argmax(u, axis=1) for u in p], axis=0) for p in prob]

    # evaluate
    acc_frame = [np.mean(p == i) for (i, p) in enumerate(cls)]

    # classify utterance by utterance
    cls = [np.argmax([np.sum(u, axis=0) for u in p], axis=1) for p in prob]

    # evaluate
    acc_utter = [np.mean(p == i) for (i, p) in enumerate(cls)]

    return (acc_frame, acc_utter)


def main(train, test, fs):
    """
    main function
    train, test: raw signal
    fs: sample rate
    """
    # extract mfcc with 16 coefficents:
    # 17 coefficients with first (energy) removed
    train_mfcc = [[mfcc(u, fs, 0.032, 0.01, 17, )[1:] for u in p] for p in train]
    test_mfcc = [[mfcc(u, fs, 0.032, 0.01, 17)[1:] for u in p] for p in test]

    # (c) k = 2
    acc_frame, acc_utter = experiment(train_mfcc, test_mfcc, 2)
    print '==== k = 2, 16 mfcc coef. ===='
    print 'accuracy frame level per person: %s' % acc_frame
    print 'accuracy utterance level per person: %s' % acc_utter

    # (d) plot accuracy vs k = 1,2,3,4
    afs = np.zeros(4)
    aus = np.zeros(4)
    afs[1], aus[1] = np.mean(acc_frame), np.mean(acc_utter)
    acc_frame, acc_utter = experiment(train_mfcc, test_mfcc, 1)
    afs[0], aus[0] = np.mean(acc_frame), np.mean(acc_utter)
    acc_frame, acc_utter = experiment(train_mfcc, test_mfcc, 3)
    afs[2], aus[2] = np.mean(acc_frame), np.mean(acc_utter)
    acc_frame, acc_utter = experiment(train_mfcc, test_mfcc, 4)
    afs[3], aus[3] = np.mean(acc_frame), np.mean(acc_utter)

    print '==== k = [1,2,3,4], 16 mfcc coef. ===='
    print 'avg acc frame level = %s' % afs
    print 'avg acc utterance level = %s' % aus

    # (e) plot accuracy vs # mfcc coef. = 4,8,12,16 (k = 3)
    for i in xrange(4):
        train_mfcc = [[mfcc(u, fs, 0.032, 0.01, i * 4 + 5, )[1:] for u in p] for p in train]
        test_mfcc = [[mfcc(u, fs, 0.032, 0.01, i * 4 + 5)[1:] for u in p] for p in test]
        acc_frame, acc_utter = experiment(train_mfcc, test_mfcc, 3)
        afs[i], aus[i] = np.mean(acc_frame), np.mean(acc_utter)
    print '==== k = 3, [4,8,12,16] mfcc coef. ===='
    print 'avg acc frame level = %s' % afs
    print 'avg acc utterance level = %s' % aus
    
if __name__ == '__main__':
    # load files
    train = [[wav.read('data/DataSet1/train/s%d.wav' % i)[1]] for i in xrange(1, 9)]
    test = [[wav.read('data/DataSet1/test/s%d.wav' % i)[1]] for i in xrange(1, 9)]
    fs, _ = wav.read('data/DataSet1/train/s1.wav') # assume the rest are the same
    main(train, test, fs)

