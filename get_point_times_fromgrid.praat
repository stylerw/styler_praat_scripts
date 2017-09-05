# This spits out the times of any labeled Textgrid points on all point tiers in all files, along with the filename and file duration.
# Written by Will Styler, September 2017

file_type$ = ".TextGrid"
directory$ = chooseDirectory$ ("Choose the directory containing textgrids")
directory$ = "'directory$'" + "/" 
resultfile$ = "'directory$'"+"pointinfo.txt"
# Specify where you want the output to live

header_row$ = "filename" + tab$ + "timepoint" + tab$ + "label" + tab$ + "point_number" + tab$ + "tier_number" + newline$
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
		ispoint = Is interval tier: tier
		if ispoint == 0
			numint = Get number of points... 'tier'
			# Start the loop
			for i from 1 to numint
				label = "none"
				selectObject: "TextGrid 'sn$'"
				label$ = Get label of point: 'tier', 'i'
				if label$ <> ""
					time = Get time of point: 'tier', 'i'
					# Spit the results into a text file
					result_row$ = "'sn$'" + tab$ + "'time'" + tab$ + "'label$'" + tab$ + "'i'" + tab$ + "'tier'" + newline$
					fileappend "'resultfile$'" 'result_row$'
				endif	
			endfor
		endif
	endfor
    select all
    minus Strings list
    Remove
endfor