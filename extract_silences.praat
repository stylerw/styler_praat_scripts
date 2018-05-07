# Silence Finder
# Will Styler - 2018
# 
# This Praat script will find silences in sound files


form Normalize Amplitude in sound files
	comment Sound file extension:
	     optionmenu file_type: 2
	     option .aiff
	     option .wav
	comment Draw png showing boundaries?
			boolean draw yes
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 

Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings
for ifile to number_files
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'directory$''sound$'
	objectname$ = selected$ ("Sound")
	To TextGrid (silences)...  100 0.01  -30 0.05 0.1 sil 
	Save as text file... 'directory$''objectname$'.TextGrid
	if draw
		Erase all
		selectObject: "Sound 'objectname$'"
		Select inner viewport: 1, 9, 0.5, 2.5
		Draw: 0, 0, 0, 0, "no", "Curve"
		Select inner viewport: 1, 9, 2.5, 4.5
		noprogress To Spectrogram: 0.005, 5000, 0.002, 20, "Gaussian"
		Paint: 0, 0, 0, 0, 100, "yes", 50, 6, 0, "yes"
		Select inner viewport: 1, 9, 0.5, 4.5
		selectObject: "TextGrid 'objectname$'"
		Draw: 0, 0, "yes", "yes", "yes"
		Save as 300-dpi PNG file... 'directory$''objectname$'.png
	endif
	select all
	minus Strings list
	Remove

endfor
