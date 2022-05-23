

#include "DriverJeuLaser.h"
#include "GestionDFT.h"
#include "GestionSon.h"
#include "Affichage_Valise.h"


extern short int LeSignal;

int tab[64];
short dma_buf[64];
int score[4];
int frequence[4];
int est_comptabilise[4];
char trame[10];
int est_a_jour; 
char led[4]; 
int indice_led; 


void Systick_function()
{
	//démarrage de la DMA sur 64 échantillons:
	Start_DMA1(64);
	//attente de la fin de DMA:
	Wait_On_End_Of_DMA1();
	//•arrêter la DMA
	Stop_DMA1;
	
	for (int i=0; i<64; i++){
	tab[i] = DFT_ModuleAuCarre(dma_buf, i); 
	}
	for(int i=0; i<4;i++){
		if(tab[frequence[i]]>0x9999A&&est_comptabilise[i]==0){
			StartSon();
			score[i]++;
			Prepare_Afficheur(i+1, score[i]);
			est_comptabilise[i]=1;
			est_a_jour=0; 
		} else if (tab[frequence[i]]<0x9999A&&est_comptabilise[i]==1){
			est_comptabilise[i]=0;
		}
	}
}

int main(void)
{
// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================
	
	// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
	CLOCK_Configure();
	
	//---CONFIGURATION DE SYSTICK---
	//réglage de la périodicité du systick
	Systick_Period_ff(360000);
	//configuration du timer (débordement) 
	Systick_Prio_IT( 9, Systick_function);
	//lancer le systick
	SysTick_On;
	//valider   les   interruptions
	SysTick_Enable_IT;
	
	//---CONFIGURATION DE TIM2---
	//Activation de ADC1 avec prélèvement de 1us 
	Init_TimingADC_ActiveADC_ff( ADC1, 72 );
	//Choix du pin d'entrée
	Single_Channel_ADC( ADC1, 2 );
	//Configuration du timer 2 pour qu'ADC1 soit à 320 kHz
	Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
	//Configuration du remplissage de RAM
	Init_ADC1_DMA1( 0, dma_buf );
	
	
	//---CONFIGURATION DU SON---
	Timer_1234_Init_ff(TIM4,72*91); // 72000=1ms
	Active_IT_Debordement_Timer(TIM4,1,CallbackSon);	

	//Configuration du PWM 
	PWM_Init_ff(TIM3, 3, 720);
		
	//Configuration du PortB.0
	GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
	
	
	//---CONFIGURATION DE L'AFFICHAGE---
	Init_Affichage(); 
	est_a_jour=1; 
	led[0] = LED_Cible_1; 
	led[1] = LED_Cible_2; 
	led[2] = LED_Cible_3; 
	led[3] = LED_Cible_4; 
	
	
	
	//---INITIALISATION DES JOUEURS---
	for(int i=0;i<4;i++){
		score[i]=0;
		est_comptabilise[i]=0;
	}
	frequence[0]=17;
	frequence[1]=18;
	frequence[2]=19;
	frequence[3]=20;
	
	
//============================================================================	
Prepare_Set_LED(led[indice_led]);
Mise_A_Jour_Afficheurs_LED();
Prepare_Clear_LED(led[indice_led]);
indice_led ++; 	
while	(1)
	{

		if(!est_a_jour) //si le score a changé
		{
			Prepare_Clear_LED(led[indice_led]);
			indice_led = (indice_led + 1)%4;
			
			Prepare_Set_LED(led[indice_led]);
			Mise_A_Jour_Afficheurs_LED();
			est_a_jour=1;

		}

	}
}

