# This script gets your vocal tract length from a neutral vowel (long schwa).  According to Keith Johnson's "Acoustic and Auditory Phonetics".
# Will Styler, 2011

f3h = Get third formant
length = (1715/(4 * f3h))
lcm = length * 100
print Your vocal tract length is  'lcm:1'  cm

