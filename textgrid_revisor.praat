# Grid Revision Assistant
# Will Styler - 2016
#
# This script will just open all files in a folder with their grids, allowing you to make changes and review the work
#

directory$ = chooseDirectory$ ("Choose the directory containing sound files for gridding")
directory$ = "'directory$'" + "/" 
file_type$ = ".wav"
Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

label restart

for ifile to number_files
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'directory$''sound$'
	soundname$ = selected$ ("Sound", 1)
	gridfile$ = "'directory$''soundname$'.TextGrid"
	badfile$ = "'directory$''soundname$'.isBad"
	if fileReadable (gridfile$)
		selectObject: "Sound 'soundname$'"
			Read from file... 'directory$''soundname$'.TextGrid
			selectObject: "Sound 'soundname$'"
			plusObject: "TextGrid 'soundname$'"
			Edit
			editor TextGrid 'soundname$'
				beginPause ("After reviewing and adjusting, click OK.")
					skipstat = endPause ("OK", 1)
			endeditor
			selectObject: "TextGrid 'soundname$'"
			if skipstat == 1
				Save as text file: "'directory$''soundname$'.TextGrid"
			endif
			lastsound$ = soundname$
		endif
		selectObject: "Sound 'soundname$'"
		plusObject: "TextGrid 'soundname$'"
		Remove
		lastsound$ = soundname$
	endif
endfor
select Strings list
Remove
