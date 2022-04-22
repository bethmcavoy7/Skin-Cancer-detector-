classdef gui < matlab.apps.AppBase
    properties (Access = public)
        UIFigure                     
        SaveButton                   
        PlotButton                   
        YaxisButtonGroup             
        LogFreqButton_y              
        ZphaseButton_y               
        ZButton_y                    
        ImagZButton_y                
        RealZButton_y                
        FrequencyButton_y            
        ImportDataButton             
        ResultsSlider                
        ResultsSliderLabel           
        StatusTextArea               
        StatusTextAreaLabel          
        DataPathEditField            
        DataPathEditFieldLabel       
        DateofMeasurementDatePicker  
        DateofMeasurementDatePickerLabel  
        PatientNameEditField         
        PatientNameEditFieldLabel    
        XaxisButtonGroup             
        LogFreqButton_x              
        ZphaseButton_x               
        ZButton_x                    
        ImagZButton_x                
        RealZButton_x                
        FrequencyButton_x  
        externalButton
        UIAxes                       
        freqs
        Zs
        reZ
        imZ
        Sfreqs
        SZs
        SreZ
        SimZ
    end
    methods (Access = private)
        function ImportDataButtonPushed(app, ~)
            app.StatusTextArea.Value=fileread('call');
            diary call
            try
                path=app.DataPathEditField.Value;
                if isempty(path)
                    disp('Fill in File name')
                    diary off
                    app.StatusTextArea.Value=fileread('call');
                    return
                else
                    parsefile(app,path,0)
                    disp('data in')
                    diary off
                    app.StatusTextArea.Value=fileread('call');
                end
            catch ME
                disp('importing error')
                disp(ME.message)
                diary off
                app.StatusTextArea.Value=fileread('call');
            end
        end
        function parsefile(app,file,shortflag)
            try
            	data=importdata(file);
            catch 
                disp('invalid file name')
                disp('make sure to include full file name.txt')
                diary off
                app.StatusTextArea.Value=fileread('call');
                return
            end
            for a=1:length(data)
            	dat=data(a);
                dat=dat{1};
                ou=split(dat);
                if length(ou)==3
                	tmp=ou{1};
                    freq=sscanf(tmp,'%f');
                    if ~isempty(sscanf(tmp,'%f'))
                        fs(a)=freq;
                    end
                	tmp=ou{2};
                    comp=sscanf(tmp,'R=%f/I=%f');
                    if ~isempty(comp)
                    	RI(:,a)=comp;
                    end
                    tmp=ou{3};
                    z=sscanf(tmp,'|Z|=%f');
                    if ~isempty(comp)
                    	zs(a)=z;
                    end
                end
            end
            if shortflag
                disp('short data imported');
                app.Sfreqs=fs;
                app.SreZ=RI(1,:);
                app.SimZ=RI(2,:);
                app.SZs=zs;
            else
                disp('Importing');
                app.freqs=fs;
                app.reZ=RI(1,:);
                app.imZ=RI(2,:);
                app.Zs=zs;
            end
        end
        function PatientNameEditFieldValueChanged(app, ~)
            app.StatusTextArea.Value=fileread('call');
            diary call
            try
                value = app.PatientNameEditField.Value;
                disp('patient name is--')
                disp(value);
                diary off
                app.StatusTextArea.Value=fileread('call');
            catch ME
                disp('patient name error')
                disp(ME.message)
                diary off
                app.StatusTextArea.Value=fileread('call');
            end
        end
        function DateofMeasurementDatePickerValueChanged(app, ~)
            app.StatusTextArea.Value=fileread('call');
            diary call
            try
                value = app.DateofMeasurementDatePicker.Value;
                disp('date picked is--')
                disp(value);
                diary off
                app.StatusTextArea.Value=fileread('call');
            catch ME
                disp('Date error')
                disp(ME.message)
                diary off
                app.StatusTextArea.Value=fileread('call');
            end
        end
        function PlotButtonPushed(app, ~)
            app.StatusTextArea.Value=fileread('call');
            diary call
            try
                if isempty(app.freqs)
                   disp('Please import data first')
                   diary off
                   app.StatusTextArea.Value=fileread('call');
                   return
                end
                x=app.XaxisButtonGroup.SelectedObject.Text;
                y=app.YaxisButtonGroup.SelectedObject.Text;
                switch x
                    case 'Log Freq'
                        xdata=app.freqs;
                        app.UIAxes.XScale = 'log';
                        app.UIAxes.XLabel.String='Log Freq';
                    case 'Frequency'
                        xdata=app.freqs;
                        app.UIAxes.XScale = 'linear';
                        app.UIAxes.XLabel.String='Frequency';
                    case 'Real Z'
                        xdata=app.reZ;
                        app.UIAxes.XLabel.String='Real Z';
                    case 'Imag Z'
                        xdata=app.imZ;
                        app.UIAxes.XLabel.String='Imag Z';
                    case '|Z|'
                        xdata=app.Zs;
                        app.UIAxes.XLabel.String='|Z|';
                    case 'Zphase'
                        eqn=app.reZ+(app.imZ*1j);
                        phs=rad2deg(angle(eqn));
                        xdata=phs;
                        app.UIAxes.XLabel.String='Zphase';
                end
                switch y
                    case 'Log Freq'
                        ydata=app.freqs;
                        app.UIAxes.YScale = 'log';
                        app.UIAxes.YLabel.String='Log Freq';
                    case 'Frequency'
                        ydata=app.freqs;
                        app.UIAxes.YScale = 'linear';
                        app.UIAxes.YLabel.String='Frequency';
                    case 'Real Z'
                        ydata=app.reZ;
                        app.UIAxes.YLabel.String='Real Z';
                    case 'Imag Z'
                        ydata=app.imZ;
                        app.UIAxes.YLabel.String='Imag Z';
                    case '|Z|'
                        ydata=app.Zs;
                        app.UIAxes.YLabel.String='|Z|';
                    case 'Zphase'
                        eqn=app.reZ+(app.imZ*1j);
                        phs=rad2deg(angle(eqn));
                        ydata=phs;
                        app.UIAxes.YLabel.String='Zphase';
                end
                plot(app.UIAxes,xdata,ydata)
                title(app.UIAxes,strcat(x,' VS ',y))
                diary off
                app.StatusTextArea.Value=fileread('call');
            catch ME
                disp('plotting error')
                disp(ME.message)
                diary off
                app.StatusTextArea.Value=fileread('call');
            end
        end
        function SaveButtonPushed(app, ~)
            app.StatusTextArea.Value=fileread('call');
            diary call
            try
                x=app.UIAxes.XLabel.String;
                y=app.UIAxes.YLabel.String;
                pat=app.PatientNameEditField.Value;
                if ismissing(app.DateofMeasurementDatePicker.Value)
                    date='';
                else
                    date = string(app.DateofMeasurementDatePicker.Value);
                end
                str=strcat(pat,'_',x,' VS ',y,'_',date,'.jpg');
                figure('Visible', 'off') 
                ax=axes;
                copyobj(app.UIAxes.Children,ax)
                saveas(ax,str)
                disp('plot saved')
                diary off
                app.StatusTextArea.Value=fileread('call');
            catch ME
                disp('saving error')
                disp(ME.message)
                diary off
                app.StatusTextArea.Value=fileread('call');
            end
        end 
    end
    methods (Access = private)
        function createComponents(app)
            diary call
            try
                app.UIFigure = uifigure('Visible', 'off');
                app.UIFigure.Position = [100 100 640 480];
                app.UIFigure.Name = 'Bioimpedance Skin Cancer Detector';

                app.UIAxes = uiaxes(app.UIFigure);
                title(app.UIAxes, 'Title')
                xlabel(app.UIAxes, 'X')
                ylabel(app.UIAxes, 'Y')
                zlabel(app.UIAxes, 'Z')
                app.UIAxes.Position = [324 204 316 277];

                app.XaxisButtonGroup = uibuttongroup(app.UIFigure);
                app.XaxisButtonGroup.Title = 'X axis';
                app.XaxisButtonGroup.Position = [39 112 122 156];

                app.FrequencyButton_x = uiradiobutton(app.XaxisButtonGroup);
                app.FrequencyButton_x.Text = 'Frequency';
                app.FrequencyButton_x.Position = [1 92 75 20];
                app.FrequencyButton_x.Value = true;

                app.RealZButton_x = uiradiobutton(app.XaxisButtonGroup);
                app.RealZButton_x.Text = 'Real Z';
                app.RealZButton_x.Position = [1 69 65 20];

                app.ImagZButton_x = uiradiobutton(app.XaxisButtonGroup);
                app.ImagZButton_x.Text = 'Imag Z';
                app.ImagZButton_x.Position = [1 46 79 20];

                app.ZButton_x = uiradiobutton(app.XaxisButtonGroup);
                app.ZButton_x.Text = '|Z|';
                app.ZButton_x.Position = [1 23 65 20];

                app.ZphaseButton_x = uiradiobutton(app.XaxisButtonGroup);
                app.ZphaseButton_x.Text = 'Zphase';
                app.ZphaseButton_x.Position = [1 1 65 20];

                app.LogFreqButton_x = uiradiobutton(app.XaxisButtonGroup);
                app.LogFreqButton_x.Text = 'Log Freq';
                app.LogFreqButton_x.Position = [1 115 70 20];

                app.PatientNameEditFieldLabel = uilabel(app.UIFigure);
                app.PatientNameEditFieldLabel.HorizontalAlignment = 'right';
                app.PatientNameEditFieldLabel.Position = [37 387 78 22];
                app.PatientNameEditFieldLabel.Text = 'Patient Name';

                app.PatientNameEditField = uieditfield(app.UIFigure, 'text');
                app.PatientNameEditField.ValueChangedFcn = createCallbackFcn(app, @PatientNameEditFieldValueChanged, true);
                app.PatientNameEditField.Position = [135 387 150 22];
                app.PatientNameEditField.Value='';

                app.DateofMeasurementDatePickerLabel = uilabel(app.UIFigure);
                app.DateofMeasurementDatePickerLabel.HorizontalAlignment = 'right';
                app.DateofMeasurementDatePickerLabel.Position = [1 350 120 22];
                app.DateofMeasurementDatePickerLabel.Text = 'Date of Measurement';

                app.DateofMeasurementDatePicker = uidatepicker(app.UIFigure);
                app.DateofMeasurementDatePicker.ValueChangedFcn = createCallbackFcn(app, @DateofMeasurementDatePickerValueChanged, true);
                app.DateofMeasurementDatePicker.Position = [136 350 150 22];

                app.DataPathEditFieldLabel = uilabel(app.UIFigure);
                app.DataPathEditFieldLabel.HorizontalAlignment = 'right';
                app.DataPathEditFieldLabel.Position = [64 427 58 22];
                app.DataPathEditFieldLabel.Text = 'Data Path';

                app.DataPathEditField = uieditfield(app.UIFigure, 'text');
                app.DataPathEditField.Position = [133 427 152 22];

                app.StatusTextAreaLabel = uilabel(app.UIFigure);
                app.StatusTextAreaLabel.HorizontalAlignment = 'right';
                app.StatusTextAreaLabel.Position = [376 142 39 22];
                app.StatusTextAreaLabel.Text = 'Status';

                app.StatusTextArea = uitextarea(app.UIFigure);
                app.StatusTextArea.Editable = 'off';
                app.StatusTextArea.Position = [430 4 211 162];

                app.ResultsSliderLabel = uilabel(app.UIFigure);
                app.ResultsSliderLabel.HorizontalAlignment = 'right';
                app.ResultsSliderLabel.Position = [21 66 45 22];
                app.ResultsSliderLabel.Text = 'Results';

                app.ResultsSlider = uislider(app.UIFigure);
                app.ResultsSlider.Limits = [0 10];
                app.ResultsSlider.Position = [87 75 248 3];

                app.ImportDataButton = uibutton(app.UIFigure, 'push');
                app.ImportDataButton.ButtonPushedFcn = createCallbackFcn(app, @ImportDataButtonPushed, true);
                app.ImportDataButton.BackgroundColor = [0.302 0.7451 0.9333];
                app.ImportDataButton.Position = [42 311 100 22];
                app.ImportDataButton.Text = 'Import Data';

                app.YaxisButtonGroup = uibuttongroup(app.UIFigure);
                app.YaxisButtonGroup.Title = 'Y axis';
                app.YaxisButtonGroup.Position = [211 112 122 156];

                app.FrequencyButton_y = uiradiobutton(app.YaxisButtonGroup);
                app.FrequencyButton_y.Text = 'Frequency';
                app.FrequencyButton_y.Position = [1 92 75 20];
                app.FrequencyButton_y.Value = true;

                app.RealZButton_y = uiradiobutton(app.YaxisButtonGroup);
                app.RealZButton_y.Text = 'Real Z';
                app.RealZButton_y.Position = [1 69 65 20];

                app.ImagZButton_y = uiradiobutton(app.YaxisButtonGroup);
                app.ImagZButton_y.Text = 'Imag Z';
                app.ImagZButton_y.Position = [1 46 79 20];

                app.ZButton_y = uiradiobutton(app.YaxisButtonGroup);
                app.ZButton_y.Text = '|Z|';
                app.ZButton_y.Position = [1 23 65 20];

                app.ZphaseButton_y = uiradiobutton(app.YaxisButtonGroup);
                app.ZphaseButton_y.Text = 'Zphase';
                app.ZphaseButton_y.Position = [1 1 65 20];

                app.LogFreqButton_y = uiradiobutton(app.YaxisButtonGroup);
                app.LogFreqButton_y.Text = 'Log Freq';
                app.LogFreqButton_y.Position = [1 115 70 20];

                app.PlotButton = uibutton(app.UIFigure, 'push');
                app.PlotButton.ButtonPushedFcn = createCallbackFcn(app, @PlotButtonPushed, true);
                app.PlotButton.BackgroundColor = [0.302 0.7451 0.9333];
                app.PlotButton.Position = [182 311 100 22];
                app.PlotButton.Text = 'Plot';

                app.SaveButton = uibutton(app.UIFigure, 'push');
                app.SaveButton.ButtonPushedFcn = createCallbackFcn(app, @SaveButtonPushed, true);
                app.SaveButton.BackgroundColor = [0.302 0.7451 0.9333];
                app.SaveButton.Position = [182 280 100 22];
                app.SaveButton.Text = 'Save';
                
                
                app.UIFigure.Visible = 'on';
                diary off
                app.StatusTextArea.Value=fileread('call');
            catch ME
                disp('initialization error')
                disp(ME.message)
                diary off
                app.StatusTextArea.Value=fileread('call');
            end
        end
    end
    methods (Access = public)
        function app = gui
            createComponents(app)
            registerApp(app, app.UIFigure)
            try
                app.parsefile('short_data.txt',1);
            catch 
                disp('Short data not avilable for offset')
                app.Sfreqs=[];
                app.SZs=[];
                app.SreZ=[];
                app.SimZ=[];
            end
            
            if nargout == 0
                clear app
            end
        end
        function delete(app)
            if exist('call','File')
                diary off
                delete call
            end
            delete(app.UIFigure)
        end
    end
end