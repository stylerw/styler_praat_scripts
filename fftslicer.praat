# FFT Slicer, Will Styler, 2008
# Add this script to your "spectrogram" menu to have an easier way to get an FFT (spectral slice) from a given point.  
# Based on a script by Rebecca Scarborough

# Make a temporary selection from the original sound:
cursor = Get cursor
start = cursor - 0.015
end = cursor + 0.015
Select... start end

# name the new Sound object according to the time point where the cursor was
milliseconds = round (cursor * 1000)
Extract windowed selection... FFT_'milliseconds'ms Kaiser2 2 no

# leave the Sound editor for a while to calculate and draw the spectrum
endeditor

# Make the Spectrum object from the new Sound
To Spectrum (fft)
Edit
editor Spectrum FFT_'milliseconds'ms
# zoom the spectrum to a comfortable frequency view...
Zoom... 0 5000
endeditor

# select and remove the temporary Sound object 
select Sound FFT_'milliseconds'ms
Remove

# return to the Sound editor window and recall the original cursor position
editor
Move cursor to... cursor
