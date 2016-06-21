#General Information
This script is distributed under the GNU General Public License.

Copyright 08.06.2016 Simon Gonzalez

email: s.gonzalez@griffith.edu.au

# audio_textgrid_split
Split audio and TextGrid files in Praat

This script splits WAV files and TextGrids into equal sections.
The script can be used in the following cases:

1. Split an individual WAV file
2. Split an individual TextGrid file
3. Split a combined WAV file with its corresponding TextGrid. In the last case, both files must have the same duration and same name.

## Example

As a user, I want to split an audio (.wav) file with its correspoding TextGrid into five equal sections.
The original files have a duration of 5 minutes. at the end of the script, five files will be created.
Each file has a duration of 1 minute.

## Parameters

1 TextGrid number: Number of TextGrid in the object window.
2 Sound number: Number of audio file in the object window (not Long Sound).

3 Number of divisions: Number of divisions in which the original files will be split.

4 Create (Bollean): If TRUE, a table with the temporal infomation for each file will be created.
This will have information on the start and end points for each file.

5 Format: If Create is TRUE, the infomation will be saved in either a text file or a csv file.
