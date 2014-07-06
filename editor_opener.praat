# Editor Opener
# Will Styler - 2012
#
# This script will just open all files in a folder in editor windows, one after another
#
# So, it'll open file1, you can make your measurements, unpause, and it'll open file2...
#
# Also, it'll save the files to a given directory, in case you've made any cuts or edits.  Just save them to /tmp/ if you don't want them.
#
# This makes the script great for cleaning and reviewing stimuli.  


form Open sequentially in editors and save...
   sentence Sound_file_extension .wav
   comment Directory path of input files:
   text input_directory /Users/will/Desktop/Redos/
   comment Directory path of output files:
	text output_directory /Users/will/Desktop/willredos/

endform

Create Strings as file list... list 'input_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings
for ifile to numberOfFiles
	select Strings list
	sound$ = Get string... ifile
	Read from file... 'input_directory$''sound$'
          soundname$ = selected$ ("Sound")
	select Sound 'soundname$'
	Edit
	editor Sound 'soundname$'
		pause When ready to move onto the next file, click Continue
	# You'll need to manually close the window (or it won't close at all).  This is oddly more efficient.
	endeditor
	select Sound 'soundname$'
	outname$ = "'output_directory$''soundname$'"
	Save as WAV file... 'outname$'.wav
endfor

select Strings list
Remove
