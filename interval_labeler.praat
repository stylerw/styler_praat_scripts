# Interval Labeler
# Will Styler - 2008
#
# This script takes as input a selected sound with unlabeled textgrid (where the intervals are present, but unlabeled), and then labels them sequentially according to lines in a text file.  
#
# This allows you, if you're gridding the same elicitation script over and over (and not using forced-align, because you hate yourself), to just mark the boundaries for each word, then automatically enter the labels post-hoc.  Much quicker, especially when using the intervalator script to then add vowels.
#

sn$ = selected$ ("Sound")
select Sound 'sn$'
select TextGrid 'sn$'
numint = Get number of intervals... 2
Read Strings from raw text file... labelfile.txt
Rename... wordfile

	for i from 1 to numint
		select TextGrid 'sn$'
		Set interval text... 2 i 
		if i mod 2 = 0
			wrdnum = i / 2
			select Strings wordfile
			wrd$ = Get string... wrdnum
			select TextGrid 'sn$'
			#Set interval text... 1 i 'wrd$'
			Set interval text... 2 i the

		endif
	endfor
select Strings wordfile
Remove
