
% --- Executes on selection change in UnitsMenu.
function UnitsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to UnitsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns UnitsMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from UnitsMenu


% --- Executes during object creation, after setting all properties.
function UnitsMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UnitsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


