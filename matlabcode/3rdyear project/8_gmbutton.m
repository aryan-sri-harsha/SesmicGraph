
% --- Executes on button press in GMsButton.
function GMsButton_Callback(hObject, eventdata, handles)
% hObject    handle to GMsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global state Building GM Responses g lengthT forceT

[filename pathname] = uigetfile('*.csv','Ground Motions');
if ~ischar(filename) && ~ischar(pathname)   % If no file
    msgbox('No file selected.','Error');
    set(handles.BuildingText,'String','Error: Must select a file.');
    return
end

LoadedFile = importdata([pathname filename]);
LoadedData = LoadedFile.data;

Ngm = size(LoadedData,2);
GM.Names = LoadedFile.colheaders;
GM.dt = LoadedData(2,:);
GM.SF = LoadedData(3,:);
GM.Acc = cell(1,Ngm);
GM.time = GM.Acc;
GM.Npts = LoadedData(1,:);
for i = 1:size(LoadedData,2)
    Np = GM.Npts(i);
    if Np+3 > size(LoadedData,1)
        GM.Acc{i} = LoadedData(4:end,i);
        GM.Acc{i}(Np) = 0;
    else
        GM.Acc{i} = LoadedData(4:3+Np,i);
    end
    GM.Acc{i}(isnan(GM.Acc{i})) = 0;
    GM.time{i} = 0:GM.dt(i):(GM.dt(i)*(Np-1));
end

% Update State
state = state + 1;

set(handles.GMText,'String','Ground Motions Loaded!');
GMMenuText = ['Select Ground Motion',GM.Names];
set(handles.PlotGMsMenu,'String',GMMenuText)
msgbox(['Done loading ' num2str(Ngm) ' ground motions'],'Done');
