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
    % TO COMPLETE
    % implementation of resampling step 
    % You can use the function sample_hist for that purpose

    
end



