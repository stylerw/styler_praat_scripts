# CU Phonetics Lab Noise Creator Helper
#
# Version 0.5.0
#
# Will Styler, 1/2014
# 
# This script will create three separate versions of a word with a labeled vowel on tier 1 that have noise replacing the onset, coda, and vowel.
# 
# It's designed for phoneme recovery experiments
#


form Add noise to a given interval
	comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 

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
	freq = do ("Get sampling frequency")
	# identify associated TextGrid
	gridfile$ = "'directory$''soundname$'.TextGrid"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		select TextGrid 'soundname$'
		number_intervals = Get number of intervals... 1
		labeledv = 0
		for kitty from 1 to number_intervals
			v_label$ = Get label of interval... 1 'kitty'
			if not labeledv
				if v_label$ <> ""
					v_startreal = Get starting point... 1 'kitty'
					v_endreal = Get end point... 1 'kitty'
					v_dur = v_endreal - v_startreal
					# adjust by 8% of the vowel's duration
					#v_start = v_startreal + (0.08 * v_dur)
					#v_end = v_endreal - (0.08 * v_dur)
					# Adjust by 12 ms
					v_start = v_startreal + 0.02
					v_end = v_endreal - 0.02
					labeledv = 1
				endif
			endif
		endfor
		select Sound 'soundname$'
		do ("Extract part...", 'v_start', 'v_end', "rectangular", 1,"no")
		soundamp = do ("Get intensity (dB)")
		do ("Scale intensity...", 70)
		#Write to WAV file... 'directory$'_noised/'soundname$'_vowelnoise.wav
		select Sound 'soundname$'
		intstart = 0
		intend = v_start
		intdur = intend - intstart
		intmid = intstart + (intdur / 2)
		do ("Create Sound from formula...", "noise", 1, 0, 'intdur', 'freq', "randomGauss(0,0.1)")
		do ("Scale intensity...", 70)
		select Sound 'soundname$'
		do ("Extract part...", 'intend', 'filedur' , "rectangular", 1,"no")
		do ("Scale intensity...", 70)
		select Sound noise
		plus Sound 'soundname$'_part
		do ("Concatenate")
		#Write to WAV file... 'directory$'_noised/'soundname$'_o.wav
		select TextGrid 'soundname$'
		intstart = v_start
		intend = v_end
		select Sound 'soundname$'

		do ("Extract part...", 'intstart', 'intend' , "rectangular", 1,"no")
		do ("Scale intensity...", 70)
		Write to WAV file... 'directory$'_noised/'soundname$'_vowel.wav
		select TextGrid 'soundname$'
		intstart = v_end
		intend = filedur
		intdur = intend - intstart
		intmid = intstart + (intdur / 2)
		select Sound 'soundname$'
		do ("Extract part...", 0, 'intstart', "rectangular", 1,"no")
		soundamp = do ("Get intensity (dB)")
		do ("Scale intensity...", 70)
		do ("Create Sound from formula...", "noise", 1, 0, 0.25, 'freq', "randomGauss(0,0.1)")
		do ("Scale intensity...", 70)
		select Sound 'soundname$'_part
		#Write to WAV file... 'directory$'_noised/'soundname$'_silentcoda.wav
		select Sound 'soundname$'_part
		plus Sound noise
		do ("Concatenate")
		#Write to WAV file... 'directory$'_noised/'soundname$'_c.wav
		select all
		minus Strings list
		Remove
	endif
endfor

