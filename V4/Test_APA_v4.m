function varargout = Test_APA_v4(varargin)
% TEST_APA_V4 MATLAB code for Test_APA_v4.fig
%      TEST_APA_V4, by itself, creates a new TEST_APA_V4 or raises the existing
%      singleton*.
%
%      H = TEST_APA_V4 returns the handle to a new TEST_APA_V4 or the handle to
%      the existing singleton*.
%
%      TEST_APA_V4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_APA_V4.M with the given input arguments.
%
%      TEST_APA_V4('Property','Value',...) creates a new test_apa_v4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Test_APA_v4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Test_APA_v4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Test_APA_v4

% Last Modified by GUIDE v2.5 13-Nov-2014 16:48:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Test_APA_v4_OpeningFcn, ...
    'gui_OutputFcn',  @Test_APA_v4_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
%% Test_APA_v4_OpeningFcn -Funcion principale
% --- Executes just before Test_APA_v4 is made visible.
function Test_APA_v4_OpeningFcn(hObject, eventdata, handles, varargin)
global haxes1 haxes2 haxes3 haxes4 haxes6 h_marks_T0 h_marks_HO h_marks_TO h_marks_FC1 h_marks_FO2 h_marks_FC2 Resultats
% Funcion principale (Interface)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Test_APA_v4 (see VARARGIN)

% Choose default command line output for Test_APA_v4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Test_APA_v4 wait for user response (see UIRESUME)
% uiwait(handles.Test_APA_v4);
set(gcf,'Name','Calcul des APA v4');

scrsz = get(0,'ScreenSize');
set(hObject,'Position',[scrsz(3)/20 scrsz(4)/20 scrsz(3)*9/10 scrsz(4)*9/10]);

ylabel(haxes1,'Axe antéro-postérieur (mm)','FontName','Times New Roman','FontSize',10);
set(haxes1,'Visible','Off');

ylabel(haxes2,'Axe médio-latéral(mm)','FontName','Times New Roman','FontSize',10);
set(haxes2,'Visible','Off');

ylabel(haxes3,'Axe antéro-postérieur (m/s)','FontName','Times New Roman','FontSize',10);
set(haxes3,'Visible','Off');

ylabel(haxes4,'Axe vertical(m/s)','FontName','Times New Roman','FontSize',10);
set(haxes4,'Visible','Off');
xlabel(haxes4,'Temps (sec)','FontName','Times New Roman','FontSize',10);

ylabel(haxes6,'Axe vertical(m²/s)','FontName','Times New Roman','FontSize',10);
set(haxes6,'Visible','Off');
xlabel(haxes6,'Temps (sec)','FontName','Times New Roman','FontSize',10);

h_marks_T0 = [];
h_marks_HO = [];
h_marks_TO = [];
h_marks_FC1 = [];
h_marks_FO2 = [];
h_marks_FC2= [];
Resultats = {};

%Initialisation des états d'affichages pour la vitesse
set(findobj('tag','V_intgr'),'Value',1); %Intégration
set(findobj('tag','V_der'),'Value',0); %Dérivation
set(findobj('tag','V_der_Vic'),'Value',0); %Dérivation (vicon)

%FILE MENU
h = uimenu('Parent',hObject,'Label','FILE','Tag','menu_fichier','handlevisibility','On') ;
h1= uimenu(h,'Label','NOUVEAU SUJET','handlevisibility','on') ;
uimenu(h1,'Label','Charger acquisitions','Callback',@uipushtool1_ClickedCallback);
uimenu(h1,'Label','Charger dossier','Callback',@uipushtool2_ClickedCallback) ;

uimenu(h,'Label','CHARGER SUJET','handlevisibility','On','Callback',@uipushtool4_ClickedCallback) ; %% uipushtool4_ClickedCallback(findobj('tag','uipushtool4'), eventdata, handles))
uimenu(h,'Label','DONNEES SUJET','handlevisibility','On','Tag','subject_info','Callback',@subject_info,'Enable','off') ;

%GROUP MENU
g = uimenu('Parent',hObject,'Label','MOYENNE/GROUPE','handlevisibility','On') ;
uimenu(g,'Label','NOUVEAU GROUPE','handlevisibility','on','Callback',@Group_subjects_Callback) ;
uimenu(g,'Label','AJOUTER A UN CORRIDOR','handlevisibility','on','Callback',@Corridors_add,'Tag','Corridors_add','Enable','off') ;
uimenu(g,'Label','AJOUTER A UN GROUPE','handlevisibility','on','Callback',@Group_subjects_add,'Tag','Group_subjects_add','Enable','off') ;
uimenu(g,'Label','CHARGER GROUPE','handlevisibility','on','Callback',@Group_subjects_load,'Enable','off') ;

% NOTOCORD load MENU
n = uimenu('Parent',hObject,'Label','Notocord prétraité','Tag','menu_notocord','handlevisibility','On','Enable','on') ;
uimenu(n,'Label','Charger session(s) (*_session.mat)','Callback',@load_notocord_results) ;
uimenu(n,'Label','Charger dossier de sessions (*_session.mat)','Callback',@load_notocord_results_dir) ;
uimenu(n,'Label','Ajouter session(s)','Callback',@add_notocord_results,'handlevisibility','On','Tag','add_not','Enable','off');
uimenu(n,'Label','Ajouter dossier de sessions','Callback',@add_notocord_results_dir,'handlevisibility','On','Tag','add_not_dir','Enable','off');
uimenu(n,'Label','Exporter Excel','Callback',@export_excel_notocord,'handlevisibility','On','Tag','excel_not','Enable','off');

% LFP load MENU
l = uimenu('Parent',hObject,'Label','LFP','Tag','menu_lfp','handlevisibility','On','Enable','off') ;
uimenu(l,'Label','Charger fichier (*.edf; *.trc; *.Poly5)','Callback',@load_lfp) ;
uimenu(l,'Label','Exporter format LENA (.lena)','Callback',@export_lena,'Enable','off','Tag','lena_out') ;

% EXPORT MENU
e = uimenu('Parent',hObject,'Label','EXPORT','Tag','Export','handlevisibility','On','Enable','On') ;
uimenu(e,'Label','Export evts -> c3d','Callback',@export_events);
uimenu(e,'Label','Export format commun','Callback',@export_format_commun);

% --- Outputs from this function are returned to the command line.
function varargout = Test_APA_v4_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% listbox1_Callback - Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
% Choix/Click dans la liste actualisée
global haxes1 haxes2 haxes3 haxes4 haxes6 APA TrialParams ResAPA liste_marche acq_courante flag_afficheV Notocord Resultats
% hObject    handle to listbox1 (see GCBO)

%Récupération de l'acquisition séléctionnée
pos = get(hObject,'Value');
acq_courante = liste_marche{pos};

% On check la présence de données de vitesse dérivé (pour l'affichage)
flag_der = isfield(APA.Trial(pos),'CG_Speed_d');
if flag_der
    set(findobj('tag','V_der'),'Enable','On');
    set(findobj('tag','Vy_FO1'),'Enable','On');
    set(findobj('tag','V2'),'Enable','On');
else
    set(findobj('tag','V_der'),'Value',0);
    set(findobj('tag','V_der'),'Enable','Off');
    set(findobj('tag','Vy_FO1'),'Enable','Off');
    set(findobj('tag','V2'),'Enable','Off');
end

%Initialisation des plots/axes et marqueurs si Multiplot Off
axess = findobj('Type','axes');
for i=1:length(axess)
    if get(findobj('tag','Multiplot'),'Value') %% Si bouton Multiplot pressé
        set(axess(i),'NextPlot','add'); % Multiplot On
    else
        set(axess(i),'NextPlot','replace'); % Multiplot Off
    end
end

% Affichage des courbes déplacements (CP) et Puissance/Acc
plot(haxes1,APA.Trial(pos).CP_Position.Time,APA.Trial(pos).CP_Position.Data(1,:)); axis(haxes1,'tight');
plot(haxes2,APA.Trial(pos).CP_Position.Time,APA.Trial(pos).CP_Position.Data(2,:)); axis(haxes2,'tight');

flagPF=get(findobj('tag','PlotPF'),'Value');
if ~flagPF
    set(findobj('Tag','Acc_txt'),'String','Accélération/Puissance CG');
    xlabel(haxes6,'Temps (s)','FontName','Times New Roman','FontSize',10);
    try
        plot(haxes6,APA.Trial(pos).CG_Power.Time,APA.Trial(pos).CG_Power.Data); afficheY_v2(0,':k',haxes6);
        ylabel(haxes6,'Puissance (Watt)','FontName','Times New Roman','FontSize',12);
    catch Err
    end
else
    set(findobj('Tag','Acc_txt'),'String','Trajectoire CP');
    xlabel(haxes6,'Axe Antéropostérieur(mm)','FontName','Times New Roman','FontSize',10);
    ylabel(haxes6,'Axe Médio-Latéral (mm)','FontName','Times New Roman','FontSize',10);
    plot(haxes6,APA.Trial(pos).CP_Position.Data(2,:),APA.Trial(pos).CP_Position.Data(1,:)); %axis tight
    set(haxes6,'YDir','reverse');
end

%Affichage des vitesses en fonction des choix de l'utilisateur et présence de données dérivées
flags_V = [get(findobj('tag','V_intgr'),'Value') get(findobj('tag','V_der'),'Value') get(findobj('tag','V_der_Vic'),'Value')];
flag_afficheV = sum(flags_V); %Flag d'affichage

% Extraction des maximas/minimas pour affichage des vitesses dans la bonne échelle

try
    Fech = APA.Trial(pos).CP_Position.Fech;
    T0 = round(TrialParams.Trial(pos).EventsTime(2)*Fech)-10;
    FC2 = round(TrialParams.Trial(pos).EventsTime(7)*Fech);
catch
    T0 = 100;
    FC2 = round(length(APA.Trial(pos).CP_Position.Data(1,:))/2); % Au pif
end


try
    Min_AP=min(APA.Trial(pos).CG_Speed.Data(1,T0:FC2+10))*1.25;
    Max_AP=max(APA.Trial(pos).CG_Speed.Data(1,T0:FC2+10))*1.25;
    Min_Z=min(APA.Trial(pos).CG_Speed.Data(3,T0:FC2+10))*1.25;
    Max_Z=max(APA.Trial(pos).CG_Speed.Data(3,T0:FC2+10))*1.25;
catch
    Min_AP=min(APA.Trial(pos).CG_Speed.Data(1,:));
    Max_AP=max(APA.Trial(pos).CG_Speed.Data(1,:));
    Min_Z=min(APA.Trial(pos).CG_Speed.Data(3,:));
    Max_Z=max(APA.Trial(pos).CG_Speed.Data(3,:));
end

t = APA.Trial(pos).CG_Speed.Time;
Fin = length(t);
switch flag_afficheV
    case 0 %Aucune sélection
        plot(haxes3,t,zeros(1,length(t)),'Color','w');
        plot(haxes4,t,zeros(1,length(t)),'Color','w');
    case 1
        if flags_V(2) %Courbes dérivées
            try
                plot(haxes3,t,APA.Trial(pos).CG_Speed_d.Data(1,1:Fin),'r-');
                plot(haxes4,t,APA.Trial(pos).CG_Speed_d.Data(3,1:Fin),'r-');
            catch err_size
                t = t(1:length(t)/length(APA.Trial(pos).CG_Speed_d.Data(1,:)):end);
                plot(haxes3,t,APA.Trial(pos).CG_Speed_d.Data(1,:),'r-');
                plot(haxes4,t,APA.Trial(pos).CG_Speed_d.Data(3,:),'r-');
            end
            afficheY_v2(0,':k',haxes3); afficheY_v2(0,':k',haxes4);
            try
                set(haxes3,'ylim',[Min_AP Max_AP]);
                set(haxes4,'ylim',[Min_Z Max_Z]);
            catch
                axis(haxes3,'tight');
                axis(haxes4,'tight');
            end
        elseif flags_V(3) %Courbes dérivées
            try
                plot(haxes3,t,APA.Trial(pos).CG_Speed_d_VIC.Data(1,1:Fin),'g-');
                plot(haxes4,t,APA.Trial(pos).CG_Speed_d_VIC.Data(3,1:Fin),'g-');
            catch err_size
                t = t(1:length(t)/length(APA.Trial(pos).CG_Speed_d_VIC.Data(1,:)):end);
                plot(haxes3,t,APA.Trial(pos).CG_Speed_d_VIC.Data(1,1:Fin),'g-');
                plot(haxes4,t,APA.Trial(pos).CG_Speed_d_VIC.Data(3,1:Fin),'g-');
            end
            afficheY_v2(0,':k',haxes3); afficheY_v2(0,':k',haxes4);
            try
                set(haxes3,'ylim',[Min_AP Max_AP]);
                set(haxes4,'ylim',[Min_Z Max_Z]);
            catch
                axis(haxes3,'tight');
                axis(haxes4,'tight');
            end
        else %Courbes intégrées
            plot(haxes3,t,APA.Trial(pos).CG_Speed.Data(1,1:Fin)); afficheY_v2(0,':k',haxes3);
            plot(haxes4,t,APA.Trial(pos).CG_Speed.Data(3,1:Fin)); afficheY_v2(0,':k',haxes4);
            
            try
                set(haxes3,'ylim',[Min_AP Max_AP]);
                set(haxes4,'ylim',[Min_Z Max_Z]);
            catch
                axis(haxes3,'tight');
                axis(haxes4,'tight');
            end
        end
    case 2 % 2 courbes sur 3
        if flags_V(2) %Courbes dérivées
            try
                plot(haxes3,t,APA.Trial(pos).CG_Speed_d.Data(1,1:Fin),'r-');
                plot(haxes4,t,APA.Trial(pos).CG_Speed_d.Data(3,1:Fin),'r-');
            catch err_size
                t = t(1:length(t)/length(APA.Trial(pos).CG_Speed_d.Data(1,:)):end);
                plot(haxes3,t,APA.Trial(pos).CG_Speed_d.Data(1,:),'r-');
                plot(haxes4,t,APA.Trial(pos).CG_Speed_d.Data(3,:),'r-');
            end
            afficheY_v2(0,':k',haxes3); afficheY_v2(0,':k',haxes4);
            try
                set(haxes3,'ylim',[Min_AP Max_AP]);
                set(haxes4,'ylim',[Min_Z Max_Z]);
            catch
                axis(haxes3,'tight');
                axis(haxes4,'tight');
            end
        end
        if flags_V(3) %Courbes dérivées
            try
                plot(haxes3,t,APA.Trial(pos).CG_Speed_d_VIC.Data(1,1:Fin),'g-');
                plot(haxes4,t,APA.Trial(pos).CG_Speed_d_VIC.Data(3,1:Fin),'g-');
            catch err_size
                t = t(1:length(t)/length(APA.Trial(pos).CG_Speed_d_VIC.Data(1,:)):end);
                plot(haxes3,t,APA.Trial(pos).CG_Speed_d_VIC.Data(1,1:Fin),'g-');
                plot(haxes4,t,APA.Trial(pos).CG_Speed_d_VIC.Data(3,1:Fin),'g-');
            end
            afficheY_v2(0,':k',haxes3); afficheY_v2(0,':k',haxes4);
            try
                set(haxes3,'ylim',[Min_AP Max_AP]);
                set(haxes4,'ylim',[Min_Z Max_Z]);
            catch
                axis(haxes3,'tight');
                axis(haxes4,'tight');
            end
        end
        if flags_V(1)%Courbes intégrées
            plot(haxes3,t,APA.Trial(pos).CG_Speed.Data(1,1:Fin)); afficheY_v2(0,':k',haxes3);
            plot(haxes4,t,APA.Trial(pos).CG_Speed.Data(3,1:Fin)); afficheY_v2(0,':k',haxes4);
            
            try
                set(haxes3,'ylim',[Min_AP Max_AP]);
                set(haxes4,'ylim',[Min_Z Max_Z]);
            catch
                axis(haxes3,'tight');
                axis(haxes4,'tight');
            end
        end
        
        
    case 3 %Les 3
        
        plot(haxes3,t,APA.Trial(pos).CG_Speed.Data(1,1:Fin)); afficheY_v2(0,':k',haxes3);
        plot(haxes4,t,APA.Trial(pos).CG_Speed.Data(3,1:Fin)); afficheY_v2(0,':k',haxes4);
        
        try
            plot(haxes3,t,APA.Trial(pos).CG_Speed_d.Data(1,1:Fin),'r-');
            plot(haxes4,t,APA.Trial(pos).CG_Speed_d.Data(3,1:Fin),'r-');
        catch err_size
            t = t(1:length(t)/length(APA.Trial(pos).CG_Speed_d.Data(1,:)):end);
            plot(haxes3,t,APA.Trial(pos).CG_Speed_d.Data(1,:),'r-');
            plot(haxes4,t,APA.Trial(pos).CG_Speed_d.Data(3,:),'r-');
        end
        
        try
            plot(haxes3,t,APA.Trial(pos).CG_Speed_d_VIC.Data(1,1:Fin),'g-');
            plot(haxes4,t,APA.Trial(pos).CG_Speed_d_VIC.Data(3,1:Fin),'g-');
        catch err_size
            t = t(1:length(t)/length(APA.Trial(pos).CG_Speed_d_VIC.Data(1,:)):end);
            plot(haxes3,t,APA.Trial(pos).CG_Speed_d_VIC.Data(1,1:Fin),'g-');
            plot(haxes4,t,APA.Trial(pos).CG_Speed_d_VIC.Data(3,1:Fin),'g-');
        end
        
        afficheY_v2(0,':k',haxes3); afficheY_v2(0,':k',haxes4);
        set(haxes3,'ylim',[min([Min_AP Min_AP_D]) max([Max_AP Max_AP_D])]);
        set(haxes4,'ylim',[min([Min_Z Min_Z_D]) max([Max_Z Max_Z_D])]);
end

% Si affichage automatique 'On'
if get(findobj('tag','Automatik_display'),'Value') %% Si bouton Affichage automatique pressé
    Markers_Callback(findobj('tag','Markers'));
    APA_Vitesses_Callback(findobj('tag','Vitesses'), eventdata,handles);
    if ~Notocord
        Calc_current_Callback(findobj('tag','Calc_current'), eventdata,handles); %Arret le calcul automatique
        affiche_resultat_APA(ResAPA.Trial(pos));
    else
        try
            affiche_resultat_APA(ResAPA.Trial(pos));
        catch ERR
            disp(['Aucun calcul réalisé ' acq_courante]);
        end
    end
end

set(haxes1,'XTick',NaN);
set(haxes2,'XTick',NaN);
set(haxes3,'XTick',NaN);
set(haxes4,'XTick',NaN);

%Activation des boutons/toolbars et legendes d'axes
set(findobj('tag','text_cp'),'Visible','On');
ylabel(haxes1,'Axe antéro-postérieur (mm)','FontName','Times New Roman','FontSize',10);
ylabel(haxes2,'Axe médio-latéral(mm)','FontName','Times New Roman','FontSize',10);
ylabel(haxes3,'Axe antéro-postérieur (m/s)','FontName','Times New Roman','FontSize',10);
ylabel(haxes4,'Axe vertical(m/s)','FontName','Times New Roman','FontSize',10);
xlabel(haxes6,'Temps (sec)','FontName','Times New Roman','FontSize',10);

set(findobj('tag','text_cg'),'Visible','On');
set(findobj('tag','Acc_txt'),'Visible','On');
set(findobj('tag','Group_APA'),'Visible','On');
set(findobj('tag','Calc_current'),'Visible','On');
set(findobj('tag','Calc_batch'),'Visible','On');
set(findobj('tag','Clean_data'), 'Visible','On');
set(findobj('tag','Results'), 'Visible','On');

set(findobj('tag','Markers'), 'Visible','On');
set(findobj('tag','Vitesses'),'Visible','On');
set(findobj('tag','uitable1'),'Visible','On');
set(findobj('tag','Delete_current'),'Enable','On');

%Bouton de sauvegarde
set(findobj('tag','uipushtool3'),'Enable','On');

% %Export Triggers
% if isfield(Sujet.(acq_courante),'Trigger')
%     set(findobj('tag','Export_trigs'),'Enable','On');
%     set(findobj('tag','menu_lfp'),'Enable','On');
% else
%     set(findobj('tag','Export_trigs'),'Enable','Off');
%     set(findobj('tag','menu_lfp'),'Enable','Off');
% end

%% listbox1_CreateFcn - Création de la liste
% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% Création de la liste
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% togglebutton1_Callback - Activation des boutton de Zoom/Translation
% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% Activation des boutton de Zoom/Translation
% hObject    handle to togglebutton1 (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of togglebutton1

if get(hObject,'Value')==1
    set(findobj('tag','uitoggletool1'),'Enable','On');
    set(findobj('tag','uitoggletool2'),'Enable','On');
    set(findobj('tag','uitoggletool3'),'Enable','On');
else
    set(findobj('tag','uitoggletool1'),'Enable','Off');
    set(findobj('tag','uitoggletool2'),'Enable','Off');
    set(findobj('tag','uitoggletool3'),'Enable','Off');
end

%% uipushtool1_ClickedCallback - Charger acquisition
% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% Choix fichier(s) (simple/multiple)
% hObject    handle to uipushtool1 (see GCBO)
global dossier_c3d APA TrialParams ResAPA Resultats Corridors Subject_data liste_marche Notocord

try
    %Choix manuel des fichiers
    [files dossier_c3d] = uigetfile('*.c3d; *.xls','Choix du/des fichier(s) c3d ou notocord(xls)','Multiselect','on'); %%Ajouter plus tard les autres file types
    
    %Initialisation
    Subject_data = {};
    
    % Conservation des vieux corridors/resulats ?
    if ~isempty(Corridors) || ~isempty(Resultats)
        button = questdlg('Conserver Resultats/Corridors existants?','Nouveau Sujet','Oui','Non','Non');
        if strcmp(button,'Non')
            Resultats = {};
            Corridors = {};
        end
    end
    
    %Extraction des données d'intérêts
    button_cut = questdlg('Lire toute l''acquisition?','Durée acquisition','Oui','PF','PF');
    [APA TrialParams ResAPA] = Data_Preprocessing(files,dossier_c3d(1:end-1),button_cut);
    
    % Mise à jour interface et activation des boutons
    set(findobj('tag','listbox1'), 'Visible','On');
    set(findobj('tag','togglebutton1'),'Visible','On');
    set(findobj('tag','AutoScale'),'Visible','On');
    set(findobj('tag','Multiplot'),'Visible','On');
    set(findobj('tag','APA_auto'),'Visible','On');
    set(findobj('tag','Automatik_display'),'Visible','On');
    set(findobj('tag','Results'), 'Visible','Off');
    set(findobj('tag','Results'), 'Data',zeros(30,1));
    
    set(findobj('Tag','sujet_courant'),'Enable','On');
    set(findobj('Tag','subject_info'),'Enable','On');
    set(findobj('Tag','Delete_current'),'Visible','On');
    set(findobj('tag','Export_trigs'), 'Visible','On');
    set(findobj('tag','PlotPF'), 'Visible','On');
    Notocord =0; %% Chargement de fichiers brut d'acquisitions  et non de fichiers pré-traités
    
    %Activation des axes
    axess = findobj('Type','axes');
    for i=1:length(axess)
        set(axess(i),'Visible','On');
    end
    
    %Mise à jour de la liste
    try
        set(findobj('tag','listbox1'), 'Value',1);
    catch ERR
        disp('Liste non existante');
    end
    liste_marche = arrayfun(@(i) APA.Trial(i).CP_Position.TrialName, 1:length(APA.Trial),'uni',0);
    set(findobj('tag','listbox1'),'String',liste_marche);
    
    if length(files)>1
        set(findobj('tag','Group_APA'), 'Enable','On');
        set(findobj('tag','Clean_data'), 'Enable','On');
        set(findobj('tag','Calc_batch'), 'Enable','On');
    end
    
    %     set(findobj('tag','Visu_EMG'), 'Visible','On');
    %     set(findobj('tag','visu_lfp'), 'Visible','On');
    %     set(findobj('tag','Visu_multiple'), 'Visible','On');
    
    %     if ~isempty(EMG)
    %         set(findobj('tag','Visu_EMG'), 'Enable','On');
    %         set(findobj('tag','Visu_multiple'), 'Enable','On');
    %     end
    
catch ERR
    waitfor(warndlg('Annulation chargement fichiers!'));
end

%% uipushtool2_ClickedCallback - charger dossier
% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% Choix dossier (directory)
% hObject handle to uipushtool2 (see GCBO)
global APA TrialParams ResAPA liste_marche Notocord

try
    %Choix du dossier et extraction de la liste des fichiers existants
    dossier = uigetdir(pwd,'Repertoire de stockage des acquisitions du sujet') ;
    list_rep= dir(dossier) ;
    list_rep(1) = [];
    list_rep(1) = [];
    path = cd;
    cd(dossier)
    % Extraction des fichiers et donnéers utiles
    A = dir('*.c3d');
    files = {A(:).name};
    cd(path)
    %Extraction des données d'intérêts
    button_cut = questdlg('Lire toute l''acquisition?','Durée acquisition','Oui','PF','PF');
    [APA TrialParams ResAPA] = Data_Preprocessing(files,dossier,button_cut);
    
    % Mise à jour interface et activation des boutons
    set(findobj('tag','listbox1'), 'Visible','On');
    liste_marche = arrayfun(@(i) APA.Trial(i).CP_Position.TrialName, 1:length(APA.Trial),'uni',0);
    set(findobj('tag','listbox1'),'String',liste_marche);
    set(findobj('tag','togglebutton1'),'Visible','On');
    set(findobj('tag','AutoScale'),'Visible','On');
    set(findobj('tag','Multiplot'),'Visible','On');
    set(findobj('tag','APA_auto'),'Visible','On');
    set(findobj('tag','Automatik_display'),'Visible','On');
    set(findobj('tag','Results'), 'Visible','Off');
    set(findobj('tag','Results'), 'Data',zeros(30,1));
    
    set(findobj('Tag','sujet_courant'),'Enable','On');
    set(findobj('Tag','subject_info'),'Enable','On');
    set(findobj('Tag','Delete_current'),'Visible','On');
    set(findobj('tag','Export_trigs'), 'Visible','On');
    set(findobj('tag','PlotPF'), 'Visible','On');
    Notocord =0; %% Chargement de fichiers brut d'acquisitions  et non de fichiers pré-traités
    
    %Activation des axes
    axess = findobj('Type','axes');
    for i=1:length(axess)
        set(axess(i),'Visible','On');
    end
    
    if length(files)>1
        set(findobj('tag','Group_APA'), 'Enable','On');
        set(findobj('tag','Clean_data'), 'Enable','On');
        set(findobj('tag','Calc_batch'), 'Enable','On');
    end
    
    %Mise à jour de la liste
    try
        set(findobj('tag','listbox1'), 'Value',1);
    catch ERR
        disp('Liste non existante');
    end
    
catch ERR
    waitfor(warndlg('Annulation chargement dossier'));
end

%% axes1_CreateFcn - Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
global haxes1
% hObject    handle to axes1 (see GCBO)
haxes1 = hObject;
delete(get(haxes1,'Children'));
%% axes2_CreateFcn - Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
global haxes2
% hObject    handle to axes2 (see GCBO)
haxes2 = hObject;
delete(get(haxes2,'Children'));
%% axes3_CreateFcn - Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
global haxes3
% hObject    handle to axes2 (see GCBO)
haxes3 = hObject;
delete(get(haxes3,'Children'));
%% axes4_CreateFcn - Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
global haxes4
% hObject    handle to axes2 (see GCBO)
haxes4 = hObject;
delete(get(haxes4,'Children'));

%% axes6_CreateFcn
% --- Executes during object creation, after setting all properties.
function axes6_CreateFcn(hObject, eventdata, handles)
global haxes6
% hObject    handle to axes2 (see GCBO)
haxes6 = hObject;
delete(get(haxes6,'Children'));

% --------------------------------------------------------------------
%% uipushtool4_ClickedCallback - Chargement d'un fichier deja traité
function uipushtool4_ClickedCallback(hObject, eventdata, handles)
% Chargement d'un fichier deja traité
global APA ResAPA TrialParams liste_marche acq_courante

try
    
    APA = {};
    ResAPA = {};
    TrialParams = {};
    
    [var dossier] = uigetfile('*_APA.mat','Choix du fichier APA à charger');
    if ischar(var)               
        eval(['load ' fullfile(dossier,var)]);
        eval(['APA = ' var(1:end-4)]);
        eval(['load ' strrep(fullfile(dossier,var),'APA','ResAPA')]);
        eval(['ResAPA = ' strrep(var(1:end-4),'APA','ResAPA')]);
        eval(['load ' strrep(fullfile(dossier,var),'APA','TrialParams')]);
        eval(['TrialParams = ' strrep(var(1:end-4),'APA','TrialParams')])  ;     
    end
    
    % Mise à jour interface et activation des boutons
    set(findobj('tag','listbox1'), 'Visible','On');
    liste_marche = arrayfun(@(i) APA.Trial(i).CP_Position.TrialName, 1:length(APA.Trial),'uni',0);
    set(findobj('tag','listbox1'),'String',liste_marche);
    set(findobj('tag','listbox1'), 'Value',1);
    acq_courante = liste_marche{1};
    set(findobj('tag','togglebutton1'),'Visible','On');
    set(findobj('tag','AutoScale'),'Visible','On');
    set(findobj('tag','Multiplot'),'Visible','On');
    set(findobj('tag','APA_auto'),'Visible','On');
    set(findobj('tag','Automatik_display'),'Visible','On');
    set(findobj('tag','Results'), 'Visible','Off');
    set(findobj('tag','Results'), 'Data',zeros(30,1));
    set(findobj('tag','Affich_corridor'), 'Visible','On');
    set(findobj('tag','PlotPF'), 'Visible','On');
    
    set(findobj('tag','pushbutton20','Visible','On'));
    
    set(findobj('Tag','sujet_courant'),'Enable','On');
    set(findobj('Tag','subject_info'),'Enable','On');
    set(findobj('Tag','Delete_current'),'Visible','On');
    
    if length(liste_marche)>1
        set(findobj('tag','Group_APA'), 'Enable','On');
        set(findobj('tag','Clean_data'), 'Enable','On');
        set(findobj('tag','Calc_batch'), 'Enable','On');
    end
    
    axess = findobj('Type','axes');
    for i=1:length(axess)
        set(axess(i),'Visible','On');
        set(axess(i),'NextPlot','new');
    end
    
%     % On demande d'afficher uniquement les courbes moyennes sur la liste?
%     if ~isempty(Corridors) && ~isempty(liste_actuelle)
%         button = questdlg('Choix des acquisitions à charger sur la liste?','Mise à jour liste','Tous','Corridors','Dernier','Dernier');
%         switch button
%             case 'Corridors'
%                 set(findobj('tag','listbox1'), 'String',fieldnames(Corridors));
%             case 'Tous'
%                 set(findobj('tag','listbox1'), 'String',fieldnames(Sujet));
%             otherwise
%                 set(findobj('tag','listbox1'), 'String',liste_actuelle);
%         end
%         set(findobj('tag','Affich_corridor'), 'Enable','On');
%         set(findobj('tag','Corridors_add'), 'Enable','On');
%         set(findobj('tag','Clean_corridor'), 'Visible','On');
%         set(findobj('tag','Clean_corridor'), 'Enable','On');
%     else
%         %     set(findobj('tag','listbox1'), 'String',liste_actuelle);
%         set(findobj('tag','listbox1'), 'String',fieldnames(Sujet));
%         set(findobj('tag','Affiche_corridor'), 'Enable','Off');
%         set(findobj('tag','Clean_corridor'), 'Enable','Off');
%     end
catch ERR
    disp('Annulation chargement');
end

%% uipushtool3_ClickedCallback -Sauvegarde d'un fichier en cours
% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% Sauvegarde d'un fichier en cours
% hObject    handle to uipushtool3 (see GCBO)
global APA TrialParams ResAPA 

chemin = uigetdir();
eval([APA.Infos.FileName '_APA = APA;'])
nom_fich = fullfile(chemin,[APA.Infos.FileName '_APA.mat']);
eval(['save(nom_fich,''' APA.Infos.FileName '_APA'');'])
eval([APA.Infos.FileName '_ResAPA = ResAPA;'])
nom_fich = fullfile(chemin,[ResAPA.Infos.FileName '_ResAPA.mat']);
eval(['save(nom_fich,''' ResAPA.Infos.FileName '_ResAPA'');'])
eval([APA.Infos.FileName '_TrialParams = TrialParams;'])
nom_fich = fullfile(chemin,[TrialParams.Infos.FileName '_TrialParams.mat']);
eval(['save(nom_fich,''' TrialParams.Infos.FileName '_TrialParams'');'])

% Export Excel
button = questdlg('Exporter sur Excel??','Sauvegarde résultats','Oui','Non','Non');
if strcmp(button,'Oui')
    fichier = [ResAPA.Infos.FileName '_ResAPA.xlsx'];
    champs = fieldnames(ResAPA.Trial(1));    
    Tab.tag(1,:) = [champs(end-2:end-1);champs(1:end-3)]';
    for i = 1 : length(ResAPA.Trial)
        Tab.tag(i+1,1) = {ResAPA.Trial(i).TrialName};
        Tab.tag(i+1,2) = num2cell(ResAPA.Trial(i).TrialNum);
        Tab.tag(i+1,3) = {ResAPA.Trial(i).Cote};
        for j = 2 : length(champs)-3
            Tab.data(i,j-1) = ResAPA.Trial(i).(champs{j})(1);
        end
    end
    xlswrite(fullfile(chemin,fichier),Tab.tag,1,'A1')
    xlswrite(fullfile(chemin,fichier),Tab.data,1,'D2')
else
    warndlg('Attention données non exportées!');
end


%% AutoScale_Callback - Remise à l'échelle
% --- Executes on button press in AutoScale.
function AutoScale_Callback(hObject, eventdata, handles)
% Remise à l'échelle
% hObject    handle to AutoScale (see GCBO)
axess = findobj('Type','axes');
for i=1:length(axess)
    axis(axess(i),'tight');
end

%% T0_Callback - Choix T0 (1er évt Biomécanique)
% --- Executes on button press in T0.
function T0_Callback(hObject, eventdata, handles)
% Choix T0 (1er évt Biomécanique)
global haxes3 haxes4 APA Res_APA TrialParams liste_marche acq_courante h_marks_T0
% hObject    handle to T0 (see GCBO)

pos = matchcells(liste_marche,{acq_courante});
if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end
TrialParams.Trial(pos).EventsTime(2) = Manual_click(1);

efface_marqueur_test(h_marks_T0);
h_marks_T0=affiche_marqueurs(Manual_click(1),'-r');

[C,I] = min(abs(APA.Trial(pos).CG_Speed.Time - TrialParams.Trial(pos).EventsTime(2)));
APA.Trial(pos).CG_Speed.Data(3,:) = APA.Trial(pos).CG_Speed.Data(3,:) - APA.Trial(pos).CG_Speed.Data(3,I);
ch = get(haxes4,'children');
set(ch(end),'YData',APA.Trial(pos).CG_Speed.Data(3,:));

APA.Trial(pos).CG_Speed.Data(1,:) = APA.Trial(pos).CG_Speed.Data(1,:) - APA.Trial(pos).CG_Speed.Data(1,I);
ch = get(haxes3,'children');
set(ch(end),'YData',APA.Trial(pos).CG_Speed.Data(1,:));

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% HO_Callback - Choix HO (Heel-Off)
% --- Executes on button press in HO.
function HO_Callback(hObject, eventdata, handles)
% Choix HO (Heel-Off)
global TrialParams liste_marche acq_courante h_marks_HO
% hObject    handle to HO (see GCBO)
pos = matchcells(liste_marche,{acq_courante});

if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end
TrialParams.Trial(pos).EventsTime(3) = Manual_click(1);

efface_marqueur_test(h_marks_HO);
h_marks_HO=affiche_marqueurs(Manual_click(1),'-k');

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% TO_Callback - Choix TO (Toe-Off)
% --- Executes on button press in TO.
function TO_Callback(hObject, eventdata, handles)
% Choix TO (Toe-Off)

global TrialParams liste_marche acq_courante h_marks_TO h_marks_Vy_FO1
% hObject    handle to TO (see GCBO)
pos = matchcells(liste_marche,{acq_courante});

if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end
TrialParams.Trial(pos).EventsTime(4) = Manual_click(1);

efface_marqueur_test(h_marks_TO);
efface_marqueur_test(h_marks_Vy_FO1);
h_marks_TO=affiche_marqueurs(Manual_click(1),'-b');

% % Choix sur la courbe intégrée ou dérivée
% if get(findobj('tag','V_intgr'),'Value')
%     Vy_FO1 = Sujet.(acq_courante).V_CG_AP(ind);
% else
%     try
%         Vy_FO1 = Sujet.(acq_courante).V_CG_AP_d(ind);
%     catch ERR
%         warndlg('Veuillez cocher une courbe de vitesse!!');
%         Vy_FO1 = Sujet.(acq_courante).V_CG_AP(ind);
%     end
% end
% h_marks_Vy_FO1 = plot(haxes3,Sujet.(acq_courante).t(ind),Vy_FO1,'x','Markersize',11);

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% Choix FC1 - FC1_Callback
% --- Executes on button press in FC1.
function FC1_Callback(hObject, eventdata, handles)
% Choix FC1 (Foot-Contact du pied oscillant)
global haxes4 APA TrialParams liste_marche acq_courante h_marks_FC1 h_marks_V2
% hObject    handle to FC1 (see GCBO)
pos = matchcells(liste_marche,{acq_courante});
if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end
TrialParams.Trial(pos).EventsTime(5) = Manual_click(1);
ind = find(APA.Trial(pos).CG_Speed.Time>= Manual_click(1),1,'first') - 1;

efface_marqueur_test(h_marks_FC1);
efface_marqueur_test(h_marks_V2);

h_marks_FC1=affiche_marqueurs(Manual_click(1),'-m');
% Choix sur la courbe intégrée ou dérivée
if get(findobj('tag','V_intgr'),'Value')
    V2 = APA.Trial(pos).CG_Speed.Data(3,ind);
else
    try
        V2 = APA.Trial(pos).CG_Speed_d.Data(3,ind);
    catch ERR
        warndlg('Veuillez cocher une courbe de vitesse!!');
        V2 = APA.Trial(pos).CG_Speed.Data(3,ind);
    end
end

h_marks_V2 = plot(haxes4,APA.Trial(pos).CG_Speed.Time(ind),V2,'x','Markersize',11);

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% FO2_Callback - Choix FO2
% --- Executes on button press in FO2.
function FO2_Callback(hObject, eventdata, handles)
% Choix FO2 (Foot-Off du pied d'appui)
global TrialParams liste_marche acq_courante h_marks_FO2
% hObject    handle to FO2 (see GCBO)
pos = matchcells(liste_marche,{acq_courante});
if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end
TrialParams.Trial(pos).EventsTime(6) = Manual_click(1);

efface_marqueur_test(h_marks_FO2);
h_marks_FO2=affiche_marqueurs(Manual_click(1),'-g');

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% FC2_Callback -  Choix FC2
% --- Executes on button press in FC2.
function FC2_Callback(hObject, eventdata, handles)
% Choix FC2 (Foot-Contact du pied d'appui)
global TrialParams liste_marche acq_courante h_marks_FC2
% hObject    handle to FC2 (see GCBO)
pos = matchcells(liste_marche,{acq_courante});
if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end
TrialParams.Trial(pos).EventsTime(7) = Manual_click(1);

efface_marqueur_test(h_marks_FC2);
h_marks_FC2=affiche_marqueurs(Manual_click(1),'-c');

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% yAPA_AP_Callback - Detection manuelle du déplacement postérieur max du CP lors des APA
% --- Executes on button press in yAPA_AP.
function yAPA_AP_Callback(hObject, eventdata, handles)
% Detection manuelle du déplacement postérieur max du CP lors des APA
global  ResAPA APA TrialParams liste_marche acq_courante 
% hObject    handle to yAPA_AP (see GCBO)
pos = matchcells(liste_marche,{acq_courante});
set(findobj('tag','APA_auto'),'Value',0)
if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end

ind = find(APA.Trial(pos).CP_Position.Time>= Manual_click(1),1,'first') - 1;

%Stockage du résultats
ResAPA.Trial(pos).APAy(1:2) = [mean(APA.Trial(pos).CP_Position.Data(1,round(TrialParams.Trial(pos).EventsTime(1)*APA.Trial(pos).CP_Position.Fech):round(TrialParams.Trial(pos).EventsTime(2)*APA.Trial(pos).CP_Position.Fech))) - APA.Trial(pos).CP_Position.Data(1,ind) ind];

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% yAPA_ML_Callback - Detection valeur minimale/maximale du déplacement médiolatéral du CP lors des APA
% --- Executes on button press in yAPA_ML.
function yAPA_ML_Callback(hObject, eventdata, handles)
global  ResAPA APA TrialParams liste_marche acq_courante 
% Detection valeur minimale/maximale du déplacement médiolatéral du CP lors des APA
% hObject    handle to yAPA_ML (see GCBO)
pos = matchcells(liste_marche,{acq_courante});
set(findobj('tag','APA_auto'),'Value',0)
if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end

ind = find(APA.Trial(pos).CP_Position.Time>= Manual_click(1),1,'first') - 1;

%Stockage du résultats
ResAPA.Trial(pos).APAy_lateral = [abs(mean(APA.Trial(pos).CP_Position.Data(2,round(TrialParams.Trial(pos).EventsTime(1)*APA.Trial(pos).CP_Position.Fech):round(TrialParams.Trial(pos).EventsTime(2)*APA.Trial(pos).CP_Position.Fech))) - APA.Trial(pos).CP_Position.Data(2,ind))...
    ind];

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% Vy_FO1_Callback - Détection manuelle de la Vitesse AP du CG lors de FO1
% --- Executes on button press in Vy_FO1.
function Vy_FO1_Callback(hObject, eventdata, handles)
% Détection manuelle de la Vitesse AP du CG lors de FO1
% global haxes3 Sujet acq_courante h_marks_Vy_FO1
% pos = matchcells(liste_marche,{acq_courante});
% set(findobj('tag','APA_auto'),'Value',0)
% % hObject    handle to Vy_FO1 (see GCBO)
% % Choix sur la courbe dérivée
% if get(findobj('tag','V_der_Vic'),'Value') && get(findobj('tag','V_der'),'Value') && ~get(findobj('tag','V_intgr'),'Value')
%     if ~ismac
%         Manual_click = ginput(1);
%     else
%         Manual_click = myginput(1,'crosshair');
%     end
%     ind = find(Sujet.(acq_courante).t >= Manual_click(1),1,'first') - 1;
%     
%     efface_marqueur_test(h_marks_Vy_FO1);
%     Vy_FO1 = Sujet.(acq_courante).V_CG_AP_d(ind);
%     h_marks_Vy_FO1 = plot(haxes3,Sujet.(acq_courante).t(ind),Vy_FO1,'x','Markersize',11);
%     %Réactualisation de VyFO1 et recalcul des largeur/longueur du pas
%     Sujet.(acq_courante).primResultats.Vy_FO1 = [ind Vy_FO1];
%     %Réactualisation des calculs
%     Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles)
% else
%     waitfor(warndlg('VyFO1 dépend de TO!!'));
% end
waitfor(warndlg('VyFO1 dépend de TO!!'));

%% Vm_Callback - Détection manuelle Vitesse max AP du CG
% --- Executes on button press in Vm.
function Vm_Callback(hObject, eventdata, handles)
% Détection manuelle Vitesse max AP du CG
% hObject    handle to Vm (see GCBO)
global  ResAPA APA  liste_marche acq_courante 
pos = matchcells(liste_marche,{acq_courante});
set(findobj('tag','APA_auto'),'Value',0)
if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end

ind = find(APA.Trial(pos).CG_Speed.Time>= Manual_click(1),1,'first') - 1;

% Choix sur la courbe intégrée ou dérivée
if get(findobj('tag','V_intgr'),'Value')
    Vm = APA.Trial(pos).CG_Speed.Data(1,ind);
else
    try
        Vm = APA.Trial(pos).CG_Speed_d.Data(1,ind);
    catch ERR
        waitfor(warndlg('Veuillez cocher une courbe de vitesse!!'));
        Vm = APA.Trial(pos).CG_Speed.Data(1,ind)
    end
end

% Stockage du résultats
ResAPA.Trial(pos).Vm = [Vm ind];

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% Vmin_APA_Callback - Détection manuelle Vitesse min verticale du CG lors des APA
% --- Executes on button press in Vmin_APA.
function Vmin_APA_Callback(hObject, eventdata, handles)
% Détection manuelle Vitesse min verticale du CG lors des APA
global  ResAPA APA  liste_marche acq_courante 
% hObject    handle to Vmin_APA (see GCBO)
pos = matchcells(liste_marche,{acq_courante});
set(findobj('tag','APA_auto'),'Value',0)
if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end
ind = find(APA.Trial(pos).CG_Speed.Time>= Manual_click(1),1,'first') - 1;

% Choix sur la courbe intégrée ou dérivée
if get(findobj('tag','V_intgr'),'Value')
    Vmin_APA = APA.Trial(pos).CG_Speed.Data(3,ind);
else
    try
        Vmin_APA = APA.Trial(pos).CG_Speed_d.Data(3,ind);
    catch ERR
        waitfor(warndlg('Veuillez cocher une courbe de vitesse!!'));
        Vmin_APA = APA.Trial(pos).CG_Speed.Data(3,ind);
    end
end

% Stockage du résultats
ResAPA.Trial(pos).VZmin_APA = [Vmin_APA ind];

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% V1_Callback - Détection manuelle du 1er min de la Vitesse vertciale du CG lors de l'éxecution du pas
% --- Executes on button press in V1.
function V1_Callback(hObject, eventdata, handles)
% Détection manuelle du 1er min de la Vitesse vertciale du CG lors de l'éxecution du pas
global ResAPA APA  liste_marche acq_courante 
% hObject    handle to V1 (see GCBO)
pos = matchcells(liste_marche,{acq_courante});
set(findobj('tag','APA_auto'),'Value',0)
if ~ismac
    Manual_click = ginput(1);
else
    Manual_click = myginput(1,'crosshair');
end
ind = find(APA.Trial(pos).CG_Speed.Time>= Manual_click(1),1,'first') - 1;

% Choix sur la courbe intégrée ou dérivée
if get(findobj('tag','V_intgr'),'Value')
    V1 = APA.Trial(pos).CG_Speed.Data(3,ind);
else
    try
        V1 = APA.Trial(pos).CG_Speed_d.Data(3,ind);
    catch ERR
        waitfor(warndlg('Veuillez cocher une courbe de vitesse!!'));
        V1 = APA.Trial(pos).CG_Speed.Data(3,ind);
    end
end

% Stockage du résultats
ResAPA.Trial(pos).V1 = [V1 ind];

Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;

%% V2_Callback - Détection manuelle de la Vitesse vertciale du CG lors du FC1
% --- Executes on button press in V2.
function V2_Callback(hObject, eventdata, handles)
% Détection manuelle de la Vitesse vertciale du CG lors du FC1
global ResAPA APA  liste_marche acq_courante 
% Choix sur la courbe dérivée
% if get(findobj('tag','V_der'),'Value')
%     if ~ismac
%         Manual_click = ginput(1);
%     else
%         Manual_click = myginput(1,'crosshair');
%     end
%     %ind = round(Manual_click(1)*Sujet.(acq_courante).Fech)+1;
%     ind = find(Sujet.(acq_courante).t >= Manual_click(1),1,'first') - 1;
%     
%     efface_marqueur_test(h_marks_V2);
%     V2 = Sujet.(acq_courante).V_CG_Z_d(ind);
%     h_marks_V2 = plot(haxes4,Sujet.(acq_courante).t(ind),V2,'x','Markersize',11,'Color','m','Linewidth',1.5);
%     %Réactualisation de VyFO1 et recalcul des largeur/longueur du pas
%     Sujet.(acq_courante).primResultats.V2 = [ind V2];
%     %Réactualisation des calculs
%     Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles)
% else
%     waitfor(warndlg('V2 dépend de FC1!!'));
% end
waitfor(warndlg('V2 dépend de FC1!!'));

%% Markers_Callback - Affichage des marqueurs de l'acquisition courante/sélectionnée
% --- Executes on button press in Markers.
function Markers_Callback(hObject, eventdata, handles)
% Affichage des marqueurs de l'acquisition courante/sélectionnée
global haxes1 TrialParams liste_marche acq_courante h_marks_T0 h_marks_HO h_marks_TO h_marks_FC1 h_marks_FO2 h_marks_FC2  ...
    h_marks_Trig h_trig_txt h_marks_FOG h_FOG_txt
% hObject    handle to Markers (see GCBO)

%Nettoyage des axes d'abord (??Laisser si Multiplot On??)
efface_marqueur_test(h_marks_T0);
efface_marqueur_test(h_marks_HO);
efface_marqueur_test(h_marks_TO);
efface_marqueur_test(h_marks_FC1);
efface_marqueur_test(h_marks_FO2);
efface_marqueur_test(h_marks_FC2);

efface_marqueur_test(h_marks_Trig);
efface_marqueur_test(h_trig_txt);
efface_marqueur_test(h_marks_FOG);
efface_marqueur_test(h_FOG_txt);

ind_acq = matchcells(liste_marche,{acq_courante});

%Actualisation des marqueurs
h_marks_T0 = affiche_marqueurs(TrialParams.Trial(ind_acq).EventsTime(2),'-r');
h_marks_HO = affiche_marqueurs(TrialParams.Trial(ind_acq).EventsTime(3),'-k');
h_marks_TO = affiche_marqueurs(TrialParams.Trial(ind_acq).EventsTime(4),'-b');
h_marks_FC1 = affiche_marqueurs(TrialParams.Trial(ind_acq).EventsTime(5),'-m');
h_marks_FO2 = affiche_marqueurs(TrialParams.Trial(ind_acq).EventsTime(6),'-g');
h_marks_FC2 = affiche_marqueurs(TrialParams.Trial(ind_acq).EventsTime(7),'-c');

%Affichage du trigger externe (si existe) et si pas trop éloigné
if ~isnan(TrialParams.Trial(ind_acq).EventsTime(1))
    h_marks_Trig = affiche_marqueurs(TrialParams.Trial(ind_acq).EventsTime(1),'*-k');
    h_trig_txt = text(TrialParams.Trial(ind_acq).EventsTime(1),1000,'GO/Trigger',...
        'VerticalAlignment','middle',...
        'HorizontalAlignment','left',...
        'FontSize',8,...
        'Parent',haxes1);
end

%Activation des boutons de modification manuelle des marqueurs
set(findobj('tag','T0'),'Visible','On');
set(findobj('tag','HO'),'Visible','On');
set(findobj('tag','TO'),'Visible','On');
set(findobj('tag','FC1'),'Visible','On');
set(findobj('tag','FO2'),'Visible','On');
set(findobj('tag','FC2'),'Visible','On');

%% Vitesses_Callback - Affichage des pics de Vitesse déjà calculés
% --- Executes on button press in Vitesses.
function APA_Vitesses_Callback(hObject, eventdata, handles)
% Affichage des pics de Vitesse déjà calculés
global haxes1 haxes2 haxes3 haxes4 APA ResAPA liste_marche acq_courante h_marks_APAy1 h_marks_APAy2 h_marks_Vy_FO1 h_marks_Vm h_marks_VZ_min h_marks_V1 h_marks_V2
% hObject    handle to Vitesses (see GCBO)

pos = matchcells(liste_marche,{acq_courante});

%Nettoyage des axes d'abord (??Laisser si Multiplot On??)
efface_marqueur_test(h_marks_APAy1);
efface_marqueur_test(h_marks_APAy2);
efface_marqueur_test(h_marks_Vy_FO1);
efface_marqueur_test(h_marks_Vm);
efface_marqueur_test(h_marks_VZ_min);
efface_marqueur_test(h_marks_V1);
efface_marqueur_test(h_marks_V2);

axess = findobj('Type','axes');
for i=1:length(axess)
    set(axess(i),'NextPlot','add'); % Multiplot On
end

%Affichage des APA et vitesses
try
    h_marks_APAy1 = plot(haxes1,APA.Trial(pos).CP_Position.Time(ResAPA.Trial(pos).APAy(2)),APA.Trial(pos).CP_Position.Data(1,ResAPA.Trial(pos).APAy(2)),'x','Markersize',11);
    h_marks_APAy2 = plot(haxes2,APA.Trial(pos).CP_Position.Time(ResAPA.Trial(pos).APAy_lateral(2)),APA.Trial(pos).CP_Position.Data(2,ResAPA.Trial(pos).APAy_lateral(2)),'x','Markersize',11);
catch NO_APA
    disp('Calcul automatique des APA AP et ML non réalisé');
end

try
    h_marks_Vy_FO1 = plot(haxes3,APA.Trial(pos).CG_Speed.Time(round(ResAPA.Trial(pos).Vy_FO1(2))),ResAPA.Trial(pos).Vy_FO1(1),'x','Markersize',11);
catch ERr_FO1
end

try
    h_marks_Vm = plot(haxes3,APA.Trial(pos).CG_Speed.Time(ResAPA.Trial(pos).Vm(2)),ResAPA.Trial(pos).Vm(1),'x','Markersize',11,'Color','r','Linewidth',1.5);
catch ERr_Vm
end

try
    h_marks_VZ_min = plot(haxes4,APA.Trial(pos).CG_Speed.Time(ResAPA.Trial(pos).VZmin_APA(2)),ResAPA.Trial(pos).VZmin_APA(1),'x','Markersize',11,'Color','k');
catch ERr_Vz_min
end

try
    h_marks_V1 = plot(haxes4,APA.Trial(pos).CG_Speed.Time(ResAPA.Trial(pos).V1(2)),ResAPA.Trial(pos).V1(1),'x','Markersize',11,'Color','r','Linewidth',1.25);
catch ERr_V1
end

try
    h_marks_V2 = plot(haxes4,APA.Trial(pos).CG_Speed.Time(ResAPA.Trial(pos).V2(2)),ResAPA.Trial(pos).V2(1),'x','Markersize',11,'Color','m','Linewidth',1.5);
catch ERr_V2
end

%Activation des bouton de modification manuelle des vitesses
set(findobj('tag','yAPA_AP'),'Visible','On');
set(findobj('tag','yAPA_ML'),'Visible','On');
set(findobj('tag','Vy_FO1'),'Visible','On');
set(findobj('tag','Vm'),'Visible','On');
set(findobj('tag','Vmin_APA'),'Visible','On');
set(findobj('tag','V1'),'Visible','On');

set(findobj('tag','V_der'),'Visible','On');
set(findobj('tag','V_der_Vic'),'Visible','On');
set(findobj('tag','V_intgr'),'Visible','On');

%% Calc_current_Callback - Calculs des APA sur l'acquisition selectionnée
% --- Executes on button press in Calc_current.
function Calc_current_Callback(hObject, eventdata, handles)
% Calculs des APA sur l'acquisition selectionnée
% hObject    handle to Calc_current (see GCBO)
global APA ResAPA TrialParams liste_marche acq_courante

pos = matchcells(liste_marche,{acq_courante});

if get(findobj('tag','APA_auto'),'Value')
    ResAPA.Trial(pos) = calcul_auto_APA_marker(APA.Trial(pos),TrialParams.Trial(pos),ResAPA.Trial(pos));
end
ResAPA.Trial(pos) = calculs_parametres_initiationPas_v4(APA.Trial(pos),TrialParams.Trial(pos),ResAPA.Trial(pos));
%Affichage
Current_Res = affiche_resultat_APA(ResAPA.Trial(pos));

function CR = affiche_resultat_APA(Acq)
%% Mise à jour des resultats sur le tableau d'affichage
CR={};
% if isfield(Acq,'primResultats') %% Si les calculs n'ont pas été
%     Acq = calculs_parametres_initiationPas_v1(Acq);
% end

param = fieldnames(Acq);
for i=1:length(param)
    CR{i,1} = param{i};
    if isstr(Acq.(param{i}))
        CR{i,2} = Acq.(param{i});
    elseif isnumeric(Acq.(param{i}))
        CR{i,2} = Acq.(param{i})(1);
    end
end
set(findobj('tag','Results'),'Data',CR);

%% Calc_batch_Callback - Calculs des APA sur toutes les acquisitions
% --- Executes on button press in Calc_batch.
function Calc_batch_Callback(hObject, eventdata, handles)
% Calculs des APA sur toutes les acquisitions
% hObject    handle to Calc_batch (see GCBO)
global APA ResAPA TrialParams liste_marche

% Calculs
wb = waitbar(0);
set(wb,'Name','Please wait... Calculating data');

for i=1:length(liste_marche)
    waitbar(i/length(liste_marche),wb,['Calcul acquisition: ' liste_marche{i}]);
        try
            if get(findobj('tag','APA_auto'),'Value')
                ResAPA.Trial(i) = calcul_auto_APA_marker(APA.Trial(i),TrialParams.Trial(i),ResAPA.Trial(i));
            end
            ResAPA.Trial(i) = calculs_parametres_initiationPas_v4(APA.Trial(i),TrialParams.Trial(i),ResAPA.Trial(i));
        catch No_data
            disp(['Erreur calcul: ' liste_marche{i}]);
        end
end
close(wb);

%% V_der_Callback - Etat d'affichage de la vitesse obtenue par dérivation
% --- Executes on button press in V_der.
function V_der_Callback(hObject, eventdata, handles)
% Etat d'affichage de la vitesse obtenue par dérivation
global haxes3 haxes4 APA liste_marche acq_courante flag_afficheV
% hObject    handle to V_der (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of V_der
pos = matchcells(liste_marche,{acq_courante});
flags_V = [get(findobj('tag','V_intgr'),'Value') get(findobj('tag','V_der'),'Value') get(findobj('tag','V_der_Vic'),'Value')];
flag_afficheV = sum(flags_V); %Flag d'affichage
if get(hObject,'Value')
    if flag_afficheV==2
        set(haxes3,'Nextplot','add');
        set(haxes4,'Nextplot','add');
    end
    if isfield(APA.Trial(pos),'CG_Speed_d')
        plot(haxes3,APA.Trial(pos).CG_Speed_d.Time,APA.Trial(pos).CG_Speed_d.Data(1,:),'r-');
        plot(haxes4,APA.Trial(pos).CG_Speed_d.Time,APA.Trial(pos).CG_Speed_d.Data(3,:),'r-');
    else
        disp('Pas de vitesse calculée à partir de la dérivé du CoM')
    end
end

%% V_der_VICON_Callback - Etat d'affichage de la vitesse obtenue par dérivation pour le CG de VICON
% --- Executes on button press in V_der_Vic.
function V_der_VICON_Callback(hObject, eventdata, handles)
% Etat d'affichage de la vitesse obtenue par dérivation pour le CG de VICON
global haxes3 haxes4 APA liste_marche acq_courante flag_afficheV
% hObject    handle to V_der (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of V_der
pos = matchcells(liste_marche,{acq_courante});
flags_V = [get(findobj('tag','V_intgr'),'Value') get(findobj('tag','V_der'),'Value') get(findobj('tag','V_der_Vic'),'Value')];
flag_afficheV = sum(flags_V); %Flag d'affichage
if get(hObject,'Value')
    if flag_afficheV==2
        set(haxes3,'Nextplot','add');
        set(haxes4,'Nextplot','add');
    end
    if isfield(APA.Trial(pos),'CG_Speed_d_VIC')
        plot(haxes3,APA.Trial(pos).CG_Speed_d_VIC.Time,APA.Trial(pos).CG_Speed_d_VIC.Data(1,:),'r-');
        plot(haxes4,APA.Trial(pos).CG_Speed_d_VIC.Time,APA.Trial(pos).CG_Speed_d_VIC.Data(3,:),'r-');
    else
        disp('Pas de vitesse calculée à partir de la dérivé du CoM_VICON')
    end
end

%% V_intgr_Callback - Etat d'affichage de la vitesse obtenue par intégration
% --- Executes on button press in V_intgr.
function V_intgr_Callback(hObject, eventdata, handles)
% Etat d'affichage de la vitesse obtenue par intégration
global haxes3 haxes4 APA liste_marche acq_courante flag_afficheV
% hObject    handle to V_intgr (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of V_intgr
pos = matchcells(liste_marche,{acq_courante});
flags_V = [get(findobj('tag','V_intgr'),'Value') get(findobj('tag','V_der'),'Value') get(findobj('tag','V_der_Vic'),'Value')];
flag_afficheV = sum(flags_V); %Flag d'affichage
if get(hObject,'Value')
    if flag_afficheV==2
        set(haxes3,'Nextplot','add');
        set(haxes4,'Nextplot','add');
    end
    if isfield(APA.Trial(pos),'CG_Speed')
        plot(haxes3,APA.Trial(pos).CG_Speed.Time,APA.Trial(pos).CG_Speed.Data(1,:),'b-');
        plot(haxes4,APA.Trial(pos).CG_Speed.Time,APA.Trial(pos).CG_Speed.Data(3,:),'b-');
    else
        disp('Pas de vitesse calculée à partir de la dérivé du CoM_VICON')
    end
end

%% Clean_data_Callback - Nettoyage des données en éliminant manuellement les mauvaises acquisitions
% --- Executes on button press in Clean_data.
function Clean_data_Callback(hObject, eventdata, handles)
% Nettoyage des données en éliminant manuellement les mauvaises acquisitions
global APA Res_APA TrialParams liste_marche clean
% hObject    handle to Clean_data (see GCBO)

%Extraction des acquisitions sur la liste
% listes_acqs = filednames(Sujet);

%Sélections de l'utilisateur
[ind_acq,v] = listdlg('PromptString',{'Nettoyage données','Choix des acquisitions à vérifier'},...
    'ListSize',[300 300],...
    'ListString',liste_marche);

%Affichage dans une nouvelle fenêtre contrôlable (clean)
clean=figure;
c=uicontextmenu('Parent',clean);
cb1 = 'mouse_actions_APA(''identify'')';
cb2 = 'mouse_actions_APA(''gait_suppression'')';
uimenu(c, 'Label', 'Repérer/déséléctionner acquisition', 'Callback',cb1);
uimenu(c, 'Label', 'Supprimer marche', 'Callback',cb2);

%Création des fenêtres
h1 = subplot(411); hold on
ylabel('Déplacement CP AP (mm)');
h2 = subplot(412); hold on
ylabel('Déplacement CP ML (mm)');
h3 = subplot(413); hold on
ylabel('Vitesse CG AP (m/sec)');
h4 = subplot(414); hold on
ylabel('Vitesse CG verticale (m/sec)');

%Chargement des acquisitions et affichage dans la fenêtre de contrôle
acqs = liste_marche(ind_acq);
try
    for i = 1:length(acqs)
        tags = extract_tags(acqs{i});
        
        
        if ~strcmp(tags(end),'KO')
            endFC2 = round(TrialParams.Trial(ind_acq(i)).EventsTime(7)*(APA.Trial(ind_acq(i)).CP_Position.Fech));
            try
                plot(h1,APA.Trial(ind_acq(i)).CP_Position.Data(1,1:endFC2),'ButtonDownFcn',@maselection,'uicontextmenu',c,'displayname',acqs{i});
                plot(h2,APA.Trial(ind_acq(i)).CP_Position.Data(2,1:endFC2),'ButtonDownFcn',@maselection,'uicontextmenu',c,'displayname',acqs{i});
                plot(h3,APA.Trial(ind_acq(i)).CG_Speed.Data(1,1:endFC2),'ButtonDownFcn',@maselection,'uicontextmenu',c,'displayname',acqs{i});
                plot(h4,APA.Trial(ind_acq(i)).CG_Speed.Data(3,1:endFC2),'ButtonDownFcn',@maselection,'uicontextmenu',c,'displayname',acqs{i});
            catch FC2_far
                plot(h1,APA.Trial(ind_acq(i)).CP_Position.Data(1,:),'ButtonDownFcn',@maselection,'uicontextmenu',c,'displayname',acqs{i});
                plot(h2,APA.Trial(ind_acq(i)).CP_Position.Data(2,:),'ButtonDownFcn',@maselection,'uicontextmenu',c,'displayname',acqs{i});
                plot(h3,APA.Trial(ind_acq(i)).CG_Speed.Data(1,:),'ButtonDownFcn',@maselection,'uicontextmenu',c,'displayname',acqs{i});
                plot(h4,APA.Trial(ind_acq(i)).CG_Speed.Data(3,:),'ButtonDownFcn',@maselection,'uicontextmenu',c,'displayname',acqs{i});
            end
        end
    end
    %On retire les mauvaises acquisitions de la variable Sujet et on remet à jour la liste et la variable Resultats
    msgbox('Cliquez sur les courbes/acquisitions à retirer (click droit pour déséléctionner) - puis appuyer sur OK');
catch ERR
    warndlg('!!Une seule acquisition chargée!!');
end

%% Automatik_display_Callback
% --- Executes on button press in Automatik_display.
function Automatik_display_Callback(hObject, eventdata, handles)
% hObject    handle to Automatik_display (see GCBO)
% Hint: get(hObject,'Value') returns toggle state of Automatik_display

%% Test_APA_v4_ResizeFcn
% --- Executes when Test_APA_v4 is resized.
function Test_APA_v4_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to Test_APA_v4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Group_APA_Callback - Moyennage des acquisitions sélectionnées et stockage dans une variable acquisition (Corridors)
% --- Executes on button press in Group_APA.
function Group_APA_Callback(hObject, eventdata, handles)
% Moyennage des acquisitions sélectionnées et stockage dans une variable acquisition (Corridors)
global APA ResAPA TrialParams  Corridors
% hObject    handle to Group_APA (see GCBO)

%Extraction des acquisitions
button = questdlg('Choisir parmis toutes les acquisitions (Oui)?, ou celles de la liste (Non)?','Calcul corridor','Oui','Non','Non');
if strcmp(button,'Oui') % On affiche le corridor dans une nouvelle fenêtre de visualisation de l'interface
    listes_acqs = fieldnames(Sujet);
else
    listes_acqs = cellstr(get(findobj('tag','listbox1'),'String'));
end

%Choix du nom de la moyenne
groupe_acqs = cell2mat(inputdlg('Entrez le nom du groupe d''acquisitions','Calcul corridor Moyen'));

%Sélections de l'utilisateur
try
    [acqs,v] = listdlg('PromptString',{strcat('Group ',groupe_acqs),'Choix des acquisitions à inclure dans le group'},...
        'ListSize',[300 300],...
        'ListString',listes_acqs);
    
    %Stockage des acquisitions choisies dans une structure équivalente
    Group_data={};
    Moy_data={};
    Group_emg={};
    Activation_emg={};
    Group_lfp={};
    Side = {};
    
    for i=1:length(acqs)
        tags = extract_tags(listes_acqs{acqs(i)});
        if ~strcmp(tags(end),'KO') && ~isfield(Corridors,listes_acqs{acqs(i)}) %% Retire les acquisitions 'KO' (NOtocord) et Corridors
            
            Group_data.(listes_acqs{acqs(i)}) = Sujet.(listes_acqs{acqs(i)});
            try
                Group_emg.(listes_acqs{acqs(i)}) = EMG.(listes_acqs{acqs(i)});
            catch ErrEMG
                disp(['Pas d''EMGs pour l''acquisition: ' listes_acqs{acqs(i)}]);
            end
            
            try
                Group_lfp.(listes_acqs{acqs(i)}) = LFP.(listes_acqs{acqs(i)}); % Pour la visu (données réechantillonés à Freq_vis)
                Group_lfp_raw.(listes_acqs{acqs(i)}) = LFP_raw.(listes_acqs{acqs(i)}); % Données brut durant l'essai
                Group_lfp_base.(listes_acqs{acqs(i)}) = LFP_base.(listes_acqs{acqs(i)}); % Données baseline
            catch ErrLFP
                disp(['Pas de LFPs pour l''acquisition: ' listes_acqs{acqs(i)}]);
            end
            
            if ~isfield(Resultats,listes_acqs{acqs(i)}) % Calculs des paramètres si non effectués
                disp(['Calculs acquisition ' listes_acqs{acqs(i)}]);
                if Notocord
                    Resultats.(listes_acqs{acqs(i)})=calculs_parametres_initiationPas_Not(Sujet.(listes_acqs{acqs(i)}),Resultats.(listes_acqs{acqs(i)}));
                else
                    Resultats.(listes_acqs{acqs(i)})=calculs_parametres_initiationPas_v1(Sujet.(listes_acqs{acqs(i)}));
                end
            end
            
            try
                Side{i} = Resultats.(listes_acqs{acqs(i)}).Cote; %Extraction Coté
                tagss = extract_tags(listes_acqs{acqs(i)});
                Cnd{i} = tagss{3}; %Extraction Condition de Marche
            catch isNotocord
                Side{i} = Resultats.(listes_acqs{acqs(i)}).Pied;
                Cnd{i} = Resultats.(listes_acqs{acqs(i)}).Condition;
            end
            
            try
                if isfield(Activation_EMG_percycle,listes_acqs{acqs(i)}) % Moyenneage des activations EMG (si existent)
                    % Rassembler les periodes d'activation EMG
                    Activation_emg.(listes_acqs{acqs(i)}) = Activation_EMG_percycle.(listes_acqs{acqs(i)});
                else
                    disp(['Pas d''activations EMG pour l''acquisition: ' listes_acqs{acqs(i)}]);
                end
            catch ERR
                disp('Pas de calcul moyen EMG');
            end
            
            Moy_data.(listes_acqs{acqs(i)}) = Resultats.(listes_acqs{acqs(i)});
        end
    end
    

    
    
    %Calcul du corridor et des resultats moyens
    [Res_moy Res_group Ecarts_res] = regroupe_acquisitions(Moy_data);
    % [Acq_moy Data_group Ecarts_acqs] = regroupe_acquisitions_v2(Group_norm);
    butTri = questdlg('Trier par condition?','Tri automatique','Oui','Non','Non');
    if strcmp(butTri,'Oui')
        choixC = inputdlg({'Condition à sélectionner?'},'Choix TRi',1);
        choixC = cell2mat(choixC);
        [Acq_moy Data_group Ecarts_acqs] = regroupe_acquisitions_v3Not(Group_norm,Side,Cnd,choixC);
    else
        [Acq_moy Data_group Ecarts_acqs] = regroupe_acquisitions_v4(Group_norm,Side);
    end
    
    %Stockage
    Corridors.(groupe_acqs) = Data_group;
    Sujet.(groupe_acqs) = Acq_moy;
    Resultats.(groupe_acqs) = Res_moy;
        
    %Affichage
    set(findobj('tag','Affich_corridor'), 'Visible','On');
    set(findobj('tag','Affich_corridor'), 'Enable','On');
    set(findobj('tag','Corridors_add'), 'Enable','On');
    set(findobj('tag','Clean_corridor'), 'Visible','On');
    set(findobj('tag','Clean_corridor'), 'Enable','On');
    button = questdlg('Afficher corridor ?','Affichage interface','Oui','Non','Non');
    if strcmp(button,'Oui') % On affiche le corridor dans une nouvelle fenêtre de visualisation de l'interface
        Affich_corridor_Callback(findobj('tag','Affich_corridor'), groupe_acqs);
    end
    
    % On demande si on veut supprimer les acquisitions
    button = questdlg('Retirer les acquisitions du groupe de la liste ?','Réduction de la liste','Oui','Non','Non');
    listes_acqs = [listes_acqs;groupe_acqs];
    if strcmp(button,'Oui') % On supprime uniquement de la liste les acquisitions qui ont été prises dans les groupe
        listes_acqs(acqs,:)=[];
    end
    set(findobj('tag','listbox1'), 'Value',1);
    set(findobj('tag','listbox1'),'String',listes_acqs);
    
catch ERR
    warndlg('Arret création groupe');
end

%% Corridors_add - Ajout d'acquisition(s) à un corridor existant
function Corridors_add(hObject, eventdata, handles)
% Ajout d'acquisition(s) à un corridor existant
global Sujet Resultats Corridors Activation_EMG_percycle Notocord EMG Corridors_EMG
% hObject    handle to Corridors_add (see GCBO)
try
    %Choix du corridors
    listes_grp = fieldnames(Corridors);
    %Sélections de l'utilisateur
    [i,v] = listdlg('PromptString',{'Choix du corridor à incrémenter'},...
        'ListSize',[300 300],...
        'ListString',listes_grp);
    
    groupe_acqs = cell2mat(listes_grp(i));
    
    listes_acqs = fieldnames(Sujet);
    [acqs,v] = listdlg('PromptString',{strcat('Group ',groupe_acqs),'Choix des acquisitions à ajouter dans le corridor'},...
        'ListSize',[300 300],...
        'ListString',listes_acqs);
    
    %Stockage des acquisitions choisies dans une structure équivalente
    Group_data={};
    Moy_data={};
    Group_emg={};
    Activation_emg={};
    for i=1:length(acqs)
        Group_data.(listes_acqs{acqs(i)}) = Sujet.(listes_acqs{acqs(i)});
        try
            Group_emg.(listes_acqs{acqs(i)}) = EMG.(listes_acqs{acqs(i)});
        catch ErrEMG
            disp(['Pas d''EMGs pour l''acquisition: ' listes_acqs{acqs(i)}]);
        end
        
        if ~isfield(Resultats,listes_acqs{acqs(i)}) % Calculs des paramètres si non effectués
            disp(['Calculs groupe ' listes_acqs{acqs(i)}]);
            if Notocord
                Resultats.(listes_acqs{acqs(i)})=calculs_parametres_initiationPas_Not(Sujet.(listes_acqs{acqs(i)}),Resultats.(listes_acqs{acqs(i)}));
            else
                Resultats.(listes_acqs{acqs(i)})=calculs_parametres_initiationPas_v1(Sujet.(listes_acqs{acqs(i)}));
            end
        end
        
        try
            if isfield(Activation_EMG_percycle,listes_acqs{acqs(i)}) % Moyenneage des activations EMG (si existent)
                % Rassembler les periodes d'activation EMG
                Activation_emg.(listes_acqs{acqs(i)}) = Activation_EMG_percycle.(listes_acqs{acqs(i)});
            else
                disp(['Pas d''activations EMG pour l''acquisition: ' listes_acqs{acqs(i)}]);
            end
        catch ERR
            disp('Pas de calcul moyen EMG');
        end
        
        Moy_data.(listes_acqs{acqs(i)}) = Resultats.(listes_acqs{acqs(i)});
    end
    
    %Normalisation des nouvelles données
    if isempty(Group_emg)
        Group_norm = normalise_APA_v2(Group_data);
    else
        [Group_norm EMGs_norm] = normalise_APA_v4(Group_data,Group_emg);
        [EMG_moy_new EMG_group_new Ecarts_emg_new] = regroupe_acquisitions(EMGs_norm);
    end
    
    %Moyennage des activations EMG
    EMG_activation_moy={};
    if ~isempty(Activation_emg)
        EMG_activation_moy_new = regroupe_EMGs(Activation_emg);
        try
            EMG_activation_moy_old = Activation_EMG_percycle.(groupe_acqs);
        catch ERrEMG %pas d'activation au groupe précedent
            EMG_activation_moy_old ={};
        end
        
        if isempty(EMG_activation_moy_old)
            EMG_activation_moy = EMG_activation_moy_new;
        else
            tmp_emg.old_grp = EMG_activation_moy_old;
            tmp_emg.new_grp = EMG_activation_moy_new;
            EMG_activation_moy = regroupe_EMGs(tmp_emg);
        end
        
    end
    
    %Création d'un groupe provisoire
    [Acq_moy_new Data_group_new Ecarts_acqs_new] = regroupe_acquisitions_v2(Group_norm);
    
    %Ajout du groupe
    Group_data2.add_acqs = Data_group_new;
    Group_data2.old_group = Corridors.(groupe_acqs);
    
    %Renormalisation avec le corridor de base
    if isempty(Group_emg)
        Group_norm2 = normalise_APA_v2(Group_data2);
    else
        Group_emg2.add_acqs = EMG_group_new;
        Group_emg2.old_group = Corridors_EMG.(groupe_acqs);
        [Group_norm2 EMGs_norm2] = normalise_APA_v4(Group_data2,Group_emg2);
        [EMG_moy_all EMG_group Ecarts_emg] = regroupe_corridors(EMGs_norm2);
    end
    
    
    Acqs_moy.add_acqs  = Acq_moy_new;
    Acqs_moy.old_group = Sujet.(groupe_acqs);
    Moy_data.old_group = Resultats.(groupe_acqs);
    
    %Calcul du corridor et des resultats moyens
    [Corr_moy Data_group Ecarts_corrs] = regroupe_corridors(Group_norm2);
    [Acq_moy Data_group2 Ecarts_acqs] = regroupe_acquisitions_v2(Acqs_moy);
    [Res_moy Res_group Ecarts_res] = regroupe_acquisitions(Moy_data);
    
    %Stockage
    Corridors.(groupe_acqs) = Data_group;
    Sujet.(groupe_acqs) = Acq_moy;
    Resultats.(groupe_acqs) = Res_moy;
    
    %EMG
    if ~isempty(Group_emg)
        Corridors_EMG.(groupe_acqs) = EMG_group;
        Activation_EMG_percycle.(groupe_acqs) = EMG_activation_moy;
        Muscles = fieldnames(EMG_moy_all);
        EMG.(groupe_acqs).nom = Muscles;
        EMG.(groupe_acqs).Fech = EMG.(listes_acqs{acqs(i)}).Fech;
        
        for m = 1:length(Muscles)
            EMG.(groupe_acqs).val(:,m) = EMG_moy_all.(Muscles{m})';
        end
    end
    %Affichage
    set(findobj('tag','Affich_corridor'), 'Visible','On');
    set(findobj('tag','Affich_corridor'), 'Enable','On');
    set(findobj('tag','Clean_corridor'), 'Visible','On');
    set(findobj('tag','Clean_corridor'), 'Enable','On');
    button = questdlg('Afficher corridor ?','Affichage interface','Oui','Non','Non');
    if strcmp(button,'Oui') % On affiche le corridor dans une nouvelle fenêtre de visualisation de l'interface
        Affich_corridor_Callback(findobj('tag','Affich_corridor'), groupe_acqs);
    end
    
    % On demande si on veut supprimer les acquisitions
    button = questdlg('Retirer les acquisitions du groupe de la liste ?','Réduction de la liste','Oui','Non','Non');
    if strcmp(button,'Oui') % On supprime uniquement de la liste les acquisitions qui ont été prises dans les groupe
        listes_acqs(acqs,:)=[];
        set(findobj('tag','listbox1'), 'Value',1);
        set(findobj('tag','listbox1'),'String',listes_acqs);
    end
catch ERrt
    warndlg('Arrêt ajout groupe!');
end

%% Group_subjects_Callback - Moyennage des acquisitions des sujets sélectionnés et stockage dans une variable acquisition (Group)
% --- Executes on button press in Group_subjects.
function Group_subjects_Callback(hObject, eventdata, handles)
% Moyennage des acquisitions des sujets sélectionnés et stockage dans une variable acquisition (Group)
global Sujet Resultats Corridors Activation_EMG_percycle Notocord Group EMG Corridors_EMG
% hObject    handle to Group_subjects (see GCBO)

%Extraction des corridors
listes_acqs = fieldnames(Corridors);

%Choix du nom du group
groupe_acqs = cell2mat(inputdlg('Entrez le nom du groupe:','Calcul corridor groupe'));

%Sélections de l'utilisateur
try
    [acqs,v] = listdlg('PromptString',{strcat('Group ',groupe_acqs),'Choix des corridors à inclure dans le group'},...
        'ListSize',[300 300],...
        'ListString',listes_acqs);
    
    %Stockage des acquisitions choisies dans une structure équivalente
    Group_data={};
    Moy_data={};
    Group_emg={};
    Group_emg2={};
    Activation_emg={};
    
    for i=1:length(acqs)
        Group_data.(listes_acqs{acqs(i)}) = Corridors.(listes_acqs{acqs(i)});
        Group_data2.(listes_acqs{acqs(i)}) = Sujet.(listes_acqs{acqs(i)}); %% Pour calculer les marqueurs temporels moyens
        
        try
            Group_emg.(listes_acqs{acqs(i)}) = Corridors_EMG.(listes_acqs{acqs(i)});
        catch ErrEMG
            disp(['Pas de corridor EMG pour le groupe: ' listes_acqs{acqs(i)}]);
        end
        
        try
            Group_emg2.(listes_acqs{acqs(i)}) = EMG.(listes_acqs{acqs(i)});
        catch ErrEMG2
            disp(['Pas d''EMG moyen pour le groupe: ' listes_acqs{acqs(i)}]);
        end
        
        if ~isfield(Resultats,listes_acqs{acqs(i)}) % Calculs des paramètres si non effectués
            disp(['Calculs groupe ' listes_acqs{acqs(i)}]);
            if Notocord
                Resultats.(listes_acqs{acqs(i)})=calculs_parametres_initiationPas_Not(Sujet.(listes_acqs{acqs(i)}),Resultats.(listes_acqs{acqs(i)}));
            else
                Resultats.(listes_acqs{acqs(i)})=calculs_parametres_initiationPas_v1(Sujet.(listes_acqs{acqs(i)}));
            end
        end
        
        try
            if isfield(Activation_EMG_percycle,listes_acqs{acqs(i)}) % Moyenneage des activations EMG (si existent)
                % Rassembler les periodes d'activation EMG
                Activation_emg.(listes_acqs{acqs(i)}) = Activation_EMG_percycle.(listes_acqs{acqs(i)});
            else
                disp(['Pas d''activations EMG pour le groupe: ' listes_acqs{acqs(i)}]);
            end
        catch ERR
            disp('Pas de calcul moyen EMG');
        end
        
        Moy_data.(listes_acqs{acqs(i)}) = Resultats.(listes_acqs{acqs(i)});
    end
    
    
    %Normalisation des données brutes
    if isempty(Group_emg)
        Group_norm = normalise_APA_v2(Group_data);
        Group_norm2 = normalise_APA_v2(Group_data2);
    else
        %     [Group_norm EMGs_norm] = normalise_APA_v4(Group_data,Group_emg);
        [Group_norm EMGs_norm] = normalise_Corridors(Group_data,Group_emg);
        [Group_norm2 EMGs_norm2] = normalise_APA_v4(Group_data2,Group_emg2);
    end
    
    %Moyennage des activations EMG
    EMG_activation_moy={};
    if ~isempty(Activation_emg)
        EMG_activation_moy = regroupe_EMGs(Activation_emg);
    end
    
    %Calcul du corridor et des resultats moyens
    [Corr_moy Data_group Ecarts_corrs] = regroupe_corridors(Group_norm);
    [Corr_emg_moy EMG_group_all Ecarts_corrs] = regroupe_corridors(EMGs_norm);
    [Acq_moy Data_group2 Ecarts_acqs] = regroupe_acquisitions_v2(Group_norm2);
    [Res_moy Res_group Ecarts_res] = regroupe_acquisitions(Moy_data);
    [EMG_moy EMG_group_moy Ecarts_emg] = regroupe_acquisitions(EMGs_norm2);
    
    %Stockage
    Group.(groupe_acqs) = Data_group;
    Corridors.(groupe_acqs) = Data_group;
    Sujet.(groupe_acqs) = Acq_moy;
    Resultats.(groupe_acqs) = Res_moy;
    
    %EMG
    if ~isempty(Group_emg)
        Corridors_EMG.(groupe_acqs) = EMG_group_all;
        if ~isempty(EMG_activation_moy)
            Activation_EMG_percycle.(groupe_acqs) = EMG_activation_moy;
        end
        Muscles = fieldnames(EMG_moy);
        EMG.(groupe_acqs).nom = Muscles;
        EMG.(groupe_acqs).Fech = EMG.(listes_acqs{acqs(i)}).Fech;
        
        for m = 1:length(Muscles)
            EMG.(groupe_acqs).val(:,m) = EMG_moy.(Muscles{m})';
        end
    end
    
    %Affichage
    set(findobj('tag','Affich_corridor'), 'Visible','On');
    set(findobj('tag','Affich_corridor'), 'Enable','On');
    set(findobj('tag','Clean_corridor'), 'Visible','On');
    set(findobj('tag','Clean_corridor'), 'Enable','On');
    set(findobj('tag','Group_subjects_add'),'Enable','On');
    button = questdlg('Afficher corridor ?','Affichage interface','Oui','Non','Non');
    if strcmp(button,'Oui') % On affiche le corridor dans une nouvelle fenêtre de visualisation de l'interface
        Affich_corridor_Callback(findobj('tag','Affich_corridor'), groupe_acqs);
    end
    
    % On demande si on veut supprimer les acquisitions
    button = questdlg('Retirer les acquisitions du groupe de la liste ?','Réduction de la liste','Oui','Non','Non');
    if strcmp(button,'Oui') % On supprime uniquement de la liste les acquisitions qui ont été prises dans les groupe
        listes_acqs(acqs,:)=[];
        set(findobj('tag','listbox1'), 'Value',1);
        set(findobj('tag','listbox1'),'String',listes_acqs);
    end
catch ERR
    warndlg('Arret création groupe');
end

%% Group_subjects_add - Ajout de corridors à un group existant
function Group_subjects_add(hObject, eventdata, handles)
% Ajout de corridors à un group existant
global Sujet Resultats Corridors Activation_EMG_percycle Notocord Group EMG Corridors_EMG
% hObject    handle to Group_subjects_add (see GCBO)

try
    %Choix du groupe
    listes_grp = fieldnames(Group);
    %Sélections de l'utilisateur
    [i,v] = listdlg('PromptString',{'Choix du goupe à incrémenter'},...
        'ListSize',[300 300],...
        'ListString',listes_grp);
    
    groupe_acqs = cell2mat(listes_grp(i));
    
    listes_acqs = fieldnames(Corridors);
    [acqs,v] = listdlg('PromptString',{strcat('Group ',groupe_acqs),'Choix des corridors à inclure dans le group'},...
        'ListSize',[300 300],...
        'ListString',listes_acqs);
    
    %Stockage des acquisitions choisies dans une structure équivalente
    Group_data={};
    Moy_data={};
    Group_emg={};
    Group_emg2={};
    Activation_emg={};
    for i=1:length(acqs)
        Group_data.(listes_acqs{acqs(i)}) = Corridors.(listes_acqs{acqs(i)});
        Group_data2.(listes_acqs{acqs(i)}) = Sujet.(listes_acqs{acqs(i)}); %% Pour calculer les marqueurs temporels moyens
        
        try
            Group_emg.(listes_acqs{acqs(i)}) = Corridors_EMG.(listes_acqs{acqs(i)});
        catch ErrEMG
            disp(['Pas de corridor EMG pour le groupe: ' listes_acqs{acqs(i)}]);
        end
        
        try
            Group_emg2.(listes_acqs{acqs(i)}) = EMG.(listes_acqs{acqs(i)});
        catch ErrEMG2
            disp(['Pas d''EMG moyen pour le groupe: ' listes_acqs{acqs(i)}]);
        end
        
        if ~isfield(Resultats,listes_acqs{acqs(i)}) % Calculs des paramètres si non effectués
            disp(['Calculs groupe ' listes_acqs{acqs(i)}]);
            if Notocord
                Resultats.(listes_acqs{acqs(i)})=calculs_parametres_initiationPas_Not(Sujet.(listes_acqs{acqs(i)}),Resultats.(listes_acqs{acqs(i)}));
            else
                Resultats.(listes_acqs{acqs(i)})=calculs_parametres_initiationPas_v1(Sujet.(listes_acqs{acqs(i)}));
            end
        end
        
        try
            if isfield(Activation_EMG_percycle,listes_acqs{acqs(i)}) % Moyenneage des activations EMG (si existent)
                % Rassembler les periodes d'activation EMG
                Activation_emg.(listes_acqs{acqs(i)}) = Activation_EMG_percycle.(listes_acqs{acqs(i)});
            else
                disp(['Pas d''activations EMG pour l''acquisition: ' listes_acqs{acqs(i)}]);
            end
        catch ERR
            disp('Pas de calcul moyen EMG');
        end
        
        Moy_data.(listes_acqs{acqs(i)}) = Resultats.(listes_acqs{acqs(i)});
    end
    
    %Ajout du groupe
    Group_data.(groupe_acqs) = Group.(groupe_acqs);
    Group_data2.(groupe_acqs) = Sujet.(groupe_acqs);
    
    %Normalisation des données brutes
    if isempty(Group_emg)
        Group_norm = normalise_APA_v2(Group_data);
        Group_norm2 = normalise_APA_v2(Group_data2);
    else
        Group_emg.(groupe_acqs) = Corridors_EMG.(groupe_acqs);
        Group_emg2.(groupe_acqs) = EMG.(groupe_acqs);
        [Group_norm EMGs_norm] = normalise_APA_v4(Group_data,Group_emg);
        [Group_norm2 EMGs_norm2] = normalise_APA_v4(Group_data2,Group_emg2);
        [EMG_all_moy EMG_group_all Ecarts_corrs] = regroupe_corridors(EMGs_norm);
        [EMG_Acq_moy EMG_group_moy Ecarts_acqs] = regroupe_acquisitions(EMGs_norm2);
    end
    
    %Moyennage des activations EMG
    EMG_activation_moy={};
    if ~isempty(Activation_emg)
        EMG_activation_moy_new = regroupe_EMGs(Activation_emg);
        try
            EMG_activation_moy_old = Activation_EMG_percycle.(groupe_acqs);
        catch ERrEMG %pas d'activation au groupe précedent
            EMG_activation_moy_old ={};
        end
        
        if isempty(EMG_activation_moy_old)
            EMG_activation_moy = EMG_activation_moy_new;
        else
            tmp_emg.old_grp = EMG_activation_moy_old;
            tmp_emg.new_grp = EMG_activation_moy_new;
            EMG_activation_moy = regroupe_EMGs(tmp_emg);
        end
        
    end
    
    %Calcul du corridor et des resultats moyens
    [Corr_moy Data_group Ecarts_corrs] = regroupe_corridors(Group_norm);
    [Acq_moy Data_group2 Ecarts_acqs] = regroupe_acquisitions_v2(Group_norm2);
    [Res_moy Res_group Ecarts_res] = regroupe_acquisitions(Moy_data);
    
    %Stockage
    Group.(groupe_acqs) = Data_group;
    Corridors.(groupe_acqs) = Data_group;
    Sujet.(groupe_acqs) = Acq_moy;
    Resultats.(groupe_acqs) = Res_moy;
    
    %EMG
    if ~isempty(Group_emg)
        Corridors_EMG.(groupe_acqs) = EMG_group_all;
        Activation_EMG_percycle.(groupe_acqs) = EMG_activation_moy;
        Muscles = fieldnames(EMG_all_moy);
        EMG.(groupe_acqs).nom = Muscles;
        EMG.(groupe_acqs).Fech = EMG.(listes_acqs{acqs(i)}).Fech;
        
        try
            for m = 1:length(Muscles)
                EMG.(groupe_acqs).val(:,m) = EMG_all_moy.(Muscles{m})';
            end
        catch Err_size
            EMG = rmfield(EMG.(groupe_acqs),'val');
            for m = 1:length(Muscles)
                EMG.(groupe_acqs).val(:,m) = EMG_all_moy.(Muscles{m})';
            end
        end
        
    end
    %Affichage
    set(findobj('tag','Affich_corridor'), 'Visible','On');
    set(findobj('tag','Affich_corridor'), 'Enable','On');
    set(findobj('tag','Clean_corridor'), 'Visible','On');
    set(findobj('tag','Clean_corridor'), 'Enable','On');
    button = questdlg('Afficher corridor ?','Affichage interface','Oui','Non','Non');
    if strcmp(button,'Oui') % On affiche le corridor dans une nouvelle fenêtre de visualisation de l'interface
        Affich_corridor_Callback(findobj('tag','Affich_corridor'), groupe_acqs);
    end
    
    % On demande si on veut supprimer les acquisitions
    button = questdlg('Retirer les acquisitions du groupe de la liste ?','Réduction de la liste','Oui','Non','Non');
    if strcmp(button,'Oui') % On supprime uniquement de la liste les acquisitions qui ont été prises dans les groupe
        listes_acqs(acqs,:)=[];
        set(findobj('tag','listbox1'), 'Value',1);
        set(findobj('tag','listbox1'),'String',listes_acqs);
    end
catch ERrt
    warndlg('Arrêt ajout groupe!');
end

%% Affich_corridor_Callback - Affichage des corridors pour les données brutes
% --- Executes on button press in Affich_corridor.
function Affich_corridor_Callback(hObject, eventdata, handles)
% Affichage des corridors pour les données brutes
global axes1 axes2 axes3 axes4 Corridors Sujet list Sujet_tmp listes_corr i t
% hObject    handle to Affich_corridor (see GCBO)
Sujet_tmp = Sujet;
choix_corr = {};
%Extraction des corridors calculés
try
    legendes={};
    if isempty(eventdata)
        listes_corr = fieldnames(Corridors);
        %Sélections de l'utilisateur
        [i,v] = listdlg('PromptString',{'Choix du corridor à afficher'},...
            'ListSize',[300 300],...
            'ListString',listes_corr,'SelectionMode','Multiple');
    else
        if iscell(eventdata)
            listes_corr = eventdata;
            i = 1:size(listes_corr,1);
        else
            listes_corr{1} = eventdata;
            i = 1;
        end
    end
    
    buttonSTD = questdlg('Modifier Epaisseur corridors?','Affichage Corridors','Oui','Non','Oui');
    if strcmp(buttonSTD,'Oui')
        facK = inputdlg({'(0-1)'},'Facteur de réduction ?',1,{'1'});
        facK = str2double(facK);
    else
        facK = 1;
    end
    
    listes_acqs = fieldnames(Sujet_tmp);
    %Affichage
    % Création de l'interface de visu
    f = figure();
    b = uiextras.HBox( 'Parent', f);
    b1 = uiextras.VBox( 'Parent', b);
    %Ajout de la liste sans la moyenne du/des corridor(s) venant d'être calculé(s)
    list = uicontrol( 'Style', 'listbox', 'Parent', b, 'String', listes_acqs,'Callback',@list_Callback);
    
    axes1 = axes( 'Parent', b1, ...
        'ActivePositionProperty', 'Position','xticklabel',[]);
    
    colors={'r' 'g' 'b' 'm' 'k' 'c' 'y'};
    for k=1:length(i)
        t=(0:size(Corridors.(listes_corr{i(k)}).CP_AP,2)-1)*1/max(Corridors.(listes_corr{i(k)}).Fech);
        Offset_CPAP = Sujet_tmp.(listes_corr{i(k)}).CP_AP(1)*1e-1;
        try
            h_corr_CP_AP = stdshade(Corridors.(listes_corr{i(k)}).CP_AP*1e-1-Offset_CPAP,0.3,colors{k},t,1,axes1,[],[],facK);
        catch more_than7corrs
            h_corr_CP_AP = stdshade(Corridors.(listes_corr{i(k)}).CP_AP*1e-1-Offset_CPAP,0.3,[(k-0.5)/length(i) (k-1)/length(i) k/length(i)],t,1,axes1,[],[],facK);
        end
        
        txt1 = listes_corr{i(k)};
        txt2 = [listes_corr{i(k)} '±1STD'];
        txt1(regexp(txt1,'_'))=' ';
        txt2(regexp(txt2,'_'))=' ';
        legendes{2*(k-1)+1} = txt1;
        legendes{2*k} = txt2;
    end
    ylabel(axes1,'Déplacememt AP CP (cm)');
    axis tight
    
    legend(legendes);
    
    axes2 = axes( 'Parent', b1, ...
        'ActivePositionProperty', 'Position','xticklabel',[]);
    for k=1:length(i)
        t=(0:size(Corridors.(listes_corr{i(k)}).CP_ML,2)-1)*1/max(Corridors.(listes_corr{i(k)}).Fech);
        if isfield(Corridors.(listes_corr{i(k)}),'CP_ML_D') || isfield(Corridors.(listes_corr{i(k)}),'CP_ML_G')
            try
                Offset_CPMLD = nanmean(Corridors.(listes_corr{i(1)}).CP_ML_D(:,1))*1e-1;
                stdshade(Corridors.(listes_corr{i(k)}).CP_ML_D*1e-1-Offset_CPMLD,0.3,colors{k},t,1,axes2,[],[],facK);
            catch NO_CP_D
                disp('Pas de moyennage côté D!');
            end
            
            try
                Offset_CPMLG = nanmean(Corridors.(listes_corr{i(1)}).CP_ML_G(:,1))*1e-1;
                stdshade(Corridors.(listes_corr{i(k)}).CP_ML_G*1e-1-Offset_CPMLG,0.3,[colors{k} '--'],t,1,axes2,[],[],facK);
            catch NO_CP_G
                disp('Pas de moyennage côté G!');
            end
            %             legend('Pied D','','Pied G','');
        else
            Offset_CPML = Sujet_tmp.(listes_corr{i(k)}).CP_ML(1)*1e-1;
            try
                h_corr_CP_ML = stdshade(Corridors.(listes_corr{i(k)}).CP_ML*1e-1-Offset_CPML,0.3,colors{k},t,1,axes2,[],[],facK);
            catch more_than7corrs
                h_corr_CP_ML = stdshade(Corridors.(listes_corr{i(k)}).CP_ML*1e-1-Offset_CPML,0.3,[(k-0.5)/length(i) (k-1)/length(i) k/length(i)],t,1,axes2,[],[],facK);
            end
        end
    end
    ylabel(axes2,'Déplacememt ML CP (cm)');
    axis tight
    
    axes3 = axes( 'Parent', b1, ...
        'ActivePositionProperty', 'Position','xticklabel',[]);
    for k=1:length(i)
        t=(0:size(Corridors.(listes_corr{i(k)}).V_CG_AP,2)-1)*1/max(Corridors.(listes_corr{i(k)}).Fech);
        if get(findobj('tag','V_intgr'),'Value')
            try
                h_corr_CG_AP = stdshade(Corridors.(listes_corr{i(k)}).V_CG_AP,0.3,colors{k},t,1,axes3,[],[],facK);
            catch more_than7corrs
                h_corr_CG_AP = stdshade(Corridors.(listes_corr{i(k)}).V_CG_AP,0.3,[(k-0.5)/length(i) (k-1)/length(i) k/length(i)],t,1,axes3,[],[],facK);
            end
        else
            try
                h_corr_CG_AP = stdshade(Corridors.(listes_corr{i(k)}).V_CG_AP_d,0.3,colors{k},t,1,axes3,[],[],facK);
            catch more_than7corrs
                h_corr_CG_AP = stdshade(Corridors.(listes_corr{i(k)}).V_CG_AP_d,0.3,[(k-0.5)/length(i) (k-1)/length(i) k/length(i)],t,1,axes3,[],[],facK);
            end
        end
    end
    ylabel(axes3,'Vitesse CG AP (m/sec)');
    axis tight
    
    axes4 = axes( 'Parent', b1, ...
        'ActivePositionProperty', 'Position');
    xlabel(axes4,'Temps (sec)')
    
    for k=1:length(i)
        fin = size(Corridors.(listes_corr{i(k)}).V_CG_Z,2);
        t=(0:fin-1)*1/max(Corridors.(listes_corr{i(k)}).Fech);
        V_CG_Z = Corridors.(listes_corr{i(k)}).V_CG_Z;
        
        if get(findobj('tag','V_intgr'),'Value')
            try
                h_corr_CG_Z = stdshade(V_CG_Z,0.3,colors{k},t,1,axes4,[],[],facK);
            catch more_than7corrs
                h_corr_CG_Z = stdshade(V_CG_Z,0.3,[(k-0.5)/length(i) (k-1)/length(i) k/length(i)],t,1,axes4,[],[],facK);
            end
        else
            try
                h_corr_CG_Z = stdshade(V_CG_Z_d,0.3,colors{k},t,1,axes4,[],[],facK);
            catch more_than7corrs
                h_corr_CG_Z = stdshade(V_CG_Z_d,0.3,[(k-0.5)/length(i) (k-1)/length(i) k/length(i)],t,1,axes4,[],[],facK);
            end
        end
    end
    axis tight
    
    ylabel(axes4,'Vitesse CG Z (m/sec)');
    
catch ERR
    waitfor(warndlg('!!!Pas de corridors calculés/sélectionnés!!!'));
end

%% list_Callback - Affichage courbes avec corridors
% --- Execute when pressing corridor interface list
function list_Callback(hObj,eventdata,handles)
% Affichage courbes avec corridors
global axes1 axes2 axes3 axes4 Sujet_tmp list listes_corr i t T_FC1_base

%Récupération de l'acquisition séléctionnée et affichage
try
    contents = cellstr(get(list,'String'));
    acq_choisie = contents{get(list,'Value')};
    t_0 = Sujet_tmp.(acq_choisie).t(1);
    T0 = round((Sujet_tmp.(acq_choisie).tMarkers.T0-t_0)*Sujet_tmp.(acq_choisie).Fech);
    
    dimm = length(t);
    
    %Recalage sur le Foot-Contact (ne marche pas)
    FC1 = round((Sujet_tmp.(acq_choisie).tMarkers.FC1-t_0)*Sujet_tmp.(acq_choisie).Fech) - T0;
    FC1_corr = round(T_FC1_base*Sujet_tmp.(listes_corr{i(1)}).Fech);
    decalage_V = abs(FC1 - FC1_corr);
    V_CG_Z = Sujet_tmp.(acq_choisie).V_CG_Z;
    %     V_CG_Z_d = Sujet_tmp.(acq_choisie).V_CG_Z_d;
    diff = dimm - length(V_CG_Z(T0+decalage_V:end));
    
    
    if diff<0
        try
            V_CG_Z = V_CG_Z(T0+decalage_V:end+diff);
        catch Errt
            V_CG_Z = [Nan*ones(abs(T0+decalage_V),1) V_CG_Z(1:end+diff)];
        end
    else
        try
            V_CG_Z = [V_CG_Z(T0+decalage_V:end);NaN*ones(diff,1)];
        catch Errrt
            V_CG_Z = [Nan*ones(abs(T0+decalage_V),1) V_CG_Z(1:end) NaN*ones(diff,1)];
        end
    end
    
    txt = acq_choisie;
    txt(regexp(acq_choisie,'_')) = ' ';
    
    Offset_CPAP = Sujet_tmp.(acq_choisie).CP_AP(1)*1e-1;%-Sujet_tmp.(listes_corr{i(1)}).CP_AP(1);
    try
        hh1 = plot(axes1,t,Sujet_tmp.(acq_choisie).CP_AP*1e-1-Offset_CPAP,'r','Linewidth',1.5);
    catch Err_CPAP
        tt = Sujet_tmp.(acq_choisie).t;
        hh1 = plot(axes1,tt,Sujet_tmp.(acq_choisie).CP_AP*1e-1-Offset_CPAP,'r','Linewidth',1.5);
    end
    
    set(hh1,'Displayname',txt);
    affiche_label(hh1,txt,axes1);    axis(axes1,'tight');
    
    Offset_CPML = Sujet_tmp.(acq_choisie).CP_ML(1)*1e-1;%-Sujet_tmp.(listes_corr{i(1)}).CP_ML(1);
    try
        hh2 = plot(axes2,t,Sujet_tmp.(acq_choisie).CP_ML*1e-1-Offset_CPML,'r','Linewidth',1.5);
    catch Err_CPML
        tt = Sujet_tmp.(acq_choisie).t;
        hh2 = plot(axes2,tt,Sujet_tmp.(acq_choisie).CP_ML*1e-1-Offset_CPML,'r','Linewidth',1.5);
    end
    
    set(axes2,'Visible','On');
    affiche_label(hh2,txt,axes2);    axis(axes2,'tight');
    
    try
        hh3 = plot(axes3,t,Sujet_tmp.(acq_choisie).V_CG_AP,'r','Linewidth',1.5);
    catch Err_V_CG
        tt = Sujet_tmp.(acq_choisie).t;
        hh3 = plot(axes3,tt,Sujet_tmp.(acq_choisie).V_CG_AP,'r','Linewidth',1.5);
    end
    
    affiche_label(hh3,txt,axes3);    axis(axes3,'tight');
    
    %      hh4 = plot(,tt,V_CG_Z,'r','Linewidth',1.5);
    
    try
        hh4 = plot(axes4,t,Sujet_tmp.(acq_choisie).V_CG_Z,'r','Linewidth',1.5);
    catch Err_V_CG
        tt = Sujet_tmp.(acq_choisie).t;
        hh3 = plot(axes4,tt,Sujet_tmp.(acq_choisie).V_CG_Z,'r','Linewidth',1.5);
    end
    affiche_label(hh4,txt,axes4);    axis(axes4,'tight');
    
catch ERR
    waitfor(warndlg('Fermer et recharger la fenêtre de visu des corrdidors!','Redraw corridors'));
end

%% subject_info -Enregistrement des données sujet
% --- Execute when choosing to set subject data
function Data = subject_info(hObj,eventdata,handles)
% Enregistrement des données sujet
global Subject_data

prompt = {'ID','Nom','Sexe',...
    'Age (ans)','Pathologie'};

if ~isempty(Subject_data)
    def = {num2str(Subject_data.ID),Subject_data.Name,Subject_data.Sexe,num2str(Subject_data.Age),Subject_data.Patho};
else
    def = {'ID','Nom','M','25','Sain'};
end

try
    rep = inputdlg(prompt,'Données Sujet',1,def);
    Data.ID = rep{1};
    Data.Name = rep{2};
    Data.Sexe = rep{3};
    Data.Age = str2double(rep{4});
    Data.Patho = rep{5};
    
    Subject_data = Data;
catch ERR
    disp('Erreur acquisition données sujet');
end

%% Clean_corridor_Callback - Retirer un corridor si mauvais
% --- Executes on button press in Clean_corridor.
function Clean_corridor_Callback(hObject, eventdata, handles)
% Retirer un corridor si mauvais
global Sujet Corridors Resultats Corridors_EMG EMG Activation_EMG_percycle LFP Corridors_LFP
% hObject    handle to Clean_corridor (see GCBO)

try
    listes_corr = fieldnames(Corridors);
    %Sélections de l'utilisateur
    [i,v] = listdlg('PromptString',{'Choix du/des corridor(s) à effacer'},...
        'ListSize',[300 300],...
        'ListString',listes_corr,'SelectionMode','Multiple');
    
    for corrd=1:length(i)
        try
            Sujet = rmfield(Sujet,listes_corr{i(corrd)});
            Resultats = rmfield(Resultats,listes_corr{i(corrd)});
            EMG = rmfield(EMG,listes_corr{i(corrd)});
            LFP = rmfield(LFP,listes_corr{i(corrd)});
        catch ERr_S
        end
        Corridors = rmfield(Corridors,listes_corr{i(corrd)});
        Corridors_EMG = rmfield(Corridors_EMG,listes_corr{i(corrd)});
        Activation_EMG_percycle = rmfield(Activation_EMG_percycle,listes_corr{i(corrd)});
        Corridors_LFP = rmfield(Corridors_LFP,listes_corr{i(corrd)});
    end
    
    disp('Corridors supprimés');
    listes_corr{i}
    
    listes_corr_post = fieldnames(Corridors);
    if isempty(listes_corr_post)
        set(findobj('tag','Affich_corridor'), 'Enable','Off');
        set(findobj('tag','Clean_corridor'), 'Enable','Off');
    end
    
catch ERR
    warndlg('!!Pas de Corridors calculés!!')
end

%% Delete_current_Callback
% --- Executes on button press in Delete_current.
function Delete_current_Callback(hObject, eventdata, handles)
global APA ResAPA TrialParams liste_marche acq_courante
% hObject    handle to Delete_current (see GCBO)
pos = matchcells(liste_marche,{acq_courante});

%Supression de l'acquisition séléctionné
APA.removedTrials = [APA.removedTrials,APA.Trial(pos)];
ResAPA.removedTrials = [ResAPA.removedTrials,ResAPA.Trial(pos)];
TrialParams.removedTrials = [TrialParams.removedTrials,TrialParams.Trial(pos)];
num_Trial = arrayfun(@(i) APA.Trial(i).CP_Position.TrialNum,1:length(APA.Trial));
num_remTrial = arrayfun(@(i) APA.removedTrials(i).CP_Position.TrialNum,1:length(APA.removedTrials));
[a,ind_supp_tri] = sort(unique(num_remTrial));
APA.removedTrials = APA.removedTrials(ind_supp_tri);
ResAPA.removedTrials = ResAPA.removedTrials(ind_supp_tri);
TrialParams.removedTrials = TrialParams.removedTrials(ind_supp_tri);
[a,ind_trial] = setdiff(num_Trial,num_remTrial);
APA.Trial = APA.Trial(ind_trial);
ResAPA.Trial = ResAPA.Trial(ind_trial);
TrialParams.Trial = TrialParams.Trial(ind_trial);
set(findobj('tag','listbox1'),'Value',1);
liste_marche = arrayfun(@(i) APA.Trial(i).CP_Position.TrialName, 1:length(APA.Trial),'uni',0);
set(findobj('tag','listbox1'),'String',liste_marche);

%% Export_trigs_Callback - Export des évènements temporels (ptx et évènements .lena) si présence de Trigger
% --- Executes on button press in Export_trigs.
function Export_trigs_Callback(hObject, eventdata, handles)
% Export des évènements temporels (ptx et évènements .lena) si présence de Trigger
% hObject    handle to Export_trigs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sujet Resultats Subject_data Activation_EMG LFP e_lena e_multi

% Calculs
liste = fieldnames(LFP); %% On extrait la liste des essais valides

wb = waitbar(0);
set(wb,'Name','Please wait... Exporting trigger data');

Resultats_new={};
Export={}; % Structure qui va contenir les évènements temporels dans les 2 bases de temps (PF et LFP)
liste_evts = {};
for i=1:length(liste)
    waitbar(i/length(liste)-1,wb,['Vérification acquisition: ' liste{i}]);
    if isfield(Sujet.(liste{i}),'Trigger')
        % Calcul dans les bases du trigger (export excel)
        if ~isfield(Resultats,liste{i})
            Resultats.(liste{i}) = calculs_parametres_initiationPas_v1(Sujet.(liste{i}));
        end
        
        % Calcul dans les bases PF/LFP (export lena/ptx)
        if isfield(Sujet.(liste{i}),'Trigger_LFP')
            [Resultats_new.(liste{i}) Export.(liste{i})] = calculs_parametres_initiationPas_v3(Sujet.(liste{i}));
        end
        
        % Gestion des Onset des EMG
        try
            Onset_EMG_TA = min([Activation_EMG.(liste{i}).RTA(1,1) Activation_EMG.(liste{i}).LTA(1,1)]); %Debut inhibition
            Export.(liste{i}).tPF.TA = Sujet.(liste{i}).tMarkers.Onset_TA;
            Export.(liste{i}).tLFP.TA =  T_trig_lfp + (Onset_EMG_TA - T_trig);
        catch NO_EMG
            disp(['EMG non traité ' liste{i}]);
            Export.(liste{i}).tPF.TA = NaN;
            Export.(liste{i}).tLFP.TA = NaN;
        end
        
    end
    liste_evts = [liste_evts;fieldnames(Export.(liste{i}).tLFP)];
end

if isempty(Subject_data)
    Subject_data = subject_info();
end

% Export Excel
button = questdlg('Export Excel?','Exporter Trigger/Temps sous Excel?','Oui','Non','Non');
if strcmp(button,'Oui')
    fichier = inputdlg({'Nom du fichier/sujet' 'Nom de la feuille/session'},'Ecriture .xls',1,{Subject_data.ID 'Triggers'});
    ecrireQR_xls(Export,[fichier{1} '.xls'],fichier{2});
end
close(wb);

% Export du vecteur temporel des evts (base PF et LFP) format Lena (base LFP)
try
    [e_lena e_multi] = ecrire_evts_ptx_v4(Export,unique(liste_evts));
catch Err
    disp('Pas d''export pistes techniques');
end

%% PlotPF_Callback - Affichage de la trajectoire du CP sur la PF
% --- Executes on button press in PlotPF.
function PlotPF_Callback(hObject, eventdata, handles)
% Affichage de la trajectoire du CP sur la PF
global haxes6 Sujet acq_courante
% hObject    handle to PlotPF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PlotPF

flagPF=get(findobj('tag','PlotPF'),'Value');
set(haxes6,'NextPlot','replace');
if flagPF
    set(findobj('Tag','Acc_txt'),'String','Trajectoire CP');
    plot(haxes6,Sujet.(acq_courante).CP_AP,Sujet.(acq_courante).CP_ML);
    xlabel(haxes6,'Axe Antéropostérieur(mm)','FontName','Times New Roman','FontSize',10);
    ylabel(haxes6,'Axe Médio-Latéral (mm)','FontName','Times New Roman','FontSize',10);
    set(haxes6,'YDir','Reverse');
else
    set(findobj('Tag','Acc_txt'),'String','Accélération/Puissance CG');
    xlabel(haxes6,'Temps (s)','FontName','Times New Roman','FontSize',10);
    try
        plot(haxes6,Sujet.(acq_courante).t,Sujet.(acq_courante).Puissance_CG); afficheY_v2(0,':k',haxes6);
        ylabel(haxes6,'Puissance (Watt)','FontName','Times New Roman','FontSize',12);
    catch Err
        plot(haxes6,Sujet.(acq_courante).t,Sujet.(acq_courante).Acc_Z); afficheY_v2(0,':k',haxes6);
        ylabel(haxes6,'Axe vertical(m²/s)','FontName','Times New Roman','FontSize',10);
    end
end

%% Export des evenements du pas
function export_events(hObject, eventdata, handles)
global TrialParams ResAPA

path = cd;
chemin_c3d = uigetdir('','Choix du repertoire des c3d');
cd(chemin_c3d)
A = dir('*.c3d');
liste_files = { A(:).name}';
liste_acq = get(findobj('Style','listbox'),'String');
for i_acq = 1 : length(liste_acq)
    disp(['Export events pour : ' liste_acq{i_acq}]);
    try
        if ~isempty(strfind(liste_acq{i_acq},'ON'))
            trait = {'_ON'};
        elseif ~isempty(strfind(liste_acq{i_acq},'OFF'))
            trait = {'_OFF'};
        end
        ind_trait = matchcells2(liste_files,trait);
        if ~isempty(strfind(liste_acq{i_acq},'_MR'))
            marche = {'_MR'};
        elseif ~isempty(strfind(liste_acq{i_acq},'_MN'))
            marche = {'_MN'}; 
        elseif ~isempty(strfind(liste_acq{i_acq},'_R'))
            marche = {'_R'};
        elseif ~isempty(strfind(liste_acq{i_acq},'_S'))
            marche = {'_S'};
        end
        ind_marche = matchcells2(liste_files,marche);
        cpt = 3;
        num=NaN;
        while isnan(num) || ~isnumeric(num)
            cpt = cpt-1;
            num = str2double(liste_acq{i_acq}(end-cpt:end));
        end
        num = ['0' num2str(num)];
        ind_num = matchcells2(liste_files,{num(end-1:end)});
        num_file = intersect(intersect(ind_marche,ind_trait),ind_num);
        nom_fich = liste_files{num_file};
        acq = btkReadAcquisition(fullfile(chemin_c3d,nom_fich));
        btkClearEvents(acq)
        btkAppendEvent(acq,'Foot_Strike',TrialParams.Trial(i_acq).EventsTime(2),'General');
        btkAppendEvent(acq,'Event',TrialParams.Trial(i_acq).EventsTime(3),'General');
        if ~isempty(strfind(ResAPA.Trial(i_acq).Cote,'Gauche'))
            btkAppendEvent(acq,'Foot Off',TrialParams.Trial(i_acq).EventsTime(4),'Left');
            btkAppendEvent(acq,'Foot Strike',TrialParams.Trial(i_acq).EventsTime(5),'Left');
            btkAppendEvent(acq,'Foot Off',TrialParams.Trial(i_acq).EventsTime(6),'Right');
            btkAppendEvent(acq,'Foot Strike',TrialParams.Trial(i_acq).EventsTime(7),'Right');
        elseif ~isempty(strfind(ResAPA.Trial(i_acq).Cote,'Droit'))
            btkAppendEvent(acq,'Foot Off',TrialParams.Trial(i_acq).EventsTime(4),'Right');
            btkAppendEvent(acq,'Foot Strike',TrialParams.Trial(i_acq).EventsTime(5),'Right');
            btkAppendEvent(acq,'Foot Off',TrialParams.Trial(i_acq).EventsTime(6),'Left');
            btkAppendEvent(acq,'Foot Strike',TrialParams.Trial(i_acq).EventsTime(7),'Left');
        end
        btkSetEventId(acq, 'Event', 0);
        btkSetEventId(acq, 'Foot Strike', 1);
        btkSetEventId(acq, 'Foot Off', 2);
        %     btkWriteAcquisition(acq,fullfile(chemin_c3d,strrep(nom_fich,'.c3d','_2.c3d')))
        btkWriteAcquisition(acq,fullfile(chemin_c3d,nom_fich))
        disp('OK')
    catch
        disp('Erreur export events')
    end
end
cd(path);



%% Export format commun traitemetn du signal
function export_format_commun(hObject, eventdata, handles)

global Sujet Subject_data removedSujet Resultats removedResultats

liste_trial = fieldnames(Sujet);

if strfind(liste_trial{1},'ON')
    traitement = 'ON';
elseif strfind(liste_trial{1},'OFF')
    traitement = 'OFF';
end

if ~isempty(strfind(liste_trial{1},'MN')) || ~isempty(strfind(liste_trial{1},'S'))
    vit = 'S';
elseif ~isempty(strfind(liste_trial{1},'MR')) || ~isempty(strfind(liste_trial{1},'R'))
    vit = 'R';
end

if strfind(liste_trial{1},'Preop')
    Session = 'Preop';
elseif strfind(liste_trial{1},'LFP')
    Session = 'LFP';
elseif strfind(liste_trial{1},'M3Stim1')
    Session = 'M3Stim1';
elseif strfind(liste_trial{1},'M3Stim2')
    Session = 'M3Stim2';
end

ind_tag = strfind(liste_trial{1},'_');
Tag_sujet = liste_trial{1}(ind_tag(2)+1:ind_tag(3)-1);

nom_fich = ['GBMOV_' Session '_' Tag_sujet '_' traitement '_' vit];
[save_name,chemin] = uiputfile([ nom_fich '.mat']);
nom_fich_PF = [nom_fich '_PF'];
nom_fich_trialParams = [nom_fich '_trialParams'];

liste_trial = fieldnames(Sujet);

for i_trial = 1 : length(liste_trial)
    
    if isnan(str2double(liste_trial{i_trial}(end-1)))
        numTrial = ['0' liste_trial{i_trial}(end)];
    elseif ~isnan(str2double(liste_trial{i_trial}(end)))
        numTrial = ['' liste_trial{i_trial}(end-1:end)];
    else
        numTrial = '';
    end
    
    nom_trial = ['GBMOV_' Session '_' Tag_sujet '_' traitement '_' vit '_' numTrial];
    
    eval([nom_fich_PF '.Trial{' num2str(i_trial) '}.fech =  Sujet.' liste_trial{i_trial} '.Fech;']);
    eval([nom_fich_PF '.Trial{' num2str(i_trial) '}.Loads =  Sujet.' liste_trial{i_trial} '.Loads;']);
    eval([nom_fich_PF '.Trial{' num2str(i_trial) '}.CP =  cat(2,Sujet.' liste_trial{i_trial} '.CP_AP,Sujet.' liste_trial{i_trial} '.CP_ML);']);
    eval([nom_fich_PF '.Trial{' num2str(i_trial) '}.V_CG =  cat(2,Sujet.' liste_trial{i_trial} '.V_CG_AP,Sujet.' liste_trial{i_trial} '.V_CG_ML,Sujet.' liste_trial{i_trial} '.V_CG_Z);']);
    eval([nom_fich_PF '.Trial{' num2str(i_trial) '}.Acc_CG =  Sujet.' liste_trial{i_trial} '.Acc_CG;']);
    eval([nom_fich_PF '.Trial{' num2str(i_trial) '}.time =  Sujet.' liste_trial{i_trial} '.t'';']);
    eval([nom_fich_PF '.Trial{' num2str(i_trial) '}.file_name =  nom_trial;']);
    eval([nom_fich_PF '.history =  [];']);
    
    tag_events = fieldnames(Sujet.(liste_trial{i_trial}).tMarkers);
    temps = [];
    for j_events = 1 : length(tag_events)
        temps(end+1) = Sujet.(liste_trial{i_trial}).tMarkers.(tag_events{j_events});
    end
    eval([nom_fich_trialParams '.Trial{' num2str(i_trial) '}.eventsTime =  temps;']);
    eval([nom_fich_trialParams '.Trial{' num2str(i_trial) '}.StartingFoot =  Resultats.' liste_trial{i_trial} '.Cote;']);
    eval([nom_fich_trialParams '.Trial{' num2str(i_trial) '}.file_name =  nom_trial;']);
    eval([nom_fich_trialParams '.markerNames =  tag_events;']);
    eval([nom_fich_PF '.history =  [];']);
    
end

if ~isempty(removedSujet)
    liste_removed_trial = fieldnames(removedSujet);
    for i_trial = 1 : length(liste_removed_trial)
        
        if isnan(str2double(liste_removed_trial{i_trial}(end-1)))
            numTrial = ['0' liste_removed_trial{i_trial}(end)];
        elseif ~isnan(str2double(liste_removed_trial{i_trial}(end)))
            numTrial = ['' liste_removed_trial{i_trial}(end-1:end)];
        else
            numTrial = '';
        end
        
        nom_trial = ['GBMOV_' Session '_' Tag_sujet '_' traitement '_' vit '_' numTrial];
        eval([nom_fich_PF '.removedTrial{' num2str(i_trial) '}.fech =  removedSujet.' liste_removed_trial{i_trial} '.Fech;']);
        eval([nom_fich_PF '.removedTrial{' num2str(i_trial) '}.Loads = removedSujet.' liste_removed_trial{i_trial} '.Loads;']);
        eval([nom_fich_PF '.removedTrial{' num2str(i_trial) '}.CP =  cat(2,removedSujet.' liste_removed_trial{i_trial} '.CP_AP,removedSujet.' liste_removed_trial{i_trial} '.CP_ML);']);
        eval([nom_fich_PF '.removedTrial{' num2str(i_trial) '}.V_CG =  cat(2,removedSujet.' liste_removed_trial{i_trial} '.V_CG_AP,removedSujet.' liste_removed_trial{i_trial} '.V_CG_ML,removedSujet.' liste_removed_trial{i_trial} '.V_CG_Z);']);
        eval([nom_fich_PF '.removedTrial{' num2str(i_trial) '}.Acc_CG =  removedSujet.' liste_removed_trial{i_trial} '.Acc_CG;']);
        eval([nom_fich_PF '.removedTrial{' num2str(i_trial) '}.time =  removedSujet.' liste_removed_trial{i_trial} '.t'';']);
        eval([nom_fich_PF '.removedTrial{' num2str(i_trial) '}.file_name =  nom_trial;']);
        
        
        tag_events = fieldnames(removedSujet.(liste_removed_trial{i_trial}).tMarkers);
        temps = [];
        for j_events = 1 : length(tag_events)
            temps(end+1) = removedSujet.(liste_removed_trial{i_trial}).tMarkers.(tag_events{j_events});
        end
        eval([nom_fich_trialParams '.removedTrial{' num2str(i_trial) '}.eventsTime =  temps;']);
        eval([nom_fich_trialParams '.removedTrial{' num2str(i_trial) '}.StartingFoot =  removedResultats.' liste_removed_trial{i_trial} '.Cote;']);
        eval([nom_fich_trialParams '.removedTrial{' num2str(i_trial) '}.file_name =  nom_trial;']);
        eval([nom_fich_trialParams '.markerNames =  tag_events;']);
        eval([nom_fich_PF '.history =  [];']);
    end
end


eval(['save(fullfile(chemin,[ nom_fich_PF ''.mat'']),''' nom_fich_PF ''')'])
eval(['save(fullfile(chemin,[ nom_fich_trialParams ''.mat'']),''' nom_fich_trialParams ''')'])

% --- Executes on button press in APA_auto.
function APA_auto_Callback(hObject, eventdata, handles)
% hObject    handle to APA_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Calc_current_Callback(findobj('tag','Calc_current'), eventdata, handles);
APA_Vitesses_Callback;
% Hint: get(hObject,'Value') returns toggle state of APA_auto

%% data_preprocessing
function [APA TrialParams ResAPA] = Data_Preprocessing(files,dossier,b_c)
% Effectue le pré-traitement et stockage des données receuillies du répertoire d'étude (dossier)

if nargin<2
    dossier = cd;
    b_c = 'PF';
end

if nargin<3
    b_c = 'PF';
end

%%Lancement du chargement
wb = waitbar(0);
set(wb,'Name','Please wait... loading data');
warning off

%Cas ou selection d'un fichier unique
if iscell(files)
    nb_acq = length(files);
else
    nb_acq =1;
end
% initialisation
myFile = files{1}(1:end-4);
ind_tag = find(myFile=='_');
myProt = myFile(1:ind_tag(1) - 1);
mySession = myFile(ind_tag(1) + 1 : ind_tag(2) - 1);
mySubject = myFile(ind_tag(2) + 1 : ind_tag(3) - 1);
myTreat = myFile(ind_tag(3) + 1 : ind_tag(4) - 1);
if size(ind_tag,2) > 4
    mySpeed = myFile(ind_tag(4) + 1 : ind_tag(5) - 1);
else
    mySpeed = myFile(ind_tag(4) + 1 : end - 4);
end

nom_fich = upper([myProt '_' mySession '_' mySubject '_' myTreat '_' mySpeed]);
APA.Infos.Protocole = myProt;
APA.Infos.Session = mySession;
APA.Infos.Subject = mySubject;
APA.Infos.MedCondition = myTreat;
APA.Infos.SpeedCondition = mySpeed;
APA.Infos.FileName = nom_fich;
APA.removedTrials = [];

TrialParams.Infos.Protocole = myProt;
TrialParams.Infos.Session = mySession;
TrialParams.Infos.Subject = mySubject;
TrialParams.Infos.MedCondition = myTreat;
TrialParams.Infos.SpeedCondition = mySpeed;
TrialParams.Infos.FileName = nom_fich;
TrialParams.removedTrials = [];

ResAPA.Infos.Protocole = myProt;
ResAPA.Infos.Session = mySession;
ResAPA.Infos.Subject = mySubject;
ResAPA.Infos.MedCondition = myTreat;
ResAPA.Infos.SpeedCondition = mySpeed;
ResAPA.Infos.FileName = nom_fich;
ResAPA.removedTrials = [];

cpt = 0;
for i = 1:nb_acq
    
    myTrialName = upper(files{i}(1:end-4));
    myNum = str2double(files{i}(end-5:end-4));
    myFile = files{i};
    waitbar(i/nb_acq,wb,['Lecture fichier:' myFile]);
    try
        %======================================================================
        % initialisation des structures
        
        %======================================================================
        %Lecture du fichier
        DATA = lire_donnees_c3d_all(fullfile(dossier,myFile));
        h = btkReadAcquisition(fullfile(dossier,myFile));
        Freq_ana = btkGetAnalogFrequency(h); %% Modif' v6, on conserve les données PF à la fréquence de base pour export .lena
        Freq_vid = btkGetPointFrequency(h);
        t_all = (0:btkGetAnalogFrameNumber(h)-1)*1/Freq_ana;
        Fin = round(find(DATA.actmec(:,9)<70,1,'first'));  %%%% Choix ou on coupe l'acquisition!!! (defaut = PF)
        if isempty(Fin) || strcmp(b_c,'Oui')
            Fin = length(t_all);
        end
        
        %======================================================================
        % Extraction des efforts sur la PF
        if Fin<10 %% On a des 0 sur les données PF en début d'acquisitions
            Fin = length(t_all);
        end
        
        % traitement des efforts au sol
        [forceplates, forceplatesInfo] = btkGetForcePlatforms(h) ;
        av = btkGetAnalogs(h);
        analog_RPLATEFORME=[];
        channels=fieldnames(forceplates(1).channels);
        for kk=1:length(channels)
            analog_RPLATEFORME=[analog_RPLATEFORME,av.(channels{kk})];
        end;
        RES=Analog_2_forces_plates(analog_RPLATEFORME,forceplates(1).corners',forceplates(1).origin');
        RES=double(RES);
        
        clear Data
        Data = RES(1:Fin,7:12)';
        Trial_APA.GroundWrench = Signal(Data,Freq_ana,'tag',{'FX','FY','FZ','MX','MY','MZ'},...
            'units',{'N','N','N','Nmm','Nmm','Nmm'},'TrialNum',myNum,'TrialName',myTrialName);
        
        % traitement de la position du CO
        t = t_all(1:Fin);
        CP = RES(1:Fin,1:3);
        CP_filt = NaN*ones(size(CP));
        l = ~isnan(CP(:,1));
        CP_pre = CP(l,:);
        %Filtrage des données PF: filtre à réponse impulsionnel finie d'ordre 50 et de fréquence de coupure 45Hz
        CP_post = filtrage(CP_pre,'fir',50,45,Freq_ana); %%%% A changer?
        try
            CP_filt(l,:) = CP_post;
            % On complète le vecteur CP par la dernière valeur lue sur la PF
            CP0 = CP_post(end,:);
            dim_buff = Fin-sum(l);
            CP_filt(~l,:) = repmat(CP0,dim_buff,1);
        catch empty_CP
            CP_filt = CP;
        end
        
        clear Data
        Data = CP_filt(:,[2 1])';
        Trial_APA.CP_Position = Signal(Data,Freq_ana,'tag',{'X','Y'},...
            'units',{'mm','mm'},'TrialNum',myNum,'TrialName',myTrialName);
        
        
        %======================================================================
        % Extraction des marqueurs temporels d'inititation du pas
        % Extraction du temps de l'instruction (à partir du FSW) pour le calcul du temps de réaction
        Trial_TrialParams.EventsTime = NaN(1,7);
        Trial_TrialParams.EventsNames = {'TR','T0','HO','TO','FC1','FO2','FC2'};
        Trial_TrialParams.TrialName = myTrialName;
        Trial_TrialParams.TrialNum = myNum;
        Trial_TrialParams.Description = '';
        
        if isfield(DATA,'ANLG')
            signal = btkGetAnalog(h,'GO');
            if any(isnan(signal))
                signal = btkGetAnalog(h,'FSW'); %% Le trigger est sur un canal nommé 'FSW'
            end
            
            if ~any(isnan(signal))
                signal = signal - nanmean(signal);
                try
                    TR_ind = find(signal>0.2,1,'first');
                    Trial_TrialParams.EventsTime(1) = TR_ind/DATA.ANLG.Fech;
                catch GO_start
                    Trial_TrialParams.EventsTime(1) = t(1);
                end
            else
                disp('Pas de go sonore!');
                Trial_TrialParams.EventsTime(1) = t(1);
            end
        else
            disp('Pas de go sonore!');
            Trial_TrialParams.EventsTime(1) = t(1);
        end
        
        evts_fog = [];
        evts_dt = [];
        try
            % Détection T0 + extraction des evts du pas notés sur Nexus (VICON)
            evts = sort(DATA.events.temps - t(1));
            ind_1 = round((evts(1)-t(1))*Freq_ana); %1er evenment noté manuellement sur le VICON (Heel-Off)
            if ind_1>10 % Cas ou l'acqisition commence tardivement avec l'initiation du pas
                Trial_TrialParams.EventsTime(2) = calcul_APA_T0_v4(CP_filt(1:ind_1,:),t(1:ind_1)) + t(1); % 1er evt biomécanique
            else
                Trial_TrialParams.EventsTime(2) = NaN;
            end
            
            if length(evts)<5
                disp('...Evènements de l''Initiation du pas non identifiée... ');
                disp('...Détection automatique ...');
                evts = calcul_APA_all(CP_filt,t) - t(1);
                Trial_TrialParams.EventsTime(2) = evts(1) + t(1); % 1er evt biomécanique
                evts(1) = evts(2)-0.01; % ON crée le Heel-Off
            end
            
            
        catch ERR % Détection automatique
            disp(['Pas d''évènements du pas ' myFile]);
            disp('...Détection automatique des évènements');
            evts = calcul_APA_all(CP_filt,t) - t(1);
            Trial_TrialParams.EventsTime(2) = evts(1) + t(1); % 1er evt biomécanique
            evts(1) = evts(2)-0.01; % ON crée le Heel-Off
            disp('...Terminé!');
        end
        
        if ~isempty(evts)
            Trial_TrialParams.EventsTime(3:7) = evts(1:5) + t(1);
        else
            Trial_TrialParams.EventsTime(3:7) = NaN;
        end
        
        %======================================================================
        % Calcul des vitesses du CG
        waitbar(i/length(files),wb,['Calculs préliminaires vitesses et APA, marche' num2str(i) '/' num2str(nb_acq)]);
        
        V_CG = [];
        Fres = Trial_APA.GroundWrench.Data(1:3,:)';
        
        % Extraction du poids
        P = mean(Fres(20:Freq_ana/2,:),1); % on prend la moyenne de la composante Z sur la 1ère demi-seconde de l'acquisition
        if ~exist('Fin','var')
            Fin = round(find(Fres(:,3)<10,1,'first')); % Dernière frame sur la PF
            if isempty(Fin)
                Fin = length(Fres);
            end
        end
        
        gravite = 9.80928; % observatoire gravimétrique de strasbourg
        M = P/gravite;
        Acc = (Fres-repmat(P,length(Fres),1))./repmat(M,length(Fres),1); % Accéleration = GRF/m
        
        %Préconditionnement du vecteur réaction sur la bonne durée (pour l'intégration)
        Fin_pf = find(Fres(:,3)<15,1,'first');
        if Fin_pf<length(Fres)/3
            Fin_pf = length(Fres);
        end
        Fres = (Fres - repmat(P,length(Fres),1))./(P(3)/gravite); % Vecteur (GRF - P) à integré
        
        % Intégration
        V_new=[];
        t_PF=(0:Fin-1).*1/Freq_ana; % on ajoute la variable temporelle
        for ii=1:3
            y=Fres(:,ii);
            try % via la toolbox 'Curve Fitting'
                y_t = csaps(t_PF,y);  % on créé une spline
                intgrf = fnint(y_t); % on intègre
                V_new(:,ii)= fnval(intgrf,t_PF);
            catch ERR % sinon par intégration numérique par la méthode des trapèzes
                V_new(:,ii) = cumtrapz(t_PF,y); %Intégration grossière par la méthode des trapèzes
            end
        end
        
        % Pour la visu, on remplace toutes les valeurs suivant la PF par la dernière valeure
        V0 = V_new(Fin_pf,:);
        dim_end = length(V_new)-Fin_pf;
        V_new(Fin_pf+1:end,:) = repmat(V0,dim_end,1);
        
        % stockage
        clear Data
        Data = V_new(:,[2 1 3])';
        Trial_APA.CG_Speed = Signal(Data,Freq_ana,'tag',{'X','Y','Z'},...
            'units',{'m/s','m/s','m/s'},'TrialNum',myNum,'TrialName',myTrialName);
        
        % Dérivation
        if exist('DATA','var')
            % Calcul du Centre de Gravité du sujet
            try
                CG_Vic = squeeze(extraire_coordonnees_v2(DATA,{'CentreOfMass'}))'; % Calculé par Plug-In-Gait
                CoM = squeeze(barycentre_v2(extraire_coordonnees_v2(DATA,{'RASI','LASI','RPSI','LPSI'})))'; % Calculé comme barycentre des épines iliaques du bassin
                Fech_vid = round(Freq_ana * length(DATA.coord)/length(DATA.actmec)); % On réestime la fréquence d'échantillonage vidéo
                
                Fin_vid = round(Fin * Fech_vid/Freq_ana); % On réestime la dernière 'frame' vidéo
                t_vid=(0:Fin_vid-1).*1/Fech_vid; % on ajoute la variable temporelle
                VCoM=zeros(length(t_vid),3);
                VCoM_pre=zeros(length(t_vid),3);
                V_CG=zeros(length(t_vid),3);
                
                %On retire les NaN avant dérivation et filtrage
                l = sum(isnan(CoM(1:Fin_vid,:)),2)>1;
                ll = sum(isnan(CG_Vic(1:Fin_vid,:)),2)>1;
                
                for ii=1:3
                    y=CoM(~l,ii);
                    %Dérivation barycentre marqueurs bassin
                    y_t_vid = csaps(t_vid(~l),y);  % on créé une spline
                    derCoM = fnder(y_t_vid); % on dérive
                    VCoM_pre= fnval(derCoM,t_vid(~l))./1000;
                    
                    %Verification des écarts entre les méthodes (intégration vs. dérivation) (car parfois la fonction 'fnder' déconne)
                    %                 if abs(nanmean(VCoM_pre(:,ii))-nanmean(V_new(:,ii)))>1
                    %                     VCoM_pre = derive_MH_VAH(y,Fech_vid)./1000;
                    %                 end
                    
                    VCoM(~l,ii) = filtrage(VCoM_pre,'b',3,5,Fech_vid); %Lissage (filtre passe-bas de ButterWorth à 5Hz)
                    
                    %Dérivation CG Plug-In-Gait
                    if ~isnan(CG_Vic)
                        yy = CG_Vic(~ll,ii);
                        try
                            yy_t = csaps(t_vid(~ll),yy);
                            derCG = fnder(yy_t);
                            V_CG((~ll),ii) = fnval(derCG,t_vid(~ll))/1000;
                        catch ERRRR
                            V_CG((~ll),ii) = derive_MH_VAH(yy,Fech_vid)/1000;
                        end
                    end
                end
                
                % Interpolation du vecteur dérivé (sur-échantillonnage à Fech)
                if Fech_vid<Freq_ana
                    try
                        VCoM = interp1(t_vid,VCoM,t_PF);
                        V_CG = interp1(t_vid,V_CG,t_PF);
                    catch
                        disp('Pas d''interpolation à la vitesse derivée');
                    end
                end
            catch ERRR
                disp('PAs de données vidéos pour le calcul du CG');
                
            end
        end
        
        % stockage
        clear Data
        Data = V_CG(:,[2 1 3])';
        Trial_APA.CG_Speed_d = Signal(Data,Freq_ana,'tag',{'X','Y','Z'},...
            'units',{'m/s','m/s','m/s'},'TrialNum',myNum,'TrialName',myTrialName);
        
        clear Data
        Data = filtrage(Acc,'fir',30,20,Freq_ana)';
        Data = Data([2 1 3],:);
        Trial_APA.CG_Acceleration = Signal(Data,Freq_ana,'tag',{'X','Y','Z'},...
            'units',{'m.s-2','m.s-2','m.s-2'},'TrialNum',myNum,'TrialName',myTrialName);
        
        clear Data
        Data = dot(Trial_APA.CG_Speed.Data,Trial_APA.GroundWrench.Data(1:3,:),1);
        Trial_APA.CG_Power = Signal(Data,Freq_ana,'tag',{'X','Y','Z'},...
            'units',{'W','W','W'},'TrialNum',myNum,'TrialName',myTrialName);
        
        champs = {'Cote','t_Reaction','t_APA','APAy','APAy_lateral','StepWidth','t_execution','t_1step',...
            't_DA','t_step2','t_cycle_marche','Longueur_pas','V_exec','Vy_FO1','t_VyFO1','Vm','t_Vm',...
            'VML_absolue','Freq_InitiationPas','Cadence','VZmin_APA','V1','V2','Diff_V','Freinage',...
            't_chute','t_freinage','t_V1','t_V2'};
        Trial_Res_APA={};
        for j = 1 : length(champs)
            Trial_Res_APA.(champs{j})=[];
        end
        
        Trial_Res_APA = calcul_auto_APA_marker(Trial_APA, Trial_TrialParams,Trial_Res_APA);
        Trial_Res_APA = calculs_parametres_initiationPas_v4(Trial_APA, Trial_TrialParams,Trial_Res_APA);
        
        cpt = cpt+1;
        APA.Trial(cpt) = Trial_APA;
        TrialParams.Trial(cpt) = Trial_TrialParams;
        ResAPA.Trial(cpt) = Trial_Res_APA;
    catch Err_load
        disp(['Erreur de chargement pour ' myFile])
    end
end
close(wb);
warning on
