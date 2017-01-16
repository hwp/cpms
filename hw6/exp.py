#! /usr/bin/env python
# -*- encoding: UTF-8 -*-

"""
  Copyright (c) 2016, Weipeng He <weipeng.he@idiap.ch>

  CPMS, homework 6
"""


import numpy as np
from scipy.io import loadmat
from hmmlearn import hmm
from sklearn import cluster 
from sklearn.metrics import confusion_matrix, accuracy_score
import itertools
import matplotlib.pyplot as plt

import sys

def select_feature(seq):
    #return seq
    return seq[:, range(0, 8)]

def train_erg(seqs):
    # select features
    seqs = [select_feature(s) for s in seqs]
    
    # convert to hmmlearn formats
    feats = np.concatenate(seqs)
    lengths = [s.shape[0] for s in seqs]

    # model = hmm.GaussianHMM(n_components=2, covariance_type='diag').fit(feats, lengths) 
    model = hmm.GMMHMM(n_components=3, n_mix=3, covariance_type='diag', min_covar=1e-6, verbose=False).fit(feats, lengths) 

    return model

def predict_con(seq, models):
    seq = select_feature(seq)

    max_prob = -float('inf')
    for c, m in models.items():
        prob = m.score(seq)
        if prob > max_prob:
            max_prob = prob
            p = c

    return p

def train_lr(seqs):
    # select features
    seqs = [select_feature(s) for s in seqs]
    
    # convert to hmmlearn formats
    feats = np.concatenate(seqs)
    lengths = [s.shape[0] for s in seqs]

    nc = 9
    nm = 3

    t = np.diag(np.ones(nc)) * .9
    t[:-1, 1:] += np.diag(np.ones(nc - 1)) * .1
    t[-1, -1] = 1
    s = np.zeros(nc)
    s[0] = 1.0

    # model = hmm.GaussianHMM(n_components=2, covariance_type='diag').fit(feats, lengths) 
    model = hmm.GMMHMM(n_components=nc, n_mix=nm, covariance_type='diag',
                       min_covar=1e-6, init_params="mcw", params="tmcw", verbose=False)
    model.startprob_ = s
    model.transmat_ = t
    model.fit(feats, lengths) 

    return model

def train_all(feats_per_cls):
    train_sgl = train_erg
    return {c : train_sgl(f) for c, f in feats_per_cls.items()}

def train_dis(seqs, code_book):
    # select features
    seqs = [select_feature(s) for s in seqs]

    feats = code_book.predict(np.concatenate(seqs))
    lengths = [s.shape[0] for s in seqs]

    # compact set of symbols
    code_map = {s : i for i, s in enumerate(np.unique(feats))}
    centers = code_book.cluster_centers_
    for o in range(len(centers)):
        if o not in code_map.keys():
            mindis = float('inf')
            for q in code_map.keys():
                dis = np.linalg.norm(centers[o] - centers[q])
                if dis < mindis:
                    mindis = dis
                    m = q
            code_map[o] = code_map[m]
    print code_map
    feats = np.vectorize(lambda s: code_map[s])(feats)[:, np.newaxis]
    model = hmm.MultinomialHMM(n_components = 3).fit(feats, lengths)

    return (code_book, code_map, model)

def predict_dis(seq, models):
    seq = select_feature(seq)

    max_prob = -float('inf')
    for c, (b, cm, m) in models.items():
        s = np.vectorize(lambda s: cm[s])(b.predict(seq))[:, np.newaxis]
        prob = m.score(s)
        if prob > max_prob:
            max_prob = prob
            p = c

    return p

def train_all_dis(feats_per_cls):
    # select features
    seqs = np.concatenate([select_feature(s) for f in feats_per_cls.values() for s in f])
    
    # vector quantization
    code_book = cluster.KMeans(10).fit(seqs)

    return {c : train_dis(f, code_book) for c, f in feats_per_cls.items()}

train = train_all_dis
predict = predict_dis

def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    print(cm)

    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, cm[i, j],
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    plt.show()

if __name__ == '__main__':
    # load data
    #   class labels
    cls = loadmat('data/cls.mat')['cls']
    idx = np.unique(cls)

    #   subjects labels
    sbj = loadmat('data/sbj.mat')['sbj']

    #   load feature vectors
    feats = [loadmat('data/feat_%d.mat' % (i + 1))['feat'].T for i in xrange(len(cls))]

    #   remove first 30 frames
    feats = [f[30:, :] for f in feats]

    #   zip
    data = zip(cls, sbj, feats)

    # leave-one-subject-out cross validate
    labels = []
    for s in np.unique(sbj):
        train_data = [(c, f) for c, t, f in data if t != s]
        test_data = [(c, f) for c, t, f in data if t == s]

        # feature for each class, a dict as {class : list of feature vectors}
        feats_per_cls = {c : [f for d, f in train_data if d == c] for c in idx}

        # train models
        models = train(feats_per_cls)

        # test
        l = [(c, predict(f, models)) for c, f in test_data]
        labels = labels + l

        sys.stdout.write('\r%d/%d samples tested' % (len(labels), len(data)))
        sys.stdout.flush()
    print

    y_true = [c for c, p in labels]
    y_pred = [p for c, p in labels]

    #print classification_report(y_true, y_pred, idx)
    print accuracy_score(y_true, y_pred)
    cm = confusion_matrix(y_true, y_pred, idx)
    plot_confusion_matrix(cm, idx)

