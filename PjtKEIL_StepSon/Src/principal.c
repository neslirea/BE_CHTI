

#include "DriverJeuLaser.h"
#include "GestionSon.h"

int main(void)
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
CLOCK_Configure();

//** Placez votre code là ** // 	
Timer_1234_Init_ff(TIM4,72*91); // 72000=1ms
Active_IT_Debordement_Timer(TIM4,2,CallbackSon);	
	
	
// configuration de PortB.1 (PB1) en sortie push-pull
GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);
	
	

//============================================================================	
	
	
while	(1)
	{
	}
}

