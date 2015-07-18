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
	gridfile$ = "'directory$''sound$'.TextGrid"
	if fileReadable (gridfile$)
		junkvar = 1
	else
		soundname$ = selected$ ("Sound", 1)
		selectObject: "Sound 'soundname$'"
		Scale intensity: 70
		To TextGrid: "vowel", ""
		selectObject: "Sound 'soundname$'"
		plusObject: "TextGrid 'soundname$'"
		Edit
		editor TextGrid 'soundname$'
			pause When ready to move onto the next file, click Continue
		# You'll need to manually close the window (or it won't close at all).  This is oddly more efficient.
		endeditor
		selectObject: "TextGrid 'soundname$'"
		Save as text file: "'directory$''soundname$'.TextGrid"
		selectObject: "Sound 'soundname$'"
		plusObject: "TextGrid 'soundname$'"
		Remove
	endif
endfor
select Strings list
Remove
