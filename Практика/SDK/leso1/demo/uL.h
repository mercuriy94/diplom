// интерфейс MicroLAN

#ifndef _uL_H_
#define _uL_H_

#include "ADuC842.h"

sbit DQ  = 0x0B4;		// P3.4

void ow_delay(unsigned char useconds) {
  unsigned char s;
  unsigned char cd = 1 << (4 - (PLLCON & 0x03)); 

  useconds = ((int) useconds * cd); 
  for (s=0; s<useconds+cd; s++);
}

unsigned char ow_reset(void) {
  unsigned char presence;

  DQ = 0; 			
  ow_delay(29);		
  DQ = 1; 			
  ow_delay(3); 		
  presence = DQ; 	
  ow_delay(25); 	
  return(presence); 
} 					

unsigned char ow_read_bit(void) {
  unsigned char i;

  DQ = 0; 				
  DQ = 1; 				
  for (i=0; i<3; i++); 	
  return(DQ); 			
}

void ow_write_bit(char bitval) {
  DQ = 0; 				
  if(bitval==1) DQ =1; 	
  ow_delay(5); 			
  DQ = 1;				
}						

unsigned char ow_read_byte(void) {
  unsigned char i;
  unsigned char value = 0;

  for (i=0;i<8;i++) {
    if(ow_read_bit()) value|=0x01<<i; 								
	ow_delay(6); 					
  }
  return(value);
}

void ow_write_byte(char val) {
  unsigned char i;
  unsigned char temp;

  for (i=0; i<8; i++) {	
    temp = val>>i; 		
    temp &= 0x01; 		
    ow_write_bit(temp); 
  }
  ow_delay(5);
}

void ow_start(void) {
  ow_reset();
  ow_write_byte(0xCC); 								
  ow_write_byte(0x44); 								
}

unsigned int ow_read_temperature(void) {
  unsigned char get[10];
  unsigned int temp;
  int k;

  ow_reset();
  ow_write_byte(0xCC); 								
  ow_write_byte(0xBE); 								
  for (k=0;k<9;k++) {get[k]=ow_read_byte();}
  temp = get[1];
  temp = temp << 8;
  temp += get[0];
  return temp;
}

ow_temp_str(unsigned int temp, char *s) {
  unsigned char i=0, j, k, mas[5];

  if (temp & 0x8000) s[0] = '-'; else s[0] = '+';
  k = temp & 0x0F;
  temp = (temp >> 4) & 0x7F;
  
  j = 0;
  while (temp) {
    mas[j] = temp % 10;     
    temp /= 10;
    j++;
  }
  
  for (i=0; i<j; i++) s[j-i] = 0x30+mas[i];
  s[j+1] = '.';
  
  temp = k*1000/16;
  k = j+1;
  j = 0;
  for (j=0; j<3; j++) {
    mas[j] = temp % 10;     
    temp /= 10;
  }
  for (i=0; i<3; i++) s[k+3-i] = 0x30+mas[i];

  for (i=k+j+1; i<8; i++) s[i] = ' ';
  s[8] = 0;
}

#endif
