

% --- Executes on button press in VideoButton.
function VideoButton_Callback(hObject, eventdata, handles)
% hObject    handle to VideoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global state Building GM Responses g lengthT forceT leg

indGM = get(handles.PlotGMsMenu,'value')-1;

if state < 3
    waitfor(msgbox('Run the analysis first.','Error'))
    return
end

if indGM == 0
    waitfor(msgbox('Choose a ground motion.','Error'))
    return
end

indC = ones(length(Building.W),1)*length(GM.time{indGM});
Collapse = false;
% See if the GM produced collapse
for i = 1:length(indC)
    indAux = find(abs(Responses.ID{indGM}(i,:)) >= Building.d_col(i),1);
    if ~isempty(indAux)
        indC(i) = indAux;
        Collapse = true;
    end
end
[indC,StCol] = min(indC);

Nextra = 250;
if indC < length(GM.time{indGM})-Nextra
    indC = indC + Nextra;
else
    Nextra = length(GM.time{indGM}) - indC;
    indC = length(GM.time{indGM});
end

AR = inputdlg('Enter Aspect Ratio for horizontal axes.','Aspect Ratio',1,{'20'});
AR = str2double(AR);

if ~isempty(AR)
    Nst = length(Building.W);
    Xf = zeros(Nst+1,indC);
    Yf = zeros(Nst+1,indC);
    for i = 2:Nst+1
        Xf(i,:) = Responses.u{indGM}(i-1,1:indC);
        Yf(i,:) = Yf(i-1,:) + sqrt(Building.h(i-1)^2 - (Xf(i-1,:)-Responses.u{indGM}(i-1,1:indC)).^2);
    end
    
    ID = Responses.ID{indGM}(:,1:indC)';
    ug = GM.Acc_up{indGM}';
    time = GM.time{indGM}';
    
    l = cell(Nst,1);
    for i = 1:Nst
        l{i} = ['Story ' num2str(i)];
    end
    
    figure('Position',[420   100   800   850])
    a1 = subplot('Position',[0.25 0.46 0.6 0.49]);
    hold on
    for i = 1:Nst
        [Xp,Yp] = PlotIDShape(Xf(i:i+1,1),Yf(i:i+1,1));
        h1_shape(i) = plot(Xp,Yp,'b-','linewidth',3);
        h1_points(i) = plot(Xf(i:i+1,1),Yf(i:i+1,1),'bo','linewidth',3);
    end
    Ylimits = get(a1,'ylim');
    grid on
    xlabel(['Displacement [' lengthT ']'])
    ylabel(['Height [' lengthT ']'])
    ylim(Ylimits)
    title('t = 0.000 sec')
    daspect(a1,[1 AR 1])
    xlim([-1 1]*max(max(abs(Responses.u{indGM}(:,1:indC-Nextra))))*1.5)
    
    
    a2 = subplot('Position',[0.1 0.25 0.85 0.15]);
    h2 = plot(time(1),ID(1,:));
    hold on
    ylabel(['ID [' lengthT ']'])
    grid on
    legend(l,'Location','NorthEast','autoupdate','off')
    xlim([0 1.3*max(time)])
    ylim([min(min((ID(1:(indC-Nextra),:)))) max(max((ID(1:(indC-Nextra),:))))]*1.3)
    
    subplot('Position',[0.1 0.06 0.85 0.15])
    plot(time,ug,'k')
    hold on
    h3 = plot(time(1),ug(1),'r');
    ylabel('Ground Acc. [g]')
    xlabel('Time [sec]')
    grid on
    xlim([0 1.3*max(time)])
    
    for i = 2:size(Xf,2)
        pause((time(i)-time(i-1))/2)
        title(a1,['t = ' num2str(time(i),'%.3f') ' sec'])
        
        for st = 1:Nst
            maxID = max(abs(ID(1:i,st)));
            if maxID <= Building.Fy(st)/Building.K(st)
                ColorState = 'b';
                Line = '-';
            elseif maxID <= Building.Fy(st)/Building.K(st)*Building.dcdy
                ColorState = [1 0.7 0.5];
                Line = '-';
            elseif maxID <= Building.d_col(st)
                ColorState = 'r';
                Line = '-';
            else
                ColorState = 'r';
                Line = '--';
            end
            
            [Xp,Yp] = PlotIDShape(Xf(st:st+1,i),Yf(st:st+1,i));
            
            set(h1_shape(st),'Xdata',Xp);
            set(h1_shape(st),'Ydata',real(Yp));
            set(h1_shape(st),'Color',ColorState);
            set(h1_shape(st),'LineStyle',Line);
            set(h1_points(st),'Xdata',Xf(st:st+1,i));
            set(h1_points(st),'Ydata',real(Yf(st:st+1,i)));
            set(h1_points(st),'Color',ColorState);
            
        end
        
        set(h2,'Xdata',time(1:i));
        for st = 1:length(Building.W)
            set(h2(st),'Ydata',ID(1:i,st));
        end
        set(h3,'Xdata',time(1:i));
        set(h3,'Ydata',ug(1:i));
        
    end
    
    if Collapse
        plot(a2,time(indC-Nextra),ID(indC-Nextra,StCol),'rx','linewidth',2 ...
            ,'MarkerSize',8);
        axes(a2);
        text(time(indC-Nextra),ID(indC-Nextra,StCol),'   Collapse','color','r'...
            ,'FontWeight','bold');
        
        for st = 1:Nst
            i = indC-Nextra;
            maxID = max(abs(ID(1:i,st)));
            if maxID <= Building.Fy(st)/Building.K(st)
                ColorState = 'b';
                Line = '-';
            elseif maxID <= Building.Fy(st)/Building.K(st)*Building.dcdy
                ColorState = [1 0.7 0.5];
                Line = '-';
            elseif maxID <= Building.d_col(st)
                ColorState = 'r';
                Line = '-';
            else
                ColorState = 'r';
                Line = '--';
            end
            
            [Xp,Yp] = PlotIDShape(Xf(st:st+1,i),Yf(st:st+1,i));
            plot(a1,Xp,Yp,'Color',ColorState,'LineStyle',Line,'linewidth',1.5);
            plot(a1,Xf(st:st+1,i),Yf(st:st+1,i),'o','Color',ColorState,'linewidth',1.5)
        end
    end
end




function [Xp,Yp] = PlotIDShape(Xf,Yf)

Np = 20;
Amp = (Xf(1)-Xf(2))/2;
T = (Yf(2)-Yf(1))*2;
Xp = Xf(1)+Amp*cos((2*pi)/(2*Np)*(0:Np))-Amp;
Yp = Yf(1)+T/(2*Np)*(0:Np);


