function NewSampleSet=UpdateStep(ParticleSet,Data,Para)
%
% Update the weight of the particle by multiplying with current likelihood
%

switch Para.exercise
  case {0,1}
   % Data = set of position, one position per line 
   NewSampleSet=ParticleSet;
   VarLike=Para.SigLike^2;
   for i=1:Para.Nsamples
      % here: find nearest point to current state position
      position=ParticleSet.states(i,1:2);
      %compute distance to data points
      nbp=size(Data,1);
      diff=Data-repmat(position,nbp,1);
      dist=diag(diff*diff');
      distmin=min(dist(:));
      %
      like=max(Para.Likemin,exp(-0.5*distmin/VarLike));
      %
      NewSampleSet.weights(i)=ParticleSet.weights(i)*like;
   end


  case {3,4}
   NewSampleSet=ParticleSet;
   for i=1:Para.Nsamples
       like=StateLikelihood(Data,ParticleSet.states(i,:)',Para);
       NewSampleSet.weights(i)=ParticleSet.weights(i)*like;
   end
   
end

% nomralize weight so that they sum to 1
norm=sum(NewSampleSet.weights);
NewSampleSet.weights=NewSampleSet.weights/norm;