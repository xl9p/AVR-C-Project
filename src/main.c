#define F_CPU 4000000UL 

#ifdef __XC__
#include <xc.h>
#else
#include <avr/io.h>
#endif

#include <util/delay.h>

int
main (void)
{
      unsigned i = 0;
      while (1) {
            i++;

            if (i == 100) {
                  break;
            }
            _delay_ms(5);
      }

      int j = i + 100;

      return j;
}
