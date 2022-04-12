	PRESERVE8
	THUMB   
		

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		

	
; ===============================================================================================
	


		
	area    moncode,code,readonly
	
	EXPORT DFT_ModuleAuCarre
	
MAX 		equ	64
MOD			equ 63

;------------------------------------------------------

DFT_ModuleAuCarre proc
	push 	{lr}			
	push	{r4}
	push	{r5}
	push	{r6}
	push	{r7}
	push 	{r8}
	push	{r9}
	push	{r10}
	
	mov 	r4 ,#0					;n    	  = 0
	mov		r7 ,#0					;X(k) rel = 0
	mov 	r10,#0					;X(k) img = 0
	mov 	r5,r0					;r5   	  = &LeSignal 	
	mov		r6,r1					;r6	      = k
	
for_loop							;for(n = 0; n < MAX; n++)
								;start
	
	mov 	r0,r4					;n
	mov		r1,r6					;k
	bl		get_COS					;function get_COS
	mov		r8,r0					;r2 = TabCos[p]
	
	mov 	r0,r4
	mov 	r1,r6
	bl 		get_SIN
	mov 	r9,r0
	
	mov		r0,r5					;&LeSignal
	mov 	r1,r4					;n
	bl		get_LeSignal			;function get_LeSignal
	
	mla		r7 ,r8,r0,r7			;r7	 += x[n] * TabCos[p]
	mla		r10,r9,r0,r10			;r10 += x[n] * TabSin[p]
	
	add		r4,#1
	cmp		r4,#MAX
	blt		for_loop
								;end
	
	smull	r0,r7,r7,r7				;r7  = (x[n] * TabCos[p])^2
	smull	r2,r10,r10,r10			;r10 = (x[n] * TabCos[p])^2
	
	add 	r7,r7,r10				;r7  = (x[n] * TabCos[p])^2 + (x[n] * TabCos[p])^2
	
	mov		r0,r7
	
	pop		{r10}
	pop		{r9}
	pop		{r8}
	pop		{r7}
	pop		{r6}
	pop		{r5}
	pop		{r4}
	pop 	{pc}							

;------------------------------------------------------

get_SIN	proc
	ldr		r2,=TabSin				;r2 = &TabSin
	mul		r3,r0,r1				;r3 = n*k
	and		r3,r3,#MOD				;r3 = r3 % 64		
	ldrsh	r0,[r2, r3, lsl #1]		;r0 = TabSin[n*p]		
	
	bx 		lr		

get_COS proc						;(n, k) --> TabCos[p]						
	ldr		r2,=TabCos				;r2 = &TabCos
	mul		r3,r0,r1				;r3 = n*k
	and		r3,r3,#MOD				;r3 = r3 % 64		
	ldrsh	r0,[r2, r3, lsl #1]		;r0 = TabCos[n*p]		
	
	bx 		lr

get_LeSignal proc					;(&LeSignal, n) --> LeSignal[n]	
	ldrsh	r0,[r0, r1, lsl #1]
	
	bx 		lr

endp
	
;------------------------------------------------------

	AREA Trigo, DATA, READONLY

;------------------------------------------------------

TabCos
	DCW	32767	;  0 0x7fff  0.99997
	DCW	32610	;  1 0x7f62  0.99518
	DCW	32138	;  2 0x7d8a  0.98077
	DCW	31357	;  3 0x7a7d  0.95694
	DCW	30274	;  4 0x7642  0.92389
	DCW	28899	;  5 0x70e3  0.88193
	DCW	27246	;  6 0x6a6e  0.83148
	DCW	25330	;  7 0x62f2  0.77301
	DCW	23170	;  8 0x5a82  0.70709
	DCW	20788	;  9 0x5134  0.63440
	DCW	18205	; 10 0x471d  0.55557
	DCW	15447	; 11 0x3c57  0.47141
	DCW	12540	; 12 0x30fc  0.38269
	DCW	 9512	; 13 0x2528  0.29028
	DCW	 6393	; 14 0x18f9  0.19510
	DCW	 3212	; 15 0x0c8c  0.09802
	DCW	    0	; 16 0x0000  0.00000
	DCW	-3212	; 17 0xf374 -0.09802
	DCW	-6393	; 18 0xe707 -0.19510
	DCW	-9512	; 19 0xdad8 -0.29028
	DCW	-12540	; 20 0xcf04 -0.38269
	DCW	-15447	; 21 0xc3a9 -0.47141
	DCW	-18205	; 22 0xb8e3 -0.55557
	DCW	-20788	; 23 0xaecc -0.63440
	DCW	-23170	; 24 0xa57e -0.70709
	DCW	-25330	; 25 0x9d0e -0.77301
	DCW	-27246	; 26 0x9592 -0.83148
	DCW	-28899	; 27 0x8f1d -0.88193
	DCW	-30274	; 28 0x89be -0.92389
	DCW	-31357	; 29 0x8583 -0.95694
	DCW	-32138	; 30 0x8276 -0.98077
	DCW	-32610	; 31 0x809e -0.99518
	DCW	-32768	; 32 0x8000 -1.00000
	DCW	-32610	; 33 0x809e -0.99518
	DCW	-32138	; 34 0x8276 -0.98077
	DCW	-31357	; 35 0x8583 -0.95694
	DCW	-30274	; 36 0x89be -0.92389
	DCW	-28899	; 37 0x8f1d -0.88193
	DCW	-27246	; 38 0x9592 -0.83148
	DCW	-25330	; 39 0x9d0e -0.77301
	DCW	-23170	; 40 0xa57e -0.70709
	DCW	-20788	; 41 0xaecc -0.63440
	DCW	-18205	; 42 0xb8e3 -0.55557
	DCW	-15447	; 43 0xc3a9 -0.47141
	DCW	-12540	; 44 0xcf04 -0.38269
	DCW	-9512	; 45 0xdad8 -0.29028
	DCW	-6393	; 46 0xe707 -0.19510
	DCW	-3212	; 47 0xf374 -0.09802
	DCW	    0	; 48 0x0000  0.00000
	DCW	 3212	; 49 0x0c8c  0.09802
	DCW	 6393	; 50 0x18f9  0.19510
	DCW	 9512	; 51 0x2528  0.29028
	DCW	12540	; 52 0x30fc  0.38269
	DCW	15447	; 53 0x3c57  0.47141
	DCW	18205	; 54 0x471d  0.55557
	DCW	20788	; 55 0x5134  0.63440
	DCW	23170	; 56 0x5a82  0.70709
	DCW	25330	; 57 0x62f2  0.77301
	DCW	27246	; 58 0x6a6e  0.83148
	DCW	28899	; 59 0x70e3  0.88193
	DCW	30274	; 60 0x7642  0.92389
	DCW	31357	; 61 0x7a7d  0.95694
	DCW	32138	; 62 0x7d8a  0.98077
	DCW	32610	; 63 0x7f62  0.99518
TabSin 
	DCW	    0	;  0 0x0000  0.00000
	DCW	 3212	;  1 0x0c8c  0.09802
	DCW	 6393	;  2 0x18f9  0.19510
	DCW	 9512	;  3 0x2528  0.29028
	DCW	12540	;  4 0x30fc  0.38269
	DCW	15447	;  5 0x3c57  0.47141
	DCW	18205	;  6 0x471d  0.55557
	DCW	20788	;  7 0x5134  0.63440
	DCW	23170	;  8 0x5a82  0.70709
	DCW	25330	;  9 0x62f2  0.77301
	DCW	27246	; 10 0x6a6e  0.83148
	DCW	28899	; 11 0x70e3  0.88193
	DCW	30274	; 12 0x7642  0.92389
	DCW	31357	; 13 0x7a7d  0.95694
	DCW	32138	; 14 0x7d8a  0.98077
	DCW	32610	; 15 0x7f62  0.99518
	DCW	32767	; 16 0x7fff  0.99997
	DCW	32610	; 17 0x7f62  0.99518
	DCW	32138	; 18 0x7d8a  0.98077
	DCW	31357	; 19 0x7a7d  0.95694
	DCW	30274	; 20 0x7642  0.92389
	DCW	28899	; 21 0x70e3  0.88193
	DCW	27246	; 22 0x6a6e  0.83148
	DCW	25330	; 23 0x62f2  0.77301
	DCW	23170	; 24 0x5a82  0.70709
	DCW	20788	; 25 0x5134  0.63440
	DCW	18205	; 26 0x471d  0.55557
	DCW	15447	; 27 0x3c57  0.47141
	DCW	12540	; 28 0x30fc  0.38269
	DCW	 9512	; 29 0x2528  0.29028
	DCW	 6393	; 30 0x18f9  0.19510
	DCW	 3212	; 31 0x0c8c  0.09802
	DCW	    0	; 32 0x0000  0.00000
	DCW	-3212	; 33 0xf374 -0.09802
	DCW	-6393	; 34 0xe707 -0.19510
	DCW	-9512	; 35 0xdad8 -0.29028
	DCW	-12540	; 36 0xcf04 -0.38269
	DCW	-15447	; 37 0xc3a9 -0.47141
	DCW	-18205	; 38 0xb8e3 -0.55557
	DCW	-20788	; 39 0xaecc -0.63440
	DCW	-23170	; 40 0xa57e -0.70709
	DCW	-25330	; 41 0x9d0e -0.77301
	DCW	-27246	; 42 0x9592 -0.83148
	DCW	-28899	; 43 0x8f1d -0.88193
	DCW	-30274	; 44 0x89be -0.92389
	DCW	-31357	; 45 0x8583 -0.95694
	DCW	-32138	; 46 0x8276 -0.98077
	DCW	-32610	; 47 0x809e -0.99518
	DCW	-32768	; 48 0x8000 -1.00000
	DCW	-32610	; 49 0x809e -0.99518
	DCW	-32138	; 50 0x8276 -0.98077
	DCW	-31357	; 51 0x8583 -0.95694
	DCW	-30274	; 52 0x89be -0.92389
	DCW	-28899	; 53 0x8f1d -0.88193
	DCW	-27246	; 54 0x9592 -0.83148
	DCW	-25330	; 55 0x9d0e -0.77301
	DCW	-23170	; 56 0xa57e -0.70709
	DCW	-20788	; 57 0xaecc -0.63440
	DCW	-18205	; 58 0xb8e3 -0.55557
	DCW	-15447	; 59 0xc3a9 -0.47141
	DCW	-12540	; 60 0xcf04 -0.38269
	DCW	-9512	; 61 0xdad8 -0.29028
	DCW	-6393	; 62 0xe707 -0.19510
	DCW	-3212	; 63 0xf374 -0.09802


		
		
	END	