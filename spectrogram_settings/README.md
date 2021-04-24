# Easy Editor Scripts for Changing Spectrogram Settings

These scripts are designed to be added to your 'Spectrum' menu in Praat to allow you to quickly adjust your spectrogram settings.  To do this:

1) Open a sound in the Editor
2) File > Open Editor Script
3) Open the script
4) Now within the Script Editor window, File > Add to Menu...

Window: SoundEditor
Menu: Spectrum
Command: [Command Name you'd like, e.g. 'Narrow 5kHz')

Nothing else needs to be entered.  Then when you reopen a sound in the editor window, you'll see those commands.

You can also add or remove items by, WITH PRAAT CLOSED, manually editing the Buttons5 Pref file, which is found on a Mac in...

/Users/YOURNAME/Library/Preferences/Praat Prefs/Buttons5

using a text editor.  I'd recommend adding one or two first manually, so you get a sense of the process.


