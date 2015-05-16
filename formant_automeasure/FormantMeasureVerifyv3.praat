#######################################################################
#  Formant Measurement Script, v.3.1
#######################################################################
#  This script measures formant values at beginning, midpoint, and end
#  for vowels marked in a TextGrid annotated sound.  It also allows the
#  user to verify and, if necessary, correct each measurement before it
#  is logged. 
#
#  Input:   Sound files with associated TextGrids
#           - Files may contain multiple vowels to be measured.
#           - TextGrids should have at least 2 tiers:  one for vowels and
#             one for words.  Relevant vowel intervals must be labeled.
#           - As currently written, each word must contain exactly 1 vowel.
#  Output:  A log file containing - file name, word, vowel, F1, F2,
#           duration, and timepoint (start, midpoint, end).
#  Process: The script looks for soundfiles with a specified extension in a
#           specified folder.  For each soundfile, it finds the associated
#           TextGrid and then locates marked vowel intevals one-by-one.
#           For each vowel, a spectrogram with formant tracks and an FFT with
#           overlaid LPC are displayed.  The measurement point is marked in
#           the spectrogram, and calculated F1 & F2 values are listed.  The
#           user is asked whether the values are appropriate, with a chance to change
#	    those values.  After corrections are made (or not), the formant values
#           are logged (along with the other output information listed above).
#
#  
#  Originally written by Rebecca Scarborough with bits of code borrowed from scripts by Bert Remijsen, Mietta Lennes, and Katherine Crosswhite 7/28/05.  Heavily revised and re-written by Will Styler, 2008-2015
#
#  FormantMeasureVerifyv2.praat Modification by Will Styler, 2/14/08
#
#	In addition, this script is now able to remember where it left off, if you don't get through a whole dataset or it crashes midway through.  However, if you stop anywhere other than the start of a given vowel, you'll get duplication in your logfile.  In addition, this script now requires a file named stringsfile.txt to be in the same dir as the script stringsfile.txt must have two lines, each containing a "0" (no quotes) and nothing more.  Make your own, if you'd like.
#
#  FormantMeasureVerifyv3.praat, a further modification by Will Styler
#
#	The main difference here is the addition of an intelligent formant number selection, which works best for English data and female speakers.  Basically, if the labeled vowel is phonologically [+back] (it just works well like that), it searches with 5 formants, but otherwise, goes for four.  Also, pause forms have been implemented to enable inline formant data correction without another script, as well as to speed the process of annotation and correction when the word has clearly defined formants
#
#	Version 3.0.1: Added folder chooser dialog to script
#	Version 3.1 (May 2015): Added ability to measure N points per vowel
#
#######################################################################

form Calculate F1, F2 & duration for labeled vowels in files
   comment Tiers in the TextGrid for:
        integer vowel 2
        integer word 1
   comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
   comment Select sex of speaker:
        choice sex 2
        button male
        button female
   comment Length of window over which spectrogram is calculated:
        positive length 0.005
   comment Play sound?
        choice playit 2
        button yes
        button no
   	 comment How many formants (in 5000hz)?
        positive numformants 5
    comment How many measures per vowel?
         positive tpnum 12
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 

#### Set up progress file to hold the names of files it's already done

handfile$ = "'directory$'"+"_formanthandmeasurelog.txt"
resultfile$ = "'directory$'"+"_formantlog.txt"

Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

# Set up log file:
header_row$ = "Filename" + tab$ + "word" + tab$ + "vowel" + tab$ + "F1" + tab$ + "F2"  + tab$ + "F3"+ tab$ + "Duration" + tab$ + "Timepoint" + tab$ + "VowelPercent" + tab$ + "MeasType" + newline$
	fileappend "'resultfile$'" 'header_row$'

# Go through all the sound files, one by one:
# Starting from here, add everything that should be repeated for each sound file

for j from 1 to number_files
	select Strings list
	filename$ = Get string... 'j'
	Read from file... 'directory$''filename$'
	soundname$ = selected$ ("Sound")
	# identify associated TextGrid
	gridfile$ = "'directory$''soundname$'.TextGrid"
	if fileReadable (gridfile$)
	Read from file... 'gridfile$'
	select TextGrid 'soundname$'
	number_intervals = Get number of intervals... 'vowel'
	# Go through all vowel intervals in the file
	# Starting from here, add everything that should be repeated for each vowel
	for k from 1 to number_intervals
	    select TextGrid 'soundname$'
	    vowel_label$ = Get label of interval... 'vowel' 'k'
	    ## hack -- next line only works if there is exactly one vowel per word ##
	    word_label$ = Get label of interval... 'word' 2
	    #checks if interval has a labeled vowel
	    if vowel_label$ <> ""
			vowel_start = Get starting point... 'vowel' 'k'
			vowel_end = Get end point... 'vowel' 'k'
			midpoint = vowel_start + ((vowel_end - vowel_start) / 2)
			duration = (vowel_end - vowel_start) * 1000
			durationms = (vowel_end - vowel_start)
			
			finishing_time = Get finishing time
			#save the word that the vowel is contained in to a temporary soundfile for anaylsis
			word_start = Get starting point... 'word' 2
			word_end = Get end point... 'word' 2
			select Sound 'soundname$'
			Extract part...  'word_start'-0.25 'word_end'+0.25 Hanning 1 yes
			Rename... 'soundname$'_word
			finalformantnumber = numformants

			#create formant object
			select Sound 'soundname$'_word
			if sex = 2
				#### Originally 0.0025 in default, CHANGE ME AND EXPERIMENT!!!
				To Formant (burg)... 0.0 'finalformantnumber' 5500 0.025 50
			else
				To Formant (burg)... 0.0 'finalformantnumber' 5000 0.025 50
			endif
			size = durationms / (tpnum-1)
			skipstat = 1
			# cycle through measurement timepoints (start, mid, end)
			for point from 1 to tpnum
				if point = 1
					timepoint = 'vowel_start'
				elsif point = tpnum
					timepoint = 'vowel_end'
				else
					timepoint = vowel_start + (size * (point-1))
				endif		
				# Save the timepoint label for output
				tpname = 'point'
				vwlpct = ((timepoint-vowel_start)/durationms)*100
				# If you want start-mid-end, three timepoint measures, we have to tweak a bit
				if tpnum = 3
					# Oh Praat, why can't I nest if statements without defining some junk variable?
					junkvariable = 0
					if point = 2
						timepoint = 'midpoint'
					elsif point = 3
						timepoint = 'vowel_end'
					endif
				endif
				# If you just want one point, you want the midpoint
				if tpnum = 1
					timepoint = 'midpoint'
				endif
				point$ = "'point'"
				technical_timepoint = timepoint + 0.015
				call Calculate_formants
				call Display_spectrogram
				call Display_spectrum_and_LPC
				#### Note that for this modified script, Temp_Output must be called before Verify_, and Temp_input must come before Log_output
				if skipstat = 3
					call Verify_formants
				elsif skipstat = 1
					call Verify_formants
				endif
				if skipstat = 2
					conff1 = f1
					conff2 = f2
					conff3 = f3
				endif
				call Log_output
			endfor
			
			# get rid of temporary objects
			select Sound 'soundname$'_word
			plus Formant 'soundname$'_word
			Remove
	    endif
	    select Strings list
	    endfor
	endif
	# get rid of more temporary objects
	select Sound 'soundname$'
	plus TextGrid 'soundname$'
	Remove
endfor

procedure Calculate_formants
        select Formant 'soundname$'_word
        f1 = Get value at time... 1 'timepoint' Hertz Linear
        f2 = Get value at time... 2 'timepoint' Hertz Linear
        f3 = Get value at time... 3 'timepoint' Hertz Linear
        if f1 = undefined
        	f1 = 0
        	f2 = 0
        	f3 = 0
        endif
        if f2 = undefined
        	f1 = 0
        	f2 = 0
        	f3 = 0
        endif
        rndf1 = round('f1')
        rndf2 = round('f2')
        rndf3 = round('f3')
        rndduration = round('duration')
endproc
	            
procedure Display_spectrogram
        # display the formant tracks overlaid on spectrogram.
        Erase all
        Font size... 14
        display_from = 'vowel_start' - 0.15
        if ('display_from' < 0)
                display_from = 0
        endif
        display_until = 'vowel_end' + 0.15
        if ('display_until' > 'finishing_time')
                display_until = 'finishing_time'
        endif
        select Sound 'soundname$'_word
        To Spectrogram... 'length' 4000 0.002 20 Gaussian
        spectrogram = selected("Spectrogram")
        Viewport... 0 7 0 3.5
        Paint... 'display_from' 'display_until' 0 4000 100 yes 50 6 0 no
	            
        select Formant 'soundname$'_word
        Yellow
        Speckle... 'display_from' 'display_until' 4000 30 no
        Marks left every... 1 500 yes yes yes  
        Viewport... 0 7 0 4.5
        select TextGrid 'soundname$'
        Black
        Draw... 'display_from' 'display_until' no yes yes
        One mark bottom... 'timepoint' yes yes yes
        Text top... no 'soundname$' 'point$' ***** F1: 'rndf1' ***** F2: 'rndf2'
endproc
	    
procedure Display_spectrum_and_LPC
        # display the spectrum and LPC
        select Sound 'soundname$'_word
        spectrum_begin = technical_timepoint - 0.015
        spectrum_end = technical_timepoint + 0.015
        Extract part...  'spectrum_begin' 'spectrum_end' Hanning 1 no
        Rename... 'soundname$'_slice
        sound_slice = selected("Sound")
        To Spectrum (fft)
        spectrum = selected("Spectrum")
        Viewport... 0 7 4.5 8
        Draw... 0 3250 0 80 yes
        Marks bottom every... 1 500 yes yes no
        Marks bottom every... 1 250 no no yes
        select Sound 'soundname$'_word
        To LPC (autocorrelation)... 44 0.025 0.005 50
        To Spectrum (slice)... 'timepoint' 20 0 50
        Rename... LPC_'soundname$'_word
        spectrum_lpc = selected("Spectrum")
        select 'spectrum_lpc'
        Line width... 2
        Draw... 0 3250 0 80 no
        Line width... 1
        Text top... no Spectrum [30 ms] & LPC(autocorrelation)

        if (playit = 1)
                select Sound 'soundname$'_word
                Extract part... 'display_from' 'display_until' Hanning 1 no
                Play
                Remove
        endif
endproc
	           
procedure Verify_formants
        select Sound 'soundname$'_word
       	Edit
       	editor Sound 'soundname$'_word
                Show analyses... yes no no yes no 20.0
                Select... 'display_from' 'display_until'
                Zoom to selection
                Move cursor to... 'timepoint'
                Formant listing
        endeditor

        # puts nothing at the bottom of the picture, just to raise picture to the top
        Text bottom... yes 
	beginPause ("If all measurements are valid, click Continue")
		comment ("If not, make changes below")
		comment ("F1 Frequency")
			real ("conff1", 'rndf1')
		comment ("F2 Frequency")
			real ("conff2", 'rndf2')
		comment ("F3 Frequency")
			real ("conff3", 'rndf3')
		comment ("Automeasure until next word, or hand verify next timepoint?")
		skipstat = endPause ("Hand Next", "Next Word", "Next Point", 3)
       	editor Sound 'soundname$'_word
			Close
		endeditor
endproc

### Now, the modified Logging procedure logs the final result, whether they were acceptable automatic values or corrected F1/F2 values.
### It will look identical in the log whether a human intervened or the computer's guess was accepted.
procedure Log_output
		if skipstat = 1
			meastype$ = "hand"
		elsif skipstat = 2
			meastype$ = "auto"
		elsif skipstat = 3
			meastype$ = "verify"
		endif
        # save result to text file	            
        result_row$ = "'soundname$'" + tab$ + "'word_label$'" + tab$ + "'vowel_label$'" + tab$ + "'conff1'"  + tab$ + "'conff2'"+ tab$ + "'conff3'" + tab$ + "'rndduration'" + tab$ + "'point$'" + tab$ + "'vwlpct:2'" + tab$ + "'meastype$'" + newline$
        fileappend "'resultfile$'" 'result_row$'
		# Write down whether if this was hand-measured
		if skipstat = 1
			hand_row$ = "'soundname$'" + "_" + "'point$'" + newline$
      		fileappend "'handfile$'" 'hand_row$'
		endif
        # remove temporary files
        select 'spectrum_lpc'
        plus 'spectrogram'
        plus 'spectrum'
        plus Sound 'soundname$'_slice
        Remove
endproc
