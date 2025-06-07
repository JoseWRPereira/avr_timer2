#include "lcd.h"
#include "teclado.h"
#include "timer2.h"


int main(void)
{
    char tecla;
    unsigned long t = 0;

    lcd_init();
    teclado_init();
    timer2_init();

    lcd(0,0,"   Arri Egua!   ");
    while( 1 )
    {
        tecla = teclado_scan();

        if( timer2_status() == 0 )
        {
            timer2_set( 1000 );
            t++;
            lcd_num(1,0,t,5);
        }
    }
    return( 0 );
}
