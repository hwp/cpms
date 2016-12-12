function outs=ComputeOutput(ParticleSet,Para)
%
% compute the output. For real values, it computes the mean value of the particles
%  
%
switch Para.exercise
  case {0,1,3,4}
   weightedStates=ParticleSet.states.*repmat(ParticleSet.weights,1,Para.statesize);
   %  HERE, VALID BECAUSE WE ASSUME THAT THE WEIGHTS SUM TO 1
   outs=sum(weightedStates);
   if Para.exercise==4
       if outs(6)>0.5
           outs(6)=1;
       else
           outs(6)=0;
       end
       
   end
   
end
