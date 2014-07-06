# SpectralCOG Finder
# Will Styler, written for Alec Buchner way back when
#
# This script takes the peak spectral frequency and spectral COG from a selected sound in the objects window.
#

resultfile$ = "/Users/Alec/Desktop/results.txt"
header_row$ = "SoundFile" + tab$ + "Word" + tab$ + "Segment" + tab$ + "Timepoint" + tab$ + "DurationMS" + tab$ + "HighestFreq" + tab$ + "HighestAmp" + tab$ + "SpectralCOG" + newline$
fileappend "'resultfile$'" 'header_row$'
endif
sn$ = selected$ ("Sound")
select Sound 'sn$'
select TextGrid 'sn$'
numint = Get number of intervals... 2
for i from 1 to numint
	select TextGrid 'sn$'
	label$ = Get label of interval... 2 'i'
	if label$ <> ""
		start = Get starting point... 2 'i'
		end = Get end point... 2 'i'
		midpoint = start + ((end - start) / 2)
		select TextGrid 'sn$'
		wordint = Get interval at time... 1 'midpoint'
		select TextGrid 'sn$'
		wordlab$ = Get label of interval... 1 'wordint'
		# Get 1/3 point
		p1 = start + ((end - start) / 3)
		p2 = midpoint
		p3 = start + (2*((end - start) / 3))
		duration = (end - start) * 1000
		durationms = (end - start)
		
		tp = p1
		tpn = 1
		call peakmeasure

		tp = p2
		tpn = 2
		call peakmeasure

		tpn = 3
		tp = p3
		call peakmeasure
	endif
endfor

procedure peakmeasure

storeda = 0
storedf = 0
select Sound 'sn$'
Edit
	editor Sound 'sn$'
	Spectrogram settings... 0 15000 0.05 50
	Move cursor to... 'tp'
	View spectral slice
	Close
endeditor

slice$ = selected$ ("Spectrum")
select Spectrum 'slice$'
cog = Get centre of gravity... 2
select Spectrum 'slice$'
To Ltas (1-to-1)
ltas$ = selected$ ("Ltas")
select Ltas 'ltas$'
numbins = Get number of bins
for b from 1 to numbins
	ba = Get value in bin... 'b'
	bf = Get frequency from bin number... 'b'
	if bf > 1000
		if ba > storeda
			storeda = ba
			storedf = bf
		endif	
	endif
endfor
       
result_row$ = "'sn$'" + tab$ + "'wordlab$'" + tab$ + "'label$'" + tab$ + "'tpn'" + tab$ + "'durationms'" + tab$ + "'storedf'" + tab$ + "'storeda'" + tab$ + "'cog'" + newline$
fileappend "'resultfile$'" 'result_row$'
select all
minus Sound 'sn$'
minus TextGrid 'sn$'
Remove

endproc


	

