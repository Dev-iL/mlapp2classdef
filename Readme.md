[![MATLAB FEX](https://img.shields.io/badge/MATLAB%20FEX-mlapp2classdef-brightgreen.svg)](http://www.mathworks.com/matlabcentral/fileexchange/56237-mlapp2classdef) ![Minimum Version](https://img.shields.io/badge/Requires-R2009b%20%28v7.9%29-orange.svg)

# mlapp2classdef()

MLAPP2CLASSDEF() prompts the user to select an App Designer GUI, packaged as an `*.mlapp` file, and converts the GUI's class definition from an XML file to a standalone `*.m` file.

The class definition for an App Designer GUI is embedded in an XML file located in a subfolder of the packaged `*.mlapp` file, which can be accessed like a `*.zip` file. MLAPP2CLASSDEF strips the XML header & footer and saves the class definition to a `*.m` file located in the same path as the `*.mlapp` file.

# Current Limitations

MLAPP2CLASSDEF assumes that the targeted `*.mlapp` file is a GUI created by MATLAB's App Designer. Other packaged apps are not explicitly supported.

Structure of the packaged `*.mlapp` file is assumed to be a constant (e.g. `~\matlab\document.xml` is the path to the class definition XML)

For ease of output formatting, the XML file is read line-by-line into a cell array. Preallocation of this cell array is currently only supported for Windows operating systems. All other operating systems will grow this array in memory as the file is read in, resulting in a potentially significant performance decrease.
