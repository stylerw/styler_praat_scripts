# Will Styler
# TextGrid information extraction script
# Gathers labels from other tiers on Textgrids
# So if you want to find the label from another tier corresponding to the time of another tier


grid$ = selected$ ("TextGrid")
resultfile$ = "'grid$'_info.txt"

header_row$ = "gridname" + tab$ + "segment" + tab$ + "previousword" + tab$ + "word" + tab$ + "duration" + tab$ + "intensity" + newline$
fileappend "'resultfile$'" 'header_row$'


selectObject: "TextGrid 'grid$'"

numint = Get number of intervals... 2
# Start the loop
for i from 1 to numint
	label = ""
	selectObject: "TextGrid 'grid$'"
	label$ = Get label of interval: 2, 'i'
	if label$ <> ""
		vstart = Get start point: 2, 'i'
		vend = Get end point: 2, 'i'
		vdur = vend - vstart
		midpoint = vstart + (vdur/2)

		# Spit the results into a text file
		int1 = Get interval at time... 1 'midpoint'
		lab1$ = Get label of interval... 1 int1
		# print "'vdur'"
		prevint = int1 - 1
		labpre$ = Get label of interval... 1 'prevint'
		int3 = Get interval at time... 3 'midpoint'
		dur = Get label of interval... 3 'int3'
		int4 = Get interval at time... 4 'midpoint'
		intensity = Get label of interval... 4 'int4'
		result_row$ = "'grid$'" + tab$ + "'label$'" + tab$ + "'labpre$'" + tab$ + "'lab1$'" + tab$ + "'dur'" + tab$ + "'intensity'" + newline$
		fileappend "'resultfile$'" 'result_row$'
	endif	
endfor

