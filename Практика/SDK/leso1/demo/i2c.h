// интерфейс I2C

#ifndef _I2C_H_
#define _I2C_H_

#include "ADuC842.h"

void i2c_delay(void) {
  // ничего не делаем - просто тратим процессорное время
  // на вход/выход в процедуру (этого достаточно)
  return;
}

void i2c_start(void) {
  MDE=1;
  MDO=1;
  MCO=1;
  i2c_delay();
  MDO=0;
  i2c_delay();
  MCO=0;
}

void i2c_stop(void) {
  MDE=1;
  MDO=0;
  MCO=1;  
  i2c_delay();
  MDO=1;
  i2c_delay();
  MCO=0;
  MDE=0;
}

bit i2c_send (unsigned char ch) { 
  char cnt;
  bit ack;
  
  MDE=1;
  for (cnt=0; cnt<8; cnt++, ch<<=1) { 
    MDO=(ch&0x80)?1:0;
    MCO=1;
    i2c_delay();
    MCO=0;
    i2c_delay();
  }

  MDE=0;
  MCO=1;
  i2c_delay();
  ack=MDI;
  MCO=0;
  return ack;
}
   
unsigned char i2c_recv(unsigned char is_last) { 
  char cnt, ch = 0;

  MDE=0;
  MCO=0;
  for (cnt=0;cnt<8;cnt++) { 
    ch<<=1;
    MCO=1;
    i2c_delay();
    ch|=MDI;
    MCO=0;
    i2c_delay();
  }

  MDE=1;
  MDO=is_last;  
  MCO=1;
  i2c_delay();
  MCO=0;
  i2c_delay();
  MDE=0;
  return ch;
}

#endif
