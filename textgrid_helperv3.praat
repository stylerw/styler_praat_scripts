# Grid Assistant
# Will Styler - 2015
#
# This script will just open all files in a folder and generate textgrids
#
# This makes the script great for cleaning and reviewing stimuli.  

# If you change the below "0" to a "1", it'll open all files, whether already gridded or not.  This is great for reviewing your work.
viewall = 0

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
		if viewall = 1
			Filter (pass Hann band): 0, 5000, 100
			Scale intensity: 70
			Read from file... 'directory$''soundname$'.TextGrid
			selectObject: "Sound 'soundname$'_band"
			plusObject: "TextGrid 'soundname$'"
			Edit
			editor TextGrid 'soundname$'
				beginPause ("If the sound file is fine, click OK.  If the target is missing or otherwise bad , click Bad File")
					skipstat = endPause ("Redo last", "Bad file!", "OK", 3)
			endeditor
			selectObject: "TextGrid 'soundname$'"
			if skipstat == 2
				Save as text file: "'directory$''soundname$'.isBad"
			elsif skipstat == 3
				Save as text file: "'directory$''soundname$'.TextGrid"
			elsif skipstat == 1
				lastgridfile$ = "'directory$''lastsound$'.TextGrid"
				lastbadfile$ = "'directory$''lastsound$'.isBad"
				deleteFile: lastgridfile$
				deleteFile: lastbadfile$
				selectObject: "Sound 'soundname$'"
				plusObject: "Sound 'soundname$'_band"
				plusObject: "TextGrid 'soundname$'"
				Remove
				goto restart
			endif
			lastsound$ = soundname$
		endif

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
				skipstat = endPause ("Redo last", "Bad file!", "OK", 3)
		endeditor
		
		selectObject: "TextGrid 'soundname$'"
		if skipstat == 2
			Save as text file: "'directory$''soundname$'.isBad"
		elsif skipstat == 3
			Save as text file: "'directory$''soundname$'.TextGrid"
		elsif skipstat == 1
			lastgridfile$ = "'directory$''lastsound$'.TextGrid"
			lastbadfile$ = "'directory$''lastsound$'.isBad"
			deleteFile: lastgridfile$
			deleteFile: lastbadfile$
			selectObject: "Sound 'soundname$'"
			plusObject: "Sound 'soundname$'_band"
			plusObject: "TextGrid 'soundname$'"
			Remove
			goto restart
		endif
		selectObject: "Sound 'soundname$'"
		plusObject: "Sound 'soundname$'_band"
		plusObject: "TextGrid 'soundname$'"
		Remove
		lastsound$ = soundname$
	endif
endfor
select Strings list
Remove
