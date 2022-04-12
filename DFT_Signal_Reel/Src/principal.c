#include "DriverJeuLaser.h"

extern int DFT_ModuleAuCarre(int16_t* Signal64ech, int8_t k);

short dma_buf[64];

int DFT = 0;

void DMA()
{	
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	
	DFT = DFT_ModuleAuCarre(dma_buf, 17);
}

int main(void)
{
	CLOCK_Configure();
	
	Systick_Period_ff(360000);
	Systick_Prio_IT(2, DMA);
	SysTick_On;
	SysTick_Enable_IT;
	
	Init_TimingADC_ActiveADC_ff(ADC1, 72);
	Single_Channel_ADC(ADC1, 2);
	Init_Conversion_On_Trig_Timer_ff(ADC1, TIM2_CC2, 225);
	Init_ADC1_DMA1(0, dma_buf);
	
	while	(1)	{}
}

