function varargout = final1(varargin)
% FINAL1 MATLAB code for final1.fig
%      FINAL1, by itself, creates a new FINAL1 or raises the existing
%      singleton*.
%
%      H = FINAL1 returns the handle to a new FINAL1 or the handle to
%      the existing singleton*.
%
%      FINAL1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL1.M with the given input arguments.
%
%      FINAL1('Property','Value',...) creates a new FINAL1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final1

% Last Modified by GUIDE v2.5 13-Apr-2020 21:05:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final1_OpeningFcn, ...
                   'gui_OutputFcn',  @final1_OutputFcn, ...
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


% --- Executes just before final1 is made visible.
function final1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final1 (see VARARGIN)
set(handles.axes_one,'visible','off');
% Choose default command line output for final1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_multiple.
function button_multiple_Callback(hObject, eventdata, handles)
% hObject    handle to button_multiple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes_multiple);
[filename,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.jpeg;*.tif'},'Pick an image','database_multiple');
str=[pathname filename];
if isequal(filename,0)||isequal(pathname,0)
    warndlg('Please select a picture first!','Warning');
    return;
else
    im = imread(str); 
    imshow(im);		
    imwrite(im,'imagesForSIFT\multiple.jpg');
end


% --- Executes on button press in button_one.
function button_one_Callback(hObject, eventdata, handles)
% hObject    handle to button_one (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes_one);
[filename,pathname]=uigetfile({'*.bmp;*.jpg;*.png;*.jpeg;*.tif'},'Pick an image','database_one');
str=[pathname filename];
if isequal(filename,0)||isequal(pathname,0)
    warndlg('Please select a picture first!','Warning');
    return;
else
    im = imread(str); 
    imshow(im);		
    imwrite(im,'imagesForSIFT\one.jpg');
end


% --- Executes on button press in button_find.
function button_find_Callback(hObject, eventdata, handles)
% hObject    handle to button_find (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if exist('imagesForSIFT\one.jpg','file')==0 && ...
        exist('imagesForSIFT\multiple.jpg','file')==0
   warndlg('Please select a picture first!','Warning');
   return;
end
one = imread('imagesForSIFT\one.jpg');
multiple = imread('imagesForSIFT\multiple.jpg');
set(handles.text_result,'String','waiting for result');
drawnow;
result = siftCal(one,multiple);
if result == 1
    set(handles.text_result,'String','Find it!');
else
    set(handles.text_result,'String','Not find it!');
end



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('imagesForSIFT\one.jpg','file')==0 && ...
        exist('imagesForSIFT\multiple.jpg','file')==0
   warndlg('You have not started finding','Warning');
   return;
end
cla(handles.axes_multiple);
cla(handles.axes_one);
delete('imagesForSIFT\one.jpg');
delete('imagesForSIFT\multiple.jpg');
set(handles.text_result,'String','result here!');
