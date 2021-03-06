COMMENT *

������������ � 3
�������� �����. ����� ������� �� ����. ����� ������� ���� ��� ��������� ��������. 
����� ������ ������ � ����� ���������� ����� ����� ���� �������. � ����� ������ � �����                
���������� � ���������� ����������:
� ���� ������ � ���������� ����� �������;
� ����� ���������� ������ � ������ �� �����;
� ������� ������ �������� ���������� � �����������, ��������� ���������� ����� ����;
� ������������ ��������� ������� � ��������� ����������.

������� 6
���� �����������. 
���������� ���������� ����, ���������� ���� �� ���� ����� �� ����, �������� ������.                              
                
����������� �����, 9 ��.

*

ORG 100H

.CODE
         
start:    
    ; ����� ��������� � �������� ������ ������
    MOV     AH, 09H
    LEA     DX, enterTextMessage
    INT     21H                                        
    
    ; ���� ������ � �����
    MOV     AH, 0AH             
    LEA     DX, stringWithText      
    INT     21H                                          
    
    ; ����� �����, ����� ��������� ������ ����� ��������� � [DX + 1], ���� ������ ����� ���������� � [DX + 2]               
    MOV     SI, DX
    MOV     BL, [SI + 1] 
    MOV     textLength, BL         
                     
    ; SI + BX + 2 - ����� ������� �������� �������, �� ������� ���������� ����
    ; �������� ��� �� ������ ��� ������ ����� ���������� 21H                 
    ADD     SI, BX
    MOV     [SI + 2], 24H       
                  
readSymbols:     
    CALL    NewLine         
         
    ; ����� ��������� � �������� ������ �������     
    MOV     AH, 09H
    LEA     DX, enterSymbolsMessage
    INT     21H                                                                         
               
    ; ����� ����� ������ � ��������� � SI
    LEA     SI, stringWithSymbols       
    
    ; ����� ���-�� �������� �������� � CX
    MOV     CX, numOfSymbols
    
readSymbol:           
    ; ���������� ��������� �������               
    CALL    ReadChar
    MOV     [SI], AL                                          
    
    ; ��������� � ���������� �������
    INC     SI
    
    ; ��������� ���� �� ����� CX ��������    
    LOOP    readSymbol
    
printString:  
    CALL    NewLine
     
    ; ����� ��������� � ��������� ������
    MOV     AH, 09H
    LEA     DX, enteredStringMessage
    INT     21H           
               
    ; ����� ��������� ������
    LEA     DX, stringWithText + 2              
    INT     21H                                                       
                            
printSymbols:               
    CALL    NewLine
    
    ; ����� ��������� � ��������� ��������
    MOV     AH, 09H
    LEA     DX, enteredSymbolsMessage
    INT     21H           
    
    ; ����� �������� ��������
    LEA     DX, stringWithSymbols
    INT     21H                                      
                                
callMainProcedure: 
    ; �������� ���������� � ��������� ����� ����  
              
    MOV     BX, numOfSymbols
    PUSH    BX          
              
    LEA     BX, stringWithSymbols
    PUSH    BX   
    
    LEA     BX, stringWithText     
    PUSH    BX                              
               
    CALL    MainProc 
    
    ; ����� �� ���������
    MOV     AX, 4C00H	
    INT     21H                                     
                  
                  
                                                                                                                    
MainProc PROC
    ; ��������� BP � ����, ����� ����� ��� ����� �������� ��������� ��������� �� ����� 
    PUSH    BP 
    MOV     BP, SP 
    
    ; ��������� � ���� �������� ���� ���������, ������� ����� ������������ � ���������        
    
    PUSH    AX        
    PUSH    BX
    PUSH    CX 
    PUSH    DX
            
    PUSH    SI
    PUSH    DI        
            
    MOV     DI, [BP + 4]        ; DI - ����� ������-������
    MOV     SI, [BP + 6]        ; SI - ����� ��������
    MOV     DX, [BP + 8]        ; DX - ���-�� ��������
    
    XOR     CX, CX
    MOV     CL, [DI + 1]        ; CX - ���-�� �������� � ������, ������� �� ��� �� �������� � 2-�� ���������            
    ADD     DI, 2               ; ������ DI - ����� ������� �������� ��������� ������
    
    MOV     BX, 0               ; BX - ���-�� ����, ���������� �� ������� ���� ���� �� ���� ��������        
            
    ; ���� ������� ������ �����, �� ��������� � ������ ������
    CMP     CX, 1
    JE      printAnswer
                   
compareSymbols:   
    ; �������� ��������� ������ ������ � AL ��� ��������� � 2-�� ��������� 
    MOV     AL, [DI]
    
    ; ���� ������ �������� ��������, ��������� � �������� ��������
    CMP     AL, 20H
    JE      skipWhiteSpaces
    
    ; �������� � ���� CX (���-�� �������� � ������, ������� �� ��� �� �������� � 2-�� ���������,) � DI (����� �������� ��������������� ������� ������), ...           
    PUSH    CX
    PUSH    DI
    
    ; ... � �� �� ����� �������� 2 (���-�� ��������, � �������� ����� �������� ������ ������) � SI (����� ���� 2-� ��������)
    MOV     CX, DX
    MOV     DI, SI
    
    ; �������� �� 2-� �������� � ��������� CX, ���� �� ������ ����������� ������� ��� ���� CX �� ������ 0
    REPNE   SCASB    
    JE      foundWordWithSymbol
    
    ; ���� �� �����, �� ���������� ������� �������� � DI � CX
    POP     DI
    POP     CX
    
    ; ��������� � ���������� ������� � ������
    INC     DI    
    
    ; ��������� ���-�� �������� � ������, ������� �� ��� �� �������� � 2-�� ���������, �, ���� ��� �� ����� 0, ��������� � ��������� ��������
    LOOP    compareSymbols
    JNE     printAnswer 
    
foundWordWithSymbol: 
    ; ����������� ������� ����, ��������������� ������� ������
    INC     BX
    
    ; ���������� ������� �������� � DI � CX
    POP     DI
    POP     CX
    
    ; ������� ���������� ����� ����� �� ������� �������
    MOV     AL, 20H        
    REPNE   SCASB
                   
skipWhiteSpaces:                                 
    ; ������� ���� �������� �� ���������� ����� ��� �����
    REPE    SCASB     
    
    ; ���� ����� �� ����� ������, �� ��������� � ������ ����������
    CMP     CX, 0
    JE      printAnswer      
    
    ; ����� ������������ �� ������ ����� � ����������� ���-�� �������� � ������, ������� �� ��� �� �������� � 2-�� ���������      
    DEC     DI    
    INC     CX
    
    ; ��������� � ��������� ��������
    JMP     compareSymbols         
        
printAnswer:
    CALL    NewLine
                  
    ; ����� ��������� � ����������
    MOV     AH, 09H
    LEA     DX, answerMessage
    INT     21H              
                  
    ; ����� ����������
    MOV     AX, BX   
    CALL    WriteInteger 
    
    ; ��������������� �������� �������������� ���������
    
    POP     DI
    POP     SI
    
    POP     DX
    POP     CX
    POP     BX
    POP     AX     
    
    POP     BP
    
    RET                           
MainProc ENDP
               
                              
                            
; ��������� ������ ����������� �����, ����������� � AX
WriteInteger PROC 
    ; C�������� ���������� ��������� AX, BX, CX � DX, ������� ������������ � ���� ���������, � ����  
    PUSH    AX                                          
    PUSH    BX  
    PUSH    CX  
    PUSH    DX  
    
    XOR     CX, CX                                      ; �������� �������� CX
    MOV     BX, 10                                      ; �������� ����� 10 � BX ��� �������������� ������� 
        
    TEST    AX, AX                                      ; ������, ������������� �� �����, ��������� ��������� �   
    JS      printMinusAndMakeUnsigned                   ; ���� ������������� - ������� ����� ��� ����� � ������ ���� �����
    JMP     pushDigitsOfNumberToStackAndGetItsOrder     ; ����� ����� ��������� � ��������� ���� ����� � ����� � ��� �������

printMinusAndMakeUnsigned:
    PUSH    AX          ; C�������� ���������� �������� AX 
    
    MOV     DL, '-'     ; �������� ����� � ������� DL 
    MOV     AH, 02H     ; �������� ����� ��������� ������� DOS 02H (����� ������� �� �������) � ������� AH 
    INT     21h         ; �������� �������
    
    POP     AX          ; �������������� �������� � �������� AX, ������� ���� � ��� �� ������ ������
    NEG     AX          ; ������� ����� � �����

; �������� ���������� �����, �� ������� ������� ����� (������� ������ �������� � AX), � ��������� �� � ����
; � CX ����� ������� ������� ����� (��� 0..9 ������� 1, 10..99 2, ...)
pushDigitsOfNumberToStackAndGetItsOrder:  
    XOR     DX, DX                                      ; �������� �������� � �������� DX   
    IDIV    BX                                          ; ������������ ����� ����� � AX �� 10 (� BX). 
                                                        ;       ����� ����� ����� �������� � AX,
                                                        ;       �������, ������� ��� ����� �������� � ����, ����� ������� � DX
                              
    PUSH    DX                                          ; ��������� ��������� ����� ����� � ����
    INC     CX                                          ; ����������� ������� ����� �� �������
    CMP     AX, 0                                       ; ������, ���� �� ��� � ����� �����, �� ����������� � ����, ����� ��������� ��� � �����
    JG      pushDigitsOfNumberToStackAndGetItsOrder     ; ���� ����� ������ ����, ������ ��������� ��������

; �������� �����, �������� ����� �� �����, ����������� �� � ASCII ������� � ������ � �������  
printInteger:  
    POP     AX              ; ������ ��������� ����� �� �����
    ADD     AL, '0'         ; ������������ � � ASCII ������, �������� '0'
  
    CALL    WriteChar       ; �������� ��������� ������ ������ �������
    LOOP    printInteger    ; ��������� �������� � ����� �� ���� �������, 
                            ;       ���� �� ����������� ��� ����� ����� (�.�. ���� ����� � CX �� ������ ����� 0),   
                            
    ; �������������� �������� � ��������� AX, BX, CX � DX, ������� ���� � ��� �� ������ �����                            
    POP     DX              
    POP     CX  
    POP     BX  
    POP     AX 
    RET                     ; ������������ �� ���������
WriteInteger ENDP
                        
; ��������� ������ ������ �������, ����������� � AL                
WriteChar PROC          
    ; C�������� ���������� ��������� AX � DX, ������� ������������ � ���� ���������, � ����
    PUSH    AX          
    PUSH    DX  
    
    MOV     DL, AL      ; �������� ������, ������� ����� �������, � ������� DL
    MOV     AH, 02H     ; �������� ����� ��������� ������� DOS 02H (����� ������� �� �������) � ������� AH 
    INT     21h         ; �������� �������
                        
    ; �������������� �������� � ��������� AX � DX, ������� ���� � ��� �� ������ �������                        
    POP     DX          
    POP     AX  
    
    RET                 ; ������������ �� ���������
WriteChar ENDP                        
                        
; ��������� ����� �������, ����� ��������� ��������� ������ ����� ������� � ������� AL 
ReadChar PROC  
    MOV     AH, 01H     ; �������� ����� ��������� ������� DOS 01H (���� � ����������) � AH  
    INT     21H         ; �������� �������
    
    RET                 ; ������������ �� ���������
ReadChar ENDP    

; ������� �� ����� ������ 
NewLine PROC  
    PUSH    AX
    PUSH    DX
    
    MOV     AH, 09H         ; �������� ����� ��������� ������� DOS 09H (������ ������ � �������) � AH
    LEA     DX, CRLF        ; �������� ������ � ��������� ������ � DX
    INT     21H             ; �������� �������
              
    POP     DX
    POP     AX
              
    RET 
NewLine ENDP          

.DATA 
    stringWithText                  DB 254, 254 DUP(?)
    stringWithSymbols               DB 2 DUP(?), '$' 
    
    numOfSymbols                    DW 2
    textLength                      DB ?
    
    enterTextMessage                DB '������� ������', 0DH, 0AH, 2DH, 2DH, 3EH, 20H, '$'
    enterSymbolsMessage             DB '������� �������', 0DH, 0AH, 2DH, 2DH, 3EH, 20H, '$'      
    
    enteredStringMessage            DB '�������� ������: $'
    enteredSymbolsMessage           DB '�������� �������: $'
    
    answerMessage                   DB '���������� ����, ���������� ���� �� ���� ������ �� ����: $' 
    
    CRLF                            DB 0DH, 0AH, '$'    ; ������� ������