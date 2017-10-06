# Formant, Pitch, and Amplitude finder
# Will Styler, 5/24/12
# Originally written for Ksenia Bogomolets at the University of Colorado
# 
# This part presents a form to the user
form Measure Formants, Pitch, and Amplitude
	comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
# This may need to be \
directory$ = "'directory$'" + "/" 
resultfile$ = "'directory$'"+"arapahopitchlog.txt"

header_row$ = "filename" + tab$ + "word" + tab$ + "vowel" + tab$ + "Duration" + tab$ + "MaxF0" + tab$ + "MeanF0" + tab$ + "MaxAmp" + tab$ + "MeanAmp" + tab$ + "F1" + tab$ + "F2" + tab$ + "F3" + newline$

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
		# First we operate on the first tier where the fun stuff is
		number_intervals = Get number of intervals... 1

		# Go through each item
		for k from 1 to number_intervals
			select TextGrid 'soundname$'
			int_label$ = Get label of interval... 1 'k'
			# Get word label Here it's Tier 2, interval 1
			word_label$ = Get label of interval... 2 1
		
			#checks if interval has a labeled vowel			
			if int_label$ <> ""

				# Calc start, end, and duration of interval
				intstart = Get starting point... 1 'k'
				intend = Get end point... 1 'k'
				intdur = intend - intstart
				intmid = intstart + (intdur / 2)

				# Get all the formants!
				select Sound 'soundname$'
				To Formant (burg)... 0 5 5500 0.025 50
				intf1 = Get value at time... 1 'intmid' Hertz Linear
				intf2 = Get value at time... 2 'intmid' Hertz Linear
				intf3 = Get value at time... 3 'intmid' Hertz Linear

				select Sound 'soundname$'
				# Get interval amplitude
				intmeanamp = Get mean... 0 'intstart' 'intend'
				intmaxamp = Get maximum... 'intstart' 'intend' Sinc70

				# Get pitch stuff
				select Sound 'soundname$'
				To Pitch... 0 75 300
				meanf0 = Get mean... 'intstart' 'intend' Hertz
				maxf0 = Get maximum... 'intstart' 'intend' Hertz Parabolic


				# Dump results into a file.
				result_row$ = "'filename$'" + tab$ + "'word_label$'" + tab$ + "'int_label$'" + tab$ + "'intdur'" + tab$ + "'maxf0'" + tab$ + "'meanf0'" + tab$ + "'intmaxamp'" + tab$ + "'intmeanamp'" + tab$ + "'intf1'" + tab$ + "'intf2'" + tab$ + "'intf3'" + newline$
		
				fileappend "'resultfile$'" 'result_row$'
			endif
		endfor
	endif
endfor
