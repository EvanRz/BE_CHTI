#include "DFT.h"
#include "DriverJeuLaser.h"

#define MAX_POINTS 64
#define DMA_TICK 360000

extern int DFT_ModuleAuCarre(int16_t* Signal64ech, int8_t k);

int16_t dma_buf[MAX_POINTS];
int32_t DFT = 0;

void DMA_DMA()
{
	Start_DMA1(MAX_POINTS);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	
	DFT = DFT_ModuleAuCarre(dma_buf, 17);
}


void DMA_init()
{
	Systick_Period_ff(DMA_TICK);
	Systick_Prio_IT(2, DMA_DMA);
	SysTick_On;
	SysTick_Enable_IT;
	
	Init_TimingADC_ActiveADC_ff(ADC1, 72);
	Single_Channel_ADC(ADC1, 2);
	Init_Conversion_On_Trig_Timer_ff(ADC1, TIM2_CC2, 225);
	Init_ADC1_DMA1(0, dma_buf);
}