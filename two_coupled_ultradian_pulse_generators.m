function rhythms
% This program is for generating figures for the talk
% by Alexander N. Churilov and John G. Milton
% "An Integrate-and-fire Mechanism for Modeling Rhythmicity 
% in the Neuroendocrine System"
% presented at the international conference "Big Brain 2022",
% Fudan University, Shanghai, China, November/December 2022.
% Conference proceedings
% to be published by De Gruyter.
%
% There are two pulse generators based on integrate-and-fire (IAF) 
% mechanism - one located in the hypothalamus,
% the other in the pituitary gland
% The target is a periphery gland.
% 
% 
clc
clear all
% system parameters
global alpha1 alpha2 alpha3 k1 k2 k3
global mu1 mu2 U0 V0 I01 I02
global Delta1 Delta2

% hypothalamic pulse generator parameters

alpha1 = 0.17; % Decay coefficient (4 min half-life)
k1=3;          % Secretory gain 
mu1=0.005;     % IAF leakage coefficient
Delta1=60;     % IAF firing threshold
I01=0.001;     % IAF constant input
U0=400;        % IAF putential constant component


% pituitary pulse generator parameters

alpha2 = 0.15; % Decay coefficient (6 min half-life)
k2=100;        % Secretory gain
mu2=0.005;     % IAF leakage coefficient
Delta2=180;    % IAF firing threshold
I02=0.001;     % IAF constant input
V0=400;        % IAF potential constant component

% target gland hormonal release

alpha3 = 0.05; % Decay coefficient (15 min half-life)
k3 = 0.1;      % Secretory gain

%%%%%%%%%%%%%%%%%%%%%
% Simulation time (min)
tfin = 1440;
% Note: there are 1440 minutes in a day

% Preliminary initial values (the first three components may be chaged)
x0 =[0 0 0 0 0];  
% Preliminary integration at an extended time interval
np = 2;      % extention of the integration interval - may be changed
[tt,yy,tte,tte1,tte2,yye] = integ(tfin*np,x0);
ne = length(tte);
if ne == 0
  fprintf('\n No impulses detected\n');
  pause;
  return;
end
%
% Final integration
% Comment: If the initial point is taken arbitrarily (e,g,zero)
% in most cases the time series will 
% contain the transient and  the steady rhythm. 
% We shift the initial point to omit the transients
%
% the shift for ns impulses to skip the transient
ns = round((np - 1)*ne/np);
ns = ns - 1;          % may be adjusted 
xf0 = yye(ns,:);      % new initial point (the right-sided limit)
if xf0(4) == Delta1
   xf0(4) = 0;
end
if xf0(5) == Delta2
   xf0(5) = 0;
end
[tt,yy,tte,tte1,tte2,yye] = integ(tfin+60,xf0); % the new integration

[T1,T2] = interpulse(tte1,tte2);
fprintf('\n Interpulse intervals\n');
T1      % for hypothalamic impulses
T2      % for pituitary impulses

plot3h(tt,yy);  % plotting time series
fprintf('\n');
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% functions %%%%%%%%%%%%%%%%%%

function [tt,xx,tte,tte1,tte2,xxe] = integ(tfin,x0)
% Integration of the impulsive equations
% Output parameters:
% tt - array of times, 0<=t<=tfin
% xx - values of x(t) at tt times
% tte - joint array of impulse times (tte1 and tte2)
% tte1 - times of hypothalamic impulses
% tte2 - times of pituitary impulses
% xxe - values of x(t) (left-sided limits) at impulse times
T = tfin;
x0(4) = 0;     
x0(5) = 0;
tte1 = [];
tte2 = [];
opts=ddeset('RelTol',1e-5,'AbsTol',1e-8,'Events',@event);
% Integration until the first event (if any)
np = 3;
[t,x,te,xe,ie] = ode45(@odex1f,[0, T*np],x0,opts);
tt = t;
xx = x;
tte = te;
xxe = xe;
u = x(end,:);
ne = length(ie);
% if hypothalamic event occurs
% Note: two events may occur simultaneously (ne == 2)
if (ne > 0 && ie(1) == 1) || (ne > 1 && ie(2) == 1)
    tte1 = [tte1; te];
    u(4) = 0;
end
% if pituitary event occurs
if (ne > 0 && ie(1) == 2) || (ne > 1 && ie(2) == 2)
    tte2 = [tte2; te];
    u(5) = 0;
end
% Integration until tfin, recording all the rest events
while t(end) < tfin
   T = min(t(end)+100000,tfin); % new period
   opts=ddeset('RelTol',1e-5,'AbsTol',1e-8,'Events',@event);
   [t,x,te,xe,ie] = ode45(@odex1f,[t(end), T],u,opts);
   tt = [tt; t];
   xx = [xx; x];
   tte = [tte; te];
   xxe = [xxe; xe];
   ne = length(ie);
   u = x(end,:); 
   if (ne > 0 && ie(1) == 1) || (ne > 1 && ie(2) == 1)
      u(4) = 0;   % membrane potensial reset
      tte1 = [tte1; te];
   end                                
   if (ne > 0 && ie(1) == 2) || (ne > 1 && ie(2) == 2)
      u(5) = 0;   % membrane potential reset
      tte2 = [tte2; te];
   end                              
end
% ------------------------------------------------------------------------
function [T1,T2] = interpulse(tte1,tte2)
% Interpulse intervals 
% T1 - intervals between hypothalamic impulses 
% T2 - impulses between pituitary impulses
ne1 = length(tte1);
T1 = [];
for i = 1:ne1-1
  T1(i) = tte1(i+1) - tte1(i);
end
ne2 = length(tte2);
T2 = [];
for i = 1:ne2-1
  T2(i) = tte2(i+1) - tte2(i);
end
%----------------------------------------------------------------------

function plot3h(tt,yy)
% Plotting time series (3 hormons in 3 figures)
figure;
subplot(3,1,1);
plot(tt,yy(:,1),'k','LineWidth',1.5);
ylabel('x');
title('hypothalamic pulse generator')
subplot(3,1,2);
plot(tt,yy(:,2),'k','LineWidth',1.5);
ylabel('y');
title('pituitary gland pulse generator')
subplot(3,1,3);
plot(tt,yy(:,3),'k','LineWidth',1.5);
ylabel('z');
title('target gland hormonal release')
xlabel('time (min)');

function dydt = odex1f(t,y)
% Differential equations: right-hand sides
global alpha1 alpha2 alpha3 k1 k2 k3 mu1 mu2 U0 V0 I01 I02
dydt=zeros(5,1);
% y(1) - concentration of the hypothalamic hormone
% y(2) - concentration of the pituitary hormone
% y(3) - concentration of the target gland hormone
% y(4) - membrane potential in the hypothalamus
% y(5) - membrane potential in the pituitary
%
% Hypothalamus dynamics
F1 = Fu(y(4));
I1 = (1+H(t)) * L1(y(3)); 
%I1 = L1(y(3));  % Liasoned circadian input
%I1 = 0;         % Isolated hypothalamus
dydt(1) = - alpha1 * y(1) + F1 *k1* (I1 + I01);
dydt(4) =  - mu1 * (y(4) - U0) +  I1;
%
% Pituitary dynamics
F2 = Fv(y(5));
I2 =  y(1) * L2(y(3));
%I2 = 0;        % Isolated pituitary
dydt(2) = - alpha2 * y(2) + F2 * k2*(I2 + I02);
dydt(5) =  - mu2 * (y(5) - V0) +  I2;
%
% Target gland dynamics
dydt(3) = - alpha3 * y(3) + k3 * y(2);

%---------------------------------------------------------------
function u = Fu(x)
% Shaping function for hypothalamic pulses
ku = 0.1;
u = ku*x*exp(-ku.*x + 1);
%-----------------------------------------------------------

function u = Fv(x)
% Shaping function for pituitary pulses
kv = 0.01;
u = kv*x*exp(-kv.*x + 1);
%-----------------------------------------------------------

function u = H(t)
% Circadian input to the hypothalamus
omega = 2*pi/1440;
u = 55 - 45*cos(omega*t);

%---------------------------------------------------------

function u = L1(z)
% Supression of the hypothalamus by the target gland
% (negative feedback function)
h = 1;
r = 1;
u = 1/(1 +  (z/h)^r); 

% --------------------------------------------------------------------------
function u = L2(z)
% Supression of the pituitary by the target gland 
% (negative feedback function)
h = 1;
r = 1;
u = 1/(1 +  (z/h)^r);

% --------------------------------------------------------------------------
function [value,isterminal,direction]=event(t,x)
% Event occurs when the potentials reach their thresholds
global Delta1 Delta2
%-------------------------------------------------------------------------
value(1) = Delta1 - x(4);
isterminal(1) = 1;
direction(1) = 0;

value(2) = Delta2 - x(5);
isterminal(2) = 1;
direction(2) = 0;
%-------------------------------------------------------------------------


