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
	mov r5, r1 ;val de k (argument)

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
	mul r4, r4, r6 ;on doit faire une multiplication 4.12 par 1.15 -> 5.27
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
	;on va se retrouver avec du 10.54 soit 64 bits !!!
	smull r1, r0, r1, r1 ;r1 least significant / r0 most significant OK
	smlal r1, r0, r2, r2
	;somme de r0, r1 avec r2, r3 (attention à la retenue !!)
	;adds r0, r0, r2
	;adc r1, r1, r3
	;on arrondit en 10.22 en troncant, seulement r0 sera lue

		
	
	pop {r4-r8, lr}
	bx lr


	endp
		
	END
		