% --- Executes on button press in AnalysisButton.
function AnalysisButton_Callback(hObject, eventdata, handles)
% hObject    handle to AnalysisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global state Building GM Responses g lengthT forceT dSF

if state < 2
    msgbox('First load the Building Information (Input #1) and the Ground Motions (Input #2).'...
        ,'Error')
    return;
end

Ngm = length(GM.dt);
set(handles.ExportParameterMenu,'value',1);
ExportOptions = get(handles.ExportParameterMenu,'String');

tol = 1E-4;
StrengthLimitCheck = get(handles.StrengthLimitCheck,'value');

u = cell(1,Ngm);
v = u; a_t = u; fs_st = u; fs = u; ID = u; IDR = u; IV = u;
h = waitbar(0,['0 of ' num2str(Ngm) ' ground motions completed']...
    ,'Name','Analyzing...');

tic
if get(handles.CollapseSFCheck,'value') == 0    % Just run each ground motion
    
    for igm = 1:Ngm
        [u{igm}, v{igm}, a_t{igm}, fs_st{igm}, fs{igm}, ~, ~, ~, ~, ~, GM.time{igm}, GM.Acc_up{igm}] = ...
            MDOF_Shear_IMK_seismic...
            (Building.h, Building.W, Building.P, Building.K, Building.Xi, GM.Acc{igm}'.*GM.SF(igm), GM.dt(igm), ...
            Building.do, Building.Vo, Building.Fy, Building.as, Building.dcdy,...
            Building.ac, tol, g, GM.Names{igm},StrengthLimitCheck);
        
        Uaux = [zeros(1,size(u{igm},2));u{igm}];
        ID{igm} = diff(Uaux,[],1);
        IDR{igm} = (1./Building.h)*ones(1,size(ID{igm},2)).*ID{igm};
        Vaux = [zeros(1,size(v{igm},2));v{igm}];
        IV{igm} = diff(Vaux,[],1);
        waitbar(igm/Ngm,h,[num2str(igm) ' of ' num2str(Ngm) ' ground motions completed'])
    end
    close(h);
    
    Responses.u = u;
    Responses.v = v;
    Responses.a_t = a_t;
    Responses.fs_st = fs_st;
    Responses.fs = fs;
    Responses.ID = ID;
    Responses.IDR = IDR;
    Responses.IV = IV;
    
    % Update Menu of Ground Motions, with their SF
    GMMenuText = ['Select Ground Motion',GM.Names];
    for i = 2:length(GMMenuText)
        GMMenuText{i} = [GMMenuText{i} ' (SF = ' num2str(GM.SF(i-1)) ')'];
    end
    
    set(handles.PlotGMsMenu,'String',GMMenuText)
    
    if length(ExportOptions) == 13
        set(handles.ExportParameterMenu,'String',ExportOptions(1:12));
    end
    
else            % Run each ground motion up to collapse
    pos = get(h,'position');
    set(h,'Position',[pos(1) pos(2) pos(3) pos(4)*1.3])
    
    SF = dSF*ones(1,Ngm);
    
    for igm = 1:Ngm     % for each ground motion
        cont = true;
        dSF_use = dSF;
        while cont
            waitbar((igm-1)/Ngm,h,{['Analizing "' GM.Names{igm} '" - SF = ' num2str(SF(igm))]...
                ,[num2str(igm-1) ' of ' num2str(Ngm) ' ground motions completed']})
            ugSF = GM.Acc{igm}'.*SF(igm);
            [u{igm}, v{igm}, a_t{igm}, fs_st{igm}, fs{igm}, ~, ~, ~, ~, ~, GM.time{igm}, GM.Acc_up{igm}] = ...
                MDOF_Shear_IMK_seismic...
                (Building.h, Building.W, Building.P, Building.K, Building.Xi, ugSF, GM.dt(igm), ...
                Building.do, Building.Vo, Building.Fy, Building.as, Building.dcdy,...
                Building.ac, tol, g, GM.Names{igm},StrengthLimitCheck);
            
            Uaux = [zeros(1,size(u{igm},2));u{igm}];
            ID{igm} = diff(Uaux,[],1);
            
            MAX_ID = max(abs(ID{igm}),[],2);
            if MAX_ID <= Building.d_col     % No collapse yet
                SF(igm) = SF(igm) + dSF_use;
            else                            % Collapsed
                if dSF_use/SF(igm) <= 0.01  % Convergence criteria: 1% of difference
                    cont = false;
                else
                    dSF_use = dSF_use/2;
                    SF(igm) = SF(igm) - dSF_use;
                end
            end
            
        end
        IDR{igm} = (1./Building.h)*ones(1,size(ID{igm},2)).*ID{igm};
        Vaux = [zeros(1,size(v{igm},2));v{igm}];
        IV{igm} = diff(Vaux,[],1);
        waitbar(igm/Ngm,h,[num2str(igm) ' of ' num2str(Ngm) ' ground motions completed'])
    end
    close(h);
    
    
    Responses.u = u;
    Responses.v = v;
    Responses.a_t = a_t;
    Responses.fs_st = fs_st;
    Responses.fs = fs;
    Responses.ID = ID;
    Responses.IDR = IDR;
    Responses.IV = IV;
    Responses.SF_col = SF;
    
    % Update Menu of Ground Motions, with their SF
    GMMenuText = ['Select Ground Motion',GM.Names];
    for i = 2:length(GMMenuText)
        GMMenuText{i} = [GMMenuText{i} ' (SF_col = ' num2str(SF(i-1)) ')'];
    end
    
    set(handles.PlotGMsMenu,'String',GMMenuText)
    
    if length(ExportOptions) == 12
        ExportOptions{end+1} = 'Collapse SF';
        set(handles.ExportParameterMenu,'String',ExportOptions);
    end
    
end

AnalysisTime=toc;
% Update State
state = 3;

set(handles.RunText,'String','Analysis Complete!');

msgbox(['Analysis completed in ' num2str(AnalysisTime,'%.1f') ' seconds!'],'Done');
