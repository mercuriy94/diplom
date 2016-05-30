// интерфейс зуммера и музыки

#ifndef _SOUND_H_
#define _SOUND_H_

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "ADuC842.h"

#include "lcd.h"

sbit ZM=0xB3;

#define NC  1
#define NCd 2
#define ND  3
#define NDd 4
#define NE  5
#define NF  6
#define NFd 7
#define NG  8
#define NGd 9
#define NA 10
#define NB 11
#define NH 12
#define NP  0

#define MUZ_STRCNT 6
unsigned char code muz_data[MUZ_STRCNT][65] = {
  "O1 L8 C G. L16 G L8 A. L16 A L8 B L4 A L8 G\0",
  "L2 G. L8 C G. L16 G L8 A. L16 A L8 B L4 A L8 G\0", 
  "L2 G. L8 E C. L16 C L8 D. L16 C L8 E- L4 D L8 C\0", 
  "L2 C. L16 <F F# L8 G. L16 G L8 A. L16 A L8 B\0",
  "L4 A L8 G L2 G L8 <G >C. L16 E L8 F. L16 E L8 F. L16 E\0",
  "L16 F G L8 G L4 G L8 F. L16 E L8 F. L16 E L4 F L8 E C L1 C\0" };

unsigned char code notes[10] = {1,3,5,6,8,10,11,12,1,3};

unsigned char SNDH, SNDL;
unsigned long int SNDREP;
unsigned char muz_playing, snd_playing;

unsigned int freq (int okt, unsigned char nota);

unsigned char snd_sound(unsigned int freq, unsigned int length) {
  unsigned char CPUD = PLLCON & 0x03;                  // CPU core clock divider (биты CD2..CD0 регистра PLLCON)
  unsigned long int cnt;  

  if (freq<150 || freq>15000) return 0; 
  if (length < 1) return 0;
  cnt =  ((unsigned long int) 8388608/freq) >> CPUD;  // 16777216 - число тактов при f=16,77ћ√ц, за врем€ = 1 сек
  if (cnt > 0xFFFF) return 0;                         // полпериода - в 2 раза меньше
  cnt = 0xFFFF - cnt;
  SNDH = (cnt >> 8);
  SNDL = cnt;
 
  SNDREP = (unsigned long int) length * freq / 500;  

  ET1 = 1;
  TMOD |= 0x10;
  TH1 = 0xFF;
  TL1 = 0xFF;
  TR1 = 1; 
  snd_playing = 1; 
  return 1;
}

void snd_nosound(void) {
  ET1 = 0;
  TMOD = TMOD & 0x0F;  
  SNDREP = 0;
  snd_playing = 0;
}

unsigned char snd_sound_w(unsigned int freq, length) {
  unsigned char p;

  p = snd_sound(freq, length);
  if (!p) return p;
  while (SNDREP);
  return 0; 
}

void snd_t1int(void) interrupt 3 {
  ZM = !ZM; 
  if (SNDREP--) {
    TH1 = SNDH;
    TL1 = SNDL;
    TR1 = 1;    
  }
  else {
    ET1 = 0;
    TMOD = TMOD & 0x0F;
    snd_playing = 0;
  }
}

void snd_beep(unsigned char k) {
  if (snd_playing) snd_nosound();

  if (k>0 && k<=8) 
    snd_sound(freq(1, notes[k-1]), 3000);          
  else {
    if (k==0) k = 10;
    snd_sound(freq(2, notes[k-1]), 3000);          
  }
}

unsigned char nota(char c1, char c2) {
  unsigned char n;

  switch (c1) {
    case 'C': n = NC; break;
    case 'D': n = ND; break;
    case 'E': n = NE; break;
    case 'F': n = NF; break;
    case 'G': n = NG; break;
    case 'H': n = NH; break;
    case 'A': n = NA; break;
    case 'B': n = NB; break;
    case 'P': n = NP; break;
  }
  switch (c2) {
    case '#','+' : n++; break;
    case '-'     : n--; break;
  }
  return n;
}

unsigned int freq (int okt, unsigned char nota) {
  if (nota == NP) return 0;
  else {
    return 440 * exp(log(2)*((float) okt-1 - (10 - (float) nota)/12));
  }
}

void zvuk (unsigned char nota, int okt, unsigned int del) {
  if (nota != NP) { 
    P0 = (P0 & 0xF0) + 1 << ((nota-1)%4);
    snd_sound_w(freq(okt, nota), del);
  }
  else P0 = (P0 & 0xF0);
}

unsigned char stn(char c1, char c2) {
  int n;
  char s[3];
  
  s[0] = c1;
  if (c2 != 0) s[1] = c2; else s[1] = 0;
  s[3] = 0;

  sscanf(s, "%d", &n);
  return n;
}

unsigned int d8;
int okt=0;
unsigned char l=0, tri=0;

void muz_playstr(char code *s) {
  unsigned char n=0, i;
  unsigned int del=0;

  if (strlen(s) == 0) return;
  i=0;

  while (i < strlen(s)) {
    if (!muz_playing) break;
    switch (s[i]) {
      case ';' : { return; break; }
      case 'O' : { okt = stn(s[i+1], 0); i+=2; break; }
      case '>' : { okt++; i++; break; }
      case '<' : { okt--; i++; break; }
      case 'L' : {
            if ((i+2 < strlen(s)) && (s[i+2] >= '0') && (s[i+2] <= '9')) {
              l = stn(s[i+1], s[i+2]); i+=3;
            }
            else {
              l = stn(s[i+1], 0); i+=2;
            }
            break;
          }
      case '3' : { tri = 3; i++; break; }
      case '6' : { tri = 6; i++; break; }
      case 'A' :
      case 'B' :
      case 'C' :
      case 'D' :
      case 'E' :
      case 'F' :
      case 'G' :
      case 'H' :
      case 'P' : {
            if ((i+1 < strlen(s)) && (s[i+1] == '#' || s[i+1] == '+' || s[i+1] == '-')) {
              n = nota(s[i], s[i+1]); i+=2; 
            }
            else {
              n = nota(s[i], 0); i++; 
            }
            del = 8*d8 / l;
            if ((i+1 < strlen(s)) && (s[i] == '.') && (s[i+1] == '.')) {
              del += 3*del / 4; i+=2; 
            }
            else
            if ((i < strlen(s)) && (s[i] == '.')) {
                del *= 1.5; i++; 
            } 
            if (tri > 0) {
              del = (2*del) / 3;
              tri--;
            }
            zvuk (n, okt, del);
            break;
          }
      default : i++;
    }
  }
  P0 = (P0 & 0xF0);
}

void muz_play(void) {
  unsigned char i;

  muz_playing = 1;
  d8 = 250;
  
  for(i=0; i<MUZ_STRCNT; i++) {
    if (muz_playing) muz_playstr(muz_data[i]); 
    else break;
  }

  muz_playing = 0;
}

#endif
