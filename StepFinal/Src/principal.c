#include <stdlib.h>
#include <time.h>
#include <stdio.h>

#include "DriverJeuLaser.h"
#include "Affichage_Valise.h"

#define K1 17 
#define K2 18
#define K3 19
#define K4 20
#define NB_JOUEURS 4
#define BUFFER_SIZE 64
#define DMA_TICK 360000
#define MIN_DMA 100000
#define TIMER_MAX 90

extern int DFT_ModuleAuCarre(int16_t* Signal64ech, int8_t k);
extern void callbackSon(); 

extern uint32_t soundIndex;
extern uint32_t LongueurSon;
extern uint16_t sortieSon;

int16_t dma_buf[BUFFER_SIZE];

uint8_t  K[NB_JOUEURS] = {K1, K2, K3, K4};

char leds[4] = {LED_Cible_1, LED_Cible_2, LED_Cible_3, LED_Cible_4};
char led = 0;

int scores[NB_JOUEURS];
int DMA_result = 0;
int timer = 0;
int update_timer = 0;
int hit = 0;
int update = 0;

int8_t get_player()
{
	int max = 0;
	int8_t player = -1;
	
	for (uint8_t i = 0; i < NB_JOUEURS; i++)
	{
		DMA_result = DFT_ModuleAuCarre(dma_buf, K[i]);
		
		if (DMA_result > MIN_DMA)
		{	
			if (max < DMA_result) 
			{
				max = DMA_result;
				player = i;
			}
		}
	}
	
	return player;
}

void affichage_select_capteur()
{	
	srand(TIM2->CNT);
	
	Prepare_Clear_LED(leds[led]);
	Mise_A_Jour_Afficheurs_LED();	
		
	led = rand() % 4;
	
	Choix_Capteur(led + 1);
	Prepare_Set_LED(leds[led]);
	Mise_A_Jour_Afficheurs_LED();
}

void affichage_update(char aff, char value)
{
	Prepare_Afficheur(aff, value);
	Mise_A_Jour_Afficheurs_LED();
}

void sound_play()
{
		if (soundIndex >= 2 * LongueurSon) soundIndex = 0;
}

void DMA()
{	
	Start_DMA1(BUFFER_SIZE);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	
	int player = get_player();
	
	if (!hit) 
	{
		if (player >= 0)
		{			
			hit = 1;
			update = 1;
			scores[player] += 1;
			
			sound_play();
		}
	}
	else 
	{
		timer++;
		
		if (timer > TIMER_MAX) 
		{
				timer = 0;
				hit = 0;
		}
	}
}

void DMA_init()
{
	Systick_Period_ff(DMA_TICK);
	Systick_Prio_IT(1, DMA);
	SysTick_On;
	SysTick_Enable_IT;
	
	Init_TimingADC_ActiveADC_ff(ADC1, 72);
	Single_Channel_ADC(ADC1, 2);
	Init_Conversion_On_Trig_Timer_ff(ADC1, TIM2_CC2, 225);
	Init_ADC1_DMA1(0, dma_buf);
}

void sound_init()
{
	GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
	
	PWM_Init_ff(TIM3, 3, 720);
	Timer_1234_Init_ff( TIM4, 11000);
	Active_IT_Debordement_Timer(TIM4, 2, callbackSon);
}

void affichage_init()
{
	Init_Affichage();
	
	Choix_Capteur(0);
	Prepare_Set_LED(LED_Cible_1);
	Mise_A_Jour_Afficheurs_LED();
}

int main(void)
{	
	CLOCK_Configure();	
	sound_init();	
	DMA_init();
	affichage_init();
	
	while	(1)	
	{
			PWM_Set_Value_TIM3_Ch3(sortieSon);		
					
			if (update) 
			{	
					affichage_select_capteur();
				
					affichage_update(1, scores[0]);
					affichage_update(2, scores[1]);
					affichage_update(3, scores[2]);
					affichage_update(4, scores[3]);
					
					update = 0;
			}
	}
}

