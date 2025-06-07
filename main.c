#include "lcd.h"
#include "teclado.h"
#include "timer2.h"

int main(void)
{
    char tecla;
    unsigned long t = 0;

    timer2_init();
    teclado_init();
    lcd_init();

    lcd(0,0," Temporizador:  ");
    lcd(1,0,"   h   min   s  ");
    while( 1 )
    {
        tecla = teclado_scan();

        if( timer2_status() == 0 )
        {
            timer2_set( 200 );
            t++;
            lcd_num(1, 0,t/(60*60),3);
            lcd_num(1, 5,t/(60),2);
            lcd_num(1,11,t%(60),2);
        }
    }
    return( 0 );
}
