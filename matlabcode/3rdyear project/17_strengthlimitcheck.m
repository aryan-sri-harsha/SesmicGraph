
% --- Executes on button press in StrengthLimitCheck.
function StrengthLimitCheck_Callback(hObject, eventdata, handles)
% hObject    handle to StrengthLimitCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of StrengthLimitCheck

if get(hObject,'Value') == 0
    waitfor(msgbox({'It is recommended to include the Strength Limit option.',...
        'Only uncheck this checkbox if you are comparing against IIIDAP.'},'Warning'))
end