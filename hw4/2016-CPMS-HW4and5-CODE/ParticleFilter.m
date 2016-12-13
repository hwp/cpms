
clear all;
close all;

Para.exercise=0;
Para.resampling=1;    % 0: No resampling of the particles - 1: Resampling
Para.Display=1;

Para.DisplayLikelihoodMap=0;
Para.DisplayLikelihoodMapStep=10;

% definition of the state
%   and parameters specific to an exercice
switch Para.exercise
  case 0
   Para.statesize=2; % for x and for y position
   Para.InitState=[3 3];  % initial position
  case 1  % for x and for y position and speed (use same
          % initialization as case 0 for position
   Para.statesize=4;
   Para.InitState=[3 3 0 0];

  case 3  % for x (column) and for y (line) position and speed,
          % plus scale (last parameter)
          % Initial position will be define through a guy, see
          % later



  case 4 % case 3, but with an additional parameter, indicating the
         % type of dynamics (0 = previous position + noise; 1 =
         % using the speed information)

end

switch Para.exercise
  case {0, 1}
   Para.DynSigma=1.0;    % noise in dynamics
   Para.Likemin=1e-20;   % minimum likelihood for a particle
   Para.SigLike=1.0;       % variance of measurement noise in likelihood model
   Para.inittime=1;      % first time step
   Para.endtime=40;      % las time step
   Para.Ntimes=Para.endtime;
   %   A=load('CleanData.mat');
   % A=load('NoiseData05.mat');
   A=load('NoiseMultiple.mat');
   Para.DataPts=A.DataPts;
   % display the trajectory of the measurements
   DisplayMeasurementSequence(Para);

   % for output display
   Para.FigureRes=figure;
   p=get(gcf,'position');
   % for weight display
   Para.FigureBar=figure;
   set(gcf,'Position',[p(1)+p(3),p(2),p(3),p(4)]);
   % To display the data and filter output since beginning
   Para.FigureAll=figure;
   set(gcf,'Position',[p(1),p(2)-p(4),p(3),p(4)]);

  case {3,4}
   Para.DynSigma=2.;     % noise in dynamics (for location>/spee)
   Para.ChangeDyn=0.2;  % proba of changing dynamics (ct location =0
                        % or ct speed = 1), for case 4
   Para.DynSigmaScale=0.01; % noise in dynamics (for scale)
   Para.Likemin=1e-30;  % minimum likelihood for a particle
   Para.lambdah=20;    % coefficient of Bhattacharyya distance

   Para.DisplayParticles=1;          % Display all particles in the image
   Para.DisplayLikelihoodMap=1;      % show likelihood map (for every position)
   Para.DisplayLikelihoodMapStep=20;  % As this is expensive, only
                                     % compute every x steps

   Seq=2;
   Para=SelectSequence(Para,Seq);

   [Para.ImageList,Para.TimeInstants]=GetFileList(Para.seqbasename,Para.ndigits,Para.extension,Para.inittime,Para.endtime,Para.timestep);
   %
   Para.Ntimes=size(Para.TimeInstants,1);

   % GETIING INITIALISATION and OBJECT MODEL (Histogram)
   % Number of bins per dimension for the Histograms
   Para.hist_bins_number=8;

   %initial location is given as [colnum rownum] of box center point
   [hist_model,location_init,halfheight,halfwidth]=InitTracker(Para.ImageList(1,:),Para.hist_bins_number);

   Object.hist_model=hist_model;
   Object.halfheight=halfheight;
   Object.halfwidth=halfwidth;
   Para.Object=Object;
   % DEFINE HERE THE INITIAL STATE (see InitTracker)
   if Para.exercise==3
       Para.InitState=[location_init(1) location_init(2) 0 0 1];  % initial state (scale=1)
   else
       Para.InitState=[location_init(1) location_init(2) 0 0 1 0];  % initial state (scale=1)
   end

   % for displaying average result
   Para.FigureRes=figure;
   % for weight display
   Para.FigureBar=figure;
   title('Particle weight');
   % For likelihood map
   if Para.DisplayLikelihoodMap>0
       Para.FigureLikelihood=figure;
       title('likelihood map for the average size');
   end

end

pause(.5);

Para.Nsamples=50;
Para.StateOutput=[];

% definition of the particle set
ParticleSet.states=zeros(Para.Nsamples,Para.statesize);
ParticleSet.weights=zeros(Para.Nsamples,1);


% Initialization of particle set
ParticleSet=InitializeParticleSet(ParticleSet,Para);

%
for time=1:Para.Ntimes
    time

    %% Proposal step:
    %  we use the boostrap filter, so we
    %    apply dynamics to all samples
    ParticleSet=ProposalStep(ParticleSet,Para);

    %% Read the data for time time
    Data=ReadData(time,Para);

    %% Update Step: compute particle weight
    ParticleSet=UpdateStep(ParticleSet,Data,Para);

    %% Compute Ouput (Average of particle set)
    Para.outs=ComputeOutput(ParticleSet,Para);
    Para.StateOutput=[Para.StateOutput;Para.outs];

    %% DisplayResults
    if Para.Display
        DisplayResults(Para,ParticleSet,Data,time);
    end

    %% Display LikelihoodMap at every position for average window
    %% (only for exercise 3 & 4)
    if Para.Display
        if and(Para.DisplayLikelihoodMap>0,mod(time,Para.DisplayLikelihoodMapStep)==0)
            AverageScale=Para.outs(5);
            ImageLike=LikelihoodMap(Data,Para,AverageScale);
            figure(Para.FigureLikelihood);
            image(uint8(ImageLike));
            title(['likelihood map for the average size' time]);
        end
    end

    %% Resample the particles
    %[ParticleSet.weights ParticleSet.states]
    ParticleSet=ResampleStep(ParticleSet,Para);
    %[ParticleSet.weights ParticleSet.states]

    if Para.Display
        pause(0.01)
    end
end


switch Para.exercise
  case {3,4}
  % Generate Ouput Movie
  tracking_movie=TrackingMovie(Para.ImageList,Para.StateOutput,Para);
  movieview(tracking_movie);
end
