# Nasality Automeasure Script Package - README
Developed at the University of Colorado's Phonetics Lab by Will Styler and Rebecca Scarborough, and maintained by Will Styler.  Available from: https://github.com/stylerw/styler_praat_scripts

# Introduction

So, you've decided to do some nasality measurements on your data using our scripts.  Well, before you get started, there are a few things you'll need to know.

## Disclaimer:

This script package, although in production use by the authors and others at the CU Phonetics Lab, the University of Michigan, UC San Diego, and elsewhere, may still have bugs and quirks, alongside the difficulties and provisos which are described throughout the documentation. 

By using this script, you acknowledge:

* That you understand that this script package does not reliably produce camera-ready data, and that all results must be hand-checked for sanity's sake. Pasting data from this script straight into your dissertation without careful review is not wise, as neither Praat, the script, nor the authors of the script should be trusted implicitly.  

* That you understand that this script package is a work in progress which may contain bugs.  Future versions will be released, and bug fixes (and additions) will not necessarily be advertised.

* That this script package may break with future updates of Praat, and that the authors are not required to repair the package when that happens.

* That you understand that the authors are not required or necessarily available to fix bugs which are encountered (although you're welcome to submit bug reports to will@savethevowels.org, if needed), nor to modify the script to your needs.

* That you will acknowledge the authors of the script package if you use, modify, fork, or re-use the code in your future work.  

* That rather than re-distributing this script package to other researchers, you will instead advise them to download the latest version from the website.

... and, most importantly:

* That neither Will Styler, nor the members of the CU Phonetics lab, nor the University of Colorado on the whole, nor any other institution, are responsible for the results obtained from the proper or improper usage of the script, and that the script is provided as-is, as a service to our fellow linguists.

Thanks for using our script, and we hope it works wonderfully for you!

## A Warning on Nasality Data

This script has provided meaningful data, used in a variety of publications in our lab, and externally.  We (and others) have found expected patterns of nasality in our work, with careful curation and examination of the data. However, *nasality measurement is tricky*!  In order to interpret these data, you should become familiar with both the measure, and papers which have used it, and you should be aware of the following facts of nasal acoustics and measurement.

* The A1-P0 and A1-P1 components of this work are based in Marilyn Chen's 1997 paper, cited below, and uses the method (and algorithm) recommended there for A1-P0 measurement.  

* The A1-P0 measure is robust, well-studied, and well-correlated with nasality.  It is useful primarily for non-high vowels, and is the best single-number measure of nasality currently available.  You should still become familiar with this paper, and the details of the measurement, before using it.

* **However**, A1-P0 measurements are not meaningful at a token-by-token level.  Although one can safely (and easily) find patterns of nasality in a large dataset, for any given measurement, particularly when found automatically, one cannot make claims like "*This particular vowel* is nasalized".  The best approach is to compare large groups of tokens across differing conditions.

* **Crucially**, A1-P0 measurement values *cannot be compared across speakers*.  There is evidence (see Styler 2017) that speakers vary both in terms of their base value of A1-P0 (their mean values for oral and nasal vowels), as well as the range between oral and nasal vowels.  This means that although you can safely compare within-speaker changes across conditions ("Across all speakers, vowels were more nasal in NVNs than NVCs"), *you cannot reliably compare across-speaker changes in degree* ("Speakers are more nasal in Boston than Denver" or "L2 speakers show greater nasality than L1 speakers") using A1-P0.  

* Although we've seen promise for some of the secondary measures of nasality (A3-P0, P0Prominence, Formant Bandwidths) (see Styler 2015), they have not been vetted in the literature, and their measurement is not as well studied or established.  Because much less is known about these measures, they should be used carefully.

* Secondary measures (mainly vowel formant frequencies and bandwidths) are not treated as cautiously in the script, and are not automatically sanity-checked.  They are derived directly from Praat's LPCs, with little processing.  Please treat the formant output of this script as one might any other formant analysis script.

- Please see [my 2017 JASA paper](http://wstyler.ucsd.edu/files/styler2017_jasa_onacousticalnatureofnasality.pdf) for a more up-to-date survey of some of the problems inherent in acoustical measurement of nasality.

## About the Script

This script measures a variety of nasality-related values at multiple points, in vowels marked in a TextGrid annotated sound.

### Input

This script uses sound files with associated TextGrids

* TextGrids should have at least interval 2 tiers:  one for vowels and one for words.  Relevant and word vowel intervals must be labeled.
* As currently written, each word must contain exactly 1 vowel interval.
* **Important Note!** - stringsfile.txt MUST be in the resources folder in the same folder as this script in order for this script to run at all.

### Output

* A log file (./nasalitylog.txt) containing file name, word, vowel, as well as measurements described below.

### Process: 	

The script looks for soundfiles with a specified extension in a specified folder.  For each soundfile, it finds the associated TextGrid and then locates marked vowel intervals one-by-one.

The script then cycles through all files, immediately measuring and logging all datapoints which display no sign of trouble. Then, for those which are flagged in the automation process, an FFT with overlaid LPC and a spectrogram are displayed for the user.  Measurement points for H1, H2, and A1 are marked in the spectrum, and calculated H1 amp, H2 amp & A1 values are listed.  The user is asked whether the values are appropriate. If yes, they are logged (along with the other output information listed above).  

If not, the user can manually enter the requested vales in a pause form.

You may stop at any point in the dataset, and Praat will simply return to where you were next time you run the script on the data, provided the nasprogress file isn't deleted.

### Accompanying Files

* NasalityAutomeasure.praat: The script itself, which does the measurement.

* resources/stringsfile.txt: Needed for the script to run.  Just a text file with "0", line break, "0", line break.  This is because Praat won't let you create a 'strings' object from thin air.

* resources/highvowels.txt: Here, you specify textgrid labels which indicate high vowels, one per line.

* nasality_FFT.praat: This allows you to hand-create an FFT using the same process used in the script		

### Attribution

Nasality Measurement code originally written by Rebecca Scarborough based on a nasality measurement script written by Sarah Johnstone, with bits of code borrowed from scripts by Bert Remijsen, Mietta Lennes, and Katherine Crosswhite.  

Error control, Automation and UI improvements (in Version 3+) were later added by Will Styler, 2008-2018.  Will is the current maintainer of the code.

## Installation:

This script package doesn't really need to be installed, just drag the whole folder to a safe place on your computer.  Then, I'd recommend that you add the main script (NasalityAutomeasure.praat) to your Praat objects window for easy access, then add nasality_FFT.praat to your editor window for easy access.  Then you can run the script by just selecting the main script from your objects window.  Or, you can just double-click the main script and select "Run" from the Praat menus.  Whatever you do, it's vital that you keep the "resources" directory in the same directory as the main script.  It won't run without it.

If you ask for three measurements per vowel, it'll give you measures at start, midpoint, and end.  If you ask for one, it'll give you centers only.  And if you ask for any other number, it will calculate the timepoints to be evenly spaced.  These timepoints are calculated by dividing the duration of the vowel by the number of iterations specified, and then adding that amount to the timepoint each time.  So, for a 100ms vowel measuring 10 timepoints, the first timepoint (1 in the data file) should be at 0 ms, the second at 10 ms, the third at 20 ms...

## Data format:

Your data will need to be in soundfile (.aiff or .wav) and matching textgrid format, and stored in a folder someplace.  The textgrids will have to have a word and vowel tier, and the vowel will _have_ to be labeled (as the script will measure all labeled intervals).  So, the contents of your folder should look like:

* joey_2_m_bame.TextGrid
* joey_2_m_bame.wav
* joey_2_m_band.TextGrid
* joey_2_m_band.wav
* joey_2_m_bang.TextGrid
* joey_2_m_bang.wav
* joey_2_m_bench.TextGrid
* joey_2_m_bench.wav
...(and so forth)

Right now, this script is not capable of running on a single item, say, in a Praat window, so just save it with a textgrid in a folder, and you're golden.

Note that all labeled intervals on the tier used for vowels will be measured, whether they're vowels or not.  

## Modes of Running:

There are three ways to run this script, in two-pass automation mode, manual mode, or full-auto.  This is selected in the form which pops up when you run the script.  

Two-pass automation goes through the entire dataset (leaving you free to go grab a drink), making measurements and flagging measurements that it views as suspect, then asks you to hand-review the flagged measurements (just as you would in non-automated mode).  Depending on your data, this could reduce the human time required for making a given set of measurements significantly. Unfortunately, it will not dump graphs in this mode.  Sorry!

Going through the data manually is still possible.  In this mode, the script will go through each data point with you, presenting you with a spectrum, list of measurements, editor window, access to all the files, and a window with all the measurement numbers for editing.  If you find an issue with a measurement, you're then free to generate spectra at another timepoint (using the nasality_FFT editor script), to manually get frequencies and amplitudes and enter those in the window, or to pull that token altogether.

Full-auto mode acts identically to two-pass mode, except it doesn't ask for help and stores all values, including those it's suspicious of.  It also keeps a "Flag" which shows what made the script uneasy and would've kicked over to manual review if you weren't on full-auto.  Use at your own risk!

**When the script is running in Full-Auto mode, due to the way that Praat is programmed, your computer may think that Praat is "Not Responding".  You may be unable to use other parts of Praat, move its windows, etc.  This is normal, and is just a symptom of how much number crunching Praat is doing.  If you're concerned that you may have actually crashed, just open the log file and see if new entries are being added.**

# How does this script work?  

Simply put, for each timepoint, the script will:

1. Extract the pulse nearest to the timepoint
2. Copy that small pulse over and over again until it reaches 0.5 seconds (assuming that you've asked it to do that.)
3. From this newly generated repeated pulse files (or from the sound itself, depending on settings), we take the first formant and get the pitch using Praat's pitch tools
4. After some error checking, the script finds the frequency and amplitude of the maximum nearest the detected pitch (in a +/- F0 window).  This is measured and labeled as H1
5. The script then doubles the F0, and searches again for a maximum in a +/- F0 window.  The highest frequency and amplitude are saved as H2
6. The same thing is done for the harmonics under where the LPC detects F1
7. P1 is found by searching +/- one harmonic from the user-specified P1 search frequency
8. The results are then output into a file.

# Logfile Description

* filename - The filename from which this measurement came
* word - The label in the "word" tier
* vowel - The label in the "vowel" tier
* freq_f1 - The frequency of the peak where A1 was measured (Hz)
* amp_f1- The Amplitude of the highest peak under F1 (dB)
* width_f1 - The bandwidth of F1 (Hz)
* freq_f2 - Where Praat found F2 for the vowel (not hand confirmed) (Hz)
* amp_f2 - The Amplitude of the highest peak under F2 (dB)
* width_f2 - The bandwidth of F2 (Hz)
* freq_f3 - Where Praat found F3 for the vowel (not hand confirmed) (Hz)
* amp_f3 - The Amplitude of the highest peak under F3 (dB)
* width_f3 - The bandwidth of F3 (Hz)
* freq_h1 - The frequency of the peak where H1 was measured (Hz)
* amp_h1 - The Amplitude of H1 (dB)
* freq_h2 - The frequency of the peak where H2 was measured (Hz)
* amp_h2 - The Amplitude of H2 (dB)
* amp_h3 - The Amplitude of H3 (dB)
* amp_p0 - The Amplitude of P0 (as measured using the highest of H1 or H2) (dB)
* freq_p0 - The frequency of the peak where H1 was measured (Hz)
* p0_id - Which harmonic was chosen as P0 (H1, or H2)
* p0prominence - The height of P0 relative to the surrounding two harmonics (See Styler 2015, Styler and Scarborough 2014 (ASA Poster))
* a1p0_h1 - A1-P0 calculated using H1
* a1p0_h2 - A1-P0 calculated using H2
* a1p0_h3 - A1-P0 calculated using H3
	* This is ONLY for speakers who have exceptionally low F0.  The script will never naturally give A1-P0 using H3 for the baseline 'a1p0', only H1 and H2.  Unless you're sure it applies for this speaker, do not use this value.
* a1p0 - A1-P0 calculated using whichever of the first harmonics was higher (H1 or H2), as recommended in Chen 1997.
* a1p0_compensated - Chen (1997) gives a method of adjusting A1-P0 based on formants and bandwidth.  This number is the result of that method, based on the HighPeak A1-P0.
* freq_p1 - The freqnency of the peak where P1 was measured (Hz)
amp_p1 - The Amplitude of P1 (the highest peak near the value set in the script's form) (dB)
* a1p1 - A1-P1 calculated using the peak at P1Freq
* a1p1_Compensated - Chen (1995) gives a method of adjusting A1-P1 based on formants and bandwidth.  This number is the result of that method, based on the A1-P1 above
* a3p0 - The amplitude of F3 - the amplitude of P0.  Fundamentally, a measure of spectral tilt (See Styler 2015).
* vwl_amp_rms - The RMS amplitude of the vowel (Pascal)
* vwl_duration - The duration of the vowel (ms)
* timepoint - Which timepoint (by number) this measurement comes from
* point_time - The time of this measurement within the file
* point_vwlpct - The time of this measurement in terms of % duration of the vowel.
* attempted_fix - If the script tried to fix something, this lets you know.  An entry here doesn't mean there's a problem with the final data.
* status - Was this measurement done automatically (Auto) or hand-verified (Verify)
* errorflag - These all indicate problems with the measurement.
	* **Any measurement which shows something other than "none" listed here should be excluded from further use or analysis.**
	* LowF1 = If F1 is lower than the lowest acceptable value set in the script (the "hif1" settings), the point fails
	* HighF1 = If F1 is higher than the highest acceptable value set in the script (the "lof1" settings), the point fails.
	* LoPitch = The H1 detected was less than "crazylowh1" in the script (default is 80 Hz, but can be adjusted)
	* HiPitch = The H2 detected was more than "crazyhighh1" in the script (default is 300 Hz, but can be adjusted)
	* HarmDev = The frequency of H2 detected is more than half an F0 away from 2*H1, in any direction.
	* Shallow = If the deepest point between H1 and H2 is, well, not deep at all, this trips.  This prevents Praat finding H1 and H2 on the side of a single peak
	* F1Vary = This trips if the F1 found deviates from the F1 average by more than f1vary (set in script) * F0
	* Crash = This trips if, for whatever reason, Praat can't generate a needed value.  This means you'll have to try another point.

# Troubleshooting and FAQ

## "Oh no!  The script won't run"

1. Make sure that the directory with soundfiles and textgrids ends with a / (/path/to/file/folder/sounds/)
2. Make sure you have all the right files in the folder with the script, especially stringsfile.txt
3. Make sure your soundfiles and textgrids are properly laid out (One tier for words, one for vowels)
4. Make sure that you've assigned the vowel/word tiers properly in the startup dialog.  Remember, settings in the startup dialog aren't saved, so you'll need to re-enter each time.
5. If you've run the script before on this set of data, and the script won't re-measure, just delete the nasprogress.txt file in the folder.
	
## "Oh no!  The script crashed while processing!"
	
1. The easiest solution is to look at the bottom of the Praat Objects window to see which file crashed the script, then remove said file from the folder and re-run the script.  This usually happens because a given word doesn't have any modal voicing, and as such, the script can't get a handle on it.  There will be some files that can't be measured by this technique, especially those with heavy creak, and you'll just have to give up on those.

## "Oh no!  I'm being asked to verify this spectrum and it's all wrong!"

1. If the spectrum is OK and the script just found the wrong peaks, use the correct_ scripts to label the correct peaks in the spectrum window by moving the cursor to the peak, then selecting the relevant "correct_" script.
2. If the spectrum is bad (choppy or just two or three peaks), use the nasality_FFT.praat script to create a new spectrum from a different location in the word.  Just put the cursor on a point and run the script.  Your best bet is the blackest part of a pulse, in a region where Praat has a pitch-track.
3. If you can't get a good spectrum anywhere in the word (which does happen), delete that word from the to-measure folder and move on with life.
4. If no spectrum is visible in the verify window, or if you only get the very tips of peaks, go down to the "procedure Display_spectrum_and_LPC" part of the main nasality script and edit the numbers as instructed to control the dynamic range.
5. If your top line in the verify window is "ERROR: Manual Measurement will be needed, 0 inserted", there's no pitch track or the script tried to crash.  Don't worry, and proceed as usual, you just won't have data for that.

## "Oh no!  Something's wrong with my data!"

1. Unfortunately, this script is not terribly accurate at finding the frequencies of H1, H2, and F0.  If you go through your data, you'll realize that you'll get a great many data points with H1 freqs of one number, then that number + 21 Hz, then that one + 21 Hz.  This is expected behavior, and is a limitation of the ability of Praat to resolve frequencies in small samples.  The amplitude measurement (which is what A1-P0 cares about anyways) is still reasonably accurate despite this.
2. If you see Zeroes or "--(something)--" in the data log, just erase them, because of a lack of pitch-track, data for that point was unable to be measured.
3. If you'd like to do more hand verification, or are extra paranoid, either run the dataset without the automatic first pass, or decrease the "Shallow" tolerance under "procedure Checks_And_Balances"

## "Oh no!  My poor computer has been brought to its knees!  Praat is frozen, my fans are going crazy, and it's been chugging for almost 20 minutes!"

When the script is running in Full-Auto mode, due to the way that Praat is programmed, your computer may think that Praat is "Not Responding", especially if you've got a particularly fast computer.  You may be unable to use other parts of Praat, move its windows, etc.  This is normal, and is just a symptom of how much number crunching Praat is doing.  If you're concerned that you may have actually crashed, just open the log file and see if new entries are being added.

If this is a source of major pain for you, you can purposefully slow the script down by removing "noprogress" in the line (around line 560, at the time of writing):

	noprogress To Pitch... 0 60 'crazyhighh1'

This will cause Praat to stop what it's doing and display a "Progress" bar when creating the pitch object.  This gives your OS something to do with itself while the script is running, and although it will add 5-10 minutes to runtime (believe it or not), it should make Praat perform like any other program under heavy load.

If you have any further questions, email will@savethevowels.org.  If not, have fun, and enjoy the nasality!

# Version History

## Version 2.0
* Version 2.0 (2008-2010): Introduced the first measurement autocorrection procedures, and laid groundwork for automation.  

## Version 3.0 
* Version 3.0 (Spring 2010): Added two-pass automation capability and additional error robustness
* 3.1 (9/17/2010): Added high F1 as an error prevention flag, also streamlined non-automated running
* 3.1.1 (9/24/2010): Added the option to only measure vowel midpoints (using the initial form).  Created version history

## Version 4.0

* Version 4.0.0 (August 2011) Merged iterative and start/mid/end scripts, condensed the code considerably (~400 lines removed), added A1-P1 measurement, and also now calculate the A1-P0 and A1-P1 in the script. In addition, an easier way to specify max and min F0 for speakers.  Many other small tweaks.  Major revision, designed to supplant and improve upon 3.x in nearly every way.

* 4.0.1 (January 31st, 2012): Removed the (now unnecessary) "check this box if you made manual measurements" box. 

* 4.0.2 (February 21st, 2012): Added OS-native "Open folder" dialogs

* 4.0.3 (March 23rd, 2012): Fixed a crash when Word tier != 2

* 4.0.4 (March 25th, 2012): Fixed a crash when using manual verification alone (Thanks Lisa Davidson!)

* 4.0.5 (March 31st, 2012): Fixed double-outputting of individual datapoints in manual mode (Thanks again, Lisa Davidson!)

## Version 5.0

* Version 5.0 (May 2013) This was a big one:
	* Added Full-Auto running mode, for those who like to live dangerously
	* Modified the script to fully utilize A1-P1
	* Added the use of Chen's compensation formulae for A1-P1 and A1-P0, as described in Chen 1995 and 1997
	* Added option to dump graphs of A1-P0 and A1-P1 to PDF in Full-Auto or Manual Mode
	* Fixed a bug where Timepoints >3 were unevenly spaced due to a linguist attempting math.
	* F0 now falls back to the mean F0 for the vowel if it's not findable at a given point
	* F1 is now compared to mean F1 for the vowel as a sanity check

* Version 5.1 (July 15th, 2013): 
	* Added the option to NOT extract and iterate a pulse, but instead, just to take a window within the actual vowel and grab the measures from it. 
	* Modified graphdump to only dump compensated A1-P0, A1-P1
	* If the script finishes cleanly with the data in a given folder, it deletes the nasprogress progress file.  
	* Then, I fixed a bug which caused the intensely annoying crash when there's a progress-file present.  But kept the prior change because it's cleaner
	* Improved dumped graph labeling
	* Code cleanup, small tweaks, etc

* Version 5.2 (December 2013): Formant Finding Fun!
	* One of the most common failure modes was finding an F1 lower than was sane.  
	* As such, the script is now vowel aware, using vowel labels in the "highvowels" file under /resources.  Change these labels to change what's associated with "high", everything else is "Low" so long as the appropriate option is checked
	* When a high or low vowel is detected, it changes the formant sanity check settings, as specified in the preamble of the main script
	* Also, you now have the option to bump the start and end points away from the edges by an amount specified in the form.  This helps with annotation errors, more than a bit.
	* More comments in the code, because why not?
	* De-crufted some of the code, removing reference to old functions since replaced
	* Separated "Flag$" and "ErrorAdj$".  Now flag means "This is bad data" and "ErrorAdj" means "I think I fixed it, but it could be bad data"
	* ErrorAdj, in its old function, was deprecated as the script no longer moves around to find good data, instead falling back to means.  This is safer 
	
* Version 5.3 (December 2013): More data!

	* Added the option in the code to look for the features which the author is studying in his dissertation (willdata =1) (*Successful measures are removed as of 5.7.6*)
	* If selected, this will output more columns

* Version 5.4 (March 15th, 2014): Bugfixes!
	* The two-pass and manual modes were screwed up, somehow or another.  Optimized the control code for them, and fixed that problem.
	* Solved a bug which would cause undefined pulses and "shallow" FFTs at the beginning and end of words respectively.

* Version 5.5 (March 27th, 2014): P1
	* Finally giving P1 picking some much needed love.

* Version 5.6 (April 1st, 2014): More Love for P1
	* Added an option (in the script preamble, not the opening form) to manually confirm P1's location.  It'll pop up a spectrum, and you need to click on the P1 peak, then hit "Continue" in the pause form.  Praat will then find the peak nearest your cursor (so try to click as close to central as you can), and use that frequency to get amplitudes from the same LTAS object that all the other values come from.  This occurs after the automatic attempt to get P1Freq, but prior to the manual confirmation step.  Also, note that this can work whether or not you've chosen to run manually, two-pass, or full-auto, although it will pause for every single measurement to get a P1.
	* This also serves as a template to add new sections to manually confirm other peaks.  
	* Added comments in the script which indicate a pair of lines that you can comment/uncomment to only evaluate high vowels.  This can be changed to only measure low vowels.
	* Removed reference to the "Correction Scripts", and removed the scripts from the package.  They were based on a fantastically ugly hack, and have been supplanted by the pause form allowing manual entry of data.  I'll look into improved ways of implementing them, but as it stood, because of issues in swapping data between two scripts, they weren't reliable enough to maintain.
	* Updated documentation accordingly.
	* Tweaked the layout of the two-pass confirmation spectrum box, to remove "ErrorAdjustment" (deprecated) and add P1's value there.  Also added a line for P1 (thanks, Rebecca, for the suggestion!)

* Version 5.6.1 (April 13, 2014): Formant Bandwidth Tweak
	* If the script can't find F1, F2, or F3 (--undefined--), it also won't be able to find the bandwidth.  The script will now use the 0.5 quantile of the bandwidth if the formant is undefined, in the same way that it uses the mean formant frequency.  If it's defined, though, it'll still take it at the timepoint. 
	
* Version 5.6.5 (October 2014): Revised names of output variables to be more predictable and useful.

* Version 5.7 (February 2015): All specs (amp, bandwidth and frequency) are now output by default for F1, F2 and F3, along with P0Prominence, and A3-P0 (see Styler 2015).  All column headers are now in lowercase, because I know *I* was sick and tired of guessing which were caps and which weren't.  Also, 'A1P0_Highpeak' is now just 'A1P0' in the output, because I don't hate you. "Willdata" collection is disabled by default, as the features there simply aren't very good for measuring nasality (I know that now!)

* Version 5.7.5 (Mid-February, 2015): A1-P0 based on H3 is now output, for speakers with exceptionally low F0.  It will never be used in the A1P0 measurements, and is only there for reference.  Also, measurement timepoint position is now also expressed in terms of percentage of the vowel.

* Version 5.7.6 (Late February, 2015): Output Columns Reordered to make more sense.  All vestiges of the "willdata" measures are gone, as they were never worth anything anyways :)

* Version 5.8 (Late February, 2015): Organization improvements within the code (put all the formant-grabbing together, etc), as well as extensive commenting to explain *how* the script does what it does. Graphdump improved to display A1-P0 and F1's bandwidth (instead of A1-P0 Compensated and A1-P1).  No other functional changes, just a few cosmetic ones.

* Version 5.8.1 (May 2015): **Initial Public Release!**.  Updated documentation to reflect the now-public nature of the script, and added discussion of the intricacies of vowel nasality.  No changes were made to the function or code of the script from 5.8.1.

* Version 5.8.2 (Feb 2016): 
	* Added Debug mode (modify the var early in the script to start) which will allow you to dump to file a spectrum and spectrogram of each point.  Really handy for generating plots for papers and for figuring out what the heck is wrong with the script in a given dataset.  
	* It also changes the behavior for Formant-finding.  Basing it on F0 results in absurdly large ranges for High F0 speakers ("F1 is the highest peak within 600 Hz of what the LPC claims"), so it's now fixed to the highest peak +/- 150 Hz of the LPC.
	* The script now flags situations where F1 is "found" at a lower frequency than H1.  This happens rarely with speakers with high F0.  

* Version 5.9 (July 2017)
	* Added fixes for large, multi-word files from Rebecca Scarborough
	* Moved to non-word-based boundaries for extract-and-iterate in all cases
	* Added option to specifically include (or exclude) a word based on grid labels
	
## References

M. Y. Chen. Acoustic Parameters of Nasalized Vowels in Hearing-Impaired and Normal-Hearing Speakers. *The Journal of the Acoustical Society of America*, 98(5):2443–2453, 1995.

M. Y. Chen. Acoustic correlates of English and French nasalized vowels. *The Journal of the Acoustical Society of America*, 102(4):2350–2370, 1997.

W. Styler. *On the Acoustical and Perceptual Features of Vowel Nasality*. PhD thesis, University of Colorado at Boulder, March 2015.

W. Styler. On the Acoustical Features of Vowel Nasality in English and French. Journal of the Acoustical Society of America. 142(4):2469-2482. Oct. 2017.
