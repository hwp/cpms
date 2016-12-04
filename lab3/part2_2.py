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

def experiment(train, test, ncomp, models=None, ncoef=None):
    """
    do experiment with given training and test sets using the specified
    number of components.
    train and test is array of array of array feature vectors
    i.e [[[mfcc per frame] per utterance] per person]
    return accuracy at frame level (per person) and utterance level
    """
    # use first ncoef number of coefficients
    if ncoef is not None:
        train = [p[:,:ncoef] for p in train]
        test = [[u[:,:ncoef] for u in p] for p in test]

    # train one model for each person
    if models is None:
        models = [GaussianMixture(ncomp, covariance_type='diag',
                                  n_init=10).fit(p) for p in train]

    # for each model, predict (log) probability of each frame
    prob = [[np.concatenate([m.score_samples(u)[:,np.newaxis]
                for m in models], axis=1) for u in p] for p in test]

    # classify utterance by utterance
    cls = [np.argmax([np.sum(u, axis=0) for u in p], axis=1) for p in prob]

    # evaluate
    return [np.mean(p == i) for (i, p) in enumerate(cls)], models

def main(train_head, train_head_seg, test_head, test_head_seg, test_arr, test_arr_seg, fs):
    """
    main function
    train_head, train_head_seg: raw data and segmentation labels
    test_head, test_head_seg: raw data and segmentation labels
    test_arr, test_arr_seg: raw data and segmentation labels
    fs: sample rate
    """
    # extract mfcc with 16 coefficents:
    # 17 coefficients with first (energy) removed
    train_mfcc = [mfcc(u, fs, 0.032, 0.01, 21)[:,1:] for u in train_head]

    # filter with segmentation
    train_mfcc = [t[train_head_seg[:len(t), i] == 1] for i, t in enumerate(train_mfcc)]

    # test head
    test_mfcc = [mfcc(u, fs, 0.032, 0.01, 21)[:,1:] for u in test_head]
    test_mfcc = [t[test_head_seg[:len(t), i] == 1] for i, t in enumerate(test_mfcc)]

    # test array
    arr_mfcc = mfcc(test_arr, fs, 0.032, 0.01, 21)[:,1:]
    arr_mfcc = [arr_mfcc[test_head_seg[:len(arr_mfcc), i] == 1] for i in xrange(len(train_head))]

    # (a)
    print '==== k=16, 20 mfcc coef. ===='

    # frame level
    acc, models = experiment(
            train_mfcc, [np.array_split(p, len(p)) for p in test_mfcc], 16)
    print 'head acc frame level = %s' % acc
    acc, _ = experiment(
            train_mfcc, [np.array_split(p, len(p)) for p in arr_mfcc], 16, models)
    print 'array acc frame level = %s' % acc

    # (20 frames) level
    acc, _ = experiment(
            train_mfcc, [np.array_split(p, len(p) / 20) for p in test_mfcc], 16, models)
    print 'head acc 20-frame level = %s' % acc
    acc, _ = experiment(
            train_mfcc, [np.array_split(p, len(p) / 20) for p in arr_mfcc], 16, models)
    print 'array acc 20-frame level = %s' % acc

    # file level
    acc, _ = experiment(
            train_mfcc, [np.array_split(p, 1) for p in test_mfcc], 16, models)
    print 'head acc file level = %s' % acc
    acc, _ = experiment(
            train_mfcc, [np.array_split(p, 1) for p in arr_mfcc], 16, models)
    print 'array acc file level = %s' % acc

    # (b)
    # change # of components
    print '==== k=1~16, 20 mfcc coef. ===='
    acc_head = np.zeros(16)
    acc_arr = np.zeros(16)
    for k in xrange(1,17):
        acc, models = experiment(
                train_mfcc, [np.array_split(p, 1) for p in test_mfcc], k)
        acc_head[k-1] = np.mean(acc)
        acc, _ = experiment(
                train_mfcc, [np.array_split(p, 1) for p in arr_mfcc], k, models)
        acc_arr[k-1] = np.mean(acc)
    print 'avg head acc file level = %s' % acc_head
    print 'avg array acc file level = %s' % acc_arr

    plt.figure(1)
    plt.xlabel('Number of mixture components')
    plt.ylabel('Average accuracy (file level)')
    plt.ylim(0, 1)
    plt.plot(np.arange(1,17), acc_head, label='head')
    plt.plot(np.arange(1,17), acc_arr, label='array')
    plt.legend(loc='lower right')
    plt.show()

    # (c)
    # change # of mfcc coefficients
    print '==== k=16, [4,8,12,16,20] mfcc coef. ===='
    acc_head = np.zeros(5)
    acc_arr = np.zeros(5)
    for n in [4, 8, 12, 16, 20]:
        acc, models = experiment(
                train_mfcc, [np.array_split(p, 1) for p in test_mfcc], 16, ncoef=n)
        acc_head[n/4-1] = np.mean(acc)
        acc, _ = experiment(
                train_mfcc, [np.array_split(p, 1) for p in arr_mfcc], 16, models, n)
        acc_arr[n/4-1] = np.mean(acc)
    print 'avg head acc file level = %s' % acc_head
    print 'avg array acc file level = %s' % acc_arr

    plt.figure(2)
    plt.xlabel('Number of MFCC coefficients')
    plt.ylabel('Average accuracy (file level)')
    plt.ylim(0, 1)
    plt.plot(np.arange(4, 21, 4), acc_head, label='head')
    plt.plot(np.arange(4, 21, 4), acc_arr, label='array')
    plt.legend(loc='lower right')
    plt.show()

if __name__ == '__main__':
    # load files
    train_head = [wav.read('data/DataSet2/AMItrainHead/H%d.wav' % i)[1]
                    for i in xrange(1, 5)]
    train_head_seg = np.loadtxt('data/DataSet2/AMItrainHead/SpeechSegmentation_train_100.txt',
                                dtype=int)
    test_head = [wav.read('data/DataSet2/AMItestHead/H%d.wav' % i)[1]
                    for i in xrange(1, 5)]
    test_head_seg = np.loadtxt('data/DataSet2/AMItestHead/SpeechSegmentation_test_100.txt',
                               dtype=int)
    fs, test_arr = wav.read('data/DataSet2/AMItestArray/Array.wav')
    test_arr_seg = np.loadtxt('data/DataSet2/AMItestArray/SpeechSegmentation_test_100.txt',
                              dtype=int)
    fs, _ = wav.read('data/DataSet2/AMItrainHead/H1.wav') # assume the rest are the same
    main(train_head, train_head_seg, test_head, test_head_seg, test_arr, test_arr_seg, fs)

