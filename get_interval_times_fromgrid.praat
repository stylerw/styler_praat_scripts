# This spits out the start and end times of any labeled Textgrid intervals on all tiers, along with the filename and file duration.
# It's awesome for getting correction values for reaction times
# Written by Will Styler, January 2017

file_type$ = ".TextGrid"
directory$ = chooseDirectory$ ("Choose the directory containing textgrids")
directory$ = "'directory$'" + "/" 
resultfile$ = "'directory$'"+"_intervalinfo.txt"
# Specify where you want the output to live

header_row$ = "filename" + tab$ + "tier" + tab$ + "intervalnum" + tab$ + "label" + tab$ + "start" + tab$ + "end" + tab$ + "duration" + newline$
fileappend "'resultfile$'" 'header_row$'

Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

# This opens all the files one by one
for j from 1 to number_files
	select Strings list
	filename$ = Get string... 'j'
	Read from file... 'directory$''filename$'
	# This works on whatever sound you have selected in the objects window.  Make sure the Textgrid is in the objects window too.
	sn$ = selected$ ("TextGrid")
	selectObject: "TextGrid 'sn$'"
	numtier = Get number of tiers
	for tier from 1 to numtier
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
				result_row$ = "'sn$'" + tab$ + "'tier'" + tab$ + "'i'" + tab$ + "'label$'" + tab$ + "'vstart'" + tab$ + "'vend'" + tab$ + "'vdur'" + newline$
				fileappend "'resultfile$'" 'result_row$'
			endif	
		endfor
	endfor
    select all
    minus Strings list
    Remove
endfor