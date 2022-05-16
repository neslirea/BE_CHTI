

#include "DriverJeuLaser.h"
#include "GestionDFT.h"

extern short int LeSignal;

int tab[64];
short dma_buf[64];

void Systick_function()
{
	//d�marrage de la DMA sur 64 �chantillons:
	Start_DMA1(64);
	//attente de la fin de DMA:
	Wait_On_End_Of_DMA1();
	//�arr�ter la DMA
	Stop_DMA1;
	
	for (int i=0; i<64; i++){
	tab[i] = DFT_ModuleAuCarre(dma_buf, i); 
	}
}

int main(void)
{
// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================
	
	// Apr�s ex�cution : le coeur CPU est clock� � 72MHz ainsi que tous les timers
	CLOCK_Configure();
	
	//---CONFIGURATION DE SYSTICK---
	//r�glage de la p�riodicit� du systick
	Systick_Period_ff(360000);
	//configuration du timer (d�bordement) 
	Systick_Prio_IT( 2, Systick_function);
	//lancer le systick
	SysTick_On;
	//valider   les   interruptions
	SysTick_Enable_IT;
	
	//---CONFIGURATION DE TIM2---
	//Activation de ADC1 avec pr�l�vement de 1us 
	Init_TimingADC_ActiveADC_ff( ADC1, 72 );
	//Choix du pin d'entr�e
	Single_Channel_ADC( ADC1, 2 );
	//Configuration du timer 2 pour qu'ADC1 soit � 320 kHz
	Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
	//Configuration du remplissage de RAM
	Init_ADC1_DMA1( 0, dma_buf );
//============================================================================	
		
while	(1)
	{
	}
}

