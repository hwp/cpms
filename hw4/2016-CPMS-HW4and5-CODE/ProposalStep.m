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


end
