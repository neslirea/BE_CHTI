	PRESERVE8
	THUMB   
		
	INCLUDE DriverJeuLaser.inc
; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		

	
; ===============================================================================================
	; char FlagCligno;
FlagCligno dcd 0
	export FlagCligno
	
	EXPORT timer_callback



		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; écrire le code ici		





;void timer_callback(void){
timer_callback proc
		push {lr}
		
		ldr r1,=FlagCligno
		ldr r0, [r1] ; r0 = FlagCligno
	;if (FlagCligno==1){
		cmp r0, #1
		bne cligno
	
	;FlagCligno=0;
		mov r2, #0
		str r2, [r1]
	;GPIOB_Set(1);
		mov r0, #1
		bl GPIOB_Set
	
		b fin
cligno
	;}else{
		;FlagCligno=1;
		;GPIOB_Clear(1);
	;FlagCligno=1;
		mov r2, #1
		str r2, [r1]
	;GPIOB_Clear(1);
		mov r0, #1
		bl GPIOB_Clear
	;}
fin
		pop {lr}
		bx lr
	
	
		endp
;}			
		END	