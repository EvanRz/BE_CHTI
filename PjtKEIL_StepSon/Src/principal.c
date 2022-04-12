

#include "DriverJeuLaser.h"

extern unsigned short int sortieSon;
extern void callbackSon();

int main()
{

// ===========================================================================
// ============= INIT PERIPH (faites qu'une seule fois)  =====================
// ===========================================================================

// Après exécution : le coeur CPU est clocké à 72MHz ainsi que tous les timers
	CLOCK_Configure();
	GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);

	PWM_Init_ff(TIM3, 3, 720);
	Active_IT_Debordement_Timer(TIM3, 2, callbackSon);
		
	while	(1) 
	{
		PWM_Set_Value_TIM3_Ch3(sortieSon);
	}
}

