# Duration Finder
# Will Styler, 2012
#
# This script measures the duration (in seconds and milliseconds) of every file in a folder and dumps to a file.  It's awesome, and great for getting durations for reaction time expts.
# 
# This part presents a form to the user
form Measure stuff iteratively
	comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 
resultfile$ = "'directory$'"+"durationlog.txt"

header_row$ = "filename" + tab$ + "seconddur" + tab$ + "milliseconddur" + newline$
fileappend "'resultfile$'" 'header_row$'

# List of all the sound files in the specified directory:
Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

# This opens all the files one by one
for j from 1 to number_files
	select Strings list
	filename$ = Get string... 'j'
	Read from file... 'directory$''filename$'
	dur = do ("Get total duration")
	msdur = dur *1000
	# Dump results into a file.
	result_row$ = "'filename$'" + tab$ + "'dur'" + tab$ + "'msdur'" + newline$
	fileappend "'resultfile$'" 'result_row$'
endfor
