function outs=DisplayResults(Para,ParticleSet,Data,time)
%
% Display the result (depends on exercise)
%  
%

if Para.Display==1

% for all exercices, display weights
   titretimestep=sprintf('time step %d',time);
   title(titretimestep);
%-----------------------------
   figure(Para.FigureBar);
   bar(ParticleSet.weights);
   title(titretimestep);
%-----------------------------


switch Para.exercise
  case {0,1}
   figure(Para.FigureRes); hold off;
   % display particles
   for i=1:Para.Nsamples
     h=plot(ParticleSet.states(i,1),ParticleSet.states(i,2),'g.');
     hold on;
     set(h,'MarkerSize',max(5,round(ParticleSet.weights(i)*10*Para.Nsamples)));
   end
   % display data 
   nb=size(Data,1);
   for i=1:nb
     plot(Data(i,1),Data(i,2),'r*');
   end
   % display mean 
   plot(Para.outs(1,1),Para.outs(1,2),'bx');
%   a=axis;
%   a=a+[-1 1 -1 1];
%   axis(a);
   axis([-5 50 -5 30]);

   title(titretimestep);
%-----------------------------
   figure(Para.FigureAll); hold on;
   % here assumes there is only one data point
   x=[Data(1,1),Data(1,2)];
   x=[x; Para.outs(1,1),Para.outs(1,2)];
   plot(x(:,1),x(:,2),'b-');
   plot(x(1,1),x(1,2),'r*','MarkerSize',10);
   % display mean
   plot(x(2,1),x(2,2),'bx','MarkerSize',10);

   axis([-5 50 -5 30]);

%   pause(0.25)


  case {3,4}
    tagged_image=DrawObjectLocation(Data,Para.outs(1),Para.outs(2),Para.outs(5),...
                                    Para.Object.halfheight, ...
                                    Para.Object.halfwidth);
    
    if Para.DisplayParticles==1
        np=size(ParticleSet.states,1);
        for p=1:np
            state=ParticleSet.states(p,:)';
            tagged_image=DrawObjectLocation(tagged_image,state(1),state(2),state(5),...
                                            Para.Object.halfheight, ...
                                            Para.Object.halfwidth);
        end
    end
      
    
    if Para.exercise==4
        tagged_image=DrawMotionState(tagged_image, Para.outs(6));
    end
    
    figure(Para.FigureRes);
    image(uint8(tagged_image));


end

end
