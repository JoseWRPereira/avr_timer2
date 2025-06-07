#include <avr/io.h>
#include <avr/interrupt.h>

#define T2INT_OVERFLOW_EN	0x01
#define T2COUNT_RELOAD		(256-250)
#define T2NO_CLK			0x00
#define T2CLK_DIV_8			0x01
#define T2CLK_DIV_16		0x02
#define T2CLK_DIV_32		0x03
#define T2CLK_DIV_64		0x04
#define T2CLK_DIV_128		0x05
#define T2CLK_DIV_256		0x06
#define T2CLK_DIV_1024		0x07

unsigned long t2_t = 0;

void timer2_init( void )
{
    cli();
	TCCR2B 	= T2CLK_DIV_64;
	TCNT2 	= T2COUNT_RELOAD;
	TIMSK2 	= T2INT_OVERFLOW_EN;
	t2_t = 0;
    sei();
}

ISR(TIMER2_OVF_vect) // 1ms
{
	TCNT2 = T2COUNT_RELOAD;
	if( t2_t )
	    --t2_t;
}

void timer2_set( unsigned long t )
{
    t2_t = t;
}

unsigned long timer2_status( void )
{
    return( t2_t );
}
