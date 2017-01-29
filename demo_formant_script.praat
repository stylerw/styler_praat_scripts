# Simple Formant Script!
#
# Will Styler, 5/24/14
# Written as a demo for a lecture on Praat Scripting for LING 7030: Phonetic Theory.  Designed to provide a basis for creating other scripts.
# 
# This part presents a form to the user
form Measure Formants and Duration
	comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
# This will need to be changed to \ below for PC users
directory$ = "'directory$'" + "/" 
resultfile$ = "'directory$'"+"formantlog.txt"

header_row$ = "filename" + tab$ + "vowel" + tab$ + "Duration" + tab$ + "F1" + tab$ + "F2" + tab$ + "F3" + newline$

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
	filedur = Get total duration
	# identify associated TextGrid
	gridfile$ = "'directory$''soundname$'.TextGrid"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		select TextGrid 'soundname$'
		number_intervals = Get number of intervals... 1

		# Go through each item
		for k from 1 to number_intervals
			select TextGrid 'soundname$'
			int_label$ = Get label of interval... 1 'k'
		
			#checks if interval has a label
			if int_label$ <> ""

				# Calc start, end, and duration of interval
				intstart = Get starting point... 1 'k'
				intend = Get end point... 1 'k'
				intdur = intend - intstart
				intmid = intstart + (intdur / 2)

				# Get all the formants!
				select Sound 'soundname$'
				noprogress To Formant (burg)... 0 5 5500 0.025 50
				intf1 = Get value at time... 1 'intmid' Hertz Linear
				intf2 = Get value at time... 2 'intmid' Hertz Linear
				intf3 = Get value at time... 3 'intmid' Hertz Linear

				# Dump results into a file.
				result_row$ = "'filename$'" + tab$ + "'int_label$'" + tab$ + "'intdur'" + tab$ + "'intf1'" + tab$ + "'intf2'" + tab$ + "'intf3'" + newline$
				fileappend "'resultfile$'" 'result_row$'
			endif
		endfor
	endif
endfor
