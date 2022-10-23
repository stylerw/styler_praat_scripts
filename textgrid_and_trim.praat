# Grid Assistant
# Will Styler - 2020-2022
#
# This script will just open all files in a folder and generate textgrids, save the grid for the original file, then save a trimmed version (to the second interval in the grid) and amplitude normed of the file as a stimulus with the stim_ prefix
#
# This makes the script great for cleaning and reviewing stimuli.  
windowtype$ = "hamming"
form We need some details here...
	#choice windowtype$ hamming
	#	comment What kind of window would you like to extract sounds with?
	#	button hamming
	#	button rectangular
	boolean viewall 0
		comment Would you like to view all files (rather than just those without textgrids?)
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files for gridding")
directory$ = "'directory$'" + "/"
file_type$ = ".wav"
Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

for ifile to number_files
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'directory$''sound$'
	soundname$ = selected$ ("Sound", 1)
	gridfile$ = "'directory$''soundname$'.TextGrid"
	badfile$ = "'directory$''soundname$'.isBad"	
	selectObject: "Sound 'soundname$'"
	To TextGrid: "boundaries", ""
	selectObject: "Sound 'soundname$'"
	Scale intensity: 70
	label GRIDSTEP
	selectObject: "Sound 'soundname$'"
	plusObject: "TextGrid 'soundname$'"
	Edit
	editor TextGrid 'soundname$'
		beginPause ("If the sound file is fine, click OK.  If the target is missing or otherwise bad , click Bad File")
		skipstat = endPause ("Bad file!", "OK", 2)
	endeditor
	selectObject: "TextGrid 'soundname$'"
	if skipstat == 1
		Save as text file: "'directory$''soundname$'.isBad"
	elsif skipstat == 2
		intnum = Get number of intervals: 1
		if intnum < 2
			goto GRIDSTEP
		else
			selectObject: "TextGrid 'soundname$'"
			Save as text file: "'directory$''soundname$'.TextGrid"
			wstart = Get start point: 1, 2
			wend = Get end point: 1, 2
			selectObject: "Sound 'soundname$'"
			if windowtype$ == "hamming"
				Extract part: wstart, wend, "Hamming", 1, "no"
			elsif windowtype$ == "rectangular"
				Extract part: wstart, wend, "Rectangular", 1, "no"
			endif
			selectObject: "Sound 'soundname$'_part"
			Save as WAV file: "'directory$''soundname$'.wav"
		endif
	endif
	selectObject: "Sound 'soundname$'"
	plusObject: "Sound 'soundname$'_part"
	plusObject: "TextGrid 'soundname$'"
	Remove
	lastsound$ = soundname$
endfor

select Strings list
Remove
