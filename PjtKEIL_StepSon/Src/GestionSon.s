	PRESERVE8
	THUMB   
		
; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
	
	EXPORT callbackSon
	EXPORT sortieSon
	EXPORT index
	
	EXTERN LongeurSon
	EXTERN PeriodeSonMicroSec
	EXTERN Son
	
sortieSon 	dcw 0
index 		dcd 0
	
MAX_ECH		equ 10124
SIZE_BYTE 	equ 2
SHIFT		equ 32768
COEF		equ 91
ZERO		equ 0

; ==============================================================================================

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		

callbackSon proc 
	push {lr}
	
	ldr    	r0,=sortieSon		;r0	= &sortieSon
	ldr		r1,=Son				;r1 = &Son 
	ldr    	r2,=index			;r2 = &index
	ldr    	r3, [r2]			;r3 = index
	
	push 	{r0}				;push de r0 dans la pile
	ldr 	r0,=COEF			;r0 = COEF
	
	ldrsh  	r12,[r1, r3]		;r4 = son[index]
	add 	r12,#SHIFT			;r12 += SHIFT
	udiv 	r12,r0				;r12 /= COEF
	
	pop 	{r0}				;pop r0
	strh   	r12,[r0]			;sortieSon = son[index]
	
	ldr    	r12,=MAX_ECH		;r12 = MAX_ECH
	
	cmp    	r3,r12				
	ite     lt					;si r3 < r3
	addlt  	r3,#SIZE_BYTE		;r3 += 2
	ldrgt   r3,=ZERO
	str    	r3,[r2]				;index = r3
	
	mov    r12,#0
	
 	pop  {pc}
	
	endp
	END	