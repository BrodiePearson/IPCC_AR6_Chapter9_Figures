function Z=Depth(P,LAT)
% Depth   Computes depth given the pressure at some latitude
%         Z=Depth(P,LAT) gives the Depth Z (m) for a pressure P
%             (dbars) at some latitude LAT (degrees).
%
%         Fofonoff and Millard (1982). UNESCO Tech Paper #44.
%
% Notes:  (ETP3, MBARI)
%         This algorithm was originally compiled by RP @ WHOI.
%         It was copied from the UNESCO technical report.
%         The algorithm was endorsed by SCOR Working Group 51.
%         The equations were originally developed by Saunders
%             and Fofonoff (1976).  DSR 23: 109-111.
%         The parameters were re-fit for the 1980 equation of
%             state for seawater (EOS80).
%
% CHECKVALUE: Z = 9712.653 M FOR P=10000 DECIBARS, LAT=30 DEG
%
% CALCULATON ASSUMES STD OCEAN: T = 0 DEG C; S = 35 (IPSS-78)


  X = sin(LAT/57.29578);
  X = X.*X;

% GR= GRAVITY VARIATION WITH LAT: ANON (1970) BULLETIN GEODESIQUE

  GR = 9.780318*(1.0+(5.2788E-3+2.36E-5*X).*X) + 1.092E-6.*P;

  Z = (((-1.82E-15*P+2.279E-10).*P-2.2512E-5).*P+9.72659).*P;
  Z = Z./GR;
