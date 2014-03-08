function varargout = IntensityCount(varargin)
% INTENSITYCOUNT MATLAB code for IntensityCount.fig
%      INTENSITYCOUNT, by itself, creates a new INTENSITYCOUNT or raises the existing
%      singleton*.
%
%      H = INTENSITYCOUNT returns the handle to a new INTENSITYCOUNT or the handle to
%      the existing singleton*.
%
%      INTENSITYCOUNT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTENSITYCOUNT.M with the given input arguments.
%
%      INTENSITYCOUNT('Property','Value',...) creates a new INTENSITYCOUNT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IntensityCount_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IntensityCount_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IntensityCount

% Last Modified by GUIDE v2.5 06-Nov-2013 13:16:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IntensityCount_OpeningFcn, ...
                   'gui_OutputFcn',  @IntensityCount_OutputFcn, ...
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


% --- Executes just before IntensityCount is made visible.
function IntensityCount_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IntensityCount (see VARARGIN)

% Choose default command line output for IntensityCount
handles.output = hObject;
handles.view=1;
handles.rawim=[];
handles.segim=[];
handles.radius=0;
handles.final_im=[];
% Update handles structure
guidata(hObject, handles);

if strcmp(get(hObject,'Visible'),'off')
    axes(handles.imcell);
    set(gca,'xtick',[],'ytick',[])
    axes(handles.imbacksub);
    set(gca,'xtick',[],'ytick',[])
    cla;
end
% UIWAIT makes IntensityCount wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IntensityCount_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editseg_Callback(hObject, eventdata, handles)
% hObject    handle to editseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editseg as text
%        str2double(get(hObject,'String')) returns contents of editseg as a double


% --- Executes during object creation, after setting all properties.
function editseg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editseg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editraw_Callback(hObject, eventdata, handles)
% hObject    handle to editraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editraw as text
%        str2double(get(hObject,'String')) returns contents of editraw as a double


% --- Executes during object creation, after setting all properties.
function editraw_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editraw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in segbrowse.
function segbrowse_Callback(hObject, eventdata, handles)
% hObject    handle to segbrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname]= uigetfile({'*.tif;*.tiff','Microscopy image file'; '*.*','All (*.*)'}, 'Pick the Segmented file');
segfile= fullfile(pathname, file);
set(handles.editseg, 'String', segfile);
handles.segim=imread(segfile);
m= mode(handles.segim(:)');
bw=handles.segim==m;
majoraxis= regionprops(bw, 'MajorAxisLength');
%minoraxis= regionprops(bw, 'MinorAxisLength');
handles.radius=(majoraxis(1).MajorAxisLength)/2;
if(handles.view==0)
    axes(handles.imcell);
    imshow(handles.segim, []);
end
guidata(hObject, handles);

% --- Executes on button press in rawbrowse.
function rawbrowse_Callback(hObject, eventdata, handles)
% hObject    handle to rawbrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, pathname]= uigetfile({'*.tif;*.tiff','Microscopy image file'; '*.*','All (*.*)'}, 'Pick the Cell file');
rawfile= fullfile(pathname, file);
set(handles.editraw, 'String', rawfile);
handles.rawim=imread(rawfile);
if(handles.view==1)
    axes(handles.imcell);
    imshow(handles.rawim,[]);
end
if(get(handles.checkbox2, 'Value')==0)
    handles.final_im=handles.rawim;
    axes(handles.imbacksub);
    imshow(handles.final_im,[]);
end
guidata(hObject, handles);

% --- Executes on slider movement.
function ballsize_Callback(hObject, eventdata, handles)
% hObject    handle to ballsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
coeff=get(hObject, 'Value');
bsubVal= get(handles.checkbox2, 'Value');
axes(handles.imbacksub);
if(bsubVal==1)
    background=imopen(handles.rawim, strel('disk', round(coeff*handles.radius)));
    handles.final_im=imsubtract(handles.rawim,background);
end
imshow(handles.final_im,[]);
%imshow(mat2gray(imsubtract(handles.rawim, mean(handles.rawim(:)))));
%image( find(abs(image-background) <= threshold) ) = 0;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function ballsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ballsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
intensity_list=labelim(handles);
[filename, pathname] = uiputfile('intensity.txt', 'Save Intensity');
header={'Cell_num', 'Cell_int', 'Pix_Tot_int','Pix_Mean_int', 'Pix_Max_int'};
fid = fopen(fullfile(pathname, filename), 'w');
if fid == -1; error('Cannot open file: %s', outfile); end
fprintf(fid, '%s\t', header{:});
fprintf(fid, '\n');
fclose(fid);
dlmwrite(fullfile(pathname, filename), intensity_list,'delimiter', '\t', '-append');
close gcf;


% --- Executes when selected object is changed in uipanel5.
function uipanel5_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel5 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'rdata'
        axes(handles.imcell);
        imshow(handles.rawim,[]);
    otherwise
        axes(handles.imcell);
        imshow(handles.segim,[]);
end
handles.view=~handles.view;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function uipanel5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function intensity_list= labelim(handles)
cell_list= sort(unique(handles.segim(:)))';
cell_list=cell_list(cell_list~=0);
centroid_list=zeros(length(cell_list),2);
intensity_list=zeros(length(cell_list),5);
for i=1:length(cell_list)
    bw= handles.segim==cell_list(i);
    stat=regionprops(bw, 'Centroid');
    centroid_list(i,:)= stat(1).Centroid;
    intensity_list(i,3:5)=[sum(handles.final_im(bw)), mean(handles.final_im(bw)), int64(max(max(handles.final_im(bw))))];
    intensity_list(i,1)=i;
    intensity_list(i,2)=cell_list(i);
end

disp(int64(intensity_list));
f = figure('color','white','units','normalized','position',[.1 .1 .8 .8]);
%imagesc(ind2rgb(gray2ind(handles.segim,255),jet(255)));
imshow(label2rgb(handles.segim, 'jet', 'w', 'shuffle'));
set(f,'units','pixels','position',[0 0 size(handles.segim,1)  size(handles.segim,2)],'visible','off')
%truesize; %this would be great but since it doesn't really work, fuck
%off
axis off

for i=1:length(cell_list)
    text('position',centroid_list(i,:),'FontWeight','bold','fontsize',10,'string',num2str(i)); 
end
X=getframe(gcf);
if isempty(X.colormap)
    [fileimname, path]= uiputfile('imlabel.jpg', 'Save label image');
    imwrite(X.cdata,fullfile(path,fileimname));
else
    [fileimname, path]= uiputfile('imlabel.tiff', 'Save label image');
    imwrite(X.cdata,X.colormap, fullfile(path,fileimname));
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
val= get(hObject, 'Value');
if(val==1)
    set(handles.checkbox2, 'String', 'Yes')
else
    set(handles.checkbox2, 'String','No'); 
    handles.final_im=handles.rawim;
    axes(handles.imbacksub);
    imshow(handles.final_im,[]);
end
