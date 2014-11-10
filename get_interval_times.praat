# This spits out the start and end times of any labeled Textgrid intervals on a given tier, along with the filename and file duration.
# It's awesome for getting correction values for reaction times
# Written by Will Styler, November 2014

form Output TextGrid Info
	comment Which tier do you care about?
        integer tier 1
endform
file_type$ = ".wav"
directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 
resultfile$ = "'directory$'"+"_textgridinfo.txt"
# Specify where you want the output to live

header_row$ = "SoundFile" + tab$ + "IntNum" + tab$ + "Label" + tab$ + "VStart" + tab$ + "VEnd" + tab$ + "Duration" + newline$
fileappend "'resultfile$'" 'header_row$'

Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

# This opens all the files one by one
for j from 1 to number_files
	select Strings list
	filename$ = Get string... 'j'
	Read from file... 'directory$''filename$'
	# This works on whatever sound you have selected in the objects window.  Make sure the Textgrid is in the objects window too.
	sn$ = selected$ ("Sound")
	gridfile$ = "'directory$''sn$'.TextGrid"
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		selectObject: "TextGrid 'sn$'"
		# Change the below "1" to "2" if your intervals are on tier 2
		numint = Get number of intervals... 'tier'
		# Start the loop
		for i from 1 to numint
			label = ""
			selectObject: "TextGrid 'sn$'"
			label$ = Get label of interval: 'tier', 'i'
			if label$ <> ""
				vstart = Get start point: 'tier', 'i'
				vend = Get end point: 'tier', 'i'
				vdur = Get total duration
				# Spit the results into a text file
				result_row$ = "'sn$'" + tab$ + "'i'" + tab$ + "'label$'" + tab$ + "'vstart'" + tab$ + "'vend'" + tab$ + "'vdur'" + newline$
				fileappend "'resultfile$'" 'result_row$'
			endif	
		endfor
	endif
endfor