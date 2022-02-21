;Bradley, Cody CS516 Section 11107 12/10/2019
;Lab 5 - Bresenham's Algorithm

main:    STRO    msg1,d
         STRO    msg2,d
         CALL    inputInt    ;inputInt returns with valid user input in accumulator
         STWA    x1,d
         CALL    inputInt
         STWA    y1,d
         CALL    inputInt
         STWA    x2,d
         SUBA    x1,d        ;x2 - x1
         STWA    dx,d        ;dx = x2 - x1
         CALL    inputInt
         STWA    y2,d
         SUBA    y1,d        ;y2 - y1
         STWA    dy,d        ;dy = y2 - y1
;coordinates have been input, dx & dy have been calculated

         LDWA    x1,d
         CPWA    x2,d
         BRLE    noSwap1     ;branch to noSwap1 if x1<=x2; if x1>x2, need to swap starting and ending coords
         CALL    swap12
noSwap1: LDWA    dx,d
         CPWA    dy,d
         BRGT    noSwap2     ;branch to noSwap2 if dx>dy; if dx<dy, need to swap x and y components
         CALL    swapxy
noSwap2: LDWA    dy,d
         ASLA                ;2 * dy
         SUBA    dx,d        ;(2 * dy) - dx
         STWA    p,d         ;p = (2 * dy) - dx

while1:  LDWA    swapped,d
         BREQ    ifxy        ;not swapped, output x y
         STRO    newL,d      ;else (was swapped) output y x
         DECO    y1,d
         STRO    space,d
         DECO    x1,d
         BR      endifxy
ifxy:    STRO    newL,d
         DECO    x1,d
         STRO    space,d
         DECO    y1,d

endifxy: LDWA    p,d
         BRLT    ifpLT       ;if p<0, branch to ifpLT
         LDWA    x1,d        ;else continue
         ADDA    1,i
         STWA    x1,d        ;x1 = x1 + 1
         LDWA    y1,d
         ADDA    1,i
         STWA    y1,d        ;y1 = y1 + 1
         LDWA    dy,d
         SUBA    dx,d        ;(dy - dx)
         ASLA
         ADDA    p,d
         STWA    p,d         ;p = p + (2 * (dy - dx))
         BR      endifp      ;finished else{}, skip to after if(p<0){}
ifpLT:   LDWA    x1,d
         ADDA    1,i
         STWA    x1,d        ;x1 = x1 + 1
         LDWA    dy,d
         ASLA
         ADDA    p,d
         STWA    p,d         ;p = p + (2 * dy)
endifp:  LDWA    x1,d
         CPWA    x2,d
         BRLE    while1      ;continue looping through while1 as long as x1 <= x2
         STRO    newL,d
         STRO    EOF,d
         STOP                ;end of main

swap12:  LDWA    x1,d
         LDWX    x2,d
         STWA    x2,d
         STWX    x1,d
         LDWA    y1,d
         LDWX    y2,d
         STWA    y2,d
         STWX    y1,d
         LDWA    dx,d
         NEGA
         STWA    dx,d
         LDWX    dy,d
         NEGX
         STWX    dy,d
         RET
         

swapxy:  LDWA    x1,d        ;swaps x and y components
         LDWX    y1,d
         STWA    y1,d
         STWX    x1,d
         LDWA    x2,d
         LDWX    y2,d
         STWA    y2,d
         STWX    x2,d
         LDWA    dx,d
         LDWX    dy,d
         STWA    dy,d
         STWX    dx,d
         LDWA    1,i
         STWA    swapped,d
         RET
         
inputInt:DECI    tempInt,d
         LDWA    tempInt,d
         CPWA    minRange,i
         BRLT    outRange    ;input was less than min
         CPWA    maxRange,i
         BRGT    outRange    ;input was greater than max
         RET                 ;returns with valid user input in accumulator

outRange:STRO    msg3,d
         STOP

msg1:    .ASCII  "Pierce College CS516 Fall 2019 Lab Assignment 5 - Bradley, Cody\n\x00"
msg2:    .ASCII  "Enter two pairs of point coordinates in the range of 0-599.\n\x00"
msg3:    .ASCII  "Value out of range, ending.\n\x00" 
EOF:     .ASCII  "EOF\n\x00"
space:   .ASCII  " \x00"
newL:    .ASCII  "\n\x00"
minRange:.EQUATE 0
maxRange:.EQUATE 599         ;range is from 0 to 599
tempInt: .WORD   0
x1:      .WORD   0
y1:      .WORD   0
x2:      .WORD   0
y2:      .WORD   0
dx:      .WORD   0
dy:      .WORD   0
p:       .WORD   0
swapped: .WORD   0           ;bool to check if x and y were swapped
.END

;Converted from C++ at:
;http://mytechnotrick.blogspot.com/2015/07/c-program-to-implement-bresenhams-line.html
;only worked with dx>=dy, adjusted it to work for dx<dy as well