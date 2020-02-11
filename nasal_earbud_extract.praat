# Nasal Earbud Extraction Script
# This script is designed to extract information pulled from Nasal Earbud Measument (as described in Stewart and Kohlberger 2017)



# References

## Stewart, J., & Kohlberger, M. (2017). Earbuds: A Method for Analyzing Nasality in the Field.

form De-modulate and Process Airflow Signals
	comment Which channel contains nasal earbud signal?
		integer naschannel 2
	comment Which channel contains acoustic data?
		integer orchannel 1
	comment Which tier contains nasal segment marking?
		integer nastier 2
endform

tpnum = 25
shownasalance = 1

directory$ = chooseDirectory$ ("Choose the directory containing flow files and grids")
directory$ = "'directory$'" + "/" 
file_type$ = ".wav"
createDirectory: directory$ + "_graphs"
Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

		
# Open a file for the results
resultfile$ = "'directory$'"+"_flowlog.txt"

header_row$ = "filename" + tab$ + "point" + tab$ + "vwlpct" + tab$ + "nas_power" + tab$ + "acoustic_power" + tab$ + "percnasalance" + tab$ + "measurement_time"
pheader_row$ = "'header_row$'" + newline$
#fileappend "'resultfile$'" 'pheader_row$'

for ifile to number_files
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'directory$''sound$'
	soundname$ = selected$ ("Sound", 1)
	gridfile$ = "'directory$''soundname$'.TextGrid"
	if fileReadable (gridfile$)
		# Open the Textgrid
		Read from file... 'gridfile$'
		
		###
		# Get Grid Information
		###
		
		select TextGrid 'soundname$'
		intstart = Get starting point... 1 2
		intend = Get end point... 1 2
		intdur = intend - intstart
		intmid = intstart + (intdur / 2)
		displayoff = 0.1 * intdur
		displaystart = intstart - displayoff
		displayend = intend + displayoff
		
		
		# Make a copy of the sound
		selectObject: "Sound 'soundname$'"
		Copy: "'soundname$'_rekt"

		# Rectify the signal, the first step in AM demodulation
		Formula: "abs(self)"

		# Low pass the Rectified version, completing the AM Demodulation
		Filter (pass Hann band): 0, 40, 20
		Rename: "'soundname$'_flow"

		# Now extract the individual flow channels and delete the original

		select Sound 'soundname$'_flow
		Extract all channels
		select Sound 'soundname$'_flow
		Remove

		if naschannel = 1
			select Sound 'soundname$'_flow_ch1
			Rename: "nasal_flow"
			select Sound 'soundname$'_flow_ch2
			Rename: "oral_flow"
		else
			select Sound 'soundname$'_flow_ch1
			Rename: "oral_flow"
			select Sound 'soundname$'_flow_ch2
			Rename: "nasal_flow"
		endif

		# Process the oral flow to get standard deviations
		select Sound oral_flow
		omax = Get maximum: displaystart,displayend, "Sinc70"
		osd = Get standard deviation: 1, 0,0
		halfosd = osd*0.01
		
		# Process the nasal flow to get standard deviations
		select Sound nasal_flow
		nmax = Get maximum: displaystart,displayend, "Sinc70"
		nsd = Get standard deviation: 1, 0,0
		halfnsd = nsd*0.01

		####
		# Get %Nasalance
		####

		select Sound nasal_flow
		dur = Get total duration

		# Basically take nasalflow / (oralflow+nasalflow), and don't calculate if nasality is stupidly small

		Create Sound from formula: "'soundname$'_nasalance", 1, 0, 'dur', 44100, "if (Sound_nasal_flow [col]) < 'halfnsd' then 0 else if (Sound_oral_flow [col]) < 'halfosd' then 0 else (Sound_nasal_flow [col])/((Sound_nasal_flow [col]) + (Sound_oral_flow [col])) endif endif"

		# Percentages don't go higher than 1...
		Formula: "if self > 1 then 1 else self endif"
		
		###
		# Draw Pretty Pictures
		###

		Line width: 1

		# First paint the spectrogram for the flow chart
		Select outer viewport: 0, 9.5, 0, 9
		Erase all
		Select outer viewport: 0, 9.5, 0, 3
		
		select Sound 'soundname$'
		noprogress To Spectrogram: 0.005, 5000, 0.005, 20, "Hamming (raised sine-squared)"
		Paint: displaystart,displayend, 0, 0, 100, "yes", 50, 6, 0, "no"
		select TextGrid 'soundname$'
		Black
		Draw: displaystart, displayend, "yes", "yes", "yes"
		select Spectrogram 'soundname$'

		# Make a second spectrogram for the scaled flows
		Select outer viewport: 0, 9.5, 3, 6
		Paint: displaystart,displayend, 0, 0, 100, "yes", 50, 6, 0, "no"
		Line width: 1
		select TextGrid 'soundname$'
		Draw: displaystart, displayend, "yes", "yes", "yes"
		select Spectrogram 'soundname$'
		if shownasalance
			# Make a third spectrogram for the %nasalance
			Select outer viewport: 0, 9.5, 6, 9
			Paint: displaystart,displayend, 0, 0, 100, "yes", 50, 6, 0, "no"
			Line width: 1
			select TextGrid 'soundname$'
			Black
			Draw: displaystart, displayend, "yes", "yes", "yes"
			select Spectrogram 'soundname$'
		endif
		
		select Spectrogram 'soundname$'
		Remove

		Select outer viewport: 0, 9.5, 0, 3
		
		
		Line width: 2

		Red

			select Sound oral_flow
			omax = Get maximum: displaystart,displayend, "Sinc70"
			omin = Get minimum: displaystart,displayend, "Sinc70"
	
			select Sound nasal_flow
			nmax = Get maximum: displaystart,displayend, "Sinc70"
			nmin = Get minimum: displaystart,displayend, "Sinc70"
	
			if omax > nmax
				omax = omax + (0.1*omax)
			else
				omax = nmax + (0.1*nmax)
			endif
			if omin < nmin
				omin = omin + (0.5*omin)
			else
				omin = nmin + (0.5*nmin)
			endif
	
			Select outer viewport: 0, 9.5, 0, 3
			Draw inner box
			omin = omin 
			select Sound oral_flow
			Draw: displaystart,displayend, 'omin', 'omax', "no", "Curve"
			Line width: 2
			Lime
			select Sound nasal_flow
			Draw: displaystart,displayend, 'omin', 'omax', "no", "Curve"
			One mark right: 0, "no", "yes", "yes", "Zero"
			Text top: "no", "Nasal (Green) vs. Acoustic (Red) signal"
		
		Line width: 2
	
			select Sound 'soundname$'_nasalance
		Select outer viewport: 0, 9.5, 3, 6
			Cyan
			Draw: displaystart,displayend, 0, 1, "yes", "Curve"
			One mark left: 0.5, "no", "yes", "yes", "50%"
			Text top: "no", "Percent Nasalance over time (where both oral and nasal > 0)"
			Select outer viewport: 0, 9.5, 0, 9
		Line width: 1
		Blue
		select Sound 'soundname$'
		Select outer viewport: 0, 9.5, 6, 9
		Text top: "no", "Waveforms (Acoustic on Top, Nasal bud on Bottom)"
		Draw: displaystart,displayend, 0, 0, "yes", "Curve"
		Select outer viewport: 0, 9.5, 0, 9
		# Now save the file
		Save as 300-dpi PNG file: "'directory$'_graphs/'soundname$'.png"
		
		# Clean up a bit
		selectObject: "Sound nasal_flow"
		plusObject: "Sound oral_flow"
		Combine to stereo
		Rename: "'soundname$'_flow_pascal"
		selectObject: "Sound nasal_flow"
		plusObject: "Sound oral_flow"
		Remove
		
		###
		# Extract the data to a file
		###

		
		# Calculate how large each jump is based on duration of vowel
		size = intdur / (tpnum-1)
		
		for point from 1 to tpnum
			if point = 1
				timepoint = 'intstart'
			elsif point = tpnum
				timepoint = 'intend'
			else
				timepoint = intstart + (size * (point-1))
			endif
			selectObject: "Sound 'soundname$'_flow_pascal"
			naspasc = Get value at time: 1, 'timepoint', "Nearest"
			orpasc = Get value at time: 2, 'timepoint', "Nearest"
			
			selectObject: "Sound 'soundname$'_nasalance"
			percnas = Get value at time: 1, 'timepoint', "Nearest"
			vwlpct = ((timepoint-intstart)/intdur)*100
			
			result_row$ = "'soundname$'" + tab$ + "'point'" + tab$ + "'vwlpct:2'" + tab$ + "'naspasc:10'" + tab$ + "'orpasc:10'" + tab$ + "'percnas:5'" + tab$ + "'timepoint:4'" + newline$
			#fileappend "'resultfile$'" 'result_row$'
			
		endfor
	else
		selectObject: "Sound 'soundname$'"
		Remove
	endif
endfor
select Strings list
Remove

# Version History
# 1.0 - First release