# Amplitude Matcher
# Will Styler - 2008, 2015
# 
# This Praat script will create amplitude normalized stimuli in WAV format and save to a new directory


form Normalize Amplitude in sound files
	comment Sound file extension:
	     optionmenu file_type: 2
	     option .aiff
	     option .wav
	comment What amplitude do you want to set to?
   		positive amplitude 70
endform

directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 

Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

for ifile to number_files
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'directory$''sound$'
	objectname$ = selected$ ("Sound", 1)
	Scale intensity... 'amplitude'
	Write to WAV file... 'directory$''objectname$'_'amplitude'dB.wav
	Remove
endfor

select Strings list
Remove
