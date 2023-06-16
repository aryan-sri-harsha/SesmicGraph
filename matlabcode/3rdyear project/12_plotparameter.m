
% --- Executes on selection change in PlotParameterYMenu.
function PlotParameterYMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlotParameterYMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlotParameterYMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlotParameterYMenu

plotResponses(handles)

if get(hObject,'Value') == 1
    set(handles.YUnits,'string','');
end


% --- Executes during object creation, after setting all properties.
function PlotParameterYMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotParameterYMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PlotParameterXMenu.
function PlotParameterXMenu_Callback(hObject, eventdata, handles)
% hObject    handle to PlotParameterXMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlotParameterXMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlotParameterXMenu

plotResponses(handles)

% --- Executes during object creation, after setting all properties.
function PlotParameterXMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotParameterXMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
