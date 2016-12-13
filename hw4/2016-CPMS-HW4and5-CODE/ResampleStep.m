function NewSampleSet=ResampleStep(ParticleSet,Para)
%
%  Resample particles to avoid impoverishment
%  
%  Independent of exercise


% To recopy and have the same memory size
% When no resampling is done, this is the only operation to perform
NewSampleSet=ParticleSet;


% when Para.resampling==0, new samples are just the old samples 
%  (cf line above)
if Para.resampling
    % implementation of resampling step 
    % You can use the function sample_hist for that purpose
    idx = sample_hist(ParticleSet.weights, Para.Nsamples);
    NewSampleSet.states = ParticleSet.states(idx, :);
    NewSampleSet.weights(:) = 1.0 / Para.Nsamples; 
end

