#######################################################################
#  File Trimmer Script
#######################################################################
#  This script trims a file to 50ms on either side of a marked interval
#  Each vowel is saved as an individual Praat
#  sound file with the name of the original file plus the interval
#  label.
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
#######################################################################

form Chopping long sound files
   comment Specify which tier in the TextGrid you want to segment by:
        integer tier_number 1
   comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
   comment Replace surrounding 50ms with silence?
  		boolean silence yes
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
			            select Sound 'soundname$'
						seg_start_z = Get nearest zero crossing... 1 seg_start
						seg_end_z = Get nearest zero crossing... 1 seg_end
						if silence
							Create Sound from formula: "startsilence", 1, 0, 0.05, 44100, "0"
							select Sound 'soundname$'
							Extract part: seg_start_z, seg_end_z, "rectangular", 1, "no"
							Create Sound from formula: "endsilence", 1, 0, 0.05, 44100, "0"
							select Sound startsilence
							plus Sound 'soundname$'
							plus Sound endsilence
							Concatenate
						else
			            	start = seg_start_z - 0.050
			           		end = seg_end_z + 0.050
			           		Extract part: start, end, "rectangular", 1, "no"
						endif
						if namebase$ <> ""
			            	out_filename$ = "'out_dir$''namebase$'_'seg_label$'"
						else
			            	out_filename$ = "'out_dir$''soundname$'"
						endif
						name$ = "'out_filename$'_trim"
			          	Write to WAV file... 'name$'.wav
			            select TextGrid 'soundname$'
						if silence
							Extract part... seg_start_z seg_end_z no
							Extend time: 0.05, "Start"
							Extend time: 0.05, "End"
						else
			            	Extract part... 'start' 'end' no
						endif
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
print All files have been trimmed.

