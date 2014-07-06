# Will Styler's Amplitude Measurement Helper
# Will Styler, 5/24/12
#
# Written for Alex McCallister, I think.
# 
# This part presents a form to the user
form Measure amplitude-related things
	comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 
resultfile$ = "'directory$'"+"lenitionlog.txt"

header_row$ = "filename" + tab$ + "maxamp" + tab$ + "minamp" + tab$ + "meanamp" + tab$ + "minminusmax" + newline$
fileappend "'resultfile$'" 'header_row$'

# List of all the sound files in the specified directory:
Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

# This opens all the files one by one
for j from 1 to number_files
        select Strings list
        filename$ = Get string... 'j'
        Read from file... 'directory$''filename$'
        soundname$ = selected$ ("Sound")
	select Sound soundname$
	do ("To Intensity...", 100, 0, "yes")
	min = do ("Get minimum...", 0, 0, "Parabolic")
	max = do ("Get maximum...", 0, 0, "Parabolic")
	mean = do ("Get mean...", 0, 0, "energy")
	minmax = min - max
	# Dump results into a file.
	result_row$ = "'filename$'" + tab$ + "'max'" + tab$ + "'min'" + tab$ + "'mean'" + tab$ + "'minmax'" + newline$
	fileappend "'resultfile$'" 'result_row$'
endfor
