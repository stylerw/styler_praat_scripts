# Grid Assistant
# Will Styler - 2015
#
# This script will just open all files in a folder and generate textgrids
#
# This makes the script great for cleaning and reviewing stimuli.  

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
	if fileReadable (gridfile$)
		selectObject: "Sound 'soundname$'"
		Remove
	elif fileReadable (badfile$)
		selectObject: "Sound 'soundname$'"
		Remove
	else
		selectObject: "Sound 'soundname$'"
		To TextGrid: "vowel", ""
		selectObject: "Sound 'soundname$'"
		Filter (pass Hann band): 0, 5000, 100
		Scale intensity: 70
		
		selectObject: "Sound 'soundname$'_band"
		plusObject: "TextGrid 'soundname$'"
		Edit
		editor TextGrid 'soundname$'
			beginPause ("If the sound file is fine, click OK.  If the target is missing or otherwise bad , click Bad File")
				skipstat = endPause ("Bad file!", "OK", 2)
		endeditor
		selectObject: "TextGrid 'soundname$'"
		if skipstat <> 2
			Save as text file: "'directory$''soundname$'.isBad"
		else
			Save as text file: "'directory$''soundname$'.TextGrid"
		endif
		selectObject: "Sound 'soundname$'"
		plusObject: "Sound 'soundname$'_band"
		plusObject: "TextGrid 'soundname$'"
		Remove
	endif
endfor
select Strings list
Remove
