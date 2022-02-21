;Bradley, Cody CS516 Section 11107 11/12/19
;Third Laboratory Assignment - Zip Codes
Main:    STRO    msg1,d 
         DECI    lo,d
         LDWA    lo,d
         CPWA    -999,i ;enter -999 after state name to finish inputting entries
         BRLE    inDone
         DECI    hi,d
         LDBA    charIn,d
         STBA    ST1,d
         LDBA    charIn,d
         STBA    ST2,d
         LDWX    arrIndex,d
         LDWA    lo,d
         STWA    MyArray,x
         ADDX    2,i
         LDWA    hi,d
         STWA    MyArray,x
         ADDX    2,i
         LDWA    ST1,d
         STWA    MyArray,x
         ADDX    2,i
         STWX    arrIndex,d ;lo, hi, and state code have been read in
         LDBA    charIn,d ;getting rid of space between state code and state name
stn:     LDBA    charIn,d ;state name should be 19 characters or shorter
         CPBA    newLine,i
         BREQ    stnDone
         STBA    MyArray,x
         ADDX    1,i
         LDBA    charIn,d
         CPBA    newLine,i
         BREQ    stnDone
         STBA    MyArray,x
         ADDX    1,i
         BR      stn
stnDone: STBA    MyArray,x ;x0A byte at end of every state name (new line)
         LDWX    arrIndex,d
         ADDX    20,i
         STWX    arrIndex,d
         LDWX    limit,d
         SUBX    1,i
         STWX    limit,d
         BRGT    Main
         STRO    msg2,d ;outputs message if limit reaches 0 (70 entries entered)
         STRO    msgNewL,d
inDone:  LDWX    arrIndex,d ;all entries have been input
         STWX    maxIndex,d ;maxIndex contains the index one past the end of the array
         LDWA    70,i
         SUBA    limit,d
         STWA    limit,d ;limit now contains total number of entries
         DECO    limit,d
         STRO    msg3,d

choose:  STRO    msg4,d ;loops back here when choice is not 3 (end)
         DECI    choice,d
         LDWA    choice,d
         CPWA    1,i
         BREQ    findCode ;branch to search by state code
         CPWA    2,i
         BREQ    findZip ;branch to search by zip code
         CPWA    3,i
         BREQ    endProg ;branch to end program
         STRO    msg5,d ;choice is not 1, 2, or 3
         BR      choose

findCode:STRO    msg10,d
         LDBA    charIn,d
         STBA    ST1,d
         LDBA    charIn,d
         STBA    ST2,d
         LDWX    0,i ;resets search index to zero
         LDWA    0,i
         STWA    found,d ;resets 'bool' found to false
loopCode:LDWA    ST1,d ;both characters of state code are in accumulator
         ADDX    4,i ;index of next state code in array
         CPWA    MyArray,x
         BRNE    noMatch1 ;skips to notMatch if state code does not match current entry
         STRO    msg6_1,d
         LDBA    ST1,d
         STBA    charOut,d ;outputs first char of state code
         LDBA    ST2,d
         STBA    charOut,d ;outputs second char of state code
         STRO    msg6_2,d
         SUBX    4,i
         DECO    MyArray,x ;outputs lo zip
         STRO    msg6_3,d
         ADDX    2,i
         DECO    MyArray,x ;outputs hi zip
         STRO    msgNewL,d
         ADDX    2,i
         LDWA    1,i
         STWA    found,d ;sets found to true
noMatch1:ADDX    22,i ;index of beginning of next entry
         CPWX    maxIndex,d
         BRNE    loopCode ;continue searching until max index reached
         LDWA    found,d
         BRNE    noState ;if found is zero, skip to noState
         STRO    msg7_1,d
         LDBA    ST1,d
         STBA    charOut,d
         LDBA    ST2,d
         STBA    charOut,d
         STRO    msg7_2,d
noState: BR      choose

findZip: STRO    msg11,d
         DECI    zip,d
         LDWX    0,i
         STWX    arrIndex,d ;resets search index to zero
         LDWA    0,i
         STWA    found,d ;resets 'bool' found to false
loopZip: LDWA    zip,d
         CPWA    MyArray,x ;compares user zip to lo in array
         BRLT    noMatch2 ;skips to noMatch2 if user zip is less than lo
         ADDX    2,i
         CPWA    MyArray,x ;compares user zip to hi in array
         BRGT    noMatch2 ;skips to noMatch2 if user zip is greater than hi
         STRO    msg8_1,d
         DECO    zip,d
         STRO    msg8_2,d
         ADDX    2,i
         LDBA    MyArray,x
         STBA    charOut,d ;outputs first char of state code
         ADDX    1,i
         LDBA    MyArray,x
         STBA    charOut,d ;outputs second char of state code
         STRO    msgNewL,d
         LDWA    1,i
         STWA    found,d ;sets found to true
noMatch2:LDWX    arrIndex,d
         ADDX    26,i ;increment arrIndex by size of one entry
         STWX    arrIndex,d
         CPWX    maxIndex,d
         BRNE    loopZip
         LDWA    found,d
         BRNE    noZip
         STRO    msg9_1,d
         DECO    zip,d
         STRO    msg9_2,d
noZip:   BR      choose
endProg: STRO    msg12,d
         STOP

newLine: .EQUATE 0x0A ;\n
msg1:    .ASCII "Enter low zip, high zip, state code, state name. Enter -999 to finish\n\x00"
msg2:    .ASCII "Maximum number of entries reached - maximum is \x00"
msg3:    .ASCII " Zip Code records read\n\x00"
msg4:    .ASCII "Enter 1 to get the Zip code range for a state, 2 to get the state name for a Zip code, or 3 to end\n\x00"
msg5:    .ASCII "Response must be 1, 2, or 3 - please try again\n\x00"
msg6_1:  .ASCII "Zip code range for state \x00"
msg6_2:  .ASCII " is \x00"
msg6_3:  .ASCII " through \x00"
msg7_1:  .ASCII "State code \x00"
msg7_2:  .ASCII " was not found in the table\n\x00"
msg8_1:  .ASCII "Zip code \x00"
msg8_2:  .ASCII " is in state \x00"
msg9_1:  .ASCII "Zip code \x00"
msg9_2:  .ASCII " was not found in any state\n\x00"
msg10:   .ASCII "Enter a two-character state code\n\x00"
msg11:   .ASCII "Enter a zip code\n\x00"
msg12:   .ASCII "Exiting program\n\x00"
msgNewL: .ASCII "\n\x00"

lo:      .WORD 0
hi:      .WORD 0
ST1:     .BYTE 0
ST2:     .BYTE 0
limit:   .WORD 70
arrIndex:.WORD 0
maxIndex:.WORD 0
choice:  .WORD 0
found:   .WORD 0
zip:     .WORD 0
MyArray: .BLOCK 1820 ;limit*(2 byte lo, 2 byte hi, 2 byte state code, 20 byte state name)

         .END

9000 9999 AE ArmedForcesAtlantic
6000 6389 CT Connecticut
6391 6999 CT Connecticut
19700 19999 DE Delaware
20000 20099 DC DistrictofColumbia
20200 20599 DC DistrictofColumbia
32000 32767 FL Florida
30000 31999 GA Georgia
3900 4999 ME Maine
20600 21999 MD Maryland
1000 2799 MA Massachusetts
3000 3899 NH NewHampshire
7000 8999 NJ NewJersey
10000 14999 NY NewYork
6390 6390 NY NewYork
501 501 NY NewYork
544 544 NY NewYork
27000 28999 NC NorthCarolina
15000 19699 PA Pennsylvania
600 999 PR PuertoRico
2800 2999 RI RhodeIsland
29000 29999 SC SouthCarolina
5000 5999 VT Vermont
20100 20199 VA Virginia
22000 24699 VA Virginia
24700 26999 WV WestVirginia
-999

30000 31999 GA Georgia
3900 4999 ME Maine
20600 21999 MD Maryland
1000 2799 MA Massachusetts
3000 3899 NH NewHampshire
-999
