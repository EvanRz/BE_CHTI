	PRESERVE8
	THUMB  
	

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly

	include ./Driver/DriverJeuLaser.inc
	
	EXPORT FlagCligno
	EXPORT timer_callback

;Section RAM (read write):
	area    maram,data,readwrite
		
FlagCligno dcd 0


; ===============================================================================================
	


		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici

timer_callback proc 
	push {lr}
	mov r0,#1 ;argument à 1
	ldr r1,=FlagCligno
	ldr r2,[r1]
	cmp r2, #0
	beq EgalZero
	mov r3,#0
	str r3, [r1]
	bl GPIOB_Set
	pop {pc}
	;bx lr
EgalZero
	mov r3,#1
	str r3, [r1]
	bl GPIOB_Clear
	pop {pc}
	;bx lr
	
	endp
	END	