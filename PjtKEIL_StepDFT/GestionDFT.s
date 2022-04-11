	PRESERVE8
	THUMB
	IMPORT TabCos
	IMPORT TabSin
	IMPORT LeSignal
		
	EXPORT DFT_ModuleAuCarre
	
; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite

	
; ===============================================================================================
	
;Section ROM code (read only) :		
	area    moncode,code,readonly

	

DFT_ModuleAuCarre proc
	push {r4-r8, lr}

	ldr r7,=TabCos
	ldr r8,=TabSin
	
	;int Xim;
	mov r5, r1 ;val de k

	mov r1, #0
	;int Xre;
	mov r2, #0
	
	mov r3, #0 ;var de boucle
boucle
	;for (int n = 0; n<64; n++)
	;{
	;	Xre += x[n]*tabCos[k*n%64]; 
	ldrsh r4, [r0, r3, lsl#1] ;r4 <- x[n] 
	mul r6, r5, r3
	and r6, r6, #63   ;k*n%64
	ldrsh r6, [r7, r6, lsl#1] ;r6 <-tabCos[r6]
	mul r4, r4, r6
	add r1, r4, r1
	
	;	Xim += x[n]*tabSin[k*n%64];	
	ldrsh r4, [r0, r3, lsl#1]
	mul r6, r5, r3
	and r6, r6, #63   ;k*n%64
	ldrsh r6, [r8, r6, lsl#1] ;r6 <-tabSin[r6]
	mul r4, r4, r6
	add r2, r4, r2
	
	

	add r3, r3, #1 ;n++
	cmp r3, #64
	bne boucle
	;}
	
	;return Xre**2 + Xim**2
	mul r1, r1, r1
	mul r2, r2, r2 
	add r0, r1, r2
		
	
	pop {r4-r8, lr}
	bx lr


	endp
		
	END
