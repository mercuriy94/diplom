#include <stdio.h>
#include "ADuC842.h"
#include "common.h"
#include "lcd.h"
#include "keyb.h"
#include "i2c.h"
#include "uL.h"
#include "sound.h"
sbit LED=0xB7;
void int0(void) interrupt 0 {
  snd_nosound();
  muz_playing = 0;
  while (!P3_2);
}


void blik (void)
{
LED=1;
delay(100);
LED=0;
delay(100);
} 

int main() {  
  unsigned int xdata t, adc;
  float xdata f;
  char xdata s[9], u[9];
  unsigned char xdata m=0, hr, min, sec, k=0, i, g;

  #ifdef _SOUND_H_
    muz_playing = 0;
    snd_playing = 0;
  #endif

  // "разгоняем" ядро до 16.77 МГц
  PLLCON = PLLCON & 0xF8 + 0;
  
  // включаем XRAM
  CFG842 |= 0x81;

  // гасим светодиоды
  P0 = 0;
  
  // включаем прерывания
  EA = 1;

  // запуск преобразования термодатчика
  #ifdef _uL_H_
    ow_start();
  #endif

  // инициализация I2C
  #ifdef _I2C_H_
  SPE=0;     // включаем i2c
  I2CM=1;    // режим "програмный ведущий"
  #endif

  // включаем АЦП
  ADCCON1 = 0x8C;     

  // инициализация LCD
  #ifdef _LCD_H_
    LCD_init();
    LCD_write("LESO lab(c) 2007\0");
    for (k=0; k<7; k++) {
      if (k%6>=0 && k%6<=3)
         P0 = (P0 & 0xF0) + 1 << (3-k%6);
      else
         P0 = (P0 & 0xF0) + 1 << (k%6-3);
      delay(1000);
    }
    P0 = (P0 & 0xF0);

    // пикаем
    #ifdef _SOUND_H_
      snd_sound_w(440, 150);
    #endif
    delay(10000);

    LCD_clear();  
  #endif

  // инициализация UART
  T3CON = 0x86 - (PLLCON & 0x03);
  T3FD = 0x02D;
  SCON = 0x052;
  printf("LESO laboratory (c) 2007\nDemo test program\n\n");

  // инициализация переменных
  g = 0;
  for (i=0; i<9; i++) u[i] = 0x20;

  while(1) { 

    if (!g) {
      #ifdef _I2C_H_
        // считываем и отображаем показания часов 
        i2c_start();
        i2c_send(0xA0);       // передача адреса
        i2c_send(0x02);       // прошло успешно, отправляем адрес регистра
        i2c_start();
        i2c_send(0xA1);
        sec = i2c_recv(0);    // принимаем секунды
        min = i2c_recv(0);    // принимаем минуты
        hr  = i2c_recv(1);    // принимаем часы
        i2c_stop();

        LCD_cursor(1, 1); 
        LCD_writehex(hr);
        LCD_chr(':');
        LCD_writehex(min);
        LCD_chr(':');
        LCD_writehex(sec);
      #endif

      #ifdef _uL_H_
        // считываем и отображаем показания термодатчика
        t = ow_read_temperature();
        ow_start();
        ow_temp_str(t, s);
        LCD_cursor(1, 2);
        LCD_write(s);
      #endif
    }

    #ifdef _KEYB_H_
      k = key_read();
      if (k=='N' && snd_playing) {
        snd_nosound();
        P0 = (P0 & 0xF0);
      }
      if (k>=0 && k<=9 && !snd_playing) { 
        snd_beep(k);
        P0 = (P0 & 0xF0) + k;
      }
      
      if (k!='N') {
        g = 80;
        for (i=1; i<9; i++) u[i-1] = u[i];
        if (k>=0 && k<=9) u[7] = 0x30+k; else u[7] = k;
        u[8] = 0;
        LCD_cursor(1, 1);
        LCD_write(" Text   ");
        LCD_cursor(1, 2);
        LCD_write(u);
        while(key_pressed());
      }      
    #endif

    // ик-датчик
    P0_7 = 1;
    if (!P0_7) {
      i=100;
      while(i--);
      if (!P0_7 && !snd_playing) snd_sound(1000, 100);
    }

    // большая кнопка и музыка
    #ifdef _SOUND_H_
      P3_2 = 1;
      if (P3_2==0 && !muz_playing) {
        while (!P3_2);
        LCD_clear();
        LCD_write(" Music  ");
        EX0 = 1; // включаем прерывание на большую кнопку
        muz_play();
        EX0 = 0;
      }
    #endif
     blik();
    // АЦП
    for (i=4; i<=6; i++) {
      ADCCON2 = i;   // выставляем канал
      SCONV = 1;     // запускаем цикл преобразования
      while (SCONV);
     blik();
      if (ADCDATAL >= 4) {  // есть напряжение на канале
        g = 60;
        adc = ADCDATAH % 16;
	    adc = adc << 8;
	    adc += ADCDATAL;
        f = adc * 1.220703125;  // мВ на квант

        LCD_cursor(1, 1);
        LCD_write("ADC CH:");
        LCD_chr(0x30+i);
        LCD_cursor(1, 2);
        sprintf(s, " %4.0f mV", f);
        LCD_cursor(1, 2);
        LCD_write(s); 
      }
    }
    if (g) {
      delay(200);
      g--;
      if (!g) for (i=0; i<9; i++) u[i] = 0x20;
    }


    /*  
    m = menu_select(m);
    switch (m) {
      case 1: {
        LCD_clear();
        cur=1;
        while(1) {
          LCD_cursor(1, 1);
          LCD_write_c(help_data[cur-1]);
          LCD_cursor(1, 2);
          LCD_write_c(help_data[cur]);
          while (key_pressed());

          k = key_read_w();
          if (k==2) cur--;
          if (k==8) cur++;
          if (cur < 1) cur = HELP_CNT-1;
          if (cur > HELP_CNT-1) cur = 1;
          if (k=='*') {
            LCD_clear();
            cur=0;
            break;
          }
        } 
        break; 
      }

      case 2: {    
        LCD_clear();
        LCD_write(" Clock ");      
        while (1) {
          // считываем и отображаем показания часов       
          i2c_start();
          i2c_send(0xA0);               // передача адреса
          i2c_send(0x02);               // прошло успешно, отправляем адрес регистра
          i2c_start();
          i2c_send(0xA1);
          sec = i2c_recv(0);            // принимаем секунды
          min = i2c_recv(0);            // принимаем минуты
          hr  = i2c_recv(1);            // принимаем часы
          i2c_stop();
     
          LCD_cursor(1, 2); 
          LCD_writehex(hr);
          LCD_chr(':');
          LCD_writehex(min);
          LCD_chr(':');
          LCD_writehex(sec);
          
          if (key_read() == '*') break; 
          delay(1000);
        }
        break;
      }

      case 3: {    
        LCD_clear();
        LCD_cursor(1, 1);
        LCD_write("Termo-r");      
        while (1) {
          // считываем и отображаем показания термодатчика
          t = ow_read_temperature();
          ow_start();
          ow_temp_str(t, s);
          LCD_cursor(1, 2);
          LCD_write(s);

          if (key_read() == '*') break; 
          delay(1000);
        }
        break;
      }

      case 4: {    
        LCD_clear();
        LCD_cursor(1, 1);
        LCD_write(" Diodes ");      
        k = 0;
        while (1) {
          if (k>=0 && k<=3)
            P0 = (P0 & 0xF0) + 1 << (3-k);
          else
            P0 = (P0 & 0xF0) + 1 << (k-3);
          k++;
          if (k>5) k=0;

          if (key_read() == '*') break; 
          delay(2000);
        }
        P0 = (P0 & 0xF0);
        break;
      }

      case 5: {    
        LCD_clear();
        LCD_cursor(1, 1);
        LCD_write("Speaker");      

        while (1) {
          while(key_pressed());
          snd_nosound();
          do {
            k = key_read_w();
            if (k=='*') break;
          } while (!(k>=0 && k<=9));
          if (k=='*') break;
          else {
            if (k>0 && k<=8) 
              snd_sound(freq(1, notes[k-1]), 3000);          
            else {
              if (k==0) k = 10;
              snd_sound(freq(2, notes[k-1]), 3000);          
            }
          }
          delay(1000);
        }
        break;
      }

      case 6: {    
        LCD_clear();
        LCD_cursor(1, 1);
        LCD_write("   IR   ");      

        while (1) {
          P0_7 = 1;
          if (!P0_7) {
            snd_nosound();
            snd_sound(440, 100);
          }
          if (key_read() == '*') break; 
        }
        snd_nosound();
        break;
      }

      case 7: {    
        LCD_clear();
        i=4;
        ADCCON1 = 0x8C;   // включаем АЦП
        ADCCON2 = i;  

        while (1) {
          LCD_cursor(1, 1);
          LCD_write("ADC CH:"); LCD_chr(0x30+i);

          SCONV = 1;
          while (SCONV);
          adc = ADCDATAH % 16;
	      adc = adc << 8;
	      adc += ADCDATAL;
          f = adc * 1.220703125;
          sprintf(s, " %4.0f mV", f);
          LCD_cursor(1, 2);
          LCD_write(s);    

          k = key_read();
          if (k == '*') break; 
          if (k>=4 && k<=6) {
            i = k;
            ADCCON2 = i;
          }
          delay(1000);
        }
        break;
      }


      case 8: {    
        LCD_clear();
        LCD_cursor(1, 1);
        LCD_write("  UART  ");    
        printf("Send some text (8 max)\n>");


        while (1) {
        
          if (RI) {
            s[0] = 0;
            gets(s, 9);
          
            if (s[0] != 0) {
              s[8] = 0;
              LCD_cursor(1, 2);
              LCD_write("        ");
              LCD_cursor(1, 2);
              LCD_write(s);
            } 
            printf("\n>");         
          }

          if (key_read() == '*') break; 
        }
        printf("\n"); 
        break;
      }

    } */

   
    //delay(10000);    
  }
}
