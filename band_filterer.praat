# Band-Filterer
# Will Styler - 2017
# 
# This Praat script will create band-filtered stimuli for prosodic studies


form Normalize Amplitude in sound files
	comment Sound file extension:
	     optionmenu file_type: 2
	     option .aiff
	     option .wav
endform



directory$ = chooseDirectory$ ("Choose the directory containing sound files and textgrids")
directory$ = "'directory$'" + "/" 

Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

for ifile to number_files
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'directory$''sound$'
	objectname$ = selected$ ("Sound")

	# Bandpass at 400 Hz
	select Sound 'objectname$'
	Filter (pass Hann band): 0, 400, 50
	Scale intensity... 70
	Write to WAV file... 'directory$''objectname$'_bp400.wav
	Remove

	# Gammatone filtered, after Holman (2016), Vicenik & Sundara (2013)
	select Sound 'objectname$'
	Filter (gammatone): 200, 150
	Scale intensity... 70
	Write to WAV file... 'directory$''objectname$'_gamma_200_150.wav
	Remove

	select Sound 'objectname$'
	Filter (gammatone): 250, 150
	Scale intensity... 70
	Write to WAV file... 'directory$''objectname$'_gamma_250_150.wav
	Remove

	select Sound 'objectname$'
	Filter (gammatone): 350, 150
	Scale intensity... 70
	Write to WAV file... 'directory$''objectname$'_gamma_350_150.wav
	Remove

endfor

select Strings list
Remove
