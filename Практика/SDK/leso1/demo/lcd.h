// интерфейс LCD

#ifndef _LCD_H_
#define _LCD_H_

#include "common.h"

sfr  DATA = 0xA0; // P2
sbit E    = 0xB7; // P3.7
sbit RW   = 0xB6; // P3.6
sbit RS   = 0xB5; // P3.5

unsigned char LCD_x, LCD_y;

void LCD_send(unsigned char command, unsigned char delay_dcms) {
  RS = 0; RW = 0;
  DATA = command;
  E = 1;
  delay(1);
  E = 0;
  delay(delay_dcms);
}

void LCD_cursor(unsigned char x, unsigned char y) {
  unsigned char p = 0x80;
  
  if (x<1 || x>8 || y<1 || y>2) return;
  if (y==2) p += 0x40;
  p += (x-1);
  LCD_send(p, 1);
  LCD_x = x; 
  LCD_y = y;
}

void LCD_chr(unsigned char byte) {
  if (LCD_x > 8) { 
    LCD_x = 1;
    LCD_y++;
    if (LCD_y > 2) LCD_y = 1;
    LCD_cursor(LCD_x, LCD_y);
  }
  LCD_x++;

  RS = 1;
  RW = 0;
  DATA = byte;
  E = 1;
  delay(1);
  E = 0;
  delay(1);
}

void LCD_write(char *s) {
  unsigned char i=0;

  while (s[i] != 0 && i<255) { 
    LCD_chr(s[i]);
    i++;
  }
}

// очистка экрана
void LCD_clear(void) { 
  LCD_send(0x01, 50);
  LCD_x = 1;
  LCD_y = 1;
}

// возврат курсора в начальное положение
void LCD_home(void) { 
  LCD_send(0x02, 50);
  LCD_x = 1;
  LCD_y = 1;
}


// изменение стиль курсора: отображение/мигание
void LCD_cursor_style(unsigned char visible, unsigned char blink) {
  unsigned char p = 0x0C;

  if (visible) p += 0x02;
  if (blink)   p += 0x01;
  LCD_send(p, 1);
}

// инициализация LCD экрана
void LCD_init(void) {
  // инициализация LCD после включения питания
  delay(200);
  LCD_send(0x30, 41);  
  LCD_send(0x30, 1);
  LCD_send(0x30, 1); 

  // инициализация завершена.
  // установка режима работы дисплея:
  // двучтрочный, 8-мибитный, размер символов нормальный
  LCD_send(0x3C, 1);
  
  // настройка параметров курсора и сдвига
  LCD_send(0x14, 1);
  LCD_send(0x06, 1);  

  // включение дисплея, отключение мерцания курсора 
  LCD_send(0x0C, 1);
  LCD_cursor(1, 1);
  
  // очистка дисплея
  LCD_send(0x01, 1);
  LCD_home();
}

void LCD_fin(void) {
  // очистка дисплея
  LCD_send(0x01, 1);

  // выключение дисплея
  LCD_send(0x08, 1);
}

void LCD_writehex(unsigned char S) { 
  unsigned char a, b;
  
  a = S >> 4;
  if (a>=0 && a<=9) a+='0'; else a+='A';
  b = S & 0x0F;
  if (b>=0 && b<=9) b+='0'; else b+='A';
  LCD_chr(a);
  LCD_chr(b);
}

#endif
