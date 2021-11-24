#######################################################################
#  File Segmenter Script
#######################################################################
#  This script divides a file into individual chunks that have been marked
#  in some specified tier.  Each vowel is saved as an individual Praat
#  sound file with the name of the original file plus the interval
#  label.  25 milliseconds is added to either side of the chunk to ensure
#  that any analysis (with a 25ms window) made at the beginning of the chunk
#  will not crash.
#
#  Input:   Sound files with associated TextGrids
#           - TextGrids should have labels for relevant intervals (i.e.,
#             intervals to be chunked).
#  Output:  Individual sound files named according to the original file and
#           the interval label.
#  Process: The script asks for a directory in which to look for files, a tier
#           by which to segment, and an input sound file type.  It then looks
#           for soundfiles of the specified type with associated TextGrids in
#           the specified folder.  For each soundfile, it locates marked
#           intervals in the specifed tier one-by-one.  Each labeled interval 
#           (plus 25 ms before and after it) is saved as a new .wav file and
#           a new text grid.  After all intervals in all files in the specified
#           directory have been segmented, a finish message appears.

# This script is not by Will Styler, but is distributed by him because it's super useful.
#######################################################################

form Chopping long sound files
   comment Specify which tier in the TextGrid you want to segment by:
        integer tier_number 3
   comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
   comment Filename base (soundfile name if left blank)
   		word namebase
endform
directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 
out_dir$ = directory$

clearinfo
Create Strings as file list... list 'directory$'*'file_type$'
number_of_files = Get number of strings

# Starting from here, add everything that should be repeated for each sound file
for j from 1 to number_of_files
        select Strings list
        filename$ = Get string... 'j'
        Read from file... 'directory$''filename$'
        soundname$ = selected$ ("Sound")
        
        gridfile$ = "'directory$''soundname$'.TextGrid"
        if fileReadable (gridfile$)
                Read from file... 'gridfile$'
                select TextGrid 'soundname$'
                number_of_intervals = Get number of intervals... 'tier_number'
                
                # Go through all intervals in the file
                for k from 1 to number_of_intervals
	   		 		select TextGrid 'soundname$'
	    			seg_label$ = Get label of interval... 'tier_number' 'k'
			    	if seg_label$ <> ""
			            seg_start = Get starting point... 'tier_number' 'k'
			            seg_end = Get end point... 'tier_number' 'k'
			            start = seg_start - 0.025
			            end = seg_end + 0.025
			            select Sound 'soundname$'
			            Extract part: start, end, "rectangular", 1, "no"
						if namebase$ <> ""
			            	writename$ = "'namebase$'_'seg_label$'"
						else
			            	writename$ = "'soundname$'_'seg_label$'"
						endif
						# Although you should use ASCII when making textgrids, this bit removes some instacrashes
						writename$ = replace$ (writename$, " ", "_", 0)
						writename$ = replace$ (writename$, "/", "_", 0)
						out_filename$ = "'out_dir$''writename$'"
						# initialize anti-collision counter.
			        aff = 1
						name$ = "'out_filename$'_'aff'"

						#writeInfo: name$
			        while fileReadable ("'name$'.wav")
							aff = aff + 1
							name$ = "'out_filename$'_'aff'"
			        endwhile
			            Write to WAV file... 'name$'.wav
			            select TextGrid 'soundname$'
			            Extract part... 'start' 'end' no
			            #Rename... 'out_filename$'
			            Write to text file... 'name$'.TextGrid
				    endif
                endfor
                select all
                minus Strings list
                Remove
        endif
endfor
select all
Remove
print All files have been segmented.

