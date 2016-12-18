function NewSampleSet=ProposalStep(ParticleSet,Para)
%
% Draw from the proposal distribution.
% 
% In the current case, we simply use the dynamics
%

   NewSampleSet=ParticleSet;
   % here we apply the dynamics to each sample
   % weights are unchanged 
   for i=1:Para.Nsamples
     old_state=ParticleSet.states(i,:);
     % apply dynamics = brownian motion: x_k = x_{k-1}+ noise
     new_state=Dynamics(old_state,Para);
     NewSampleSet.states(i,:)=new_state;
     NewSampleSet.weights(i,1)=ParticleSet.weights(i,1);
   end


%%-------------------------------------------------
function new_state=Dynamics(old_state,Para)
%
% Generate a new state from the old one by applying the dynamics
%


switch  Para.exercise

  case 0
    new_state=old_state+Para.DynSigma*randn(1,2);

  case 1
    new_state(3:4) = old_state(3:4) + Para.DynSigma*randn(1,2);
    new_state(1:2) = old_state(1:2) + new_state(3:4);

  case 3

  case 4
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
end
