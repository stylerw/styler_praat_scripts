# Intervalator Vowels
# Will Styler - 2008ish
# 
# This is meant to save time when adding vowel labels to existing word-labeled data
# 
# This script is designed to be added to a log script slot, and then that keystroke assigned to a mouse button (USBOverdrive or something equivalent).  
#
# Then, you can simply select a span within a word, hit that button, and it'll automatically make an interval, and then jump to the next word interval and zoom in, so you can select the vowel, rinse, repeat
#
#

Interrupt playing
begin = Get begin of selection
end = Get end of selection
#Play or stop
Move cursor to... begin
Add on tier 1
Move cursor to... end
Add on tier 1
# Move cursor by... -0.0001
Select previous tier
Select next interval
Select next interval
Zoom to selection
Select next tier

