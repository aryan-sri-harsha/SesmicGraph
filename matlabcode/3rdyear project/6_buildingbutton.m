% --- Executes on button press in BuildingButton.
function BuildingButton_Callback(hObject, eventdata, handles)
% hObject    handle to BuildingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global state Building GM Responses g lengthT forceT

% waitfor(msgbox(['The file must contain 11 columnns: First column: IM '...
%     '(e.g. Pseudo Spectral Accelerations); Second column: Mean Annual'...
%     ' Frequencies of Exceedance.'],'REMEMBER'));

% Open File
[filename pathname] = uigetfile('*.csv','Building Information');
if ~ischar(filename) && ~ischar(pathname)   % If no file
    msgbox('No file selected.','Error');
    set(handles.BuildingText,'String','Error: Must select a file.');
    return
end

LoadedFile = importdata([pathname filename]);
LoadedData = LoadedFile.data;

if size(LoadedData,2) == 12     % Check number of columns
    % Set units
    if get(handles.UnitsMenu,'value') == 1
        lengthT = 'cm';
        forceT = 'tonf';
        g = 980.665;
    else
        lengthT = 'in';
        forceT = 'kip';
        g = 386.09;
    end
    
    % Fill the Building Information
    Building.Story = LoadedData(:,1);
    [Building.Story,ind] = sort(Building.Story);
    Nst = length(Building.Story);
    Building.h = LoadedData(ind,2);
    Building.H = cumsum(Building.h);
    Building.W = LoadedData(ind,3);
    Building.P = LoadedData(ind,4);
    Building.K = LoadedData(ind,5);
    Building.Fy = LoadedData(ind,6);
    Building.as = LoadedData(ind,7);
    Building.ac = LoadedData(ind,8);
    Building.dcdy = LoadedData(ind,9);
    Building.Xi = LoadedData(ind,10);
    Building.do = LoadedData(ind,11);
    Building.Vo = LoadedData(ind,12);
    Building.Fc = Building.Fy.*(1+(Building.dcdy - 1).*Building.as) - Building.P./Building.h.*Building.dcdy.*Building.Fy./Building.K;
    Building.d_col = Building.Fy./Building.K.*(Building.dcdy)+Building.Fc./((-Building.ac+Building.P./(Building.h.*Building.K)).*Building.K);
    
    % Compute modal information
    [Building.T,Building.Gphi] = EigAnalysis(Building.W,Building.K,g);
    
    plotUndeformed(handles);
    
    axes(handles.BuildingAxes);
    
    % Update Mode pop-up menu
    ModeText = cell(Nst+1,1);   StoryText = ModeText;
    ModeText{1} = 'Undeformed Shape';
    StoryText{1} = 'All Stories';
    for i = 1:Nst
        ModeText{i+1} = ['Mode ' num2str(i) '. T = ' num2str(Building.T(i),'%.3f') ' sec ; Xi = ' num2str(Building.Xi(i)*100) '%'];
        StoryText{i+1} = ['Story ' num2str(i)];
    end
    set(handles.ModeMenu,'String',ModeText)
    set(handles.HideCurvesMenu,'String',StoryText)
    
    % Update State
    state = state + 1;
    
    set(handles.BuildingText,'String','Building Loaded!');
    msgbox('Done Loading','Done');
    
    UnitOptions = cellstr(get(handles.UnitsMenu,'String'));
    
    set(handles.UnitsText,'String',UnitOptions{get(handles.UnitsMenu,'Value')})
    set(handles.UnitsMenu,'Visible','off')
    
else
    
    msgbox('Matrix dimensions do not match.','Error');
    set(handles.BuildingText,'String','Error: Try again.');
    
end
