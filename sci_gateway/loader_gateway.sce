// This file is released under the 3-clause BSD license. See COPYING-BSD.
// Generated by builder_gateway.sce: Please, do not edit this file

try
    v = getversion("scilab");
catch
    v = [ 5 0 ]; // or older 
end
if (v(1) <= 5) & (v(2) < 3) then
    // new API in scilab 5.3
    error(gettext("Scilab 5.3 or more is required."));
end

sci_gateway_dir = get_absolute_file_path("loader_gateway.sce");
current_dir     = pwd();

chdir(sci_gateway_dir);
if ( isdir("cpp") ) then
    chdir("cpp");
    exec("loader.sce");
end

chdir(current_dir);
clear sci_gateway_dir current_dir v;
