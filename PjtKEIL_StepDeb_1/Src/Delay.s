	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
VarTime	dcd 0

	
; ===============================================================================================
	
;constantes (équivalent du #define en C)
TimeValue 	equ 900000


	EXPORT Delay_100ms ; la fonction Delay_100ms est rendue publique donc utilisable par d'autres modules.
	EXPORT VarTime ; On rend global pour pourvoir observer
		
;Section ROM code (read only) :		
	area    moncode,code,readonly
		


; REMARQUE IMPORTANTE 
; Cette manière de créer une temporisation n'est clairement pas la bonne manière de procéder :
; - elle est peu précise
; - la fonction prend tout le temps CPU pour... ne rien faire...
;
; Pour autant, la fonction montre :
; - les boucles en ASM
; - l'accés écr/lec de variable en RAM
; - le mécanisme d'appel / retour sous programme
;
; et donc possède un intérêt pour débuter en ASM pur

Delay_100ms proc
	
	    ldr r0,=VarTime ;r0 = VarTime #adresse  
						  
		ldr r1,=TimeValue ;r1 = TimeValue #valeur	
		str r1,[r0] ;Mets la valeur de R1 dans l'adresse pointé par R0
		
BoucleTempo
		ldr r1,[r0] ;Charge la valeur pointé par R0 dans R1				
						
		subs r1,#1 ; r1 = r1 - 1
		str  r1,[r0] ; r0 = r1
		bne	 BoucleTempo ; si r1 - 1 = 0 on continue et sinon on revient à BoucleTempo
			
		bx lr ; remets l'adresse du compteur programme (PC) à la suite du programme principal
		endp
		
		
	END	