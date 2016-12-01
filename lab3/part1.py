#! /usr/bin/env python
# -*- encoding: UTF-8 -*-

"""
  Copyright (c) 2016, Weipeng He <weipeng.he@idiap.ch>

  Lab 3, Part 1
"""

import numpy as np
from sklearn.mixture import GaussianMixture
import matplotlib.pyplot as plt

def fit(ncomp, samples):
    """esitmate gmm model"""
    # init and fit model
    init_prec = np.eye(2)[np.newaxis,:].repeat(ncomp, axis=0) * 4
    est_model = GaussianMixture(ncomp, weights_init=np.ones(ncomp) / ncomp,
                                precisions_init=init_prec)
    est_model.fit(samples)

    print '==== estimated model ===='
    print '# of components = %s' % len(est_model.weights_)
    print 'weights = %s' % est_model.weights_
    print 'means = \n%s' % est_model.means_
    print 'covs = \n%s' % est_model.covariances_
    return est_model

def plot(model, samples):
    """rgb plot scatter of responsiblity values"""
    # compute responsiblity values
    resp = model.predict_proba(samples)

    # plot
    plt.axis('equal')
    plt.scatter(samples[:,0], samples[:,1], c=resp)
    plt.show()

def main():
    """main function"""

    # 2.
    # ground truth model
    weights = [.25, .5, .25]
    means = [(0, 0), (1, 1), (2, 2)]
    cov = np.eye(2)

    # generate samples
    n = 400
    # sample component
    comps = np.random.choice(3, n, p=weights)
    # sample data given component
    samples = [np.random.multivariate_normal(means[c], cov) for c in comps]
    samples = np.array(samples)     # to numpy array

    # 3. estimated model
    est_model = fit(3, samples)

    # 4. plot
    plot(est_model, samples)

    # 5. 
    # K = 2
    fit(2, samples)

    # K = 4
    fit(4, samples)

if __name__ == '__main__':
    main()

