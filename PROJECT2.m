function varargout = PROJECT2(varargin)
% PROJECT2 MATLAB code for PROJECT2.fig
%      PROJECT2, by itself, creates a new PROJECT2 or raises the existing
%      singleton*.
%
%      H = PROJECT2 returns the handle to a new PROJECT2 or the handle to
%      the existing singleton*.
%
%      PROJECT2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT2.M with the given input arguments.
%
%      PROJECT2('Property','Value',...) creates a new PROJECT2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PROJECT2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PROJECT2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PROJECT2

% Last Modified by GUIDE v2.5 03-Jun-2015 14:59:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PROJECT2_OpeningFcn, ...
                   'gui_OutputFcn',  @PROJECT2_OutputFcn, ...
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


% --- Executes just before PROJECT2 is made visible.
function PROJECT2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PROJECT2 (see VARARGIN)
set(handles.slider, 'UserData', 0)
% Choose default command line output for PROJECT2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PROJECT2 wait for user response (see UIRESUME)
% uiwait(handles.Axis1);


% --- Outputs from this function are returned to the command line.
function varargout = PROJECT2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mp4','Please select video file');
Extension = FileName(end-2:end);
if ~strcmp(Extension, 'mp4')
    h = msgbox('Please load a valid video (.mp4)', 'Error', 'error'); 
end
Video = VideoReader([PathName,FileName]);
Vid_Name = 'File: ';
Vid_Res = 'Resolution: ';
Vid_Res2 = 'x';
Vid_FR = 'Framerate: ';
Vid_Dur = 'Total Duration: ';
Vid_Hr = 'h ';
Vid_Min = 'm ';
Vid_Sec = 's';
Dur_hours = fix((Video.Duration/60)/60);
Dur_mins = fix(Video.Duration/60);
Dur_seconds = round(Video.Duration - (Dur_mins*60) - ...
    (Dur_hours*360));
set(handles.VideoName, 'String', ...
    [Vid_Name, Video.Name]);
set(handles.Resolution, 'String',...
    [Vid_Res, int2str(Video.Width), Vid_Res2, int2str(Video.Height)]);
set(handles.Framerate, 'String', [Vid_FR, int2str(Video.FrameRate)]);
set(handles.Duration, 'String', [Vid_Dur, int2str(Dur_hours), Vid_Hr, ...
    int2str(Dur_mins), Vid_Min, int2str(Dur_seconds), Vid_Sec]);
drawnow()
set(handles.Load, 'UserData', Video);
set(handles.Play, 'UserData', 1);
set(handles.slider, 'Max', Video.NumberOfFrames);
set(handles.R_slider, 'UserData', 1)
set(handles.G_slider, 'UserData', 1)
set(handles.B_slider, 'UserData', 1)
set(handles.RGB_button, 'UserData', 1)
set(handles.slider, 'UserData', 1)
firstframe = read(Video, 1 );
imshow(firstframe, 'Parent', handles.axes1);
pixelCount_red = imhist(firstframe(:,:,1));
pixelCount_green = imhist(firstframe(:,:,2));
pixelCount_blue = imhist(firstframe(:,:,3));
plot(handles.RGB_axes, pixelCount_red, 'r');
hold on
plot(handles.RGB_axes, pixelCount_green, 'g');
plot(handles.RGB_axes, pixelCount_blue, 'b');
xlim([0 260]);

% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.slider, 'UserData') == 0
    h = msgbox('Please load a valid video (.mp4)', 'Error', 'error'); 
    set(handles.Play, 'string', 'Pause')
end
Video = get(handles.Load, 'UserData');
set(handles.Stop, 'UserData', 1);
if get(handles.Play, 'string') == 'Play '
    set(handles.Play, 'string', 'Pause');
    for i = get(handles.Play, 'UserData'):Video.NumberOfFrames
        x = read(Video,i);
        new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
        new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
        new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
        vidframe(:,:,1) = new_red;
        vidframe(:,:,2) = new_green;
        vidframe(:,:,3) = new_blue;
        imshow(vidframe, 'Parent', handles.axes1);
        pixelCount_red = imhist(new_red);
        pixelCount_green = imhist(new_green);
        pixelCount_blue = imhist(new_blue);
        if get(handles.RGB_button, 'UserData') == 1
            plot(handles.RGB_axes, pixelCount_red, 'r');
            hold on
            plot(handles.RGB_axes, pixelCount_green, 'g');
            plot(handles.RGB_axes, pixelCount_blue, 'b');
            xlim([0 260]);
        elseif get(handles.RGB_button, 'UserData') == 0
            cla(handles.RGB_axes)
        end
        set(handles.slider, 'Value', i);
        drawnow();
        if get(handles.Stop, 'UserData') == 1
            cla(handles.RGB_axes,'reset')
        elseif get(handles.Stop, 'UserData') == 0
            break;
        end
        if i == Video.NumberOfFrames
            x = read(Video,i);
            new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
            new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
            new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
            vidframe(:,:,1) = new_red;
            vidframe(:,:,2) = new_green;
            vidframe(:,:,3) = new_blue;
            imshow(vidframe, 'Parent', handles.axes1);
            x = [0:255];
            redfr = vidframe(:,:,1);
            greenfr = vidframe(:,:,2);
            bluefr = vidframe(:,:,3);
            pixelCount_red = imhist(redfr);
            pixelCount_green = imhist(greenfr);
            pixelCount_blue = imhist(bluefr);
            plot(handles.RGB_axes, pixelCount_red, 'r');
            hold on
            plot(handles.RGB_axes, pixelCount_green, 'g');
            plot(handles.RGB_axes, pixelCount_blue, 'b');
            xlim([0 260]);
            set(handles.Play, 'string', 'Play ');
            set(handles.Play, 'UserData', 1);
            drawnow()
        end
    end
elseif get(handles.Play, 'string') == 'Pause'
    set(handles.Play, 'string', 'Play ');
    slider_val = round(get(handles.slider, 'Value'));
    set(handles.Stop, 'UserData',0)
    set(handles.Play, 'UserData', round(slider_val));
end

%Gives error when closes early
%FIX PAUSE

% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.slider, 'UserData') == 0
    h = msgbox('Please load a valid video (.mp4)', 'Error', 'error'); 
end
set(handles.Stop, 'UserData', 0)
set(handles.Play, 'UserData', 1)
if get(handles.Play, 'string') == 'Pause'
    set(handles.Play, 'string', 'Play ');
end

% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

Video = get(handles.Load, 'UserData');
if get(handles.slider, 'Value') <= 1
    slider_val = 1;
else
    slider_val = round(get(handles.slider, 'Value'));
end
if get(handles.Play, 'string') == 'Pause'
    set(handles.Stop, 'UserData', 0);
    set(handles.Play, 'string', 'Play ');
end
x = read(Video,slider_val);
new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
vidframe(:,:,1) = new_red;
vidframe(:,:,2) = new_green;
vidframe(:,:,3) = new_blue;
imshow(vidframe, 'Parent', handles.axes1);
set(handles.Play, 'UserData', slider_val);
cla(handles.RGB_axes,'reset');
if strcmp(get(handles.RGB_button, 'string'), 'Disable RGB View')
    x = [0:255];
    redfr = vidframe(:,:,1);
    greenfr = vidframe(:,:,2);
    bluefr = vidframe(:,:,3);
    pixelCount_red = imhist(redfr);
    pixelCount_green = imhist(greenfr);
    pixelCount_blue = imhist(bluefr);
    plot(handles.RGB_axes, pixelCount_red, 'r');
    hold on
    plot(handles.RGB_axes, pixelCount_green, 'g');
    plot(handles.RGB_axes, pixelCount_blue, 'b');
    xlim([0 260]);
    drawnow()
end

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in step_fwd.
function step_fwd_Callback(hObject, eventdata, handles)
% hObject    handle to step_fwd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.slider, 'UserData') == 0
    h = msgbox('Please load a valid video (.mp4)', 'Error', 'error'); 
end
Video = get(handles.Load, 'UserData');
set(handles.Stop, 'UserData', 0);
slider_val = round(get(handles.slider, 'Value'));
if get(handles.Play, 'string') == 'Pause'
    set(handles.Play, 'string', 'Play ');
end
if slider_val+1 < Video.NumberOfFrames
    set(handles.Play, 'UserData', slider_val + 1);
    set(handles.slider, 'Value', slider_val + 1);
    x = read(Video,slider_val);
    new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
    new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
    new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
    vidframe(:,:,1) = new_red;
    vidframe(:,:,2) = new_green;
    vidframe(:,:,3) = new_blue;
    imshow(vidframe, 'Parent', handles.axes1);
    cla(handles.RGB_axes,'reset');
    if strcmp(get(handles.RGB_button, 'string'), 'Disable RGB View')
        x = [0:255];
        redfr = vidframe(:,:,1);
        greenfr = vidframe(:,:,2);
        bluefr = vidframe(:,:,3);
        pixelCount_red = imhist(redfr);
        pixelCount_green = imhist(greenfr);
        pixelCount_blue = imhist(bluefr);
        plot(handles.RGB_axes, pixelCount_red, 'r');
        hold on
        plot(handles.RGB_axes, pixelCount_green, 'g');
        plot(handles.RGB_axes, pixelCount_blue, 'b');
        xlim([0 260]);
        drawnow()
    end
elseif slider_val+1 >= Video.NumberOfFrames
    set(handles.Play, 'UserData', Video.NumberOfFrames);
    set(handles.slider, 'Value', Video.NumberOfFrames);
    x = read(Video,slider_val);
    new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
    new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
    new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
    vidframe(:,:,1) = new_red;
    vidframe(:,:,2) = new_green;
    vidframe(:,:,3) = new_blue;
    imshow(vidframe, 'Parent', handles.axes1);
    cla(handles.RGB_axes,'reset');
    x = [0:255];
    if strcmp(get(handles.RGB_button, 'string'), 'Disable RGB View')
        redfr = vidframe(:,:,1);
        greenfr = vidframe(:,:,2);
        bluefr = vidframe(:,:,3);
        pixelCount_red = imhist(redfr);
        pixelCount_green = imhist(greenfr);
        pixelCount_blue = imhist(bluefr);
        plot(handles.RGB_axes, pixelCount_red, 'r');
        hold on
        plot(handles.RGB_axes, pixelCount_green, 'g');
        plot(handles.RGB_axes, pixelCount_blue, 'b');
        xlim([0 260]);
        drawnow()
    end
end

% --- Executes on button press in step_bck.
function step_bck_Callback(hObject, eventdata, handles)
% hObject    handle to step_bck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.slider, 'UserData') == 0
    h = msgbox('Please load a valid video (.mp4)', 'Error', 'error'); 
end
Video = get(handles.Load, 'UserData');
set(handles.Stop, 'UserData', 0);
slider_val = round(get(handles.slider, 'Value'));
if get(handles.Play, 'string') == 'Pause'
    set(handles.Play, 'string', 'Play ');
end
if slider_val - 1 > 1
    set(handles.Play, 'UserData', slider_val - 1);
    set(handles.slider, 'Value', slider_val - 1);   
    x = read(Video,slider_val);
    new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
    new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
    new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
    vidframe(:,:,1) = new_red;
    vidframe(:,:,2) = new_green;
    vidframe(:,:,3) = new_blue;
    imshow(vidframe, 'Parent', handles.axes1);
    cla(handles.RGB_axes,'reset')
    if strcmp(get(handles.RGB_button, 'string'), 'Disable RGB View')
        x = [0:255];
        redfr = vidframe(:,:,1);
        greenfr = vidframe(:,:,2);
        bluefr = vidframe(:,:,3);
        pixelCount_red = imhist(redfr);
        pixelCount_green = imhist(greenfr);
        pixelCount_blue = imhist(bluefr);
        plot(handles.RGB_axes, pixelCount_red, 'r');
        hold on
        plot(handles.RGB_axes, pixelCount_green, 'g');
        plot(handles.RGB_axes, pixelCount_blue, 'b');
        xlim([0 260]);
        drawnow()
        drawnow()
    end
elseif slider_val - 1 < 1
    x = read(Video,1);
    new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
    new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
    new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
    vidframe(:,:,1) = new_red;
    vidframe(:,:,2) = new_green;
    vidframe(:,:,3) = new_blue;
    imshow(vidframe, 'Parent', handles.axes1);
    cla(handles.RGB_axes,'reset')
    if strcmp(get(handles.RGB_button, 'string'), 'Disable RGB View')
        x = [0:255];
        redfr = vidframe(:,:,1);
        greenfr = vidframe(:,:,2);
        bluefr = vidframe(:,:,3);
        pixelCount_red = imhist(redfr);
        pixelCount_green = imhist(greenfr);
        pixelCount_blue = imhist(bluefr);
        plot(handles.RGB_axes, pixelCount_red, 'r');
        hold on
        plot(handles.RGB_axes, pixelCount_green, 'g');
        plot(handles.RGB_axes, pixelCount_blue, 'b');
        xlim([0 260]);
        drawnow()
    end
end

% --- Executes on button press in RGB_button.
function RGB_button_Callback(hObject, eventdata, handles)
% hObject    handle to RGB_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.RGB_button, 'string') == 'Disable RGB View'
    set(handles.RGB_button, 'UserData', 0);
    set(handles.RGB_button, 'string', 'Enable RGB View ');
    cla(handles.RGB_axes, 'reset')
elseif get(handles.RGB_button, 'string') == 'Enable RGB View '
    set(handles.RGB_button, 'UserData', 1);
    set(handles.RGB_button, 'string', 'Disable RGB View')
    Video = get(handles.Load, 'UserData');
    if get(handles.Stop, 'UserData') == 0
        slider_val = round(get(handles.slider, 'Value'));
        x = read(Video,slider_val);
        new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
        new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
        new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
        vidframe(:,:,1) = new_red;
        vidframe(:,:,2) = new_green;
        vidframe(:,:,3) = new_blue;
        imshow(vidframe, 'Parent', handles.axes1);
        cla(handles.RGB_axes,'reset')
        x = [0:255];
        redfr = vidframe(:,:,1);
        greenfr = vidframe(:,:,2);
        bluefr = vidframe(:,:,3);
        pixelCount_red = imhist(redfr);
        pixelCount_green = imhist(greenfr);
        pixelCount_blue = imhist(bluefr);
        plot(handles.RGB_axes, pixelCount_red, 'r');
        hold on
        plot(handles.RGB_axes, pixelCount_green, 'g');
        plot(handles.RGB_axes, pixelCount_blue, 'b');
        xlim([0 260]);
        drawnow()
    end
end

% --- Executes on slider movement.
function R_slider_Callback(hObject, eventdata, handles)
% hObject    handle to R_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
red_val = (get(handles.R_slider, 'Value')/256) + 1;
set(handles.R_slider, 'UserData', red_val)
Video = get(handles.Load, 'UserData');
if get(handles.Play, 'string') == 'Play '
    slider_val = get(handles.Play, 'UserData');
    x = read(Video,slider_val);
    new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
    new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
    new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
    vidframe(:,:,1) = new_red;
    vidframe(:,:,2) = new_green;
    vidframe(:,:,3) = new_blue;
    imshow(vidframe, 'Parent', handles.axes1);
    cla(handles.RGB_axes,'reset');
    if get(handles.RGB_button, 'UserData') == 1
        x = [0:255];
        redfr = vidframe(:,:,1);
        greenfr = vidframe(:,:,2);
        bluefr = vidframe(:,:,3);
        pixelCount_red = imhist(redfr);
        pixelCount_green = imhist(greenfr);
        pixelCount_blue = imhist(bluefr);
        plot(handles.RGB_axes, pixelCount_red, 'r');
        hold on
        plot(handles.RGB_axes, pixelCount_green, 'g');
        plot(handles.RGB_axes, pixelCount_blue, 'b');
        xlim([0 260]);
        drawnow()
    end
end

% --- Executes during object creation, after setting all properties.
function R_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function G_slider_Callback(hObject, eventdata, handles)
% hObject    handle to G_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
green_val = (get(handles.G_slider, 'Value')/256) + 1;
set(handles.G_slider, 'UserData', green_val)
if get(handles.Play, 'string') == 'Play '
    Video = get(handles.Load, 'UserData');
    slider_val = get(handles.Play, 'UserData');
    x = read(Video,slider_val);
    new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
    new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
    new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
    vidframe(:,:,1) = new_red;
    vidframe(:,:,2) = new_green;
    vidframe(:,:,3) = new_blue;
    imshow(vidframe, 'Parent', handles.axes1);
    cla(handles.RGB_axes,'reset');
    if get(handles.RGB_button, 'UserData') == 1
        x = [0:255];
        redfr = vidframe(:,:,1);
        greenfr = vidframe(:,:,2);
        bluefr = vidframe(:,:,3);
        pixelCount_red = imhist(redfr);
        pixelCount_green = imhist(greenfr);
        pixelCount_blue = imhist(bluefr);
        plot(handles.RGB_axes, pixelCount_red, 'r');
        hold on
        plot(handles.RGB_axes, pixelCount_green, 'g');
        plot(handles.RGB_axes, pixelCount_blue, 'b');
        xlim([0 260]);
        drawnow()
    end
end
% --- Executes during object creation, after setting all properties.
function G_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to G_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function B_slider_Callback(hObject, eventdata, handles)
% hObject    handle to B_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
blue_val = (get(handles.B_slider, 'Value')/256) + 1;
set(handles.B_slider, 'UserData', blue_val)
if get(handles.Play, 'string') == 'Play '
    Video = get(handles.Load, 'UserData');
    slider_val = get(handles.Play, 'UserData');
    x = read(Video,slider_val);
    new_red = x(:,:,1) .* get(handles.R_slider, 'UserData');
    new_green = x(:,:,2) .* get(handles.G_slider, 'UserData');
    new_blue = x(:,:,3) .* get(handles.B_slider, 'UserData');
    vidframe(:,:,1) = new_red;
    vidframe(:,:,2) = new_green;
    vidframe(:,:,3) = new_blue;
    imshow(vidframe, 'Parent', handles.axes1);
    cla(handles.RGB_axes,'reset');
    if get(handles.RGB_button, 'UserData') == 1
        x = [0:255];
        redfr = vidframe(:,:,1);
        greenfr = vidframe(:,:,2);
        bluefr = vidframe(:,:,3);
        pixelCount_red = imhist(redfr);
        pixelCount_green = imhist(greenfr);
        pixelCount_blue = imhist(bluefr);
        plot(handles.RGB_axes, pixelCount_red, 'r');
        hold on
        plot(handles.RGB_axes, pixelCount_green, 'g');
        plot(handles.RGB_axes, pixelCount_blue, 'b');
        xlim([0 260]);
        drawnow()
    end
end
% --- Executes during object creation, after setting all properties.
function B_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to B_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
