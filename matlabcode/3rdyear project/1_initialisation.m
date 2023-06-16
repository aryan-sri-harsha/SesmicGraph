function varargout = THAMDOF(varargin)
% Version 2.0
%   - Added video button
%   - Added Collapse SF computation option
%
% Version 2.1
%   - Video with realistic shapes
%
% Version 3.0
%   - Added P-delta effects
%   - Added switch for Strengh limit
%   - Improved computation of Collapse SF
%
% Version 3.1
%   - Added time when completed
%   - Fixed a bug with the length of ug_int
%   - Fixed a bug when using P-delta and Strengh limit in MDOF
%
% Version 3.2
%   - Added the posibility of exporting the interstory velocities also
%
% Version 3.3
%   - Added export displacement time histories option
%
% Version 3.4
%   - Added export shear forces time histories option
%
% Version 3.5
%   - Fixed a bug when zero-padding the records
%
%
% THAMDOF MATLAB code for THAMDOF.fig
%      THAMDOF, by itself, creates a new THAMDOF or raises the existing
%      singleton*.
%
%      H = THAMDOF returns the handle to a new THAMDOF or the handle to
%      the existing singleton*.
%
%      THAMDOF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THAMDOF.M with the given input arguments.
%
%      THAMDOF('Property','Value',...) creates a new THAMDOF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before THAMDOF_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to THAMDOF_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help THAMDOF

% Last Modified by GUIDE v2.5 27-Aug-2015 14:49:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @THAMDOF_OpeningFcn, ...
    'gui_OutputFcn',  @THAMDOF_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
