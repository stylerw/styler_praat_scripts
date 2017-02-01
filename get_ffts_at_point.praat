# FFT Extractor Script
#
# Will Styler, 1/30/2017
#
# This script is designed to go through a folder of words and textgrids and extract and save one FFT per file at a given location in the (sole) labeled interval.
# One interval per file will be saved.  If multiples, it'll be the last interval.  This will create a _slices directory in the folder you're reading from.
# 
# This part presents a form to the user
form Extract FFTs from all labeled intervals
	comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
	comment What percentage of your marked interval do you want the FFT at?  (75% = 0.75)
			real measperc 0.75
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
# This will need to be changed to \ below for PC users
directory$ = "'directory$'" + "/" 
createDirectory: "'directory$'_slices"
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
				intpoint = intstart + (intdur * measperc)
				fftistart = intpoint - 0.015
				fftiend = intpoint + 0.015
				select Sound 'soundname$'
				Extract part: 'fftistart', 'fftiend', "hamming", 1, "no"
				Rename... fftpart
				noprogress To Spectrum (fft)
				Select outer viewport: 0, 8, 0, 5.5
Line width: 1.6

				Draw: 0, 3500, 0, 60, "no"
Line width: 1.0

				Draw inner box
				Marks bottom: 8, "yes", "yes", "yes"
				Marks left: 7, "yes", "yes", "yes"
				Save as 300-dpi PNG file: "'directory$'_slices/'soundname$'.png"
				Erase all
			endif
		endfor
	endif
	select all
	minus Strings list
	Remove
endfor
