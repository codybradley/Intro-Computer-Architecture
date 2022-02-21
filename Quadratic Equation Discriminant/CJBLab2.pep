;Bradley, Cody CS516 Section 11107 October 29, 2019
;Second Laboratory Assignment - Quadratic Equation Discriminant
         BR      main        
inputNum:SUBSP   2,i         ;making room for temp variable
         DECI    tempVar,s   ;takes in temp value
         LDWA    tempVar,s   ;puts temp value into accumulator
         ADDSP   2,i         
         RET                 ;returns with user's value in accumulator

checkNZ: LDWX    1,i         ;checkNZ will return with 1 in index if passed value is not zero
         LDWA    callerP,s   
         BRNE    notZero     ;if passed value is zero, execute the next 4 statements
         STRO    msgZErr1,d  
         DECO    callerP,s   
         STRO    msgZErr2,d  
         LDWX    0,i         ;checkNZ will return with 0 in index if passed value is zero
notZero: RET                 

multiply:LDWA    0,i         
         STWA    result,s    
         LDWX    mpier,s     
while1:  CPWX    0,i         
         BRLT    negate      ;negates multiplier and multiplicand if multiplier is negative
         BREQ    endwh1      ;exits while loop when index reaches zero
         LDWA    result,s    
         ADDA    mcand,s     ;adds multiplicand to result until index (multiplier) reaches zero
         BRV     oflow       
         STWA    result,s    
         SUBX    1,i         
         BR      while1      
endwh1:  RET                 ;position passres on stack has result of multiplication in it
negate:  NEGX                
         BRV     oflow       
         LDWA    mcand,s     
         NEGA                
         BRV     oflow       
         STWA    mcand,s     
         BR      while1      

oflow:   STRO    msgOFlow,d  
         STOP                

tempVar: .EQUATE 0           
callerP: .EQUATE 2           
stackTop:.EQUATE 0           
;in multiply fnc:
mpier:   .EQUATE 2           
mcand:   .EQUATE 4           
result:  .EQUATE 6           
;in main:
passmp:  .EQUATE 0           
passmc:  .EQUATE 2           
passres: .EQUATE 4           
msgTitle:.ASCII  "Pierce College CS516 Fall 2019 Lab Assignment 2 - Bradley, Cody\n\x00"
msgIn:   .ASCII  "Enter the value for \x00"
msgInA:  .ASCII  "a\n\x00"   
msgInB:  .ASCII  "b\n\x00"   
msgInC:  .ASCII  "c\n\x00"   
msgZErr1:.ASCII  "Value \x00"
msgZErr2:.ASCII  " is invalid -- re-enter\n\x00"
msgOFlow:.ASCII  "The calculation is too large for the Pep/9  and the result is not valid.\n\x00"
msgDsc:  .ASCII  "The discriminant is \x00"
msgNewL: .ASCII  "\n\x00"    
msgDscEQ:.ASCII  "The two roots are equal.\n\x00"
msgDscLT:.ASCII  "The polynomial has two complex conjugate roots.\n\x00"
msgDscGT:.ASCII  "The polynomial has two distinct real roots.\n\x00"
msgDone: .ASCII  "Program execution is complete.\n\x00"
intA:    .BLOCK  2           
intB:    .BLOCK  2           
intC:    .BLOCK  2           
bsqu:    .BLOCK  2           
fourac:  .BLOCK  2           

main:    STRO    msgTitle,d  
whileAZ: STRO    msgIn,d     ;do
         STRO    msgInA,d    
         CALL    inputNum    ;returns with user's value in accumulator
         STWA    intA,d      ;stores value returned by inputNum in intA
         SUBSP   2,i         ;push intA on stack
         STWA    stackTop,s  
         CALL    checkNZ     ;returns 0 in index if zero, 1 in index if not zero
         ADDSP   2,i         ;pops intA off stack
         CPWX    0,i         
         BREQ    whileAZ     ;while intA is zero
whileBZ: STRO    msgIn,d     ;do
         STRO    msgInB,d    
         CALL    inputNum    
         STWA    intB,d      
         SUBSP   2,i         
         STWA    stackTop,s  
         CALL    checkNZ     
         ADDSP   2,i         
         CPWX    0,i         
         BREQ    whileBZ     ;while intB is zero
whileCZ: STRO    msgIn,d     ;do
         STRO    msgInC,d    
         CALL    inputNum    
         STWA    intC,d      
         SUBSP   2,i         
         STWA    stackTop,s  
         CALL    checkNZ     
         ADDSP   2,i         
         CPWX    0,i         
         BREQ    whileCZ     ;while intC is zero
;all 3 values have been entered and are valid
         SUBSP   6,i         
         LDWA    intB,d      
         STWA    passmp,s    
         STWA    passmc,s    
         CALL    multiply    ;multiplying intB*intB
         LDWA    passres,s   
         STWA    bsqu,d      
;b^2 is done and in bsqu
         LDWA    4,i         
         STWA    passmp,s    
         LDWA    intA,d      
         STWA    passmc,s    
         CALL    multiply    ;multiplying 4*intA
         LDWA    passres,s   
         STWA    fourac,d    
;4*a is done and in fourac
         LDWA    fourac,d    
         STWA    passmp,s    
         LDWA    intC,d      
         STWA    passmc,s    
         CALL    multiply    ;multiplying (4*intA)*intC
         LDWA    passres,s   
         STWA    fourac,d    
         ADDSP   6,i         
;4*a*c is done and in fourac
         LDWA    bsqu,d      
         SUBA    fourac,d    
         BRV     oflow       
         STWA    bsqu,d      
;b^2-4ac (discriminant) is calculated and in bsqu
         STRO    msgDsc,d    
         DECO    bsqu,d      
         STRO    msgNewL,d   
         CPWA    0,i         
         BREQ    discEQ      ;if(disc==0)
         BRLT    discLT      ;else if(disc<0)
         STRO    msgDscGT,d  ;else
         BR      endif       
discEQ:  STRO    msgDscEQ,d  
         BR      endif       
discLT:  STRO    msgDscLT,d  
endif:   STRO    msgDone,d   
         STOP                
         .END                  