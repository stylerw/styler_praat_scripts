# This spits the labels of all the points on Tier, along with their timepoints
# Written by Will Styler, for Meghan Dabkowski

# Specify where you want the output to live
resultfile$ = "/Users/stylerw/Desktop/results.txt"

header_row$ = "SoundFile" + tab$ + "Point" + tab$ + "Label" + tab$ + "TimepointSeconds" + newline$
fileappend "'resultfile$'" 'header_row$'

# This works on whatever sound you have selected in the objects window.  Make sure the Textgrid is in the objects window too.
sn$ = selected$ ("Sound")
select Sound 'sn$'
select TextGrid 'sn$'
# Change the below "1" to "2" if your points are on tier 2
numint = Get number of points... 1

# Start the loop
for i from 1 to numint
	select TextGrid 'sn$'
	
# Change the below "1" to "2" if your points are on tier 2	
	label$ = Get label of point... 1 'i'
	time = Get time of point... 1 'i'

# Spit the results into a text file
	result_row$ = "'sn$'" + tab$ + "'i'" + tab$ + "'label$'" + tab$ + "'time:5'" + newline$
	fileappend "'resultfile$'" 'result_row$'
endfor