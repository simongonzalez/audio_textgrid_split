# This script splits WAV files and TextGrids into sections
# The script can be used in the following cases:
# 1. Split an individual WAV file
# 2. Split an individual TextGrid file
# 3. Split a combined WAV file with its corresponding TextGrid.
# In the last case, both files must have the same duration and same name.
#
# This script is distributed under the GNU General Public License.
# Copyright 08.06.2016 Simon Gonzalez
# email: s.gonzalez@griffith.edu.au

#Setting all parameters before running the script
#beginning of form-------------------------------------------------------------
	form File Divisions
		comment I - SELECT TEXTGRID AND/OR SOUND FILE (from the object window)

		#Input the textGrid number from the object window
			integer TextGrid_number 2
		#Input the sound number from the object window
			integer Sound_number 1

		comment II - SELECT NUMBER OF DIVISIONS
		comment Values must be larger than 0
		#Input the total number of divisions
			positive Number_of_divisions 2

		#if TRUE, creates a table with the temporal information
		#user can choose saving table as a .txt file or a .csv file
		comment III - TABLE
			boolean Create
			choice Format: 1
       			button txt
       			button csv
	endform
#end of form-------------------------------------------------------------------

#script continues if either a textGrid and a sound file or both are input
if textGrid_number > 0 or sound_number > 0
	#creates a folder in the same directory as the script
	#the new file divisions are stored in this new folder
		system_nocheck mkdir file_divisions

	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#if a sound file number is input, it gets its total duration and increments
	#increments: time divisions of the total file...
	#based on the number of divisions requested
	if sound_number > 0
		selectObject: sound_number
		ttl = Get total duration
		increment = ttl/number_of_divisions

	#gets the name of the sound file
		sound_name$ = selected$ ("Sound")

	#sets the file name
		file_name$ = sound_name$
	endif
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#if a textgrid file number is input, it gets its total duration and increments
	#increments: time divisions of the total file...
	#based on the number of divisions requested
	if textGrid_number > 0
		selectObject: textGrid_number
		ttl = Get total duration
		increment = ttl/number_of_divisions

	#gets the name of the TextGrid file
		textGrid_name$ = selected$ ("TextGrid")
	#sets the file name
		file_name$ = textGrid_name$
	endif
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#if TRUE, the script stores and saves the temporal information to a text file
	if create = 1
		#sets the name of the table
		if format = 1
			#txt file
			full_name_table$ = "file_divisions/" + file_name$ + ".txt"
		else
			#csv file
			full_name_table$ = "file_divisions/" + file_name$ + ".csv"
		endif
		
		#sets the header line for the table
		writeFileLine:   full_name_table$, "FileID" + tab$ + "Division" + tab$ + "Beginning" + tab$ + "End"
	endif
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		#temporal time at which the duration is cut
		cut_increment = 0
 
		#creates the divisions
		for i from 1 to number_of_divisions

			#stores the temporal information of divisions (beginning and end)
				#beginning
				time[i,1] = cut_increment
				#end
				time[i,2] = cut_increment + increment

			#if a sound file number has been input
			if sound_number > 0
				#sets the name of the sound file to be exported
					tmp_s$ = "file_divisions/" + sound_name$ + "_part_" + string$(i) + ".wav"
				#selects the sound file
					selectObject: sound_number
				#extract the part from the sound file
					Extract part... time[i,1] time[i,2] rectangular 1.0 0
				#saves the extract part as a WAV file
					Save as WAV file... 'tmp_s$'
				#removes the temporary sound section from the object window
					Remove
			endif
			#if a textGrid file number has been input
			if textGrid_number > 0
				#sets the name of the textGrid file to be exported
					tmp_tg$ = "file_divisions/" + textGrid_name$ + "_part_" + string$(i) + ".TextGrid"
				#selects the textGrid
					selectObject: textGrid_number
				#extract the part from the textGrid file
					Extract part... time[i,1] time[i,2] 0
				#saves the extract part as a textGrid file
					Save as text file... 'tmp_tg$'
				#removes the temporary textGrid section from the object window
					Remove
			endif

			#if the creation of the table is requested
			if create = 1
				appendFileLine:   full_name_table$, file_name$ + tab$ + string$(i) + tab$ + string$(time[i,1]) + tab$ + string$(time[i,2])
			endif

			#adds the time increment value for each division
			cut_increment = cut_increment + increment
		endfor
endif
