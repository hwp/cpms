function ParticleSetInit=InitializeParticleSet(ParticleSet,Para)
%
% Intiialize value of state; weights are initialized uniformly
%
% Input:
% - Para.InitState : contains the initial value of the state
%

   initstate=Para.InitState;
   ParticleSetInit=ParticleSet;
   initweight=1/Para.Nsamples; % uniform weight
   for i=1:Para.Nsamples
     ParticleSetInit.states(i,:)=initstate;
     ParticleSetInit.weights(i,:)=initweight;
   end

