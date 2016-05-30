// интерфейс клавиатуры

#ifndef _KEYB_H_
#define _KEYB_H_

#include "ADuC842.h"

unsigned char key_read(void) {
  unsigned char i;

  P1=0;
  
  P0_6=1;
  P0_5=1;
  P0_4=0; 

  // задержка для выполнения всех переходных процессов
  i=1;
  while(i--);

  if (!P1_0) return 1;
  if (!P1_1) return 4;
  if (!P1_2) return 7;
  if (!P1_3) return '*';
  
  P1=0;
  P0_6=1;
  P0_5=0;
  P0_4=1; 

  i=1;
  while(i--);

  if (!P1_0) return 2;
  if (!P1_1) return 5;
  if (!P1_2) return 8;
  if (!P1_3) return 0;

  P1=0;
  P0_6=0;
  P0_5=1;
  P0_4=1; 

  i=1;
  while(i--);

  if (!P1_0) return 3;
  if (!P1_1) return 6;
  if (!P1_2) return 9;
  if (!P1_3) return '#';

  return 'N'; // если ничего не нажато
}

unsigned char key_pressed(void) {
  if (key_read() == 'N') return 0; else return 1;
}

unsigned char key_read_w(void) {
  unsigned char p;
 
  while(1) {
    p = key_read();
    if (p != 'N') return p;
  }
}

#endif
