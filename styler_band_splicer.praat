# Will Styler's Band Splicer Script
#
# Version 0.5.0, July 2010
# 
# This script is designed to break a vowel into horizontal stripes, each containing a different frequency band, and then recombine those stripes in such a way as to replace one stripe in one vowel with the same frequency stripe in another vowel.
#
# This would allow you, then, to replace the acoustical F1 in one word/vowel with one from another. it was designed for fishing expeditions regarding the presence or absence of features in speech, and will likely be used as a part of Will's dissertation.

# This part presents a form to the user
form Splice donor band into recipients
	comment Donor Sound File:
	text donorfile joshnasals_band_can-o
	comment Tiers in the TextGrid for:
        integer vowel 1
        integer word 2
	comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
	comment Bandwidth
        integer bandwidth 500
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
					Rename... recip
					recip_DB = Get intensity (dB)
					select Sound recip
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
		
		# 7: Match durations!
		# 5: Change duration of longer sound to match the shorter one
		
		select Sound donor
		ddur = Get total duration
		select Sound recip
		rdur = Get total duration
		if ddur > rdur
			durdiff = ddur - rdur
			
			select Sound donor
			# Drop into a point process to get the start of the cycle at start and end, not just a zero crossing.
			To PointProcess (periodic, cc)... 75 300
			lowerbound = ddur - durdiff
			lbpulse = Get nearest index... lowerbound
			lbpulsetime = Get time from index... lbpulse
			select Sound donor
			Rename... donorpresnip
			dsnipz = Get nearest zero crossing... 1 lbpulsetime
			Extract part... 0 dsnipz rectangular 1 no
			Rename... donor
		endif
		if rdur > ddur
			durdiff = rdur - ddur
			mp = rdur/2
			select Sound recip
			# Drop into a point process to get the start of the cycle at start and end, not just a zero crossing.
			To PointProcess (periodic, cc)... 75 300
			lowerbound = rdur - durdiff
			lbpulse = Get nearest index... lowerbound
			lbpulsetime = Get time from index... lbpulse
			select Sound recip
			Rename... recippresnip
			rsnipz = Get nearest zero crossing... 1 lbpulsetime
			Extract part... 0 rsnipz rectangular 1 no
			Rename... recip
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
		Rename... fullsplice

	#	Write to text file... 'directory$'output/'soundname$'_'bandlow'-'bandhigh'Hz.TextGrid
	
		select Sound fullsplice
		Write to WAV file... 'directory$'output/'soundname$'_0_fullsplice.wav

		# 8: Generate a bandpassed vertical splice
		#
		# DONOR = NASAL
		
		bandlow = 0
		bandhigh = bandwidth
		stripenum = 20000 / bandwidth
		for s from 1 to stripenum
			
			select Sound donor
			Filter (pass Hann band)... bandlow bandhigh 5
			Rename... dpass

			select Sound recip
			Filter (stop Hann band)... bandlow bandhigh 5
			Rename... rpass

			
			Formula... (self[col]) + (Sound_dpass[col])
			Rename... mixvow
			Scale intensity... recip_DB

			
			# 9: Paste the resulting vowel into the recip context
			select Sound wordstart
			Copy... wordstartcat
			select Sound wordend
			Copy... wordendcat

			select Sound wordendcat
			plus Sound mixvow
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
			
	#		Write to text file... 'directory$'output/'soundname$'_'bandlow'-'bandhigh'Hz.TextGrid
		
			select Sound recipwordnew
			Write to WAV file... 'directory$'output/'soundname$'_'bandlow'-'bandhigh'Hz.wav
			bandlow = bandlow + bandwidth
			bandhigh = bandhigh + bandwidth

			select all
			minus Sound 'soundname$'
			minus TextGrid 'soundname$'
			minus Strings list
			minus Sound donor
			minus Sound recip
			minus Sound wordstart
			minus Sound wordend
			
			Remove
		endfor
endfor
# This closes the for loop if we're iterating
