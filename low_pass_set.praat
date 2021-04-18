# Filtered Set Creator
# Will Styler - 2021
# 
# This Praat script will generate a set of identical stimuli filtered at many different levels, by default 100-900 Hz in 100Hz steps, and 1000-20000 in 10000Hz steps
directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 

Create Strings as file list... list 'directory$'*.wav
number_files = Get number of strings

for ifile to number_files
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'directory$''sound$'
	objectname$ = selected$ ("Sound", 1)
	for freq from 1 to 20
		filtfreq = 1000*freq
		select Sound 'objectname$'
		Filter (pass Hann band): 0, filtfreq, 100
		Write to WAV file... 'directory$''objectname$'_'filtfreq'Hz.wav
	endfor
	for freq from 1 to 9
		filtfreq = 100*freq
		select Sound 'objectname$'
		Filter (pass Hann band): 0, filtfreq, 100
		Write to WAV file... 'directory$''objectname$'_'filtfreq'Hz.wav
	endfor
endfor

select Strings list
Remove
