CPMS, Homework 5
================

-- *Weipeng He*

(a)
---

Code segment for state initialization::

    Para.statesize = 6;
    Para.InitState = [0 0 0 0 1 0];

Code segment for dynamical model (ProposalStep.m)::

  if Para.ChangeDyn > rand
    a = 1 - old_state(6);
  else
    a = old_state(6);
  end

  if a == 0
    u = 0;
    v = 0;
    x = old_state(1) + Para.DynSigma * randn;
    y = old_state(2) + Para.DynSigma * randn;
  else
    u = old_state(3) + Para.DynSigma * randn;
    v = old_state(4) + Para.DynSigma * randn;
    x = old_state(1) + u;
    y = old_state(2) + v;
  end

  s = old_state(5) + Para.DynSigmaScale * randn;
  new_state = [x y u v s a];

Code segment for computing bounding box::

  BBox.c1 = max(min(floor(mycol - hwidth * scale), ncol), 1);
  BBox.c2 = max(min(ceil(mycol + hwidth * scale), ncol), 1);
  BBox.r1 = max(min(floor(myrow - hheight * scale), nrow), 1);
  BBox.r2 = max(min(ceil(myrow + hheight * scale), nrow), 1);

  Surface = (BBox.c2 - BBox.c1 + 1) * (BBox.r2 - BBox.r1 + 1);

Code segment for the likelihood function::

  [box Surface] = BoundingBox(State(1), State(2), State(5), 
      Para.Object.halfheight, Para.Object.halfwidth, ncol, nrow);

  if Surface > 100
    % Extract Histogram in Bounding Box region
    obsv = ColorHistogram(Data(box.r1:box.r2, box.c1:box.c2,:),
                          Para.hist_bins_number);      
    % Compute weight
    like = exp(-Para.lambdah * SquareBattacharya(obsv, Para.Object.hist_model));
    like = max(like, Para.Likemin);
  else
    like=0.1*Para.Likemin;
  end

(b)
---

I observe that with the original parameters the estimate does not follow up with the change of the object. Thus, I choose to increase the noise dynamics. I select: 

.. math::
  
  \sigma_{\mathbf{x}} = 4

.. math::
  
  \sigma_{s} = 0.1

I choose to have 50 particles. This is a trade-off between performance and efficiency.  

I choose the probability of switching dynamics to be 0.2, which I don't observe significant change of performance by changing this.

And for the observation likelihood, I choose:

.. math::
  
  \lambda_{h} = 20

The 'lambda_h' is very small, the likelihood will be more evenly spread over the whole image. And as the result, the tracking will not precisely follow the object. Whereas when 'lambda_h' is very large (50), the likelihood will be very concentrated which will limit the search area. 

For head sequence 1 (ste1), there are two persons in the video. Tracking only face is in general worse than tracking face and shirt. The issues are:

* Both persons have similar skin color (similar histogram). When the woman move near the men, the track will be distracted.
* The face image histogram mostly consists of the skin color, and the tracker favors small bounding box (within the face) for higher likelihood. The result does not cover the whole face.

The issues above can be solved by tracking both face and shirt.

For head sequence 2 (ste2), there is only one person. The tracker performs better for this sequence.

In the third dataset (bubbles), the whole scene is dark and foreground and background have similar color. It is hard to track in such scene due to the fact that:

* The color histogram is very sensitive to lighting condition. The color model of object is constructed at the first frame and will be fixed during the whole sequence. We can observe that the girl in the back will come from dark to bright place. Its color histogram will change significantly and the observation likelihood will be inaccurate.
* The color model does not model the position of object parts (face and shirt). Sometimes, it tracks the trousers with shirt other than face.

(c)
---

In general the tracking performance is good for helicopter sequence. It is because the helicopter is mainly red and white, which make the helicopter quite distinct from other objects in the image.

When the dynamics are very large, the proposals are located in a very large area. Most of the proposed states are very unlikely, thus reducing the efficiency of tracking.

(d)
---

The tracking of hands requires very fine tuning of the parameters. It is not easy, due to the fact that:

* The movement is very fast. Especially that the hand starts and stops very sudden.
* The face, neck and the other hand have identical color histogram, making them very likely to distract.

Possible improvements that can be done:

* Learn better, more precise dynamic model that describes how hand moves when performing sign languages. 
* Design better observation likelihood estimate. For instance, use hand detection or use multi-part color model.
* Improve data quality by increase fps and resolution.

