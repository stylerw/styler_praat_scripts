#######################################################################
#  File Splitter Script (for Rob Hagiwara)
#######################################################################
# Developed at the CU Phonetics Lab
#  This script divides a file into individual chunks x seconds long
#  Input:   Sound files 
#  Output:  Individual sound files named according to the original file 
#######################################################################

form Chopping long sound files
   comment Directory of sound files (ending with /): 
        text directory /Users/stylerw/Desktop/
   comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
	comment How many seconds per chunk?
		integer len 20
endform


clearinfo
Create Strings as file list... list 'directory$'*'file_type$'
number_of_files = Get number of strings

# Starting from here, add everything that should be repeated for each sound file
for j from 1 to number_of_files
        select Strings list
        filename$ = Get string... 'j'
        Read from file... 'directory$''filename$'
        soundname$ = selected$ ("Sound")
        dur = Get total duration
		cutstart = 0
		cutend = len
		numsegs = (dur/len) + 1
		for k from 1 to numsegs
			if cutstart < dur
				select Sound 'soundname$'
				Extract part... cutstart cutend rectangular 1 no
				out_filename$ = "'soundname$'_'k'"
				Write to WAV file... 'out_filename$'.wav
				cutstart = (cutend-1) + len
				cutend = (cutstart+2) + len
				if cutend > dur
					cutend = dur
				endif
			endif
		endfor
endfor
select all
Remove
print All files have been segmented.

