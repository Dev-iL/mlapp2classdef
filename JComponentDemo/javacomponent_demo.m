function javacomponent_demo
%% javacomponent "docs": Delete lines 2-3 from javacomponent.m to get access to docs using F1 (help browser)
hFig = figure(); 
gauge_demo(hFig);      % < Callback example here

hFig2 = figure(); 
spinner_demo(hFig2);   % < Callback example here
text_area_demo(hFig2);
knob_demo(hFig2);      % < Callback example here

% NOT WORKING ATM
% alert_demo(hFig2);
% switch_demo(hFig2);
end
%{
function alert_demo(hFig)
jAlert = javacomponent(com.jidesoft.alert.Alert,[50 200 100 50], hFig);
jAlert.setBackground(java.awt.Color(1,0.7,0.7));
jAlert.setShowAnimation(com.jidesoft.animation.CustomAnimation(...
  com.jidesoft.animation.CustomAnimation.TYPE_ENTRANCE,...
  com.jidesoft.animation.CustomAnimation.EFFECT_FADE,...
  com.jidesoft.animation.CustomAnimation.SMOOTHNESS_VERY_SMOOTH,...
  com.jidesoft.animation.CustomAnimation.SPEED_FAST));
jAlert.setHideAnimation(com.jidesoft.animation.CustomAnimation(...
  com.jidesoft.animation.CustomAnimation.TYPE_ENTRANCE,...
  com.jidesoft.animation.CustomAnimation.EFFECT_ZOOM,...
  com.jidesoft.animation.CustomAnimation.SMOOTHNESS_VERY_SMOOTH,...
  com.jidesoft.animation.CustomAnimation.SPEED_FAST));

jAlert.setResizable(true);
jAlert.setMovable(true);
jAlert.setTimeout(2000);
jAlert.setTransient(false);

jAlert.showPopup;
end
%}

function knob_demo(hFig)
%% Intro

%% Demo
grayColor = java.awt.Color(0.4,0.4,0.4);
lightGray = java.awt.Color(0.7,0.7,0.7);
% Create component:
jDial = javacomponent(com.jidesoft.gauge.Dial,[250,40,300,300], hFig);
jDial.setTickColor(grayColor);
% Configure axis:
jDial.Axis.setRangeStart(0);
jDial.Axis.setRangeEnd(100);
jDial.Axis.setStartAngle(240);
jDial.Axis.setEndAngle(-60);
jDial.Axis.setInnerRadius(0.86);
jDial.Axis.setOuterRadius(0.78);
jDial.Axis.setLabelRadius(0.95);
jDial.Axis.setTickLabelFont(java.awt.Font('Helvetica', java.awt.Font.PLAIN, 12));
jDial.Axis.setTickLabelColor(grayColor);
set(jDial.Axis.getMajorTickStyle,'TickWidth',3)
set(jDial.Axis.getMinorTickStyle,'TickWidth',3)
% Configure frame:
jDialFrame = com.jidesoft.gauge.DialFrame;
jDialFrame.setFrameWidth(0); 
jDial.setFrame(jDialFrame);
jDial.update;
% Configure needles:
jNeedle = com.jidesoft.gauge.NeedleStyle();
jNeedle.setFillPaint(grayColor);
jNeedle.setTailWidth(1.5);
jNeedle.setBaseWidth(1.5);
jNeedle.setHeadWidth(1.5);
jNeedle.setHeadLength(0);
jDial.addNeedle('bottomCircle',jNeedle);
jDial.setValue('bottomCircle',0);
jNeedle.setHeadShape(com.jidesoft.gauge.NeedleEndShape.ROUND);

jNeedle = com.jidesoft.gauge.NeedleStyle();
jNeedle.setFillPaint(lightGray);
jNeedle.setTailWidth(0);
jNeedle.setBaseWidth(0);
jNeedle.setHeadWidth(0.65);
jNeedle.setHeadShape(com.jidesoft.gauge.NeedleEndShape.TRIANGULAR);
jNeedle.setHeadLength(0.08);
jDial.addNeedle('bottomArrow',jNeedle);
jDial.setValue('bottomArrow',0);

jNeedle = com.jidesoft.gauge.NeedleStyle();
jNeedle.setFillPaint(java.awt.Color.RED);
jNeedle.setHeadWidth(0.04);
jNeedle.setHeadShape(com.jidesoft.gauge.NeedleEndShape.TRIANGULAR);
jNeedle.setBaseWidth(0.3);
jNeedle.setHeadLength(0.68);
jDial.addNeedle('redPart',jNeedle);
jDial.setValue('redPart',0);

jNeedle = com.jidesoft.gauge.NeedleStyle();
jNeedle.setFillPaint(lightGray);
jNeedle.setTailWidth(0.7);
jNeedle.setBaseWidth(0.7);
jNeedle.setHeadWidth(0.7);
jNeedle.setHeadLength(0);
jDial.addNeedle('topCircle',jNeedle);
jDial.setValue('topCircle',0);
jNeedle.setHeadShape(com.jidesoft.gauge.NeedleEndShape.ROUND);
% Configure callbacks:
set(jDial,'MouseDraggedCallback',@setKnobValue,...
          'MouseClickedCallback',@setKnobValue,...
          'PropertyChangeCallback',@valueChangedCallback);

function setKnobValue(hObject,eventdata)
  % Find angle of click:
  ang_bounds = [hObject.Axis.getStartAngle, hObject.Axis.getEndAngle];
  val_bounds = [hObject.Axis.getRangeStart, hObject.Axis.getRangeEnd];
  D = mod(atan2d(hObject.PivotY-get(eventdata,'Y'), get(eventdata,'X')-hObject.PivotX), 360);
  disallowed_angles = mod(ang_bounds,360);
  if ~isnan(discretize(D, disallowed_angles))
    [~,I] = min(abs(D - mod(ang_bounds,360)));
    D = ang_bounds(I);
  end
  % Convert angle to value (linear interpolation):
  if D > max(disallowed_angles)
    newVal = mod(D-ang_bounds(1),-360) ./ (ang_bounds(2)-ang_bounds(1))*(val_bounds(2)-val_bounds(1))+val_bounds(1);
  else
    newVal = (D-ang_bounds(1)) ./ (ang_bounds(2)-ang_bounds(1))*(val_bounds(2)-val_bounds(1))+val_bounds(1);
  end
  % Set dials to required angle:  
  hObject.setValue('bottomArrow', newVal);
  hObject.setValue('redPart', newVal); % will be intercepted by valueChangedCallback
end

function valueChangedCallback(hObject,eventdata)
% here we notify listeners, update other elements, print logs, etc.
NEEDLE_THAT_COUNTS = 'redPart';
  if strcmp(eventdata.getPropertyName,NEEDLE_THAT_COUNTS)
    disp(['The new knob value is: ' num2str(double(hObject.getValue(NEEDLE_THAT_COUNTS)))]);
    % or: num2str(eventdata.getNewValue)
  end
end

end

function switch_demo(hFig)
%% Intro

%% Demo
jTb = javacomponent(com.jidesoft.swing.JideToggleButton,[50,280,200,50],hFig);
jTb.Text = 'Toggle Button';
end

function text_area_demo(hFig)
%% Intro
% http://docs.oracle.com/javase/7/docs/api/javax/swing/JTextArea.html
% http://www.jidesoft.com/javadoc/com/jidesoft/swing/AutoResizingTextArea.html
%% Demo
jTA = javacomponent(javax.swing.JTextArea,[50,350,200,50], hFig);
jTA.setText('Some text');
% jBox = javacomponent(com.jidesoft.swing.JideBoxLayout(hFig),[260,200,200,50]);
% jARTA = javacomponent(com.jidesoft.swing.AutoResizingTextArea,[0,0,200,50], jBox);
end

function gauge_demo(hFig)
%% Intro
% As mentioned in http://undocumentedmatlab.com/blog/sliders-in-matlab-gui#range
% the JIDE visual component library ( http://www.jidesoft.com/javadoc/overview-summary.html )
% comes bundled with MATLAB.
%% Demo; see https://www.jidesoft.com/products/JIDE_Charts_Developer_Guide.pdf p.64
grayColor = java.awt.Color(0.4,0.4,0.4);
% Create component:
jDial = javacomponent(com.jidesoft.gauge.Dial,[150,40,300,300], hFig);
jDial.setTickColor(grayColor);
% Configure axis:
jDial.Axis.setRangeEnd(100);
jDial.Axis.setInnerRadius(0.87);
jDial.Axis.setOuterRadius(1);
jDial.Axis.setLabelRadius(0.78);
jDial.Axis.setTickLabelFont(java.awt.Font('Helvetica', java.awt.Font.PLAIN, 12));
jDial.Axis.setTickLabelColor(grayColor);
jDial.Axis.setStartAngle(240);
jDial.Axis.setEndAngle(-60);
% Configure needle:
jNeedle = com.jidesoft.gauge.NeedleStyle();
jNeedle.setFillPaint(java.awt.Color.RED);
jDial.addNeedle('defaultNeedle',jNeedle);
jDial.setValue('defaultNeedle',0);
% Configure frame:
jDialFrame = com.jidesoft.gauge.DialFrame;
jDialFrame.setFrameWidth(0); 
jDialFrame.setFill(java.awt.Color.WHITE); 
jDialFrame.setOuterBorderColor(grayColor); 
jDialFrame.setOuterBorderWidth(0); 
jDial.setFrame(jDialFrame);
% Configure extras:
drw = com.jidesoft.gauge.DialIntervalMarker(jDial, 0, 100, ...
  com.jidesoft.gauge.DialConicalPaint(jDial, [90,30], [java.awt.Color.GREEN, java.awt.Color.RED]));
% jDial.addDrawable(com.jidesoft.gauge.DialIntervalMarker(jDial, 0, 10, java.awt.Color.GREEN)); 
jDial.addDrawable(drw);
low = com.jidesoft.gauge.DialLabel(jDial, 0.5, 175, 'Low'); 
low.setColor(java.awt.Color.GREEN.darker()); 
jDial.addDrawable(low); 
high = com.jidesoft.gauge.DialLabel(jDial, 0.5, 5, 'High'); 
high.setColor(java.awt.Color.RED); 
jDial.addDrawable(high); 
jDial.update;
% Configure animation:
jDial.setAnimateOnChange(true);
jDial.setNeedleAnimationSpeed(3);
jDial.setNeedleAnimationPeriod(10);
drawnow(); jDial.update;
jDial.setValue('defaultNeedle',100); pause(2);
% CIRCULAR
% jDial.setStartAngle(240);
% jDial.setEndAngle(-60);
jDial.Axis.setStartAngle(240);
jDial.Axis.setEndAngle(-60);
jDial.Axis.setMajorTickInterval(20);
jDial.Axis.setMinorTickInterval(5);
pause(2);
jDial.removeDrawable(drw);
jDial.removeDrawable(low);
jDial.removeDrawable(high);
jDial.update;
pause(2);
% 90-DEGREE:
jDial.setEndAngle(88);
jDial.setStartAngle(181);
jDial.Axis.setStartAngle(180);
jDial.Axis.setEndAngle(90);
jDial.Axis.setMajorTickInterval(25);
pause(2);
% SEMI-CIRCULAR:
jDial.setEndAngle(0);
jDial.setStartAngle(180);
jDial.Axis.setEndAngle(0);
jDial.Axis.setMajorTickInterval(20);
jDial.Axis.setMinorTickInterval(5);
% LINEAR:
jSlider = javacomponent(javax.swing.JSlider,[150, 350, 300, 50], hFig);
set(jSlider,'Value', 84, 'MajorTickSpacing', 20, 'MinorTickSpacing', 5,...
  'PaintLabels', true, 'PaintTicks', true, 'StateChangedCallback',...
  @(hObject,eventdata)contSliderCallback(hObject, eventdata, jDial));

function contSliderCallback(hObject, ~, jDial)
  jDial.setValue('defaultNeedle', hObject.Value);
end

end

function hFig = spinner_demo(hFig)
%% Intro
% https://docs.oracle.com/javase/8/docs/api/javax/swing/JSpinner.html
%% Demo
% Create a spinner (w/o model): 
jJSpinnerNM = javacomponent(javax.swing.JSpinner,[50,40,80,30],hFig);
jJSpinnerNM.StateChangedCallback = @(hObject,eventdata)onSpinnerValueChanged(hObject,eventdata);
% Create a spinner (w/ model): 
spModel = javax.swing.SpinnerListModel({'item1','item2','item3'});
  % https://docs.oracle.com/javase/8/docs/api/javax/swing/SpinnerModel.html
jJSpinnerM = javacomponent(javax.swing.JSpinner(spModel),[50,80,80,30],hFig);
jJSpinnerM.StateChangedCallback = @(hObject,eventdata)onSpinnerValueChanged(hObject,eventdata);

%% Get available methods & fields, and set some properties:
M = methods(jJSpinnerM); 
F = fields(jJSpinnerM); % fields often contain the allowable settings for methods.

% Set some arbitrary properties:
jJSpinnerNM.getEditor.getTextField.setHorizontalAlignment(javax.swing.JTextField.LEFT);
jJSpinnerM.setComponentOrientation(java.awt.ComponentOrientation.RIGHT_TO_LEFT);
  % https://docs.oracle.com/javase/8/docs/api/javax/swing/SwingConstants.html

function onSpinnerValueChanged(hObject, eventdata)
  disp(['Spinner value is now: ' num2str(hObject.Value)]);
end

% Crazier demo: http://www.mathworks.com/matlabcentral/fileexchange/26970-spinnerdemo
end