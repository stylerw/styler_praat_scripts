#######################################################################
#
#	Automated Nasality Measure for Two-channel Oral Nasal Airflow Recordings	
#
#######################################################################

####### USER SPECIFIABLE OPTIONS #######

# Height of the low-pass filter
filterheight = 40
threshold = 0.000001

################# DON'T EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING :) ###############################################

form Get %nasalance statistics and more
	comment Directory of sound files and text grids:
		text directory /Users/stylerw/Desktop/arabic/
	comment Tiers in the TextGrid for:
		integer vowel 1
		integer word 3
		integer consonant 2
	comment Sound file extension:
		optionmenu file_type: 2
		option .aiff
		option .wav
	comment How many measures per measured segment? (1 for midpoint only, 3 for start/mid/end)
		integer tpnum 7
	comment Go by samples?
		optionmenu samples: 1
		option Yes
		option No
	comment Which channel is oral vs. nasal?
		integer oralchan 1
		integer nasalchan 2

endform
resultfile$ = "'directory$'"+"nasalance.txt"


#### This creates the Strings object necessary to properly transfer data between the main script and the formant changer script
Read Strings from raw text file... stringsfile.txt
Rename... tempfile

# List of all the sound files in the specified directory:
Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

# Set up log file:
header_row$ = "Filename" + tab$ + "SegmentLab" + tab$ + "Duration" + tab$ + "Timepoint" + tab$ + "Time" + tab$ + "MaxExtremum" + tab$ + "TimeOfMaxExt" + tab$ + "OralAmp" + tab$ + "NasalAmp" + tab$ + "Nasalance" + newline$
fileappend "'resultfile$'" 'header_row$'


# Go through all the sound files, one by one:
# Starting from here, add everything that should be repeated for each sound file

call Individual_Pass

# That's all folks.  The rest is just procedures :D

procedure Individual_Pass
	for j from 1 to number_files
		select Strings list
		filename$ = Get string... 'j'
		Read from file... 'directory$''filename$'
		soundname$ = selected$ ("Sound")
		### identify associated TextGrid to check if the word has a nasal (orthographic n or m), also load for later
		gridfile$ = "'directory$''soundname$'.TextGrid"
		if fileReadable (gridfile$)
			Read from file... 'gridfile$'
			select Sound 'soundname$'
			Filter (pass Hann band)... 0 'filterheight' 5
			select Sound 'soundname$'
			Rename... 'soundname$'_orig
			select Sound 'soundname$'_band
			Rename... 'soundname$'
			select Sound 'soundname$'
			#### These three lines check the sound name against the already done list, skipping the procedure if they're there
			Extract one channel... 'oralchan'
			Rename... 'soundname$'_oralflow
			select Sound 'soundname$'
			Extract one channel... 'nasalchan'
			Rename... 'soundname$'_nasalflow
			select TextGrid 'soundname$'

# Do this once for all vowels labeled


			number_intervals = Get number of intervals... 'vowel'
			# Go through all vowel intervals in the file
			# Starting from here, add everything that should be repeated for each vowel
			for k from 1 to number_intervals
				select TextGrid 'soundname$'
				# For files where the textgrid only contains one interval for the vowel which is unlabeled, this will cover it.
				vowel_label$ = Get label of interval... 'vowel' 'k'
				## The next line only works if there is exactly one vowel per word ##
				#checks if interval has a labeled vowel
				if vowel_label$ <> ""
					start = Get starting point... 'vowel' 'k'
					end = Get end point... 'vowel' 'k'
					midpoint = start + ((end - start) / 2)
					duration = (end - start) * 1000
					durationms = (end - start)
					finishing_time = Get finishing time
					rndduration = round('duration')
					call getmax
					if samples = 1
						call Analyze_Samples
					else
						for w from 1 to tpnum	
							call Analyze_Point
						endfor
					endif
				endif
			endfor

# Now do this for all consonants
			select TextGrid 'soundname$'
# 
			number_intervals = Get number of intervals... 'consonant'
			# Go through all vowel intervals in the file
			# Starting from here, add everything that should be repeated for each vowel
			for k from 1 to number_intervals
				select TextGrid 'soundname$'
				# For files where the textgrid only contains one interval for the vowel which is unlabeled, this will cover it.
				vowel_label$ = Get label of interval... 'consonant' 'k'
				## The next line only works if there is exactly one vowel per word ##
				#checks if interval has a labeled vowel
				if vowel_label$ <> ""
					start = Get starting point... 'consonant' 'k'
					end = Get end point... 'consonant' 'k'
					midpoint = start + ((end - start) / 2)
					duration = (end - start) * 1000
					durationms = (end - start)
					finishing_time = Get finishing time
					rndduration = round('duration')
					call getmax
					if samples = 1
						call Analyze_Samples
					else
						for w from 1 to tpnum	
							call Analyze_Point
						endfor
					endif
				endif
			endfor
		else 
			select Sound 'soundname$'
		endif
	endfor
endproc

procedure Analyze_Point
	size = durationms / tpnum

	if w = 1
		timepoint = 'start'
	else
		
		timepoint = 'start' + ( 'size' * 'w' )
	endif

	tpname = 'w'
	if tpnum = 1
		timepoint = 'midpoint'
	endif
	
	select Sound 'soundname$'_oralflow
	opower = Get value at time... 0 'timepoint' Sinc70
	select Sound 'soundname$'_nasalflow
	npower = Get value at time... 0 'timepoint' Sinc70
	if ('opower'+'npower') < 'threshold'
		nasalance = 0
	else
		nasalance = ('npower'/('opower'+'npower'))
	endif
	call Log_output
endproc

procedure Analyze_Samples
	starts = Get sample number from time... 'start'
	ends = Get sample number from time... 'end'
	diff = 'ends' - 'starts'
	snum = 'diff'/20
	c = 1
	for w from starts to ends
		tpname = 'c'
		w = 'w' + 50
		c = 'c' + 1
		timepoint = 'w'
		select Sound 'soundname$'_oralflow
		opower = Get value at sample number... 0 'w'
		select Sound 'soundname$'_nasalflow
		npower = Get value at sample number... 0 'w'
		if ('opower'+'npower') < 'threshold'
			nasalance = 0
		else
			nasalance = ('npower'/('opower'+'npower'))
		endif
		call Log_output
	endfor
endproc


procedure getmax
	select Sound 'soundname$'_nasalflow
	max = Get maximum... 'start' 'end' Sinc70
	min = Get minimum... 'start' 'end' Sinc70
	maxtime = Get time of maximum... 'start' 'end' Sinc70
	mintime = Get time of minimum... 'start' 'end' Sinc70

	if abs(max) > abs(min)
		extamp = abs(max)
		extime = maxtime
	else
		extamp = abs(min)
		extime = mintime
	endif

endproc

procedure Log_output
        #save result to text file	            
	result_row$ = "'soundname$'" + tab$ + "'vowel_label$'" + tab$ + "'durationms'" + tab$ + "'tpname'" + tab$ + "'timepoint'" + tab$ + "'extamp'" + tab$ + "'extime'" + tab$ + "'opower'" + tab$ + "'npower'" + tab$ + "'nasalance'" + newline$
        fileappend "'resultfile$'" 'result_row$'
endproc



