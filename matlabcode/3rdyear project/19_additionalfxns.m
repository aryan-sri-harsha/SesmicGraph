
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [T,Gphi] = EigAnalysis(wi,k,g)
Nst = length(wi);

% M and K matrices
M = diag(wi)/g;         % Mass Matrix
k_aux = k(2:end);   k_aux(end+1) = 0;
K = diag(k+k_aux) - diag(k(2:end),1) - diag(k(2:end),-1);

[phi,w2] = eig(K,M);
w = sqrt(diag(w2));     % Undamped frequencies
[w,index] = sort(w);
T = 2*pi./w;            % Undamped periods

% Sort vectors (modal shapes) and normalize them at roof: phi_roof = 1.0
sphi = phi;
for i = 1:length(wi)
    sphi(:,i) = phi(:,index(i))/ phi(end,index(i));
end
phi = sphi;             % Normalized modal shapes

r = ones(Nst,1);
Gamma = phi'*M*r./diag(phi'*M*phi);

Gphi = phi;
for i = 1:Nst
    Gphi(:,i) = Gamma(i)*phi(:,i);
end


function [] = plotUndeformed(handles)
global Building g lengthT forceT

Nst = length(Building.Story);

plot(handles.BuildingAxes,[0;Building.do],[0;Building.H],'-o','linewidth',2)
axes(handles.BuildingAxes);
grid on
xlabel(['do [' lengthT ']'])
ylabel(['Height [' lengthT ']'])
ylim([0 1.2*Building.H(end)])

doAux = [0;Building.do];
HAux = [0;Building.H];
for i = 1:Nst
    Xtext = (doAux(i) + doAux(i+1))/2;
    Ytext = (HAux(i) + HAux(i+1))/2;
    text(Xtext,Ytext,['   K_' num2str(i) ' = ' num2str(Building.K(i)) ' ' forceT '/' lengthT])
    Xtext = Building.do(i);
    Ytext = Building.H(i);
    text(Xtext,Ytext,['   W_' num2str(i) ' = ' num2str(Building.W(i)) ' ' forceT])
end


function [] = plotMode(handles,Mode)
global Building g lengthT forceT

plot(handles.BuildingAxes,[0;Building.Gphi(:,Mode)],[0;Building.H],'-o','linewidth',2)
axes(handles.BuildingAxes);
grid on
xlabel(['\Gamma_' num2str(Mode) ' \phi_' num2str(Mode)])
ylabel(['Height [' lengthT ']'])
ylim([0 1.2*Building.H(end)])
xlim(1.2*[-max(max(abs(Building.Gphi))) max(max(abs(Building.Gphi)))]);



function [] = plotResponses(handles)
global state Building GM Responses g lengthT forceT leg

ParameterX = get(handles.PlotParameterXMenu,'value');
ParameterY = get(handles.PlotParameterYMenu,'value');
indGM = get(handles.PlotGMsMenu,'value')-1;

if indGM == 0 || ParameterY == 1
    cla(handles.ResultsAxes)
    legend off
    return
end

if ParameterY > 2 && state < 3
    msgbox('First analize the building.','Error')
    set(handles.PlotParameterYMenu,'value',1)
    set(handles.YUnits,'String','')
    return
end

legTot = cell(1,length(Building.W));
for st = 1:length(Building.W)
    legTot{st} = ['Story ' num2str(st)];
end
leg = legTot;


indC = ones(length(Building.W),1)*length(GM.time{indGM});
if state == 3   % See if the GM produced collapse
    for i = 1:length(indC)
        indAux = find(abs(Responses.ID{indGM}(i,:)) >= Building.d_col(i),1);
        if ~isempty(indAux)
            indC(i) = indAux;
        end
    end
end

switch ParameterY
    case 2  % Ground Motion
        if state < 3
            PlotY = GM.Acc{indGM}';
            indC = length(PlotY);
        else
            PlotY = GM.Acc_up{indGM}';
            indC = length(PlotY);
        end
        Ytext = '[g]';
        leg = 'Ground Acceleration';
        
    case 3  % Displacement
        PlotY = Responses.u{indGM}(:,1:min(indC))';
        Ytext = ['[' lengthT ']'];
        
    case 4  % Interstory disp
        PlotY = Responses.ID{indGM}(:,1:min(indC))';
        Ytext = ['[' lengthT ']'];
        
    case 5  % IDR
        PlotY = Responses.IDR{indGM}(:,1:min(indC))';
        Ytext = '[ ]';
        
    case 6  % Velocity
        PlotY = Responses.v{indGM}(:,1:min(indC))';
        Ytext = ['[' lengthT '/sec]'];
        
    case 7  % Total Acceleration
        PlotY = Responses.a_t{indGM}(:,1:min(indC))';
        Ytext = '[g]';
        
    case 8  % Restoring Force
        PlotY = Responses.fs_st{indGM}(:,1:min(indC))';
        Ytext = ['[' forceT ']'];
        
    case 9  % Base Shear
        PlotY = Responses.fs_st{indGM}(1,1:min(indC))';
        Ytext = ['[' forceT ']'];
        leg = 'Base Shear';
        
end

switch ParameterX
    case 1  % Time
        PlotX = GM.time{indGM}(:,1:min(indC))';
        Xtext = '[sec]';
        
    case 2  % Interstory Displacement
        PlotX = Responses.ID{indGM}(:,1:min(indC))';
        Xtext = ['[' lengthT ']'];
        leg = legTot;
        
    case 3  % IDR
        PlotX = Responses.IDR{indGM}(:,1:min(indC))';
        Xtext = '[ ]';
        leg = legTot;
        
end

if ParameterX == 1
    xlimit = [0 max(GM.time{indGM})*1.2];
else
    xlimit = [min(min(PlotX)) max(max(PlotX))]*1.2;
end
ylimit = [min(min(PlotY)) max(max(PlotY))]*1.2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plot(handles.ResultsAxes,PlotX,PlotY,'linewidth',1);
xlabel(handles.ResultsAxes, Xtext);
ylabel(handles.ResultsAxes, Ytext);
axes(handles.ResultsAxes);
grid on
h_legend = legend(handles.ResultsAxes, leg, 'Location', 'best');
xlim(xlimit)
ylim(ylimit)

% Get the labels of the legend
legend_labels = get(h_legend, 'String');

% Create a new invisible figure
fig = figure('visible', 'off');

% Copy axes to new figure
new_axes = copyobj(handles.ResultsAxes, fig);

% Adjust the size and position of the new axes to fill the figure
set(new_axes, 'Units', 'normalized', 'Position', [0.13, 0.11, 0.775, 0.815]);

% Add the legend to the new axes
legend(new_axes, legend_labels, 'Location', 'best');

% Concatenate parameterX and parameterY with an underscore, and append '.png'
filename = [num2str(ParameterX) '_' num2str(ParameterY) '.png'];

% Save the figure as a PNG
saveas(fig, filename);

% Close the invisible figure
close(fig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


HideCurves(handles)


function [] = HideCurves(handles)
global leg Building

Nst = length(Building.W);

if isempty(get(handles.ResultsAxes,'children'))
    return
end

Story = get(handles.HideCurvesMenu,'value')-1;
Curves = get(handles.ResultsAxes,'children');

if Story == 0 || length(Curves) == 1
    set(Curves,'visible','on')
    legend(leg,'Location','Best')
else
    set(Curves,'visible','off')
    set(Curves(Nst+1-Story),'visible','on')
    legend(Curves(Nst+1-Story),['Story ' num2str(Story)],'Location','Best')
end
