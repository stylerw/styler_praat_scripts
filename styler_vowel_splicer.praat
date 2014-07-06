# CU Phonetics Lab Script
#
# Version 0.5.0
#
# This is designed to take a marked segment in one word and splice it into a bunch of other words
# You'll need to create an 'output' folder in whatever directory you're working.
# Here's hoping it works.  
# Will Styler, 9/2/2010
#
# This part presents a form to the user
form Splice donor segment into recipients
	comment Donor Sound File:
		text donorfile bryce_rcite-band
	comment Tiers in the TextGrid for:
        integer vowel 1
        integer word 2
	comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
endform

window = 0.0256

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 

# List of all the sound files in the specified directory:
Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

# Steps:
# 1: Get recip word
# 2: Cut out recip vowel
# 3: Identify donor word
# 4: Cut out donor vowel
# 5: Amplitude match both vowels
# 9: Paste the resulting vowel into the donor or recip (or both) word context
# 10: Save output
# 11: Repeat for all files in the folder
#
donorexists = 0
for j from 1 to number_files
		# 1: Get recip word
		# Remember that we only stored recip words in the stringslist above
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
	        number_intervals = Get number of intervals... 'vowel'
	        for k from 1 to number_intervals
	   			select TextGrid 'soundname$'
	   			vowel_label$ = Get label of interval... 'vowel' 'k'
	   			#checks if interval has a labeled vowel
	   			if vowel_label$ <> ""
					rstart = Get starting point... 'vowel' 'k'
					rcursor = rstart
				    rend = Get end point... 'vowel' 'k'
				    rmidpoint = rstart + ((rend - rstart) / 2)
				    rdur = rend - rstart
					select Sound 'soundname$'
					Copy...  'soundname$'_unedited
					select Sound 'soundname$'
					# Drop into a point process to get the start of the cycle at start and end, not just a zero crossing.
					To PointProcess (periodic, cc)... 75 300
					spulse = Get nearest index... rstart
					spulsetime = Get time from index... spulse
					epulse = Get nearest index... rend
					epulsetime = Get time from index... epulse

					select Sound 'soundname$'
					rstartz = Get nearest zero crossing... 1 spulsetime
					Extract part... 0 rstartz rectangular 1 no
					Rename... wordstart

					select Sound 'soundname$'
					rendz = Get nearest zero crossing... 1 epulsetime
					Extract part... rendz filedur rectangular 1 no
					Rename... wordend

					select Sound 'soundname$'
					Extract part... rstartz rendz rectangular 1 no
					Rename... recipbefore
					recip_DB = Get intensity (dB)
					select Sound recipbefore
					rvoweldur = Get total duration
				endif
			endfor
		endif
			
		# 3: Identify donor pair
		if donorexists = 0
			Read from file... 'directory$''donorfile$''file_type$'
			dsoundname$ = selected$ ("Sound")
			dgridfile$ = "'directory$''donorfile$'.TextGrid"
				if fileReadable (dgridfile$)
					Read from file... 'dgridfile$'
				select TextGrid 'dsoundname$'
				number_intervals = Get number of intervals... 'vowel'
					for k from 1 to number_intervals
							select TextGrid 'dsoundname$'
							dvowel_label$ = Get label of interval... 'vowel' 'k'
							#checks if interval has a labeled vowel
							if dvowel_label$ <> ""
								dstart = Get starting point... 'vowel' 'k'
								dend = Get end point... 'vowel' 'k'
								dmidpoint = dstart + ((dend - dstart) / 2)
								select Sound 'dsoundname$'
								Copy...  'dsoundname$'_unedited
								select Sound 'dsoundname$'
								# Drop into a point process to get the start of the cycle at start and end, not just a zero crossing.
								To PointProcess (periodic, cc)... 75 300
								dspulse = Get nearest index... dstart
								dspulsetime = Get time from index... dspulse
								depulse = Get nearest index... dend
								depulsetime = Get time from index... depulse
								
								select Sound 'dsoundname$'
								dstartz = Get nearest zero crossing... 1 dspulsetime
								dendz = Get nearest zero crossing... 1 depulsetime
								Extract part... dstartz dendz rectangular 1 no
								Rename... donor
								dvoweldur = Get total duration
								donorexists = 1
							endif
					endfor
				endif
		endif

	
		# 9: Paste the resulting vowel into the recip context
		select Sound wordstart
		Copy... wordstartcat
		select Sound wordend
		Copy... wordendcat

		select Sound wordendcat
		plus Sound donor
		Concatenate
		plus Sound wordstartcat
		Concatenate
		Rename... recipwordnew

		# 10: Save output
					
		select TextGrid 'soundname$'
		Remove right boundary... 'vowel' 1
		Remove right boundary... 'vowel' 1
		Insert boundary... 'vowel' rstartz 
		secondpoint = rstartz + dvoweldur
		Insert boundary... 'vowel' secondpoint
		Set interval text... 1 1 
		Set interval text... 1 2 V
		
		select TextGrid 'soundname$'
		
		Write to text file... 'directory$'output/'soundname$'_withsplice_.TextGrid
	
		select Sound recipwordnew
		Write to WAV file... 'directory$'output/'soundname$'_withsplice_.wav
		select all
		minus Strings list
		minus Sound donor
		Remove
endfor
# This closes the for loop if we're iterating
