# This is a modification of the "basic_synthesis.praat" script, originally by Bartek Plichta and packaged with Akustyk, modified by Will Styler @ CU Phonetics Lab for a more tightly controlled precision in resynthesis, as well as to accept bulk resynthesis.
# This particular flavor of this script is designed to only make uniform modifications to vowels, without any sort of contour.  
# This has been designed to work with a folder full of files to change, according to parameters set by vowel towards the latter half of the script. 

form Modify vowel formants in files
	comment Directory of sound files and text grids:
	# Add a trailing slash to the directory name, or this will fail *hard*
        text directory /Users/will/Documents/research/hyperarticulation/stimuli/all/
   comment Tiers in the TextGrid for:
        integer vowel 1
        integer word 2
   comment Select sex of speaker:
        choice sex 2
        button male
        button female
   comment Sound file extension:
        optionmenu file_type: 2
        option .aiff
        option .wav
# Here, 8 is the default (finding 4 formants), but your mileage may vary and 10 (5 formants) might work better in some cases.  Note that /u/ use 10 (as specified later), and you can specify to search for five formants by adding "_5" to the sound/textgrid filenames.
	real spec_order 8
# No need to change this, roughly, evar.
	real Time_step 0.01
# This option lets you just a single set of Deltas for both Lo->Hi and Hi->Lo.  If your F1 delta is 100, selecting "as entered" will raise by 100, and "inverted" will lower F1 by 100.  This works on all specified deltas, without exception.
	comment Invert the given deltas? (100Hz -> -100Hz)
        choice direction 1
        button As Entered
        button Inverted
	comment Recombine result with high frequencies from original?
    	choice passmerge 1
    	button Yes
    	button No
endform

# This setting works, and was originally set elsewhere.  Don't touch unless you know what you're doing.
window=0.0256

# List of all the sound files in the specified directory:
Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings

data_output_file$ = "'directory$'resynthinfo.txt"
fileappend 'data_output_file$' 'soundname$''tab$'Int_number'tab$'F1_change'tab$'F2_change'tab$'F3_change'tab$'F1_before'tab$'F1_after'tab$'F2_before'tab$'F2_after'tab$'F1_delta'tab$'F2_delta'tab$'F1_DeltaDelta'tab$'F2_DeltaDelta'newline$'
for j from 1 to number_files
        select Strings list
        filename$ = Get string... 'j'
        Read from file... 'directory$''filename$'
        soundname$ = selected$ ("Sound")
		# identify associated TextGrid
		gridfile$ = "'directory$''soundname$'.TextGrid"
		if fileReadable (gridfile$)
	 		Read from file... 'gridfile$'
	        select TextGrid 'soundname$'
	        number_intervals = Get number of intervals... 'vowel'
	        for k from 1 to number_intervals
	   			select TextGrid 'soundname$'
	   			vowel_label$ = Get label of interval... 'vowel' 'k'
	   			#checks if interval has a labeled vowel
	   			if vowel_label$ <> ""
					start = Get starting point... 'vowel' 'k'
					cursor = start
				    end = Get end point... 'vowel' 'k'
				    midpoint = start + ((end - start) / 2)
#				    duration = (end - start) * 1000
				    finishing_time = Get finishing time
					if passmerge = 1
						select Sound 'soundname$'
						Filter (stop Hann band)... 0 5000 1
						Rename... highfreq
					endif
					# Sorting_Hat identifies the vowel, then specifies the delta/filter order
					call Sorting_Hat
					# Inverter checks if the "Invert deltas..." option is checked, then inverts them if needed
					call inverter
					# Stringer_bell turns the deltas into strings.  Yes, this is necessary for some reason
					call stringer_bell
					# Formulator turns the delta statements for each vowel into a formula applicable to Formant objects
					call formulator
					# Formantnumfinder checks for the "_5" flag on filenames, and if it finds it, overrides the Sorting Hat's
					# filter order specification to five for those examples
					call formantnumfinder
					# You'll need a window bigger than the vowel for the analysis of the extracted bits
					startwindow = start - 0.025
					endwindow = end + 0.025
					#select Sound 'soundname$'
					#Copy...  'soundname$'_unedited
					# Now we extract the vowel
					select Sound 'soundname$'
					Edit
					editor Sound 'soundname$'
					Select... startwindow endwindow
					Move begin of selection to nearest zero crossing
					Move end of selection to nearest zero crossing
					Extract selected sound (preserve times)
					# This part cuts out the vowel from the word (using original borders, without the window)
					Select... start end
					Move begin of selection to nearest zero crossing
					Move end of selection to nearest zero crossing
					selstart = Get start of selection
					selend = Get end of selection
					Cut
					endeditor
					# Rename the vowel to "before"
					Rename... before
					select Sound before
					
					# Resamples to 10,000 Hz.  This *really* helps the resynth quality.
					Resample... 10000 50
					select Sound before_10000
					Copy...  'soundname$'_unedited
					select Sound before_10000
					master_sound = selected("Sound")
					duration = Get total duration
					midpoint = duration/2
					# This stores the average intensity of the original, so the resynth can be scaled to it later.  Awesome, huh?
					master_sound_DB=Get intensity (dB)

					# Now we have an LPC made using the specs specified previously.  This is where it all begins
					To LPC (burg)... filter_order window time_step 50
					Rename... Source
					master_lpc = selected("LPC")
					# Make a formant object (that we'll use throughout) from that LPC
					To Formant
					Rename... Filter
					# This is just calling a Formant by any other name
					master_formant = selected("Formant")
					# This specifies the copy of the unedited formant object
					Copy... original
					original_formant = selected("Formant")
					
					# This gets F1, F2, F3 and their bandwidths from the original, unedited formant object
					select master_formant
					f1_before = Get value at time... 1 midpoint Hertz Linear
					f2_before = Get value at time... 2 midpoint Hertz Linear
					f3_before = Get value at time... 3 midpoint Hertz Linear
					b1_before = Get bandwidth at time... 1 midpoint Hertz Linear
					b2_before = Get bandwidth at time... 2 midpoint Hertz Linear
					b3_before = Get bandwidth at time... 3 midpoint Hertz Linear

					# This makes the F1, F2, F3, and formant bandwidth changes to the master_formant object
					# These changes are made according to the formulas created by Proc Formulator above, 
					# which derives them from the deltas specified by the user
					select master_formant
					if f1_change$ <> "self"
						'f1_formula$'
					endif
					if f2_change$ <> "self"
						'f2_formula$'
					endif
					if f3_change$ <> "self"
						'f3_formula$'
					endif
					if b1_change$ <> "self"
						'f1b_formula$'
					endif
					if b2_change$ <> "self"
						'f2b_formula$'
					endif
					if b3_change$ <> "self"
						'f3b_formula$'
					endif
					
					# Now, we inverse filter the sound and LPC to get the "Source" sound for source-filter resynthesis.
					select master_lpc
					select master_sound
					plus master_lpc
					Filter (inverse)
					Rename... source
					# Now reunite the formant and raw source sound to get a new vowel
					source_sound = selected("Sound")
					plus master_formant
					Filter
					Rename... Resynthesized
					resynthesized_sound = selected("Sound")
					# Measure the intensity of the resynthed sound
					resynthesized_sound_DB=Get intensity (dB)
					# Scale it to match the original
					Scale intensity... master_sound_DB
					# Cut off any clipped peaks
					Scale peak... 0.8
					Scale peak... 0.8
					Scale peak... 0.8
					Scale peak... 0.8

					# Make an LPC for the new, resynthesized sound (still with custom settings)
					To LPC (burg)... filter_order window time_step 50
					Rename... Source_after
					lpc_after = selected("LPC")
					# Then make a formant from it
					To Formant
					Rename... formant_after
					formant_after = selected("Formant")
					
					# Measure F1, F2 and F3 IN THAT FORMANT OBJECT.  This is useless, and tells us little.
					f1_after = Get value at time... 1 midpoint Hertz Linear
					f2_after = Get value at time... 2 midpoint Hertz Linear
					f3_after = Get value at time... 3 midpoint Hertz Linear

					b1_after = Get bandwidth at time... 1 midpoint Hertz Linear
					b2_after = Get bandwidth at time... 2 midpoint Hertz Linear
					b3_after = Get bandwidth at time... 3 midpoint Hertz Linear
					
					# Paste the new vowel into the old context
					call paste
					# Generate the timepoints at 1/8, 1/4, 1/2, 3/4, 7/8
					vwldur = end - start
					halfvowel = vwldur/2
					qtrvowel = halfvowel/2
					eighthvowel = qtrvowel/2
					t1 = start + eighthvowel
					t2 = start + qtrvowel
					t3 = start + halfvowel
					t4 = end - qtrvowel
					t5 = end - eighthvowel
					
					# Make an LPC in the same way that the original LPC for the resynth was made, then test the end product
					select Sound final_audio
					To LPC (burg)... filter_order window time_step 50
					To Formant
					e1f1 = Get value at time... 1 t1 Hertz Linear
					e1f2 = Get value at time... 2 t1 Hertz Linear
					e2f1 = Get value at time... 1 t2 Hertz Linear
					e2f2 = Get value at time... 2 t2 Hertz Linear
					e3f1 = Get value at time... 1 t3 Hertz Linear
					e3f2 = Get value at time... 2 t3 Hertz Linear
					e4f1 = Get value at time... 1 t4 Hertz Linear
					e4f2 = Get value at time... 2 t4 Hertz Linear
					e5f1 = Get value at time... 1 t5 Hertz Linear
					e5f2 = Get value at time... 2 t5 Hertz Linear
			
					# Make an LPC in the same way that the original LPC for the resynth was made, then test the starting product
					select Sound 'soundname$'_unedited
					To LPC (burg)... filter_order window time_step 50
					To Formant
					s1f1 = Get value at time... 1 t1 Hertz Linear
					s1f2 = Get value at time... 2 t1 Hertz Linear
					s2f1 = Get value at time... 1 t2 Hertz Linear
					s2f2 = Get value at time... 2 t2 Hertz Linear
					s3f1 = Get value at time... 1 t3 Hertz Linear
					s3f2 = Get value at time... 2 t3 Hertz Linear
					s4f1 = Get value at time... 1 t4 Hertz Linear
					s4f2 = Get value at time... 2 t4 Hertz Linear
					s5f1 = Get value at time... 1 t5 Hertz Linear
					s5f2 = Get value at time... 2 t5 Hertz Linear
				
					# Calculate the difference
					d1f1 = e1f1 - s1f1
					d1f2 = e1f2 - s1f2
					d2f1 = e2f1 - s2f1
					d2f2 = e2f2 - s2f2
					d3f1 = e3f1 - s3f1
					d3f2 = e3f2 - s3f2
					d4f1 = e4f1 - s4f1
					d4f2 = e4f2 - s4f2
					d5f1 = e5f1 - s5f1
					d5f2 = e5f2 - s5f2
					
					dd1f1 = d1f1 - f1_change
					dd1f2 = d1f2 - f2_change
					dd2f1 = d2f1 - f1_change
					dd2f2 = d2f2 - f2_change
					dd3f1 = d3f1 - f1_change
					dd3f2 = d3f2 - f2_change
					dd4f1 = d4f1 - f1_change
					dd4f2 = d4f2 - f2_change
					dd5f1 = d5f1 - f1_change
					dd5f2 = d5f2 - f2_change				
					
					
					select Sound final_audio
					# This section was originally designed to allow manual verification of the output, but didn't prove useful
					#Play
					#beginPause ("Give a listen to the final_audio sound")
					#			comment ("Check the picture window too")
					#			comment ("Is it a trainwreck?")
					#		     	choice ("trainwreck", 2)
					#		     	option ("Yes")
					#		     	option ("No")
					#endPause ("Continue", 1)
					#
					# Specifying this here means it doesn't have to check whether it's a trainwreck
					trainwreck = 2
					if trainwreck = 2
	        			select TextGrid 'soundname$'
						Write to text file... 'directory$'/resynth/'soundname$'_res.TextGrid
						select Sound final_audio
						Rename... 'soundname$'_res
						Write to WAV file... 'directory$'/resynth/'soundname$'_res.wav
						# save dumps all the stored formant data into a file
						call save
					endif
				endif
			endfor
			# This cleans up the object list and windows
			select all
			minus Strings list
			Remove
		endif
	endfor

#######################################################################################################
#######################     Procedure Land     ########################################################
#######################################################################################################

#### This next part is where we define which vowels will be changed, and the deltas for each

procedure Sorting_Hat
	if vowel_label$ == "i"
		filter_order = spec_order 
		call ispecs
		skip = 0
	elif vowel_label$ == "I"
		filter_order = spec_order 
		call ihspecs
		skip = 0
	elif vowel_label$ == "E"
		filter_order = spec_order 
		call ehspecs
		skip = 0	
	elif vowel_label$ == "{"
		filter_order = spec_order 
		call aespecs
		skip = 0
	elif vowel_label$ == "O"
		filter_order = spec_order 
		call aspecs
		skip = 0
	elif vowel_label$ == "u"
		filter_order = 10
		call uspecs
		skip = 0
	elif vowel_label$ == "U"
		filter_order = 10
		call uspecs
		skip = 0
	elif vowel_label$ == "V"
		filter_order = spec_order 
		call uhspecs
		skip = 0
	else
		skip = 1
	endif
endproc

procedure formantnumfinder
	fiveflag = index (soundname$, "_5")
	if fiveflag <> 0
		filter_order = 10
	endif	
endproc

# In this section, fX_change changes the height of the formant
# So, f1_change = 100 would raise F1 by 100Hz, f1_change = -100 would lower it by 100Hz
# bX_change changes the bandwidth of the formant.  
# If you add more vowels, don't forget to add them for the sorting hat above too.

procedure ispecs
#	f1_change = -40
#	f2_change = 50
	f1_change = 0
	f2_change = 0
	f3_change = 0
	b1_change = 0
	b2_change = 0
	b3_change = 0
endproc

procedure ihspecs
#	f1_change = -40
#	f2_change = 50
	f1_change = 0
	f2_change = 0
	f3_change = 0
	b1_change = 0
	b2_change = 0
	b3_change = 0
endproc

procedure ehspecs
#	f1_change = 0
#	f2_change = 43
	f1_change = 0
	f2_change = 0
	f3_change = 0
	b1_change = 0
	b2_change = 0
	b3_change = 0
endproc

procedure aespecs
#	f1_change = 32.6
#	f2_change = 82
	f1_change = 0
	f2_change = 0
	f3_change = 0
	b1_change = 0
	b2_change = 0
	b3_change = 0
endproc

procedure aspecs
#	f1_change = -48.5
#	f2_change = 0
	f1_change = 0
	f2_change = 0
	f3_change = 0
	b1_change = 0
	b2_change = 0
	b3_change = 0
endproc

procedure uspecs
#	f1_change = -10
#	f2_change = -71
	f1_change = 0
	f2_change = 0
	f3_change = 0
	b1_change = 0
	b2_change = 0
	b3_change = 0
endproc

procedure uhspecs
#	f1_change = 0
#	f2_change = -61.5
	f1_change = 0
	f2_change = 0
	f3_change = 0
	b1_change = 0
	b2_change = 0
	b3_change = 0
endproc

procedure inverter
if direction = 2
	f1_change = f1_change * -1
	f2_change = f2_change * -1
	f3_change = f3_change * -1
	b1_change = b1_change * -1
	b2_change = b2_change * -1
	b3_change = b3_change * -1
endif
endproc

procedure stringer_bell
f1_change$ =  "self +" + "'f1_change'"
f2_change$ = "self +" + "'f2_change'"
f3_change$ = "self +" + "'f3_change'"
b1_change$ = "self +" + "'b1_change'"
b2_change$ = "self +" + "'b2_change'"
b3_change$ = "self +" + "'b3_change'"
endproc

procedure formulator
f1_formula$= "Formula (frequencies)... if row = 1 then 'f1_change$' else self fi"
f2_formula$= "Formula (frequencies)... if row = 2 then 'f2_change$' else self fi"
f3_formula$= "Formula (frequencies)... if row = 3 then 'f3_change$' else self fi"

f1b_formula$= "Formula (bandwidths)... if row = 1 then 'b1_change$' else self fi"
f2b_formula$= "Formula (bandwidths)... if row = 2 then 'b2_change$' else self fi"
f3b_formula$="Formula (bandwidths)... if row = 3 then 'b3_change$' else self fi"
endproc

procedure paste
select resynthesized_sound
Copy... resynth_temp
resynth_temp = selected("Sound")
dur=Get total duration
Edit
editor Sound resynth_temp
Select... selstart selend
Move begin of selection to nearest zero crossing
Move end of selection to nearest zero crossing
Copy selection to Sound clipboard
endeditor
Remove
select Sound 'soundname$'
Resample... 10000 50
Rename... restemplate
restemplate_sound = selected("Sound")
To LPC (burg)... filter_order window time_step 50
Rename... restemplate_source
restemplate_LPC = selected("LPC")
plus restemplate_sound
Filter (inverse)
Rename... restemplate_source
res_source_sound = selected("Sound")
# This option does not produce much loss
plus restemplate_LPC
Filter... no
# This option produces loss in high frequencies
#select restemplate_LPC
#To Formant
#plus res_source_sound
#Filter
Rename... final_audio
final_audio$ = selected$("Sound")
final_sound = selected("Sound")
#editor Sound restemplate
Edit
editor Sound 'final_audio$'
Move cursor to... selstart
Paste after selection
endeditor
Rename... rawresynth
if passmerge = 1
	select Sound rawresynth
	Resample... 44100 50
	Copy... added
	Formula... self[col] + Sound_highfreq[col]
	Rename... final_audio
endif
#select template_sound
#Remove
#select original_sound
#editor 'sound_original$'
#Select... sel_start sel_end
#select all
#minus master_sound
#minus resynthesized_sound
#minus template_sound
#minus original_sound
#minus final_sound
#Remove
#select original_sound
endproc

procedure save
#select all
#Write to binary file... data/'original_sound$'_resynthesis.Collection
#select resynthesized_sound
#Write to WAV file... data/'original_sound$'_res_token.wav
#select original_sound
fileappend 'data_output_file$' 'soundname$''tab$'1'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''s1f1:0''tab$''e1f1:0''tab$''s1f2:0''tab$''e1f2:0''tab$''d1f1:0''tab$''d1f2:0''tab$''dd1f1:0''tab$''dd1f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'3'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''s3f1:0''tab$''e3f1:0''tab$''s3f2:0''tab$''e3f2:0''tab$''d3f1:0''tab$''d3f2:0''tab$''dd3f1:0''tab$''dd3f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'5'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''s5f1:0''tab$''e5f1:0''tab$''s5f2:0''tab$''e5f2:0''tab$''d5f1:0''tab$''d5f2:0''tab$''dd5f1:0''tab$''dd5f2:0''newline$'
endproc