Versionn 4.1

atomsInstall('IPCV');

Version 2.1

Skipped Released merge in 4.1


Version 1.2 - 2.0

For Windows : atomsInstall('IPCV') in Scilab 6 should get the installation done.

For Linux (tested on Scilab 6.0 binary version), after atomsInstall('IPCV'), you need to do the following steps:

1. You need to delete (to be safe, move to another location) the libgomp* under scilab6folder/lib/thirdparty/redist. 

2. You need to install opencv for your linux distribution, for e.g. under ubuntu:
sudo apt-get install libopencv-dev

3. The module is compiled with Ubuntu 16.04 (with the default gcc). If you run into error during startup, run the builder.sce under IPCV folder and restart Scilab 6.

Enjoy! please let me know whether you make it works or go into error by sending the feedback at http://scilabipcv.tritytech.com/feedback-on-installation/
