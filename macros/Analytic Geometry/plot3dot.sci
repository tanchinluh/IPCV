//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function plot3dot(x,y,z,mark_foreground,mark_style)
// 3-D Parametric plot for opoints
//
// Syntax
//     plot3dot(x,y,z)
//     plot3dot(x,y,z,mark_foreground,mark_style)
//
// Parameters
//     x : x data
//     y : y data
//     z : z data
//     mark_foreground : marker color
//     mark_style : marker style
//
// Description
//    This is the function to visualize 3-D Parametric plot for opoints
//    
// Examples
//    x = rand(1:10);
//    y = rand(1:10);
//    z = rand(1:10);
//    plot3dot(x,y,z)
//
// Authors
//     Tan Chin Luh

rhs = argn(2);

if rhs < 4; mark_foreground=5; end
if rhs < 5; mark_style = 4;end

param3d1(x,y,z);
e2 = gce();
e2.line_mode='off';
e2.mark_mode='on';

execstr('e2.mark_foreground ='+ string(mark_foreground));
execstr('e2.mark_style ='+ string(mark_style));

endfunction
