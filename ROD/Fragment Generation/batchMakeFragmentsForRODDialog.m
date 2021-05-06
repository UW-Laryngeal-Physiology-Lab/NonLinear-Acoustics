function varargout = batchMakeFragmentsForRODDialog(varargin)
% BATCHMAKEFRAGMENTSFORRODDIALOG MATLAB code for batchMakeFragmentsForRODDialog.fig
%      BATCHMAKEFRAGMENTSFORRODDIALOG, by itself, creates a new BATCHMAKEFRAGMENTSFORRODDIALOG or raises the existing
%      singleton*.
%
%      H = BATCHMAKEFRAGMENTSFORRODDIALOG returns the handle to a new BATCHMAKEFRAGMENTSFORRODDIALOG or the handle to
%      the existing singleton*.
%
%      BATCHMAKEFRAGMENTSFORRODDIALOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCHMAKEFRAGMENTSFORRODDIALOG.M with the given input arguments.
%
%      BATCHMAKEFRAGMENTSFORRODDIALOG('Property','Value',...) creates a new BATCHMAKEFRAGMENTSFORRODDIALOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before batchMakeFragmentsForRODDialog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to batchMakeFragmentsForRODDialog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help batchMakeFragmentsForRODDialog

% Last Modified by GUIDE v2.5 05-Jan-2016 12:17:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @batchMakeFragmentsForRODDialog_OpeningFcn, ...
                   'gui_OutputFcn',  @batchMakeFragmentsForRODDialog_OutputFcn, ...
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


% --- Executes just before batchMakeFragmentsForRODDialog is made visible.
function batchMakeFragmentsForRODDialog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to batchMakeFragmentsForRODDialog (see VARARGIN)

% Choose default command line output for batchMakeFragmentsForRODDialog
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes batchMakeFragmentsForRODDialog wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = batchMakeFragmentsForRODDialog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in FileListbox.
function FileListbox_Callback(hObject, eventdata, handles)
% hObject    handle to FileListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FileListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FileListbox

idxClickSel = get(hObject,'value');
if idxClickSel ~= handles.fileInfo.idxCurrentFile 
    handles.fileInfo.currentFileName = handles.fileInfo.allFileNames(idxClickSel);
    handles.fileInfo.idxCurrentFile = idxClickSel;
    
    set(handles.CurrentFileEdit,'string',handles.fileInfo.allFileNames(idxClickSel));
    guidata(hObject,handles);
end


% --- Executes during object creation, after setting all properties.
function FileListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selDirBtn.
function selDirBtn_Callback(hObject, eventdata, handles)
% hObject    handle to selDirBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
oldDir = get(handles.CurrentFolderEdit,'string');

% if ~isfield(handles,'fileInfo')
%     return;
% else
%     if ~isfield(handles.fileInfo,'outputExcelFileName')
%         return;
%     end
% end
% fileInfo.outputExcelFileName = handles.fileInfo.outputExcelFileName;

[currentFileName,fileFolder] = uigetfile('*.wav','Select a wav file');
[fileFolder,currentFileName,extFileName] = fileparts(fullfile(fileFolder,currentFileName));

dirOutput=dir(fullfile(fileFolder,'*.wav'));
allFileNames={dirOutput.name};
idxCurrentFile = 1;
for n = 1 : length(allFileNames)
    if strcmp(allFileNames{n},[currentFileName,extFileName])
        idxCurrentFile = n;
        break;
    end
end

set(handles.CurrentFolderEdit,'string',fileFolder);
set(handles.CurrentFileEdit,'string',[currentFileName,extFileName]);
set(handles.FileListbox,'string',allFileNames);
set(handles.FileListbox,'value',idxCurrentFile);

fileInfo.currentFileName = currentFileName;
fileInfo.fileFolder = fileFolder;
fileInfo.extFileName = extFileName;
fileInfo.allFileNames = allFileNames;
fileInfo.idxCurrentFile = idxCurrentFile;

handles.fileInfo = fileInfo;

guidata(hObject,handles);





function CurrentFolderEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentFolderEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrentFolderEdit as text
%        str2double(get(hObject,'String')) returns contents of CurrentFolderEdit as a double


% --- Executes during object creation, after setting all properties.
function CurrentFolderEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentFolderEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in batchMakeBtn.
function batchMakeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to batchMakeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fileInfo = handles.fileInfo;
allFileNames = fileInfo.allFileNames
nmax = length(allFileNames);
for n=1:nmax
    % get File name
    fileName = strcat(handles.fileInfo.fileFolder ,'\', allFileNames{n} );
    %fileName = fileName{1};

    [fileFolder,currentFileName,extFileName] = fileparts(fileName);
    newDirName = fullfile(fileFolder,currentFileName);
    % check DirName
    while strcmp(newDirName(end),' ')
        newDirName = newDirName(1:end-1);
    end
    % make dir
    mkdir (newDirName);

    rel = splitWavFileIntoSegments(fileName,8,newDirName);
    
    strShow = ['File ' num2str(n) '(' allFileNames{n} '):'];
    if rel ~= 0
        display([strShow 'Fail in splitting.']);
    else
        display([strShow 'Done!']);
    end
end

display('Mission completed.');


function CurrentFileEdit_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrentFileEdit as text
%        str2double(get(hObject,'String')) returns contents of CurrentFileEdit as a double


% --- Executes during object creation, after setting all properties.
function CurrentFileEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentFileEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in singleMakeBtn.
function singleMakeBtn_Callback(hObject, eventdata, handles)
% hObject    handle to singleMakeBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles,'fileInfo')
    return;
end

% get File name
fileName = strcat(handles.fileInfo.fileFolder ,'\', handles.fileInfo.currentFileName );
fileName = fileName{1};

[fileFolder,currentFileName,extFileName] = fileparts(fileName);
newDirName = fullfile(fileFolder,currentFileName);
% make dir
mkdir (newDirName);

rel = splitWavFileIntoSegments(fileName,8,newDirName);
if rel ~= 0
    display('Fail in splitting.');
else
    display('Done!');
end
