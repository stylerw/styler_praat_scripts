##################################################
# 	
#	Automated Nasality Measurement Script Package
#	FFT creation script with pulse extraction and iteration
# 	Developed at the CU Phonetics Lab
#
# 	This script is designed to be given a place in the Editor window menus
#	and is used to take a new iterated FFT at a given point, using the same
#	technique that the NasalityAutoMeasurev3.praat script uses.
#
##################################################

# Choose window alignment
form Window alignment
        comment Align analysis window
        choice alignment 2
        button left (for start)
        button center (for midpoint)
        button right (for end)
endform

#soundname$ = selected$ ("Sound")
cursor = Get cursor
milliseconds = round (cursor * 1000)

# Analyze pulses
Show analyses... yes no no yes yes 20.0
Extract visible pulses
endeditor

if alignment = 1
        pulse_begin_index = Get high index... 'cursor'
        pulse_end_index = pulse_begin_index+1
endif
if alignment = 2
        pulse_begin_index = Get low index... 'cursor'
        pulse_end_index = pulse_begin_index+1
endif
if alignment = 3
        pulse_end_index = Get low index... 'cursor'
        pulse_begin_index = pulse_end_index-1
endif
        
pulse_begin_time = Get time from index... 'pulse_begin_index'
pulse_end_time = Get time from index... 'pulse_end_index'

# Select & iterate one pulse
#select Sound 'soundname$'
#Extract part... 'pulse_begin_time' 'pulse_end_time' Hanning 1 no
#Rename... 'milliseconds'ms_onepulse
editor
Select... 'pulse_begin_time' 'pulse_end_time'
Extract selection
endeditor
Rename... 'milliseconds'ms_onepulse

Copy... 
duration = Get total duration
num_copies = 0
while duration < 0.06
        plus Sound 'milliseconds'ms_onepulse
        Concatenate
        duration = Get total duration
        num_copies = num_copies + 1
endwhile
Rename... 'milliseconds'ms_pulses

# Save an analysis window
select Sound 'milliseconds'ms_pulses
Edit
editor Sound 'milliseconds'ms_pulses
        new_cursor = Get cursor
        sel_start = new_cursor-0.015
        sel_end = new_cursor+0.015
        Select... sel_start sel_end
        Extract windowed selection... slice Hamming 1.0 1
        Close
endeditor
Rename... FFT_'milliseconds'ms_window

# Make the Spectrum object from the new Sound
To Spectrum (fft)
Rename... FFT_'milliseconds'ms_window
Edit
editor Spectrum FFT_'milliseconds'ms_window
        # zoom the spectrum to a comfortable frequency view...
        Zoom... 0 5000
endeditor

# select and remove the temporary Sound objects
select Sound 'milliseconds'ms_onepulse
plus Sound 'milliseconds'ms_onepulse
plus Sound FFT_'milliseconds'ms_window
plus PointProcess untitled
for i from 1 to num_copies
        plus Sound chain
endfor
Remove
select Spectrum FFT_'milliseconds'ms_window
# return to the Sound editor window and recall the original cursor position
editor
Move cursor to... cursor
