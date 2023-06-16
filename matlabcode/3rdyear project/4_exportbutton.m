
% --- Executes on button press in ExportButton.
function ExportButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global state Building GM Responses g lengthT forceT

Parameter = get(handles.ExportParameterMenu,'value')-1;

if Parameter == 0
    msgbox('No parameter selected. Try again.','Error');
    return
end

if state < 3
    msgbox('Run analysis first.','Error');
    return
end

[filename pathname] = uiputfile('*.xlsx','Export Results');
if ~ischar(filename) && ~ischar(pathname)   % If no file
    msgbox('No file selected. Try again.','Error');
    return
end

Ngm = length(GM.dt);
Nst = length(Building.W);
DATAmax = zeros(Nst,Ngm);
DATAmin = DATAmax;
DATA = DATAmax;
switch Parameter
    case 1                                              % Displacement
        for i = 1:Ngm
            DATAmax(:,i) = max(Responses.u{i},[],2);
            DATAmin(:,i) = min(Responses.u{i},[],2);
        end
        Title = ['u [' lengthT ']'];
        Sheet = 'u';
    case 2                                              % Interstory Displ.
        for i = 1:Ngm
            DATAmax(:,i) = max(Responses.ID{i},[],2);
            DATAmin(:,i) = min(Responses.ID{i},[],2);
        end
        Title = ['ID [' lengthT ']'];
        Sheet = 'ID';
    case 3                                              % IDR
        for i = 1:Ngm
            DATAmax(:,i) = max(Responses.IDR{i},[],2);
            DATAmin(:,i) = min(Responses.IDR{i},[],2);
        end
        Title = 'IDR [ ]';
        Sheet = 'IDR';
    case 4                                              % Residual ID
        for i = 1:Ngm
            DATA(:,i) = Responses.ID{i}(:,end);
        end
        Title = ['Residual ID [' lengthT ']'];
        Sheet = 'ResID';
    case 5                                              % Residual IDR
        for i = 1:Ngm
            DATA(:,i) = Responses.IDR{i}(:,end);
        end
        Title = 'Residual IDR [ ]';
        Sheet = 'ResIDR';
    case 6                                              % Velocity
        for i = 1:Ngm
            DATAmax(:,i) = max(Responses.v{i},[],2);
            DATAmin(:,i) = min(Responses.v{i},[],2);
        end
        Title = ['v [' lengthT '/sec]'];
        Sheet = 'v';
    case 7                                              % Interstory Velocity
        for i = 1:Ngm
            DATAmax(:,i) = max(Responses.IV{i},[],2);
            DATAmin(:,i) = min(Responses.IV{i},[],2);
        end
        Title = ['Int. vel. [' lengthT '/sec]'];
        Sheet = 'Int. vel';
    case 8                                              % Total Acceleration
        for i = 1:Ngm
            DATAmax(:,i) = max(Responses.a_t{i},[],2);
            DATAmin(:,i) = min(Responses.a_t{i},[],2);
        end
        Title = 'a_t [g]';
        Sheet = 'a_t';
    case 9                                              % Story Restoring Force
        for i = 1:Ngm
            DATAmax(:,i) = max(Responses.fs_st{i},[],2);
            DATAmin(:,i) = min(Responses.fs_st{i},[],2);
        end
        Title = ['fs [' forceT ']'];
        Sheet = 'fs';
    case 10                                              % IDR Time Histories
        st_exp = str2double(inputdlg('Select story: [numeric value]'));
        if isempty(st_exp)
            return
        end
        while isnan(st_exp)
            waitfor(msgbox('Story must be a numeric value. Try again.','Error'))
            st_exp = str2double(inputdlg('Select story: [numeric value]'));
        end
        while Building.Story ~= st_exp
            waitfor(msgbox('Selected story must match with one of the building stories. Try again.','Error'))
            st_exp = str2double(inputdlg('Select story: [numeric value]'));
        end
        
        Sheet = ['TH_IDR_' num2str(st_exp)];
        
        % Maximum number of points
        Ngm_updated = zeros(1,length(GM.dt));
        for igm = 1:Ngm
            Ngm_updated(igm) = length(Responses.IDR{igm}(st_exp,:));
        end
        
        % DATA matrix for writing
        DATA = NaN(max(Ngm_updated),2*length(GM.dt));
        HEADER = cell(1,2*length(GM.dt));
        NPTS = HEADER;
        HEADER2 = HEADER;
        for igm = 1:Ngm
            HEADER(2*igm-1:2*igm) = {GM.Names{igm},GM.Names{igm}};
            NPTS(2*igm-1:2*igm) = {'Npts = ',Ngm_updated(igm)};
            HEADER2(2*igm-1:2*igm) = {'Time [sec]','IDR'};
            DATA(1:Ngm_updated(igm),2*igm-1) = GM.time{igm}';
            DATA(1:Ngm_updated(igm),2*igm) = Responses.IDR{igm}(st_exp,:)';
        end
        
    case 11                                             % Story Restoring Force Time Histories
        st_exp = str2double(inputdlg('Select story: [numeric value]'));
        if isempty(st_exp)
            return
        end
        while isnan(st_exp)
            waitfor(msgbox('Story must be a numeric value. Try again.','Error'))
            st_exp = str2double(inputdlg('Select story: [numeric value]'));
        end
        while Building.Story ~= st_exp
            waitfor(msgbox('Selected story must match with one of the building stories. Try again.','Error'))
            st_exp = str2double(inputdlg('Select story: [numeric value]'));
        end
        
        Sheet = ['TH_fs_' num2str(st_exp)];
        
        % Maximum number of points
        Ngm_updated = zeros(1,length(GM.dt));
        for igm = 1:Ngm
            Ngm_updated(igm) = length(Responses.fs_st{igm}(st_exp,:));
        end
        
        % DATA matrix for writing
        DATA = NaN(max(Ngm_updated),2*length(GM.dt));
        HEADER = cell(1,2*length(GM.dt));
        NPTS = HEADER;
        HEADER2 = HEADER;
        for igm = 1:Ngm
            HEADER(2*igm-1:2*igm) = {GM.Names{igm},GM.Names{igm}};
            NPTS(2*igm-1:2*igm) = {'Npts = ',Ngm_updated(igm)};
            HEADER2(2*igm-1:2*igm) = {'Time [sec]', ['fs [' forceT ']'];};
            DATA(1:Ngm_updated(igm),2*igm-1) = GM.time{igm}';
            DATA(1:Ngm_updated(igm),2*igm) = Responses.fs_st{igm}(st_exp,:)';
        end
        
    case 12     % SF of Collapse
        DATA = Responses.SF_col
        Title = 'Collapse SF';
        Sheet = 'ColSF';
end

h = waitbar(0,'Exporting Data...');
try
    if Parameter ~= 4 && Parameter ~= 5 && Parameter ~= 10 && Parameter ~= 11 && Parameter ~= 12
        xlswrite([pathname filename],{Title},Sheet,'A1:A1')
        xlswrite([pathname filename],GM.Names,Sheet,'B1')
        waitbar(1/4,h,'Exporting Data...')
        xlswrite([pathname filename],DATAmax,Sheet,'B2')
        xlswrite([pathname filename],(1:Nst)',Sheet,'A2')
        waitbar(1/2,h,'Exporting Data...')
        xlswrite([pathname filename],{Title},Sheet,['A' num2str(4+Nst) ':A' num2str(4+Nst)])
        xlswrite([pathname filename],GM.Names,Sheet,['B' num2str(4+Nst)])
        waitbar(3/4,h,'Exporting Data...')
        xlswrite([pathname filename],DATAmin,Sheet,['B' num2str(5+Nst)])
        xlswrite([pathname filename],(1:Nst)',Sheet,['A' num2str(5+Nst)])
        waitbar(1,h,'Exporting Data...')
    elseif Parameter == 10 || Parameter == 11
        xlswrite([pathname filename],HEADER,Sheet,'A1')
        waitbar(1/4,h,'Exporting Data...')
        xlswrite([pathname filename],NPTS,Sheet,'A2')
        waitbar(2/4,h,'Exporting Data...')
        xlswrite([pathname filename],HEADER2,Sheet,'A3')
        waitbar(3/4,h,'Exporting Data...')
        xlswrite([pathname filename],DATA,Sheet,'A4')
        waitbar(1,h,'Exporting Data...')
    elseif Parameter == 12
        xlswrite([pathname filename],{Title},Sheet,'A1:A1')
        waitbar(1/3,h,'Exporting Data...')
        xlswrite([pathname filename],GM.Names,Sheet,'A2')
        waitbar(2/3,h,'Exporting Data...')
        xlswrite([pathname filename],DATA,Sheet,'A3')
        waitbar(1,h,'Exporting Data...')
    else
        xlswrite([pathname filename],{Title},Sheet,'A1:A1')
        waitbar(1/3,h,'Exporting Data...')
        xlswrite([pathname filename],GM.Names,Sheet,'B1')
        waitbar(2/3,h,'Exporting Data...')
        xlswrite([pathname filename],DATA,Sheet,'B2')
        xlswrite([pathname filename],(1:Nst)',Sheet,'A2')
        waitbar(1,h,'Exporting Data...')
    end
    close(h)
    waitfor(msgbox('Done exporting!','Done'));
catch %#ok<CTCH>
    close(h)
    waitfor(msgbox('The file is used by another process. Close it and try again.','Error'));
    return
end
