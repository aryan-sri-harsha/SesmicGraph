% --- Executes on selection change in ExportParameterMenu.
function ExportParameterMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ExportParameterMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ExportParameterMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ExportParameterMenu


% --- Executes during object creation, after setting all properties.
function ExportParameterMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExportParameterMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

