function  [line_color, line_style] = IPCC_Get_LineColors(no_of_colors, ...
    nth_color, shading_on)
%IPCC_Get_LineColors Get IPCC style guide colorbars (Dec 2018)
%
%    [line_color, line_style] = IPCC_Get_LineColors(no_of_colors, ...
%                                               nth_color, shading_on)
%
%    returns line colors from IPCC style guide (Dec 2018) if no_of_colors
%    is greater than 6 it also returns the line style (dash, dot etc.)
%
% Input variables:
%           no_of_colors - number of colors that will be plotted
%           nth_color - index of current number
%           shading - optional argument: true if shading rather than line
%                     is required
%                       
%
% Output variables:
%           line_color - Line color for plotting
%           line_style - Line style (solid unless no_of_colors>6)
%
% Function written by Brodie Pearson

% Define reference line colors for 1-6 colours
ref_colors = [0 0 0
    112 160 205
    196 121 0
    178 178 178
    0 52 102
    0 79 0]/255;

% Switch to shading colors if needed
if exist('shading_on')
    if shading_on
        ref_colors = [128 128 128
            91 174 178
            204 174 113
            191 191 191
            67 147 195
            223 237 195]/255;
    end
end

% index for color: number between 1 and 6
i_col = rem(nth_color, 6);
if i_col==0
    i_col = 6;
end

% index for linestyle: number between 1 and 4 (up to 24 line choices)
i_sty = floor((nth_color-1)./6)+1;

% Define line color
line_color = ref_colors(i_col,:);

% Define line style
if i_sty==1
    % Solid line
    line_style = '-';
elseif i_sty==2
    % dashed line
    line_style = '--';
elseif i_sty==4
    % dash-dot line
    line_style = '-.';
elseif i_sty==3
    % dotted line
    line_style = ':';
end

end

