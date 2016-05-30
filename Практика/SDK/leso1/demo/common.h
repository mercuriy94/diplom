#ifndef _COMMON_H_
#define _COMMON_H_

#include "ADuC842.h"

// процедура формирует интервалы времени в 0.1 мс
void delay (unsigned int dcms) {                    // dcms = секунда * 10^-4
  unsigned int H, L, rep=1;
  unsigned char CPUD = PLLCON & 0x03;         // CPU core clock divider (биты CD2..CD0 регистра PLLCON)
  unsigned long int cnt = ((unsigned long int) dcms * 1677) >> CPUD;    
                                                    // 1677 - число тактов при f=16,77ћ√ц, за врем€ = 0,1 мсек 
  
  if (cnt > 0xFFFF) { 
    rep = cnt / 0x10000 + 1;
    cnt = cnt / rep;
  }
  else rep = 1;
  if (cnt == 0) return;
  cnt = 0x10000 - cnt;

  H = cnt / 0x100;
  L = cnt % 0x100;

  TR0 = 0;
  TMOD = (TMOD & 0xF0) + 1;
  while(rep--) { 
    TH0 = H;
    TL0 = L;
    TR0=1;
    while (!TF0);
    TF0=0;
  }
  TMOD = (TMOD & 0xF0);
  return;
}

#endif
