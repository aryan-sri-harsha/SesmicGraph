
% --- Executes just before THAMDOF is made visible.
function THAMDOF_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to THAMDOF (see VARARGIN)

clc;
global state Building GM Responses

state = 0;

%set(hObject, 'Units', 'Normalized', 'position', [0.05, 0.05, 0.9, 0.9]);
set(handles.figure1,'Units','Pixels','OuterPosition',get(0,'ScreenSize').*[50, 50, 0.9, 0.9])

% Choose default command line output for THAMDOF
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes THAMDOF wait for user response (see UIRESUME)
% uiwait(handles.figure1);
