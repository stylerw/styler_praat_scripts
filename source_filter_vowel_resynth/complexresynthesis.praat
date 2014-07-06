# This is a modification of the "basic_synthesis.praat" script, originally by Bartek Plichta and packaged with Akustyk, modified by Will Styler @ CU Phonetics Lab for a more tightly controlled precision in resynthesis, as well as to accept bulk resynthesis.
# This has been designed to work with a folder full of files to change, according to parameters set by vowel towards the latter half of the script. 

# USE HI RCAT PARAMETERS IN THE SCRIPT
form Modify vowel formants in files
	comment Directory of sound files and text grids:
        text directory /Users/stylerw/Documents/research/resynthtest/
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
# Here, 8 is the default (finding 4 formants), but your mileage may vary and 10 (5 formants) might work better in some weird case
	real Filter_order 8
	real Time_step 0.01
	comment Direction of Conversion:
        choice direction 1
        button Hi->Lo
        button Lo->Hi
endform

intervals = 1
window=0.0256

# List of all the sound files in the specified directory:
Create Strings as file list... list 'directory$'*'file_type$'
number_files = Get number of strings
data_output_file$ = "'directory$'resynthinfo.txt"
fileappend 'data_output_file$' 'soundname$''tab$'Int_number'tab$'F1_change'tab$'F2_change'tab$'F3_change'tab$'F1_int_change'tab$'F2_int_change'tab$'F1_before'tab$'F1_after'tab$'F2_before'tab$'F2_after'tab$'F1_delta'tab$'F2_delta'newline$'
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
				    duration = (end - start) * 1000
				    finishing_time = Get finishing time
					call Sorting_Hat
					call inverter
					call stringer_bell
					call formulator
					startwindow = start - 0.025
					endwindow = end + 0.025
					#select Sound 'soundname$'
					#Copy...  'soundname$'_unedited
					select Sound 'soundname$'
					Edit
					editor Sound 'soundname$'
					Select... startwindow endwindow
					Move begin of selection to nearest zero crossing
					Move end of selection to nearest zero crossing
					Extract selected sound (preserve times)
					Select... start end
					Move begin of selection to nearest zero crossing
					Move end of selection to nearest zero crossing
					selstart = Get start of selection
					selend = Get end of selection
					Cut
					endeditor
					Rename... before
					select Sound before
					Resample... 10000 50
					select Sound before_10000
					Copy...  'soundname$'_unedited
					select Sound before_10000
					master_sound = selected("Sound")
					duration = Get total duration
					midpoint = duration/2

					master_sound_DB=Get intensity (dB)


					To LPC (burg)... filter_order window time_step 50
					Rename... Source
					master_lpc = selected("LPC")
					To Formant
					Rename... Filter
					master_formant = selected("Formant")
					Copy... original
					original_formant = selected("Formant")
					select master_formant

					f1_before = Get value at time... 1 midpoint Hertz Linear
					f2_before = Get value at time... 2 midpoint Hertz Linear
					f3_before = Get value at time... 3 midpoint Hertz Linear

					b1_before = Get bandwidth at time... 1 midpoint Hertz Linear
					b2_before = Get bandwidth at time... 2 midpoint Hertz Linear
					b3_before = Get bandwidth at time... 3 midpoint Hertz Linear

					nframes = Get number of frames
					start = 1
					mid = nframes/2
					end = nframes
					interval = round(nframes/10)


					i1=interval
					t1=Get time from frame number... interval/2
					i2=(interval*2)
					t2=Get time from frame number... i2+(interval/2)
					i3=(interval*3)
					t3=Get time from frame number... i3+(interval/2)
					i4=(interval*4)
					t4=Get time from frame number... i4+(interval/2)
					i5=(interval*5)
					t5=Get time from frame number... i5+(interval/2)
					i6=(interval*6)
					t6=Get time from frame number... i6+(interval/2)
					i7=(interval*7)
					t7=Get time from frame number... i7+(interval/2)
					i8=(interval*8)
					t8=Get time from frame number... i8+(interval/2)
					i9=(interval*9)
					t9=Get time from frame number... i9+(interval/2)
					i10=(interval*10)
					t10=Get time from frame number... i10+(interval/2)



					f1_t1_before = Get value at time... 1 t1 Hertz Linear
					f1_t2_before = Get value at time... 1 t2 Hertz Linear
					f1_t3_before = Get value at time... 1 t3 Hertz Linear
					f1_t4_before = Get value at time... 1 t4 Hertz Linear
					f1_t5_before = Get value at time... 1 t5 Hertz Linear
					f1_t6_before = Get value at time... 1 t6 Hertz Linear
					f1_t7_before = Get value at time... 1 t7 Hertz Linear
					f1_t8_before = Get value at time... 1 t8 Hertz Linear
					f1_t9_before = Get value at time... 1 t9 Hertz Linear
					f1_t10_before = Get value at time... 1 t10 Hertz Linear

					f2_t1_before = Get value at time... 2 t1 Hertz Linear
					f2_t2_before = Get value at time... 2 t2 Hertz Linear
					f2_t3_before = Get value at time... 2 t3 Hertz Linear
					f2_t4_before = Get value at time... 2 t4 Hertz Linear
					f2_t5_before = Get value at time... 2 t5 Hertz Linear
					f2_t6_before = Get value at time... 2 t6 Hertz Linear
					f2_t7_before = Get value at time... 2 t7 Hertz Linear
					f2_t8_before = Get value at time... 2 t8 Hertz Linear
					f2_t9_before = Get value at time... 2 t9 Hertz Linear
					f2_t10_before = Get value at time... 2 t10 Hertz Linear
					
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

					if intervals=1

						#Interval 1
						for frame from 1 to i1

							if left_Interval_1$ <> "self"
								'f1_formula_1$'
							endif
							if right_Interval_1$ <> "self"
								'f2_formula_1$'
							endif

						time_begin_1=Get time from frame number... 1
						time_end_1=Get time from frame number... i1

						endfor

						#Interval 2
						for frame from i1+1 to i2
							if left_Interval_2$ <> "self"
								'f1_formula_2$'
							endif
							if right_Interval_2$ <> "self"
								'f2_formula_2$'
							endif

						endfor
						time_begin_2=Get time from frame number... i1+1
						time_end_2=Get time from frame number... i2

						#Interval 3
						for frame from i2+1 to i3
							if left_Interval_3$ <> "self"
								'f1_formula_3$'
							endif
							if right_Interval_3$ <> "self"
								'f2_formula_3$'
							endif

						endfor
						time_begin_3=Get time from frame number... i2+1
						time_end_3=Get time from frame number... i3

						#Interval 4
						for frame from i3+1 to i4
							if left_Interval_4$ <> "self"
								'f1_formula_4$'
							endif
							if right_Interval_4$ <> "self"
								'f2_formula_4$'
							endif

						endfor
						time_begin_4=Get time from frame number... i3+1
						time_end_4=Get time from frame number... i4

						#Interval 5
						for frame from i4+1 to i5
							if left_Interval_5$ <> "self"
								'f1_formula_5$'
							endif
							if right_Interval_5$ <> "self"
								'f2_formula_5$'
							endif		
						endfor
						time_begin_5=Get time from frame number... i4+1
						time_end_5=Get time from frame number... i5

						#Interval 6
						for frame from i5+1 to i6
							if left_Interval_6$ <> "self"
								'f1_formula_6$'
							endif
							if right_Interval_6$ <> "self"
								'f2_formula_6$'
							endif

						endfor
						time_begin_6=Get time from frame number... i5+1
						time_end_6=Get time from frame number... i6

						#Interval 7
						for frame from i6+1 to i7
							if left_Interval_7$ <> "self"
								'f1_formula_7$'
							endif
							if right_Interval_7$ <> "self"
								'f2_formula_7$'
							endif

						endfor
						time_begin_7=Get time from frame number... i6+1
						time_end_7=Get time from frame number... i7

						#Interval 8
						for frame from i7+1 to i8
							if left_Interval_8$ <> "self"
								'f1_formula_8$'
							endif
							if right_Interval_8$ <> "self"
								'f2_formula_8$'
							endif

						endfor
						time_begin_8=Get time from frame number... i7+1
						time_end_8=Get time from frame number... i8

						#Interval 9
						for frame from i8+1 to i9
							if left_Interval_9$ <> "self"
								'f1_formula_9$'
							endif
							if right_Interval_9$ <> "self"
								'f2_formula_9$'
							endif

						endfor
						time_begin_9=Get time from frame number... i8+1
						time_end_9=Get time from frame number... i9

						#Interval 10
						for frame from i9+1 to i10
							if left_Interval_10$ <> "self"
								'f1_formula_10$'
							endif
							if right_Interval_10$ <> "self"
								'f2_formula_10$'
							endif

						endfor
						time_begin_10=Get time from frame number... i9+1
						time_end_10=Get time from frame number... i10

					endif

					#for current_frame from 1 to 10
					#f1_t = Get value at time... 1 t'current_frame' Hertz Linear
					#f2_t = Get value at time... 2 t'current_frame' Hertz Linear
					#print 'f2_t''newline$'
					#endfor

					select master_formant

					f1_t1_after = Get value at time... 1 t1 Hertz Linear
					f1_t2_after = Get value at time... 1 t2 Hertz Linear
					f1_t3_after = Get value at time... 1 t3 Hertz Linear
					f1_t4_after = Get value at time... 1 t4 Hertz Linear
					f1_t5_after = Get value at time... 1 t5 Hertz Linear
					f1_t6_after = Get value at time... 1 t6 Hertz Linear
					f1_t7_after = Get value at time... 1 t7 Hertz Linear
					f1_t8_after = Get value at time... 1 t8 Hertz Linear
					f1_t9_after = Get value at time... 1 t9 Hertz Linear
					f1_t10_after = Get value at time... 1 t10 Hertz Linear
					f2_t1_after = Get value at time... 2 t1 Hertz Linear
					f2_t2_after = Get value at time... 2 t2 Hertz Linear
					f2_t3_after = Get value at time... 2 t3 Hertz Linear
					f2_t4_after = Get value at time... 2 t4 Hertz Linear
					f2_t5_after = Get value at time... 2 t5 Hertz Linear
					f2_t6_after = Get value at time... 2 t6 Hertz Linear
					f2_t7_after = Get value at time... 2 t7 Hertz Linear
					f2_t8_after = Get value at time... 2 t8 Hertz Linear
					f2_t9_after = Get value at time... 2 t9 Hertz Linear
					f2_t10_after = Get value at time... 2 t10 Hertz Linear



					select master_lpc
					select master_sound
					plus master_lpc
					Filter (inverse)
					Rename... source
					source_sound = selected("Sound")
					plus master_formant
					Filter
					Rename... Resynthesized
					resynthesized_sound = selected("Sound")
					resynthesized_sound_DB=Get intensity (dB)
					Scale intensity... master_sound_DB

					#Play

					To LPC (burg)... filter_order window time_step 50
					Rename... Source_after
					lpc_after = selected("LPC")
					To Formant
					Rename... formant_after
					formant_after = selected("Formant")

					f1_after = Get value at time... 1 midpoint Hertz Linear
					f2_after = Get value at time... 2 midpoint Hertz Linear
					f3_after = Get value at time... 3 midpoint Hertz Linear

					b1_after = Get bandwidth at time... 1 midpoint Hertz Linear
					b2_after = Get bandwidth at time... 2 midpoint Hertz Linear
					b3_after = Get bandwidth at time... 3 midpoint Hertz Linear
					
					call paste
					
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
					e6f1 = Get value at time... 1 t6 Hertz Linear
					e6f2 = Get value at time... 2 t6 Hertz Linear
					e7f1 = Get value at time... 1 t7 Hertz Linear
					e7f2 = Get value at time... 2 t7 Hertz Linear
					e8f1 = Get value at time... 1 t8 Hertz Linear
					e8f2 = Get value at time... 2 t8 Hertz Linear
					e9f1 = Get value at time... 1 t9 Hertz Linear
					e9f2 = Get value at time... 2 t9 Hertz Linear
					e10f1 = Get value at time... 1 t10 Hertz Linear
					e10f2 = Get value at time... 2 t10 Hertz Linear
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
					s6f1 = Get value at time... 1 t6 Hertz Linear
					s6f2 = Get value at time... 2 t6 Hertz Linear
					s7f1 = Get value at time... 1 t7 Hertz Linear
					s7f2 = Get value at time... 2 t7 Hertz Linear
					s8f1 = Get value at time... 1 t8 Hertz Linear
					s8f2 = Get value at time... 2 t8 Hertz Linear
					s9f1 = Get value at time... 1 t9 Hertz Linear
					s9f2 = Get value at time... 2 t9 Hertz Linear
					s10f1 = Get value at time... 1 t10 Hertz Linear
					s10f2 = Get value at time... 2 t10 Hertz Linear
					
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
					d6f1 = e6f1 - s6f1
					d6f2 = e6f2 - s6f2
					d7f1 = e7f1 - s7f1
					d7f2 = e7f2 - s7f2
					d8f1 = e8f1 - s8f1
					d8f2 = e8f2 - s8f2
					d9f1 = e9f1 - s9f1
					d9f2 = e9f2 - s9f2
					d10f1 = e10f1 - s10f1
					d10f2 = e10f2 - s10f2
					
					select Sound final_audio
					#Play
					#beginPause ("Give a listen to the final_audio sound")
					#			comment ("Check the picture window too")
					#			comment ("Is it a trainwreck?")
					#		     	choice ("trainwreck", 2)
					#		     	option ("Yes")
					#		     	option ("No")
					#endPause ("Continue", 1)
					trainwreck = 2
					if trainwreck = 2
	        			select TextGrid 'soundname$'
						Write to text file... 'directory$'/resynth/'soundname$'_res.TextGrid
						select Sound final_audio
						Rename... 'soundname$'_res
						Write to WAV file... 'directory$'/resynth/'soundname$'_res.wav
						call save
					endif
				endif
			endfor
			select all
			minus Strings list
			#Remove
		endif
	endfor

#######################################################################################################
#######################     Procedure Land     ########################################################
#######################################################################################################

#### This next part is where we define which vowels will be changed, and the deltas for each

procedure Sorting_Hat
	if vowel_label$ == "i"
		call ispecs
		skip = 0
	elif vowel_label$ == "ɪ"
		call ihspecs
		skip = 0
	elif vowel_label$ == "ɛ"
		call ehspecs
		skip = 0	
	elif vowel_label$ == "æ"
		call aespecs
		skip = 0
	elif vowel_label$ == "a"
		call aspecs
		skip = 0
	elif vowel_label$ == "u"
		call uspecs
		skip = 0
	elif vowel_label$ == "ʌ"
		call uhspecs
		skip = 0
	else
		skip = 1
	endif
endproc

#### LEFT INTERVAL = F1  RIGHT INTERVAL = F2
procedure ispecs
	flatchange = 0
	f1_change = 0
	f2_change = 0
	f3_change = 0
	b1_change = 0
	b2_change = 0
	b3_change = 0
	left_Interval_1 = 0
	left_Interval_2 = 0
	left_Interval_3 = 0
	left_Interval_4 = 0
	left_Interval_5 = 0
	left_Interval_6 = 0
	left_Interval_7 = 0
	left_Interval_8 = 0
	left_Interval_9 = 0
	left_Interval_10 = 0
	right_Interval_1 = 0
	right_Interval_2 = 0
	right_Interval_3 = 0
	right_Interval_4 = 0
	right_Interval_5 = 0
	right_Interval_6 = 0
	right_Interval_7 = 0
	right_Interval_8 = 0
	right_Interval_9 = 0
	right_Interval_10 = 0
endproc


procedure ispecs
	f1_change = 10
	f2_change = 100
	f3_change = 0
	b1_change = 0
	b2_change = 0
	b3_change = 0
	left_Interval_1 = 0
	left_Interval_2 = 0
	left_Interval_3 = 0
	left_Interval_4 = 0
	left_Interval_5 = 0
	left_Interval_6 = 0
	left_Interval_7 = 0
	left_Interval_8 = 0
	left_Interval_9 = 0
	left_Interval_10 = 0
	right_Interval_1 = 0
	right_Interval_2 = 0
	right_Interval_3 = 0
	right_Interval_4 = 0
	right_Interval_5 = 0
	right_Interval_6 = 0
	right_Interval_7 = 0
	right_Interval_8 = 0
	right_Interval_9 = 0
	right_Interval_10 = 0
endproc

procedure ihspecs
f1_change = 100
f2_change = 10
f3_change = 0
b1_change = 0
b2_change = 0
b3_change = 0
left_Interval_1 = 0
left_Interval_2 = 0
left_Interval_3 = 0
left_Interval_4 = 0
left_Interval_5 = 0
left_Interval_6 = 0
left_Interval_7 = 0
left_Interval_8 = 0
left_Interval_9 = 0
left_Interval_10 = 0
right_Interval_1 = 0
right_Interval_2 = 0
right_Interval_3 = 0
right_Interval_4 = 0
right_Interval_5 = 0
right_Interval_6 = 0
right_Interval_7 = 0
right_Interval_8 = 0
right_Interval_9 = 0
right_Interval_10 = 0
endproc

procedure ehspecs
f1_change = 50
f2_change = 50
f3_change = 0
b1_change = 0
b2_change = 0
b3_change = 0
left_Interval_1 = 0
left_Interval_2 = 0
left_Interval_3 = 0
left_Interval_4 = 0
left_Interval_5 = 0
left_Interval_6 = 0
left_Interval_7 = 0
left_Interval_8 = 0
left_Interval_9 = 0
left_Interval_10 = 0
right_Interval_1 = 0
right_Interval_2 = 0
right_Interval_3 = 0
right_Interval_4 = 0
right_Interval_5 = 0
right_Interval_6 = 0
right_Interval_7 = 0
right_Interval_8 = 0
right_Interval_9 = 0
right_Interval_10 = 0
endproc

procedure aespecs
f1_change = -50
f2_change = -50
f3_change = 0
b1_change = 0
b2_change = 0
b3_change = 0
left_Interval_1 = 0
left_Interval_2 = 0
left_Interval_3 = 0
left_Interval_4 = 0
left_Interval_5 = 0
left_Interval_6 = 0
left_Interval_7 = 0
left_Interval_8 = 0
left_Interval_9 = 0
left_Interval_10 = 0
right_Interval_1 = 0
right_Interval_2 = 0
right_Interval_3 = 0
right_Interval_4 = 0
right_Interval_5 = 0
right_Interval_6 = 0
right_Interval_7 = 0
right_Interval_8 = 0
right_Interval_9 = 0
right_Interval_10 = 0
endproc

procedure aspecs
f1_change = 20
f2_change = 70
f3_change = 0
b1_change = 0
b2_change = 0
b3_change = 0
left_Interval_1 = 0
left_Interval_2 = 0
left_Interval_3 = 20
left_Interval_4 = 30
left_Interval_5 = 40
left_Interval_6 = 50
left_Interval_7 = 40
left_Interval_8 = 30
left_Interval_9 = 20
left_Interval_10 = 0
right_Interval_1 = 0
right_Interval_2 = 0
right_Interval_3 = 20
right_Interval_4 = 30
right_Interval_5 = 40
right_Interval_6 = 50
right_Interval_7 = 30
right_Interval_8 = 20
right_Interval_9 = 0
right_Interval_10 = 0
endproc

procedure uspecs
f1_change = 150
f2_change = 200
f3_change = 0
b1_change = 0
b2_change = 0
b3_change = 0
left_Interval_1 = 0
left_Interval_2 = 0
left_Interval_3 = 0
left_Interval_4 = 0
left_Interval_5 = 0
left_Interval_6 = 0
left_Interval_7 = 0
left_Interval_8 = 0
left_Interval_9 = 0
left_Interval_10 = 0
right_Interval_1 = 0
right_Interval_2 = 0
right_Interval_3 = 0
right_Interval_4 = 0
right_Interval_5 = 0
right_Interval_6 = 0
right_Interval_7 = 0
right_Interval_8 = 0
right_Interval_9 = 0
right_Interval_10 = 0
endproc

procedure uhspecs
f1_change = 0
f2_change = 0
f3_change = 0
b1_change = 0
b2_change = 0
b3_change = 0
left_Interval_1 = 0
left_Interval_2 = 0
left_Interval_3 = 0
left_Interval_4 = 0
left_Interval_5 = 0
left_Interval_6 = 0
left_Interval_7 = 0
left_Interval_8 = 0
left_Interval_9 = 0
left_Interval_10 = 0
right_Interval_1 = 0
right_Interval_2 = 0
right_Interval_3 = 0
right_Interval_4 = 0
right_Interval_5 = 0
right_Interval_6 = 0
right_Interval_7 = 0
right_Interval_8 = 0
right_Interval_9 = 0
right_Interval_10 = 0
endproc

procedure inverter
if direction = 2
	f1_change = f1_change * -1
	f2_change = f2_change * -1
	f3_change = f3_change * -1
	b1_change = b1_change * -1
	b2_change = b2_change * -1
	b3_change = b3_change * -1
	left_Interval_1 = left_Interval_1 * -1
	left_Interval_2 = left_Interval_2 * -1
	left_Interval_3 = left_Interval_3 * -1
	left_Interval_4 = left_Interval_4 * -1
	left_Interval_5 = left_Interval_5 * -1
	left_Interval_6 = left_Interval_6 * -1
	left_Interval_7 = left_Interval_7 * -1
	left_Interval_8 = left_Interval_8 * -1
	left_Interval_9 = left_Interval_9 * -1
	left_Interval_10 = left_Interval_10 * -1
	right_Interval_1 = right_Interval_1 * -1
	right_Interval_2 = right_Interval_2 * -1
	right_Interval_3 = right_Interval_3 * -1
	right_Interval_4 = right_Interval_4 * -1
	right_Interval_5 = right_Interval_5 * -1
	right_Interval_6 = right_Interval_6 * -1
	right_Interval_7 = right_Interval_7 * -1 
	right_Interval_8 = right_Interval_8 * -1
	right_Interval_9 = right_Interval_9 * -1
	right_Interval_10 = right_Interval_10 * -1
endif
endproc

procedure stringer_bell
f1_change$ =  "self +" + "'f1_change'"
f2_change$ = "self +" +  "'f2_change'"
f3_change$ = "self +" +  "'f3_change'"
b1_change$ = "self +" +  "'b1_change'"
b2_change$ = "self +" + "'b2_change'"
b3_change$ = "self +" + "'b3_change'"
left_Interval_1$ = "self +" + "'left_Interval_1'"
left_Interval_2$ = "self +" + "'left_Interval_2'"
left_Interval_3$ = "self +" + "'left_Interval_3'"
left_Interval_4$ = "self +" + "'left_Interval_4'"
left_Interval_5$ = "self +" + "'left_Interval_5'"
left_Interval_6$ = "self +" + "'left_Interval_6'"
left_Interval_7$ = "self +" + "'left_Interval_7'"
left_Interval_8$ = "self +" + "'left_Interval_8'"
left_Interval_9$ = "self +" + "'left_Interval_9'"
left_Interval_10$ = "self +" + "'left_Interval_10'"
right_Interval_1$ = "self +" + "'right_Interval_1'"
right_Interval_2$ = "self +" + "'right_Interval_2'"
right_Interval_3$ = "self +" + "'right_Interval_3'"
right_Interval_4$ = "self +" + "'right_Interval_4'"
right_Interval_5$ = "self +" + "'right_Interval_5'"
right_Interval_6$ = "self +" + "'right_Interval_6'"
right_Interval_7$ = "self +" + "'right_Interval_7'"
right_Interval_8$ = "self +" + "'right_Interval_8'"
right_Interval_9$ = "self +" + "'right_Interval_9'"
right_Interval_10$ = "self +" + "'right_Interval_10'"
endproc

procedure formulator
f1_formula$= "Formula (frequencies)... if row = 1 then 'f1_change$' else self fi"
f2_formula$= "Formula (frequencies)... if row = 2 then 'f2_change$' else self fi"
f3_formula$= "Formula (frequencies)... if row = 3 then 'f3_change$' else self fi"

f1b_formula$= "Formula (bandwidths)... if row = 1 then 'b1_change$' else self fi"
f2b_formula$= "Formula (bandwidths)... if row = 2 then 'b2_change$' else self fi"
f3b_formula$="Formula (bandwidths)... if row = 3 then 'b3_change$' else self fi"

frame = 0

f1_formula_1$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_1$' else self fi"
f1_formula_2$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_2$' else self fi"
f1_formula_3$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_3$' else self fi"
f1_formula_4$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_4$' else self fi"
f1_formula_5$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_5$' else self fi"
f1_formula_6$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_6$' else self fi"
f1_formula_7$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_7$' else self fi"
f1_formula_8$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_8$' else self fi"
f1_formula_9$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_9$' else self fi"
f1_formula_10$= "Formula (frequencies)... if row = 1  and col = frame then 'left_Interval_10$' else self fi"


f2_formula_1$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_1$' else self fi"
f2_formula_2$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_2$' else self fi"
f2_formula_3$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_3$' else self fi"
f2_formula_4$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_4$' else self fi"
f2_formula_5$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_5$' else self fi"
f2_formula_6$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_6$' else self fi"
f2_formula_7$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_7$' else self fi"
f2_formula_8$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_8$' else self fi"
f2_formula_9$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_9$' else self fi"
f2_formula_10$= "Formula (frequencies)... if row = 2  and col = frame then 'right_Interval_10$' else self fi"
endproc

procedure from_editor
#original_sound = selected("Sound")
#original_sound$ = selected$("Sound")
#Copy... template
select Sound 'soundname$'
Edit
editor Sound 'soundname$'

Select... start end
Move begin of selection to nearest zero crossing
Move end of selection to nearest zero crossing
Cut
#pause Make a selection
#cursor = Get cursor
endeditor
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
fileappend 'data_output_file$' 'soundname$''tab$'1'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''left_Interval_1''tab$''right_Interval_1''tab$''s1f1:0''tab$''e1f1:0''tab$''s1f2:0''tab$''e1f2:0''tab$''d1f1:0''tab$''d1f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'2'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''left_Interval_2''tab$''right_Interval_2''tab$''s2f1:0''tab$''e2f1:0''tab$''s2f2:0''tab$''e2f2:0''tab$''d2f1:0''tab$''d2f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'3'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''left_Interval_3''tab$''right_Interval_3''tab$''s3f1:0''tab$''e3f1:0''tab$''s3f2:0''tab$''e3f2:0''tab$''d3f1:0''tab$''d3f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'4'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''left_Interval_4''tab$''right_Interval_4''tab$''s4f1:0''tab$''e4f1:0''tab$''s4f2:0''tab$''e4f2:0''tab$''d4f1:0''tab$''d4f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'5'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''left_Interval_5''tab$''right_Interval_5''tab$''s5f1:0''tab$''e5f1:0''tab$''s5f2:0''tab$''e5f2:0''tab$''d5f1:0''tab$''d5f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'6'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''left_Interval_6''tab$''right_Interval_6''tab$''s6f1:0''tab$''e6f1:0''tab$''s6f2:0''tab$''e6f2:0''tab$''d6f1:0''tab$''d6f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'7'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''left_Interval_7''tab$''right_Interval_7''tab$''s7f1:0''tab$''e7f1:0''tab$''s7f2:0''tab$''e7f2:0''tab$''d7f1:0''tab$''d7f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'8'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''left_Interval_8''tab$''right_Interval_8''tab$''s8f1:0''tab$''e8f1:0''tab$''s8f2:0''tab$''e8f2:0''tab$''d8f1:0''tab$''d8f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'9'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''left_Interval_9''tab$''right_Interval_9''tab$''s9f1:0''tab$''e9f1:0''tab$''s9f2:0''tab$''e9f2:0''tab$''d9f1:0''tab$''d9f2:0''newline$'
fileappend 'data_output_file$' 'soundname$''tab$'10'tab$''f1_change''tab$''f2_change''tab$''f3_change''tab$''left_Interval_10''tab$''right_Interval_10''tab$''s10f1:0''tab$''e10f1:0''tab$''s10f2:0''tab$''e10f2:0''tab$''d10f1:0''tab$''d10f2:0''newline$'
endproc

procedure draw
Erase all
select original_formant
Black
Speckle... startwindow endwindow 3000 30 yes
select formant_after
Red
Speckle... startwindow endwindow 3000 30 no
Black
One mark top... 'time_begin_1:4' no yes yes 1
One mark top... 'time_begin_2:4' no yes yes 2
One mark top... 'time_begin_3:4' no yes yes 3
One mark top... 'time_begin_4:4' no yes yes 4
One mark top... 'time_begin_5:4' no yes yes 5
One mark top... 'time_begin_6:4' no yes yes 6
One mark top... 'time_begin_7:4' no yes yes 7
One mark top... 'time_begin_8:4' no yes yes 8
One mark top... 'time_begin_9:4' no yes yes 9
One mark top... 'time_begin_10:4' no yes yes 10
#select original_sound
endproc



 
 
 
 
 
 
 
 
