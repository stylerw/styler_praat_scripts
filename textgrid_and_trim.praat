# Grid Assistant
# Will Styler - 2020
#
# This script will just open all files in a folder and generate textgrids, save the grid for the original file, then save a trimmed version (to the second interval in the grid) and amplitude normed of the file as a stimulus with the stim_ prefix
#
# This makes the script great for cleaning and reviewing stimuli.  

# If you change the below "0" to a "1", it'll open all files, whether already gridded or not.  This is great for reviewing your work.
viewall = 0

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
	    Save as text file: "'directory$''soundname$'.TextGrid"
	    wstart = Get start point: 1, 2
	    wend = Get end point: 1, 2
	    selectObject: "Sound 'soundname$'"
	    Extract part: wstart, wend, "Hamming", 1, "no"
	    selectObject: "Sound 'soundname$'_part"
	    Save as WAV file: "'directory$'stim_'soundname$'.wav"
    endif
    selectObject: "Sound 'soundname$'"
    plusObject: "Sound 'soundname$'_part"
    plusObject: "TextGrid 'soundname$'"
    Remove
    lastsound$ = soundname$
endfor
select Strings list
Remove
