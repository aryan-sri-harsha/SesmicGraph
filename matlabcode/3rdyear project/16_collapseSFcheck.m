% --- Executes on button press in .
function CollapseSFCheck_Callback(hObject, eventdata, handles)
% hObject    handle to CollapseSFCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of CollapseSFCheck

global dSF

if get(hObject,'Value') == 1
    dSF = str2double(inputdlg('Increment of Scale Factor (dSF): [numeric value]'));
    while isnan(dSF)
        waitfor(msgbox('Increment must be a numeric value. Try again.','Error'))
        dSF = str2double(inputdlg('Increment of Scale Factor (dSF): [numeric value]'));
    end
    while dSF < 0.02
        waitfor(msgbox('Choose a value greater than 0.02','Error'))
        dSF = str2double(inputdlg('Increment of Scale Factor (dSF): [numeric value]'));
    end
    set(handles.dSFText,'string',['dSF = ' num2str(dSF)])
else
    set(handles.dSFText,'string','')
end
