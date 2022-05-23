	PRESERVE8
	THUMB   
	INCLUDE DriverJeuLaser.inc
	
	IMPORT LongueurSon
	IMPORT Son
	EXPORT CallbackSon
	EXPORT StartSon



; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
	
SortieSon dcd 0
	EXPORT SortieSon
Index dcd 5513
	
; ===============================================================================================
	
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		
		;	if(i<LongueurSon){
		;		SortieSon = (Son[i]+32768)/92
		;		i++
		; 	}

;void timer_callback(void){
CallbackSon proc
		push {r4-r8, lr}
		; r0 : adresse de SortieSon
		ldr r0,=SortieSon
		; r1 : adresse de index
		ldr r1,=Index		
		; r2 : valeur de index
		ldr r2,[r1] ; r2 = Index
		; r3 : adresse de LongeurSon
		ldr r3,=LongueurSon
		; r4 : temp val de LongueurSon
		ldr r4,[r3]
		
		;	if(i<LongueurSon){
		cmp r2, r4
		bge fin
		
		;		SortieSon = (Son[i]+32768)/92
		ldr r4,=Son ; r4 : adresse de Son
		ldrsh r5, [r4, r2, lsl#1] ; r5 = Son[i}
		
		add r5, r5, #32768 ; r5+= 32768
		
		mov r6, #719
		mul r5, r5, r6 ; r5*=719
		
		lsr r5, r5, #16 ; r5/2^16
		
		;SortieSon = r5
		str r5, [r0]
		
		
		;		PWM_Set_Value_TIM3_Ch3(SortieSon)
		mov r0, r5
		push {lr, r1, r2}
		bl PWM_Set_Value_TIM3_Ch3
		pop {lr, r1, r2}
		;		i++
		add r2, r2, #1
		str r2, [r1]
		; 	}

fin
		pop {r4-r8, lr}
		bx lr
	
		endp
;}			
			
			
StartSon proc
		push {lr}
		; r1 : adresse de index
		ldr r1,=Index				
		; index=0
		mov r2, #0
		str r2, [r1]	
		
		pop {lr}
		bx lr
		
		endp
			
		END
	