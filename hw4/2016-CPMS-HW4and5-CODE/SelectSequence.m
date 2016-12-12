function   Para = SelectSequence(Para_in,Seq)
%
%
%  Select the parameters of the sequence to process
%  
%

Para=Para_in;

% sequence parameters
% files should be in the form of    Para.seqbasenameTime.extension, where Time is 
% encoded with N digits (e.g. time=12, encoded with 5 digits => Time= '00012'


Para.timestep=1;
Para.extension='.jpg';
RootDirectory=['./2016-StudentTrackingData/'];
Para.RootDirectory=RootDirectory;
switch Seq
  case 2
    Para.seqbasename=[RootDirectory './HEAD-SEQUENCES/ste1_'];
    Para.inittime=1;  Para.endtime=307;  % total length = 307
    Para.ndigits=3;    
    
  case 3
    Para.seqbasename=[RootDirectory './HEAD-SEQUENCES/ste2_'];
    Para.inittime=1;  Para.endtime=251;  % total length 
    Para.ndigits=3;    
    
  case 7
    Para.seqbasename=[RootDirectory './SequenceImages7/gesture3-'];
    Para.inittime=40;  Para.endtime=125;  % total length 
    Para.ndigits=6;    
    
  case 8
    Para.seqbasename=[RootDirectory './SequenceImages8/Bubbles-'];
    Para.inittime=4230;  Para.endtime=4598;  % total length 
    Para.ndigits=6;      Para.timestep=2;

  case 9
    Para.seqbasename=[RootDirectory './SequenceImages9/gesture2-'];
    Para.inittime=5400;  Para.endtime=5499;  % total length 
    Para.ndigits=4;      

  case 10
    Para.seqbasename=[RootDirectory './VOT-helicopter/'];
    Para.inittime=1;  Para.endtime=707;  % 
    Para.ndigits=8;       Para.timestep=2;

 end



