# This reads VOT measurements for each word interval, so long as the vots are delineated with 'r' for release and 'v' for voicing onset
# Written by Will Styler, December 2019

file_type$ = ".TextGrid"
directory$ = chooseDirectory$ ("Choose the directory containing textgrids")
directory$ = "'directory$'" + "/" 
resultfile$ = "'directory$'"+"vot_info.txt"
# Specify where you want the output to live

header_row$ = "filename" + tab$ + "label" + tab$ + "interval" + tab$ + "V" + tab$ + "R" + tab$ + "VOT" + newline$
fileappend "'resultfile$'" 'header_row$'

pointtier = 1
inttier = 2

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
	numint = Get number of intervals... 'inttier'
			for i from 1 to numint
				vtime = 0
				rtime = 0
				vot = 100000
				selectObject: "TextGrid 'sn$'"
				label$ = Get label of interval: 'inttier', 'i'
				if label$ <> "" 
					intstart = Get start time of interval: 'inttier', 'i'
					intend = Get end time of interval: 'inttier', 'i'	
					Extract part: 'intstart', 'intend', "no"
					selectObject: "TextGrid 'sn$'_part"
					numintp = Get number of points... 'pointtier'
					for p from 1 to numintp
						plabel$ = Get label of point: 'pointtier', 'p'
						if plabel$ == "r"
							rtime = Get time of point: 'pointtier', 'p'
							rtime = rtime * 1000
						elif plabel$ == "v"
							vtime = Get time of point: 'pointtier', 'p'
							vtime = vtime * 1000
						endif
					endfor
					selectObject: "TextGrid 'sn$'_part"
					Remove
					zerocheck = vtime*rtime
					if zerocheck <> 0
						vot = vtime - rtime
					endif
					# Spit the results into a text file
					result_row$ = "'sn$'" + tab$ + "'label$'" + tab$ + "'i'" + tab$ + "'vtime'" + tab$ + "'rtime'" + tab$ + "'vot'" + newline$
					fileappend "'resultfile$'" 'result_row$'
				endif
			endfor
		endif
    select all
    minus Strings list
    Remove
endfor