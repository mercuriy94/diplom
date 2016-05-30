using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using System.Diagnostics;
using System.IO;
using System.Threading;
using System.IO.Ports;
using System.Threading.Tasks;
using System.Timers;

using IWshRuntimeLibrary;

namespace Aldnoah
{
    public partial class Aldnoah : Form
    {
        //Глобальные переменные

        // Для основной программы
        // COM
        SerialPort port; // Переменная COM порта
        int getbyte = 0; // Переменная для приема данных из COM

        // Для загрузчика
        int ThreadSleep = 4000; //Задаем время ожидания, когда выполнится загрузка DOSBox'a, иначе ошибка записи
        string downloadadr = "0x0000 0x0"; //Начальный адрес загрузки
        int speed2 = 9600; //скорость загрузки программы

        // Переменные для текущих координат
        int X = 0;
        int Z = 0;
        int Y = 0;

        // Максимальные границы для программы
        int minX = 0;
        int maxX = 2000;
        int minZ = 0;
        int maxZ = 1000;
        int minY = 0;
        int maxY = 500;

        //Границы баночек (край)
        int grZT = 1800;
        int grZO1 = 800; // Пристрой в настройках!
        int grZO2 = 1200;
        int grZS = 200;

        // Для анимации алгоритмизации
        int ton = 0; // Таймер
        int corecoord = 0; // Наименование движения
        int migmig = 0; // Мигаем
        int timer1open1 = 0; // Открыть поток 1
        int timer1open2 = 0; // Открыть поток 2
        
        // Потоки
        Thread Thread1; // Поток для запуска алгоритмизации
        Thread Thread2; // Поток для запуска мигания анимации
        Thread Thread3; // Поток для запуска симуляции работы
         
        public Aldnoah()
        {
            InitializeComponent();
            comboBox1.SelectedIndex = 0; // Первая переменная COM1 (для загрузчика)
            comboBox5.SelectedIndex = 0; // Первая переменная COM1 (для основной)
            comboBox2.SelectedIndex = 1; // Первая переменная COM1 (для загрузчика)
            comboBox4.SelectedIndex = 1; // Первая переменная COM1 (для основной)
            comboBox3.SelectedIndex = 0; // Выбор направления до датчика
            comboBox6.SelectedIndex = 0; // Выбор направления до датчика
            Thread2 = new Thread(StartAlg1);
            Thread2.Start(); 
        }

        public void serialPort1_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            // Основная программа. Событие после получения данных
            getbyte = port.ReadByte();
            //Получение событий с датчиками и устрйоствами
            if (getbyte == 112) { checkBox14.Checked = false; checkBox3.Checked = false; richTextBox4.Text = richTextBox4.Text + "Выключен Вентилятор\n"; pictureBox3.Invoke(new Action(() => pictureBox3.Visible = true)); }// Вентилятор выключен
            if (getbyte == 111) { checkBox14.Checked = true; checkBox3.Checked = true; richTextBox4.Text = richTextBox4.Text + "Включен Вентилятор\n"; pictureBox3.Invoke(new Action(() => pictureBox3.Visible = false)); }// Вентилятор включен
            if (getbyte == 108) { checkBox13.Checked = false; checkBox2.Checked = false; richTextBox4.Text = richTextBox4.Text + "Выключен Нагреватель\n"; pictureBox4.Invoke(new Action(() => pictureBox4.Visible = true)); }// Нагреватель выключен
            if (getbyte == 107) { checkBox13.Checked = true; checkBox2.Checked = true; richTextBox4.Text = richTextBox4.Text + "Включен Нагерватель\n"; pictureBox4.Invoke(new Action(() => pictureBox4.Visible = false)); }// Нагреватель включен
        }
        
        // АЛГОРИТМИЗАЦИЯ
        
        private void button36_Click(object sender, EventArgs e)
        {
            // Основная программа. Запуск алгоритма
            Thread1 = new Thread(StartAlg);
            Thread1.Start();
           // button36.Enabled = false;
        }

        private void StartAlg()
        {
            try
            {
                progressBar2.Invoke(new Action(() => progressBar2.Maximum = richTextBox3.Lines.Length - 1));
                progressBar2.Invoke(new Action(() => progressBar2.Value = 0));
                string allstring = "";
                richTextBox3.Invoke(new Action(() => allstring = richTextBox3.Text));
                string[] split = allstring.Split(new Char[] { ' ', '\n' });
                int dallstring = split.Length;
                int send = 0;
                int sendimp = 0;
                for (int i = 0; i < dallstring; i++)
                {
                    if (split[i] == "Движение" && split[i + 1] == "влево" && split[i + 4] == "X") { send = 1; sendimp = Convert.ToInt32(split[i + 6]); }
                    if (split[i] == "Движение" && split[i + 1] == "вправо" && split[i + 4] == "X") { send = 2; sendimp = Convert.ToInt32(split[i + 6]); }
                    if (split[i] == "Движение" && split[i + 1] == "вверх" && split[i + 4] == "Z") { send = 3; sendimp = Convert.ToInt32(split[i + 6]); }
                    if (split[i] == "Движение" && split[i + 1] == "вниз" && split[i + 4] == "Z") { send = 4; sendimp = Convert.ToInt32(split[i + 6]); }
                    if (split[i] == "Время" && split[i + 1] == "сушки") { send = 7; sendimp = Convert.ToInt32(split[i + 2]); }
                    if (split[i] == "Включить" && split[i + 1] == "вентилятор") { send = 8; sendimp = 1; }
                    if (split[i] == "Выключить" && split[i + 1] == "вентилятор") { send = 9; sendimp = 1; }
                    if (split[i] == "Включить" && split[i + 1] == "нагреватель") { send = 10; sendimp = 1; }
                    if (split[i] == "Выключить" && split[i + 1] == "нагреватель") { send = 11; sendimp = 1; }
                    if (split[i] == "Возврат" && split[i + 1] == "в") { send = 12; sendimp = 1; }
                    if (send != 0)
                    {
                        getbyte = 0;
                        progressBar1.Invoke(new Action(() => progressBar1.Maximum = sendimp));
                        progressBar1.Invoke(new Action(() => progressBar1.Value = 0));
                        char sendbyte = '.'; // Пустое значение
                        int getbyteout = 999; // Пустое значение
                        int n = 1; // Счетчик импульсов
                        if (send == 1) { sendbyte = 'A'; getbyteout = 97; corecoord = 1; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет движение влево по оси X\n")); } // Движение влево по оси X, ожидание приема символа "а" (97)
                        if (send == 2) { sendbyte = 'B'; getbyteout = 98; corecoord = 2; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет движение вправо по оси X\n")); } // Движение вправо по оси X, ожидание приема символа "b" (98)
                        if (send == 3) { sendbyte = 'C'; getbyteout = 99; corecoord = 3; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет движение вверх по оси Z\n")); } // Движение вверх по оси Z, ожидание приема символа "c" (99)
                        if (send == 4) { sendbyte = 'D'; getbyteout = 100; corecoord = 4; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет движение вниз по оси Z\n")); } // Движение вниз по оси Z, ожидание приема символа "d" (100)
                        if (send == 7) { sendbyte = 'T'; getbyteout = 116; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет сушка платы\n")); } // Включить таймер ожидания, ожидание приема символа "t" (116)
                        if (send == 8) { sendbyte = 'O'; getbyteout = 111; } // Включить вентилятор, ожидание приема символа "o" (111)
                        if (send == 9) { sendbyte = 'P'; getbyteout = 112; } // Выключить вентилятор, ожидание приема символа "p" (112)
                        if (send == 10) { sendbyte = 'K'; getbyteout = 107; } // Включить нагреватель, ожидание приема символа "k" (107)
                        if (send == 11) { sendbyte = 'L'; getbyteout = 108; } // Выключить нагреватель, ожидание приема символа "l" (108)
                        if (send == 12) { sendbyte = 'N'; getbyteout = 110; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет возврат в исходное состояние\n")); } // Возврат в исходное состояние, ожидание приема символа "n" (110)
                        byte[] buffer = new byte[] { Convert.ToByte(sendbyte) };
                        while (n <= sendimp)
                        {
                            if (getbyte == 0)
                            {
                                // Смещение по оси и вывод координаты (или конец движения)
                                if (corecoord == 1 && X < maxX) { X = X + 1; label23.Invoke(new Action(() => label23.Text = "X: " + Convert.ToInt32(X))); richTextBox5.Invoke(new Action(() => richTextBox5.Text = "Текущая координата\nОсь X: " + Convert.ToInt32(X) + "\nОсь Z: " + Convert.ToInt32(Z) + "\nОсь Y: " + Convert.ToInt32(Y))); }
                                //if (corecoord == 1 && X == maxX) { richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Достигнуто максимальное положение по X, движение остановлено\n")); break; }
                                if (corecoord == 2 && X > minX) { X = X - 1; label23.Invoke(new Action(() => label23.Text = "X: " + Convert.ToInt32(X))); richTextBox5.Invoke(new Action(() => richTextBox5.Text = "Текущая координата\nОсь X: " + Convert.ToInt32(X) + "\nОсь Z: " + Convert.ToInt32(Z) + "\nОсь Y: " + Convert.ToInt32(Y))); }
                               // if (corecoord == 2 && X == minX) { richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Достигнуто минимальное положение по X, движение остановлено\n")); break; }
                                if (corecoord == 3 && Z > minZ) { Z = Z - 1; label39.Invoke(new Action(() => label39.Text = "Z: " + Convert.ToInt32(Z))); richTextBox5.Invoke(new Action(() => richTextBox5.Text = "Текущая координата\nОсь X: " + Convert.ToInt32(X) + "\nОсь Z: " + Convert.ToInt32(Z) + "\nОсь Y: " + Convert.ToInt32(Y))); }
                               // if (corecoord == 3 && Z == minZ) { richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Достигнуто минимальное положение по Z, движение остановлено\n")); break; }
                                if (corecoord == 4 && Z < maxZ) { Z = Z + 1; label39.Invoke(new Action(() => label39.Text = "Z: " + Convert.ToInt32(Z))); richTextBox5.Invoke(new Action(() => richTextBox5.Text = "Текущая координата\nОсь X: " + Convert.ToInt32(X) + "\nОсь Z: " + Convert.ToInt32(Z) + "\nОсь Y: " + Convert.ToInt32(Y))); }
                               // if (corecoord == 4 && Z == maxZ) { richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Достигнуто максимальное положение по Z, движение остановлено\n")); break; }
                                // Анимация вентиля и нагревателя
                                if (send == 8) { pictureBox3.Invoke(new Action(() => pictureBox3.Visible = false)); pictureBox29.Invoke(new Action(() => pictureBox29.Visible = true)); Thread.Sleep(500); }
                                if (send == 9) { pictureBox3.Invoke(new Action(() => pictureBox3.Visible = true)); pictureBox29.Invoke(new Action(() => pictureBox29.Visible = false)); Thread.Sleep(500); }
                                if (send == 10) { pictureBox4.Invoke(new Action(() => pictureBox4.Visible = false)); pictureBox30.Invoke(new Action(() => pictureBox30.Visible = true)); Thread.Sleep(500); }
                                if (send == 11) { pictureBox4.Invoke(new Action(() => pictureBox4.Visible = true)); pictureBox30.Invoke(new Action(() => pictureBox30.Visible = false)); Thread.Sleep(500); } 
                                port.Write(buffer, 0, 1);
                                getbyte = 999;
                                Thread.Sleep(10);
                                progressBar1.Invoke(new Action(() => progressBar1.Value = n));
                                if (ton == 0)
                                {
                                    // Включение потока с миганием
                                    // Влево
                                    if (X <= grZS && minX <= X && (corecoord == 1 || corecoord == 2)) { pictureBox6.Invoke(new Action(() => pictureBox6.Visible = false)); pictureBox10.Invoke(new Action(() => pictureBox10.Visible = false)); timer1open1 = 1; ton = 1; migmig = 1; }
                                    if (X <= grZO2 && grZO1 <= X && (corecoord == 1 || corecoord == 2)) { pictureBox2.Invoke(new Action(() => pictureBox2.Visible = false)); pictureBox7.Invoke(new Action(() => pictureBox7.Visible = false)); timer1open1 = 1; ton = 1; migmig = 2; }
                                    if (X <= maxX && grZT <= X && (corecoord == 1 || corecoord == 2)) { pictureBox1.Invoke(new Action(() => pictureBox1.Visible = false)); pictureBox5.Invoke(new Action(() => pictureBox5.Visible = false)); timer1open1 = 1; ton = 1; migmig = 3; }
                                    if (X <= grZO1 - 3 && grZS + 3 <= X && corecoord == 1) { label50.Invoke(new Action(() => label50.ForeColor = Color.LimeGreen)); label72.Invoke(new Action(() => label72.ForeColor = Color.LimeGreen)); label49.Invoke(new Action(() => label49.ForeColor = Color.Black)); label71.Invoke(new Action(() => label71.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 4; }
                                    if (X <= grZT - 3 && grZO2 + 3 <= X && corecoord == 1) { label46.Invoke(new Action(() => label46.ForeColor = Color.LimeGreen)); label70.Invoke(new Action(() => label70.ForeColor = Color.LimeGreen)); label30.Invoke(new Action(() => label30.ForeColor = Color.Black)); label69.Invoke(new Action(() => label69.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 5; }
                                    // Вправо
                                    if (X <= grZO1 - 3 && grZS + 3 <= X && corecoord == 2) { label49.Invoke(new Action(() => label49.ForeColor = Color.LimeGreen)); label71.Invoke(new Action(() => label71.ForeColor = Color.LimeGreen)); label50.Invoke(new Action(() => label50.ForeColor = Color.Black)); label72.Invoke(new Action(() => label72.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 6; }
                                    if (X <= grZT - 3 && grZO2 + 3 <= X && corecoord == 2) { label30.Invoke(new Action(() => label30.ForeColor = Color.LimeGreen)); label69.Invoke(new Action(() => label69.ForeColor = Color.LimeGreen)); label46.Invoke(new Action(() => label46.ForeColor = Color.Black)); label70.Invoke(new Action(() => label70.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 7; }
                                    // Вниз
                                    if (Z < maxZ - 3 && minZ + 3 < Z && X <= grZO2 && grZO1 <= X && corecoord == 4) { label38.Invoke(new Action(() => label38.ForeColor = Color.LimeGreen)); label31.Invoke(new Action(() => label31.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 8; }
                                    if (Z < maxZ - 3 && minZ + 3 < Z && X <= maxX && grZT <= X && corecoord == 4) { label45.Invoke(new Action(() => label45.ForeColor = Color.LimeGreen)); label44.Invoke(new Action(() => label44.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 9; }
                                    // Вверх
                                    if (Z < maxZ - 3 && minZ + 3 < Z && X <= grZO2 && grZO1 <= X && corecoord == 3) { label31.Invoke(new Action(() => label31.ForeColor = Color.LimeGreen)); label38.Invoke(new Action(() => label38.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 10; }
                                    if (Z < maxZ - 3 && minZ + 3 < Z && X <= maxX && grZT <= X && corecoord == 3) { label44.Invoke(new Action(() => label44.ForeColor = Color.LimeGreen)); label45.Invoke(new Action(() => label45.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 11; }
                                }
                                // Остановка анимации (отключение потока)
                                // Влево
                                if ((X == grZS + 1 || X == minX + 1) && (corecoord == 1 || corecoord == 2) && migmig == 1) { ton = 0; migmig = 0; pictureBox6.Invoke(new Action(() => pictureBox6.Visible = true)); pictureBox10.Invoke(new Action(() => pictureBox10.Visible = true)); timer1open1 = 999; pictureBox27.Invoke(new Action(() => pictureBox27.Visible = false)); pictureBox11.Invoke(new Action(() => pictureBox11.Visible = false)); }
                                if ((X == grZO1 - 1 || X == grZO2 + 1) && (corecoord == 1 || corecoord == 2) && migmig == 2) { ton = 0; migmig = 0; pictureBox2.Invoke(new Action(() => pictureBox2.Visible = true)); pictureBox7.Invoke(new Action(() => pictureBox7.Visible = true)); timer1open1 = 999; pictureBox26.Invoke(new Action(() => pictureBox26.Visible = false)); pictureBox28.Invoke(new Action(() => pictureBox28.Visible = false)); }
                                if ((X == grZT - 1 || X == maxX - 1) && (corecoord == 1 || corecoord == 2) && migmig == 3) { ton = 0; migmig = 0; pictureBox1.Invoke(new Action(() => pictureBox1.Visible = true)); pictureBox5.Invoke(new Action(() => pictureBox5.Visible = true)); timer1open1 = 999; pictureBox25.Invoke(new Action(() => pictureBox25.Visible = false)); pictureBox12.Invoke(new Action(() => pictureBox12.Visible = false)); }
                                if (X == grZO1 - 2 && corecoord == 1 && migmig == 4) { ton = 0; migmig = 0; timer1open1 = 0; label50.Invoke(new Action(() => label50.ForeColor = Color.Black)); label72.Invoke(new Action(() => label72.ForeColor = Color.Black)); }
                                if (X == grZT - 2 && corecoord == 1 && migmig == 5) { ton = 0; migmig = 0; timer1open1 = 0; label46.Invoke(new Action(() => label46.ForeColor = Color.Black)); label70.Invoke(new Action(() => label70.ForeColor = Color.Black)); }
                                // Вправо
                                if (X == grZO2 + 2 && corecoord == 2 && migmig == 7) { ton = 0; migmig = 0; timer1open1 = 0; label30.Invoke(new Action(() => label30.ForeColor = Color.Black)); label69.Invoke(new Action(() => label69.ForeColor = Color.Black)); }
                                if (X == grZS + 2 && corecoord == 2 && migmig == 6) { ton = 0; migmig = 0; timer1open1 = 0; label49.Invoke(new Action(() => label49.ForeColor = Color.Black)); label71.Invoke(new Action(() => label71.ForeColor = Color.Black)); }
                                // Вниз
                                if (Z == maxZ - 2 && corecoord == 4 && migmig == 8) { ton = 0; migmig = 0; timer1open1 = 0; label38.Invoke(new Action(() => label38.ForeColor = Color.Black)); }
                                if (Z == maxZ - 2 && corecoord == 4 && migmig == 9) { ton = 0; migmig = 0; timer1open1 = 0; label45.Invoke(new Action(() => label45.ForeColor = Color.Black)); }
                                // Вверх
                                if (X == minZ + 2 && corecoord == 3 && migmig == 10) { ton = 0; migmig = 0; timer1open1 = 0; label31.Invoke(new Action(() => label31.ForeColor = Color.Black)); }
                                if (X == minZ + 2 && corecoord == 3 && migmig == 11) { ton = 0; migmig = 0; timer1open1 = 0; label44.Invoke(new Action(() => label44.ForeColor = Color.Black)); }
                            }
                            if (getbyte == getbyteout)
                            {
                                n++;
                                getbyte = 0;
                            }
                        }
                        send = 0;
                        progressBar2.Invoke(new Action(() => progressBar2.Value = progressBar2.Value + 1));
                        // Зажечь на постоянно зеленый если над позицией
                        if (X <= grZS && minX <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); pictureBox6.Invoke(new Action(() => pictureBox6.Visible = false)); pictureBox10.Invoke(new Action(() => pictureBox10.Visible = false)); pictureBox27.Invoke(new Action(() => pictureBox27.Visible = true)); pictureBox11.Invoke(new Action(() => pictureBox11.Visible = true)); } else { pictureBox6.Invoke(new Action(() => pictureBox6.Visible = true)); pictureBox10.Invoke(new Action(() => pictureBox10.Visible = true)); pictureBox27.Invoke(new Action(() => pictureBox27.Visible = false)); pictureBox11.Invoke(new Action(() => pictureBox11.Visible = false)); }
                        if (X <= grZO2 && grZO1 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); pictureBox2.Invoke(new Action(() => pictureBox2.Visible = false)); pictureBox7.Invoke(new Action(() => pictureBox7.Visible = false)); pictureBox26.Invoke(new Action(() => pictureBox26.Visible = true)); pictureBox28.Invoke(new Action(() => pictureBox28.Visible = true)); } else { pictureBox2.Invoke(new Action(() => pictureBox2.Visible = true)); pictureBox7.Invoke(new Action(() => pictureBox7.Visible = true)); pictureBox26.Invoke(new Action(() => pictureBox26.Visible = false)); pictureBox8.Invoke(new Action(() => pictureBox8.Visible = false)); }
                        if (X <= maxX && grZT <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); pictureBox1.Invoke(new Action(() => pictureBox1.Visible = false)); pictureBox5.Invoke(new Action(() => pictureBox5.Visible = false)); pictureBox25.Invoke(new Action(() => pictureBox25.Visible = true)); pictureBox12.Invoke(new Action(() => pictureBox12.Visible = true)); } else { pictureBox1.Invoke(new Action(() => pictureBox1.Visible = true)); pictureBox5.Invoke(new Action(() => pictureBox5.Visible = true)); pictureBox25.Invoke(new Action(() => pictureBox25.Visible = false)); pictureBox12.Invoke(new Action(() => pictureBox12.Visible = false)); }
                        if (X <= grZO1 - 3 && grZS + 3 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label50.Invoke(new Action(() => label50.ForeColor = Color.LimeGreen)); label72.Invoke(new Action(() => label72.ForeColor = Color.LimeGreen)); } else { label50.Invoke(new Action(() => label50.ForeColor = Color.Black)); label72.Invoke(new Action(() => label72.ForeColor = Color.Black)); }
                        if (X <= grZT - 3 && grZO2 + 3 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label46.Invoke(new Action(() => label46.ForeColor = Color.LimeGreen)); label70.Invoke(new Action(() => label70.ForeColor = Color.LimeGreen)); } else { label46.Invoke(new Action(() => label46.ForeColor = Color.Black)); label70.Invoke(new Action(() => label70.ForeColor = Color.Black)); }
                        if (X <= grZO1 - 3 && grZS + 3 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label49.Invoke(new Action(() => label49.ForeColor = Color.LimeGreen)); label71.Invoke(new Action(() => label71.ForeColor = Color.LimeGreen)); } else { label49.Invoke(new Action(() => label49.ForeColor = Color.Black)); label71.Invoke(new Action(() => label71.ForeColor = Color.Black)); }
                        if (X <= grZT - 3 && grZO2 + 3 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label30.Invoke(new Action(() => label30.ForeColor = Color.LimeGreen)); label69.Invoke(new Action(() => label69.ForeColor = Color.LimeGreen)); } else { label30.Invoke(new Action(() => label30.ForeColor = Color.Black)); label69.Invoke(new Action(() => label69.ForeColor = Color.Black)); }
                        if (Z < maxZ - 3 && minZ + 3 < Z && X <= grZO2 && grZO1 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label31.Invoke(new Action(() => label31.ForeColor = Color.LimeGreen)); label38.Invoke(new Action(() => label38.ForeColor = Color.LimeGreen)); } else { label31.Invoke(new Action(() => label31.ForeColor = Color.Black)); label38.Invoke(new Action(() => label38.ForeColor = Color.Black)); }
                        if (Z < maxZ - 3 && minZ + 3 < Z && X <= maxX && grZT <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label44.Invoke(new Action(() => label44.ForeColor = Color.LimeGreen)); label45.Invoke(new Action(() => label45.ForeColor = Color.LimeGreen)); } else { label44.Invoke(new Action(() => label44.ForeColor = Color.Black)); label45.Invoke(new Action(() => label45.ForeColor = Color.Black)); }
                    }
                }
            //    Подключить.Invoke(new Action(() => Подключить.Enabled = true));
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка: " + ex.Message);
                return;
            }
        }

        // Режим симуляции работы программы

        private void button42_Click(object sender, EventArgs e)
        {
            // Основная программа. Запуск симуляции
            Thread3 = new Thread(StartAlg3);
            Thread3.Start();
            button36.Enabled = false;
            Подключить.Enabled = false;
        }

        private void StartAlg3()
        {
            try
            {
                progressBar2.Invoke(new Action(() => progressBar2.Maximum = richTextBox3.Lines.Length - 1));
                progressBar2.Invoke(new Action(() => progressBar2.Value = 0));
                string allstring = "";
                richTextBox3.Invoke(new Action(() => allstring = richTextBox3.Text));
                string[] split = allstring.Split(new Char[] { ' ', '\n' });
                int dallstring = split.Length;
                int send = 0;
                int sendimp = 0;
                for (int i = 0; i < dallstring; i++)
                {
                    if (split[i] == "Движение" && split[i + 1] == "влево" && split[i + 4] == "X") { send = 1; sendimp = Convert.ToInt32(split[i + 6]); }
                    if (split[i] == "Движение" && split[i + 1] == "вправо" && split[i + 4] == "X") { send = 2; sendimp = Convert.ToInt32(split[i + 6]); }
                    if (split[i] == "Движение" && split[i + 1] == "вверх" && split[i + 4] == "Z") { send = 3; sendimp = Convert.ToInt32(split[i + 6]); }
                    if (split[i] == "Движение" && split[i + 1] == "вниз" && split[i + 4] == "Z") { send = 4; sendimp = Convert.ToInt32(split[i + 6]); }
                    if (split[i] == "Время" && split[i + 1] == "сушки") { send = 7; sendimp = Convert.ToInt32(split[i + 2]); }
                    if (split[i] == "Включить" && split[i + 1] == "вентилятор") { send = 8; sendimp = 1; }
                    if (split[i] == "Выключить" && split[i + 1] == "вентилятор") { send = 9; sendimp = 1; }
                    if (split[i] == "Включить" && split[i + 1] == "нагреватель") { send = 10; sendimp = 1; }
                    if (split[i] == "Выключить" && split[i + 1] == "нагреватель") { send = 11; sendimp = 1; }
                    if (split[i] == "Возврат" && split[i + 1] == "в") { send = 12; sendimp = 1; }
                    if (send != 0)
                    {
                        getbyte = 0;
                        progressBar1.Invoke(new Action(() => progressBar1.Maximum = sendimp));
                        progressBar1.Invoke(new Action(() => progressBar1.Value = 0));
                        char sendbyte = '.'; // Пустое значение
                        int getbyteout = 999; // Пустое значение
                        int n = 1; // Счетчик импульсов
                        if (send == 1) { sendbyte = 'A'; getbyteout = 97; corecoord = 1; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет движение влево по оси X\n")); } // Движение влево по оси X, ожидание приема символа "а" (97)
                        if (send == 2) { sendbyte = 'B'; getbyteout = 98; corecoord = 2; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет движение вправо по оси X\n")); } // Движение вправо по оси X, ожидание приема символа "b" (98)
                        if (send == 3) { sendbyte = 'C'; getbyteout = 99; corecoord = 3; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет движение вверх по оси Z\n")); } // Движение влево по оси Z, ожидание приема символа "c" (99)
                        if (send == 4) { sendbyte = 'D'; getbyteout = 100; corecoord = 4; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет движение вниз по оси Z\n")); } // Движение вправо по оси Z, ожидание приема символа "d" (100)
                        if (send == 7) { sendbyte = 'T'; getbyteout = 116; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет сушка платы(" + textBox8.Text +" сек.)\n")); } // Включить таймер ожидания, ожидание приема символа "t" (116)
                        if (send == 8) { sendbyte = 'O'; getbyteout = 111; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Включен вентилятор\n")); } // Включить вентилятор, ожидание приема символа "o" (111)
                        if (send == 9) { sendbyte = 'P'; getbyteout = 112; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Вентялитор выключен\n")); } // Выключить вентилятор, ожидание приема символа "p" (112)
                        if (send == 10) { sendbyte = 'K'; getbyteout = 107; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Нагреватель включен\n")); } // Включить нагреватель, ожидание приема символа "k" (107)
                        if (send == 11) { sendbyte = 'L'; getbyteout = 108; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Нагреватель выключен\n")); } // Выключить нагреватель, ожидание приема символа "l" (108)
                        if (send == 12) { sendbyte = 'N'; getbyteout = 110; richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Идет возврат в исходное состояние\n")); } // Возврат в исходное состояние, ожидание приема символа "n" (110)
                        byte[] buffer = new byte[] { Convert.ToByte(sendbyte) };
                        while (n <= sendimp)
                        {
                            if (getbyte == 0)
                            {
                                // Смещение по оси и вывод координаты (или конец движения)
                                if (corecoord == 1 && X < maxX) { X = X + 1; label23.Invoke(new Action(() => label23.Text = "X: " + Convert.ToInt32(X))); richTextBox5.Invoke(new Action(() => richTextBox5.Text = "Текущая координата\nОсь X: " + Convert.ToInt32(X) + "\nОсь Z: " + Convert.ToInt32(Z) + "\nОсь Y: " + Convert.ToInt32(Y))); }
                                if (corecoord == 1 && X == maxX) { richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Достигнуто максимальное положение по X, движение остановлено\n")); break; }
                                if (corecoord == 2 && X > minX) { X = X - 1; label23.Invoke(new Action(() => label23.Text = "X: " + Convert.ToInt32(X))); richTextBox5.Invoke(new Action(() => richTextBox5.Text = "Текущая координата\nОсь X: " + Convert.ToInt32(X) + "\nОсь Z: " + Convert.ToInt32(Z) + "\nОсь Y: " + Convert.ToInt32(Y))); }
                                if (corecoord == 2 && X == minX) { richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Достигнуто минимальное положение по X, движение остановлено\n")); break; }
                                if (corecoord == 3 && Z > minZ) { Z = Z - 1; label39.Invoke(new Action(() => label39.Text = "Z: " + Convert.ToInt32(Z))); richTextBox5.Invoke(new Action(() => richTextBox5.Text = "Текущая координата\nОсь X: " + Convert.ToInt32(X) + "\nОсь Z: " + Convert.ToInt32(Z) + "\nОсь Y: " + Convert.ToInt32(Y))); }
                                if (corecoord == 3 && Z == minZ) { richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Достигнуто минимальное положение по Z, движение остановлено\n")); break; }
                                if (corecoord == 4 && Z < maxZ) { Z = Z + 1; label39.Invoke(new Action(() => label39.Text = "Z: " + Convert.ToInt32(Z))); richTextBox5.Invoke(new Action(() => richTextBox5.Text = "Текущая координата\nОсь X: " + Convert.ToInt32(X) + "\nОсь Z: " + Convert.ToInt32(Z) + "\nОсь Y: " + Convert.ToInt32(Y))); }
                                if (corecoord == 4 && Z == maxZ) { richTextBox4.Invoke(new Action(() => richTextBox4.Text = richTextBox4.Text + "Достигнуто максимальное положение по Z, движение остановлено\n")); break; }
                                // Анимация вентиля и нагревателя
                                if (send == 8) { pictureBox3.Invoke(new Action(() => pictureBox3.Visible = false)); pictureBox29.Invoke(new Action(() => pictureBox29.Visible = true)); Thread.Sleep(500); }
                                if (send == 9) { pictureBox3.Invoke(new Action(() => pictureBox3.Visible = true)); pictureBox29.Invoke(new Action(() => pictureBox29.Visible = false)); Thread.Sleep(500); }
                                if (send == 10) { pictureBox4.Invoke(new Action(() => pictureBox4.Visible = false)); pictureBox30.Invoke(new Action(() => pictureBox30.Visible = true)); Thread.Sleep(500); }
                                if (send == 11) { pictureBox4.Invoke(new Action(() => pictureBox4.Visible = true)); pictureBox30.Invoke(new Action(() => pictureBox30.Visible = false)); Thread.Sleep(500); } 
                                //Время ожидания
                                if (send == 7) { label88.Invoke(new Action(() => label88.Text = "Время выполнения сушки платы: " + Convert.ToString(n) + " сек.")); Thread.Sleep(1000); }
                                //port.Write(buffer, 0, 1);
                                getbyte = getbyteout;
                                Thread.Sleep(10);
                                progressBar1.Invoke(new Action(() => progressBar1.Value = n));
                                if (ton == 0)
                                {
                                    // Включение потока с миганием
                                    // Влево
                                    if (X <= grZS && minX <= X && (corecoord == 1 || corecoord == 2)) { pictureBox6.Invoke(new Action(() => pictureBox6.Visible = false)); pictureBox10.Invoke(new Action(() => pictureBox10.Visible = false)); timer1open1 = 1; ton = 1; migmig = 1; }
                                    if (X <= grZO2 && grZO1 <= X && (corecoord == 1 || corecoord == 2)) { pictureBox2.Invoke(new Action(() => pictureBox2.Visible = false)); pictureBox7.Invoke(new Action(() => pictureBox7.Visible = false)); timer1open1 = 1; ton = 1; migmig = 2; }
                                    if (X <= maxX && grZT <= X && (corecoord == 1 || corecoord == 2)) { pictureBox1.Invoke(new Action(() => pictureBox1.Visible = false)); pictureBox5.Invoke(new Action(() => pictureBox5.Visible = false)); timer1open1 = 1; ton = 1; migmig = 3; }
                                    if (X <= grZO1 - 3 && grZS + 3 <= X && corecoord == 1) { label50.Invoke(new Action(() => label50.ForeColor = Color.LimeGreen)); label72.Invoke(new Action(() => label72.ForeColor = Color.LimeGreen)); label49.Invoke(new Action(() => label49.ForeColor = Color.Black)); label71.Invoke(new Action(() => label71.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 4; }
                                    if (X <= grZT - 3 && grZO2 + 3 <= X && corecoord == 1) { label46.Invoke(new Action(() => label46.ForeColor = Color.LimeGreen)); label70.Invoke(new Action(() => label70.ForeColor = Color.LimeGreen)); label30.Invoke(new Action(() => label30.ForeColor = Color.Black)); label69.Invoke(new Action(() => label69.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 5; }
                                    // Вправо
                                    if (X <= grZO1 - 3 && grZS + 3 <= X && corecoord == 2) { label49.Invoke(new Action(() => label49.ForeColor = Color.LimeGreen)); label71.Invoke(new Action(() => label71.ForeColor = Color.LimeGreen)); label50.Invoke(new Action(() => label50.ForeColor = Color.Black)); label72.Invoke(new Action(() => label72.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 6; }
                                    if (X <= grZT - 3 && grZO2 + 3 <= X && corecoord == 2) { label30.Invoke(new Action(() => label30.ForeColor = Color.LimeGreen)); label69.Invoke(new Action(() => label69.ForeColor = Color.LimeGreen)); label46.Invoke(new Action(() => label46.ForeColor = Color.Black)); label70.Invoke(new Action(() => label70.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 7; }
                                    // Вниз
                                    if (Z < maxZ - 3 && minZ + 3 < Z && X <= grZO2 && grZO1 <= X && corecoord == 4) { label38.Invoke(new Action(() => label38.ForeColor = Color.LimeGreen)); label31.Invoke(new Action(() => label31.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 8; }
                                    if (Z < maxZ - 3 && minZ + 3 < Z && X <= maxX && grZT <= X && corecoord == 4) { label45.Invoke(new Action(() => label45.ForeColor = Color.LimeGreen)); label44.Invoke(new Action(() => label44.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 9; }
                                    // Вверх
                                    if (Z < maxZ - 3 && minZ + 3 < Z && X <= grZO2 && grZO1 <= X && corecoord == 3) { label31.Invoke(new Action(() => label31.ForeColor = Color.LimeGreen)); label38.Invoke(new Action(() => label38.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 10; }
                                    if (Z < maxZ - 3 && minZ + 3 < Z && X <= maxX && grZT <= X && corecoord == 3) { label44.Invoke(new Action(() => label44.ForeColor = Color.LimeGreen)); label45.Invoke(new Action(() => label45.ForeColor = Color.Black)); timer1open1 = 1; ton = 1; migmig = 11; }
                                }
                                // Остановка анимации (отключение потока)
                                // Влево
                                if ((X == grZS + 1 || X == minX + 1) && (corecoord == 1 || corecoord == 2) && migmig == 1) { ton = 0; migmig = 0; pictureBox6.Invoke(new Action(() => pictureBox6.Visible = true)); pictureBox10.Invoke(new Action(() => pictureBox10.Visible = true)); timer1open1 = 999; pictureBox27.Invoke(new Action(() => pictureBox27.Visible = false)); pictureBox11.Invoke(new Action(() => pictureBox11.Visible = false)); }
                                if ((X == grZO1 - 1 || X == grZO2 + 1) && (corecoord == 1 || corecoord == 2) && migmig == 2) { ton = 0; migmig = 0; pictureBox2.Invoke(new Action(() => pictureBox2.Visible = true)); pictureBox7.Invoke(new Action(() => pictureBox7.Visible = true)); timer1open1 = 999; pictureBox26.Invoke(new Action(() => pictureBox26.Visible = false)); pictureBox28.Invoke(new Action(() => pictureBox28.Visible = false)); }
                                if ((X == grZT - 1 || X == maxX - 1) && (corecoord == 1 || corecoord == 2) && migmig == 3) { ton = 0; migmig = 0; pictureBox1.Invoke(new Action(() => pictureBox1.Visible = true)); pictureBox5.Invoke(new Action(() => pictureBox5.Visible = true)); timer1open1 = 999; pictureBox25.Invoke(new Action(() => pictureBox25.Visible = false)); pictureBox12.Invoke(new Action(() => pictureBox12.Visible = false)); }
                                if (X == grZO1 - 2 && corecoord == 1 && migmig == 4) { ton = 0; migmig = 0; timer1open1 = 0; label50.Invoke(new Action(() => label50.ForeColor = Color.Black)); label72.Invoke(new Action(() => label72.ForeColor = Color.Black)); }
                                if (X == grZT - 2 && corecoord == 1 && migmig == 5) { ton = 0; migmig = 0; timer1open1 = 0; label46.Invoke(new Action(() => label46.ForeColor = Color.Black)); label70.Invoke(new Action(() => label70.ForeColor = Color.Black)); }
                                // Вправо
                                if (X == grZO2 + 2 && corecoord == 2 && migmig == 7) { ton = 0; migmig = 0; timer1open1 = 0; label30.Invoke(new Action(() => label30.ForeColor = Color.Black)); label69.Invoke(new Action(() => label69.ForeColor = Color.Black)); }
                                if (X == grZS + 2 && corecoord == 2 && migmig == 6) { ton = 0; migmig = 0; timer1open1 = 0; label49.Invoke(new Action(() => label49.ForeColor = Color.Black)); label71.Invoke(new Action(() => label71.ForeColor = Color.Black)); }
                                // Вниз
                                if (Z == maxZ - 2 && corecoord == 4 && migmig == 8) { ton = 0; migmig = 0; timer1open1 = 0; label38.Invoke(new Action(() => label38.ForeColor = Color.Black)); }
                                if (Z == maxZ - 2 && corecoord == 4 && migmig == 9) { ton = 0; migmig = 0; timer1open1 = 0; label45.Invoke(new Action(() => label45.ForeColor = Color.Black)); }
                                // Вверх
                                if (X == minZ + 2 && corecoord == 3 && migmig == 10) { ton = 0; migmig = 0; timer1open1 = 0; label31.Invoke(new Action(() => label31.ForeColor = Color.Black)); }
                                if (X == minZ + 2 && corecoord == 3 && migmig == 11) { ton = 0; migmig = 0; timer1open1 = 0; label44.Invoke(new Action(() => label44.ForeColor = Color.Black)); }
                            }
                            if (getbyte == getbyteout)
                            {
                                n++;
                                getbyte = 0;
                            }
                        }
                        send = 0;
                        progressBar2.Invoke(new Action(() => progressBar2.Value = progressBar2.Value + 1));
                        // Зажечь на постоянно зеленый если над позицией
                        if (X <= grZS && minX <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); pictureBox6.Invoke(new Action(() => pictureBox6.Visible = false)); pictureBox10.Invoke(new Action(() => pictureBox10.Visible = false)); pictureBox27.Invoke(new Action(() => pictureBox27.Visible = true)); pictureBox11.Invoke(new Action(() => pictureBox11.Visible = true)); } else { pictureBox6.Invoke(new Action(() => pictureBox6.Visible = true)); pictureBox10.Invoke(new Action(() => pictureBox10.Visible = true)); pictureBox27.Invoke(new Action(() => pictureBox27.Visible = false)); pictureBox11.Invoke(new Action(() => pictureBox11.Visible = false)); }
                        if (X <= grZO2 && grZO1 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); pictureBox2.Invoke(new Action(() => pictureBox2.Visible = false)); pictureBox7.Invoke(new Action(() => pictureBox7.Visible = false)); pictureBox26.Invoke(new Action(() => pictureBox26.Visible = true)); pictureBox28.Invoke(new Action(() => pictureBox28.Visible = true)); } else { pictureBox2.Invoke(new Action(() => pictureBox2.Visible = true)); pictureBox7.Invoke(new Action(() => pictureBox7.Visible = true)); pictureBox26.Invoke(new Action(() => pictureBox26.Visible = false)); pictureBox8.Invoke(new Action(() => pictureBox8.Visible = false)); }
                        if (X <= maxX && grZT <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); pictureBox1.Invoke(new Action(() => pictureBox1.Visible = false)); pictureBox5.Invoke(new Action(() => pictureBox5.Visible = false)); pictureBox25.Invoke(new Action(() => pictureBox25.Visible = true)); pictureBox12.Invoke(new Action(() => pictureBox12.Visible = true)); } else { pictureBox1.Invoke(new Action(() => pictureBox1.Visible = true)); pictureBox5.Invoke(new Action(() => pictureBox5.Visible = true)); pictureBox25.Invoke(new Action(() => pictureBox25.Visible = false)); pictureBox12.Invoke(new Action(() => pictureBox12.Visible = false)); }
                        if (X <= grZO1 - 3 && grZS + 3 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label50.Invoke(new Action(() => label50.ForeColor = Color.LimeGreen)); label72.Invoke(new Action(() => label72.ForeColor = Color.LimeGreen)); } else { label50.Invoke(new Action(() => label50.ForeColor = Color.Black)); label72.Invoke(new Action(() => label72.ForeColor = Color.Black)); }
                        if (X <= grZT - 3 && grZO2 + 3 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label46.Invoke(new Action(() => label46.ForeColor = Color.LimeGreen)); label70.Invoke(new Action(() => label70.ForeColor = Color.LimeGreen)); } else { label46.Invoke(new Action(() => label46.ForeColor = Color.Black)); label70.Invoke(new Action(() => label70.ForeColor = Color.Black)); }
                        if (X <= grZO1 - 3 && grZS + 3 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label49.Invoke(new Action(() => label49.ForeColor = Color.LimeGreen)); label71.Invoke(new Action(() => label71.ForeColor = Color.LimeGreen)); } else { label49.Invoke(new Action(() => label49.ForeColor = Color.Black)); label71.Invoke(new Action(() => label71.ForeColor = Color.Black)); }
                        if (X <= grZT - 3 && grZO2 + 3 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label30.Invoke(new Action(() => label30.ForeColor = Color.LimeGreen)); label69.Invoke(new Action(() => label69.ForeColor = Color.LimeGreen)); } else { label30.Invoke(new Action(() => label30.ForeColor = Color.Black)); label69.Invoke(new Action(() => label69.ForeColor = Color.Black)); }
                        if (Z < maxZ - 3 && minZ + 3 < Z && X <= grZO2 && grZO1 <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label31.Invoke(new Action(() => label31.ForeColor = Color.LimeGreen)); label38.Invoke(new Action(() => label38.ForeColor = Color.LimeGreen)); } else { label31.Invoke(new Action(() => label31.ForeColor = Color.Black)); label38.Invoke(new Action(() => label38.ForeColor = Color.Black)); }
                        if (Z < maxZ - 3 && minZ + 3 < Z && X <= maxX && grZT <= X) { ton = 0; timer1open1 = 0; Thread.Sleep(550); label44.Invoke(new Action(() => label44.ForeColor = Color.LimeGreen)); label45.Invoke(new Action(() => label45.ForeColor = Color.LimeGreen)); } else { label44.Invoke(new Action(() => label44.ForeColor = Color.Black)); label45.Invoke(new Action(() => label45.ForeColor = Color.Black)); }
                    }
                }
                Подключить.Invoke(new Action(() => Подключить.Enabled = true));
            }
            catch (Exception ex)
            {
                MessageBox.Show("Ошибка: " + ex.Message);
                return;
            }
        }

        // Поток для мигания изображениями в автоматическом режиме
        private void StartAlg1()
        {
            while (true)
            {
                if (timer1open1 == 1)
                {
                    if ((corecoord == 1 || corecoord == 2) && migmig == 1)
                    {
                        pictureBox27.Invoke(new Action(() => pictureBox27.Visible = true));
                        pictureBox11.Invoke(new Action(() => pictureBox11.Visible = true));
                        Thread.Sleep(500);
                        pictureBox27.Invoke(new Action(() => pictureBox27.Visible = false));
                        pictureBox11.Invoke(new Action(() => pictureBox11.Visible = false));
                        Thread.Sleep(500);
                    }
                    if ((corecoord == 1 || corecoord == 2) && migmig == 2)
                    {
                        pictureBox26.Invoke(new Action(() => pictureBox26.Visible = true));
                        pictureBox28.Invoke(new Action(() => pictureBox28.Visible = true));
                        Thread.Sleep(500);
                        pictureBox26.Invoke(new Action(() => pictureBox26.Visible = false));
                        pictureBox28.Invoke(new Action(() => pictureBox28.Visible = false));
                        Thread.Sleep(500);
                    }
                    if ((corecoord == 1 || corecoord == 2) && migmig == 3)
                    {
                        pictureBox25.Invoke(new Action(() => pictureBox25.Visible = true));
                        pictureBox12.Invoke(new Action(() => pictureBox12.Visible = true));
                        Thread.Sleep(500);
                        pictureBox25.Invoke(new Action(() => pictureBox25.Visible = false));
                        pictureBox12.Invoke(new Action(() => pictureBox12.Visible = false));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 1 && migmig == 4)
                    {
                        label50.Invoke(new Action(() => label50.ForeColor = Color.LimeGreen));
                        label72.Invoke(new Action(() => label72.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label50.Invoke(new Action(() => label50.ForeColor = Color.Black));
                        label72.Invoke(new Action(() => label72.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 1 && migmig == 5)
                    {
                        label46.Invoke(new Action(() => label46.ForeColor = Color.LimeGreen));
                        label70.Invoke(new Action(() => label70.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label46.Invoke(new Action(() => label46.ForeColor = Color.Black));
                        label70.Invoke(new Action(() => label70.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 2 && migmig == 6)
                    {
                        label49.Invoke(new Action(() => label49.ForeColor = Color.LimeGreen));
                        label71.Invoke(new Action(() => label71.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label49.Invoke(new Action(() => label49.ForeColor = Color.Black));
                        label71.Invoke(new Action(() => label71.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 2 && migmig == 7)
                    {
                        label30.Invoke(new Action(() => label30.ForeColor = Color.LimeGreen));
                        label69.Invoke(new Action(() => label69.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label30.Invoke(new Action(() => label30.ForeColor = Color.Black));
                        label69.Invoke(new Action(() => label69.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 4 && migmig == 8)
                    {
                        label38.Invoke(new Action(() => label38.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label38.Invoke(new Action(() => label38.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 4 && migmig == 9)
                    {
                        label45.Invoke(new Action(() => label45.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label45.Invoke(new Action(() => label45.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 3 && migmig == 10)
                    {
                        label31.Invoke(new Action(() => label31.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label31.Invoke(new Action(() => label31.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 3 && migmig == 11)
                    {
                        label44.Invoke(new Action(() => label44.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label44.Invoke(new Action(() => label44.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                }

                if (timer1open2 == 1)
                {

                    if ((corecoord == 1 || corecoord == 2) && migmig == 1)
                    {
                        pictureBox27.Invoke(new Action(() => pictureBox27.Visible = true));
                        pictureBox11.Invoke(new Action(() => pictureBox11.Visible = true));
                        Thread.Sleep(500);
                        pictureBox27.Invoke(new Action(() => pictureBox27.Visible = false));
                        pictureBox11.Invoke(new Action(() => pictureBox11.Visible = false));
                        Thread.Sleep(500);
                    }
                    if ((corecoord == 1 || corecoord == 2) && migmig == 2)
                    {
                        pictureBox26.Invoke(new Action(() => pictureBox26.Visible = true));
                        pictureBox28.Invoke(new Action(() => pictureBox28.Visible = true));
                        Thread.Sleep(500);
                        pictureBox26.Invoke(new Action(() => pictureBox26.Visible = false));
                        pictureBox28.Invoke(new Action(() => pictureBox28.Visible = false));
                        Thread.Sleep(500);
                    }
                    if ((corecoord == 1 || corecoord == 2) && migmig == 3)
                    {
                        pictureBox25.Invoke(new Action(() => pictureBox25.Visible = true));
                        pictureBox12.Invoke(new Action(() => pictureBox12.Visible = true));
                        Thread.Sleep(500);
                        pictureBox25.Invoke(new Action(() => pictureBox25.Visible = false));
                        pictureBox12.Invoke(new Action(() => pictureBox12.Visible = false));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 1 && migmig == 4)
                    {
                        label50.Invoke(new Action(() => label50.ForeColor = Color.LimeGreen));
                        label72.Invoke(new Action(() => label72.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label50.Invoke(new Action(() => label50.ForeColor = Color.Black));
                        label72.Invoke(new Action(() => label72.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 1 && migmig == 5)
                    {
                        label46.Invoke(new Action(() => label46.ForeColor = Color.LimeGreen));
                        label70.Invoke(new Action(() => label70.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label46.Invoke(new Action(() => label46.ForeColor = Color.Black));
                        label70.Invoke(new Action(() => label70.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 2 && migmig == 6)
                    {
                        label49.Invoke(new Action(() => label49.ForeColor = Color.LimeGreen));
                        label71.Invoke(new Action(() => label71.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label49.Invoke(new Action(() => label49.ForeColor = Color.Black));
                        label71.Invoke(new Action(() => label71.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 2 && migmig == 7)
                    {
                        label30.Invoke(new Action(() => label30.ForeColor = Color.LimeGreen));
                        label69.Invoke(new Action(() => label69.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label30.Invoke(new Action(() => label30.ForeColor = Color.Black));
                        label69.Invoke(new Action(() => label69.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 4 && migmig == 8)
                    {
                        label38.Invoke(new Action(() => label38.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label38.Invoke(new Action(() => label38.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 4 && migmig == 9)
                    {
                        label45.Invoke(new Action(() => label45.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label45.Invoke(new Action(() => label45.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 3 && migmig == 10)
                    {
                        label31.Invoke(new Action(() => label31.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label31.Invoke(new Action(() => label31.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                    if (corecoord == 3 && migmig == 11)
                    {
                        label44.Invoke(new Action(() => label44.ForeColor = Color.LimeGreen));
                        Thread.Sleep(500);
                        label44.Invoke(new Action(() => label44.ForeColor = Color.Black));
                        Thread.Sleep(500);
                    }
                }

            }
        }

        // РУЧНОЕ УПРАВЛЕНИЕ

        private void button17_Click(object sender, EventArgs e)
        {
            // Ручное управление. Движение по оси X вправо
            byte[] buffer = new byte[] { Convert.ToByte("Q") };
            port.Write(buffer, 0, 1);
        }

        private void button13_Click(object sender, EventArgs e)
        {
            // Ручное управление. Движение по оси X влево
            byte[] buffer = new byte[] { Convert.ToByte("W") };
            port.Write(buffer, 0, 1);
        }

        private void button18_Click(object sender, EventArgs e)
        {
            // Ручное управление. Движение по оси Z вправо
            byte[] buffer = new byte[] { Convert.ToByte("Y") };
            port.Write(buffer, 0, 1);
        }

        private void button16_Click(object sender, EventArgs e)
        {
            // Ручное управление. Движение по оси Z влево
            byte[] buffer = new byte[] { Convert.ToByte("U") };
            port.Write(buffer, 0, 1);
        }

        private void button19_Click(object sender, EventArgs e)
        {
            // Ручное управление. Движение по оси Y вправо
           // byte[] buffer = new byte[] { Convert.ToByte("G") };
           // port.Write(buffer, 0, 1);
            char sendbyte = 'F'; // Пустое значение
            int getbyteout = 102; // Пустое значение
            byte[] buffer = new byte[] { Convert.ToByte(sendbyte) };
            while (2 <= 5)
            {
                if (getbyte == 0)
                {
                    port.Write(buffer, 0, 1);
                   // getbyte = getbyteout;
                    Thread.Sleep(10);
                   
                                     
                }
                if (getbyte == getbyteout)
                {
                    
                    getbyte = 0;
                }
            }

        }

        private void button14_Click(object sender, EventArgs e)
        {
            // Ручное управление. Движение по оси Y влево
           // byte[] buffer = new byte[] { Convert.ToByte("H") };
            //port.Write(buffer, 0, 1);

            char sendbyte = 'E'; // Пустое значение
            int getbyteout = 101; // Пустое значение
            byte[] buffer = new byte[] { Convert.ToByte(sendbyte) };
            while (2 <= 5)
            {
                if (getbyte == 0)
                {
                    port.Write(buffer, 0, 1);
                    // getbyte = getbyteout;
                    Thread.Sleep(10);


                }
                if (getbyte == getbyteout)
                {

                    getbyte = 0;
                }
            }

        }

        private void button15_Click(object sender, EventArgs e)
        {
            // Ручное управление. Включить вентилятор
            byte[] buffer = new byte[] { Convert.ToByte("O") };
            port.Write(buffer, 0, 1);
        }

        private void button12_Click(object sender, EventArgs e)
        {
            // Ручное управление. Выключить вентилятор
            byte[] buffer = new byte[] { Convert.ToByte("P") };
            port.Write(buffer, 0, 1);
        }

        private void button11_Click(object sender, EventArgs e)
        {
            // Ручное управление. Включить нагреватель
            byte[] buffer = new byte[] { Convert.ToByte("K") };
            port.Write(buffer, 0, 1);
        }

        private void button10_Click(object sender, EventArgs e)
        {
            // Ручное управление. Выключить нагреватель
            byte[] buffer = new byte[] { Convert.ToByte("L") };
            port.Write(buffer, 0, 1);
        }

        private void button21_Click(object sender, EventArgs e)
        {
            // Ручное управление. Возврат в исходное состояние
            byte[] buffer = new byte[] { Convert.ToByte("N") };
            port.Write(buffer, 0, 1);
        }

        private void button20_Click(object sender, EventArgs e)
        {
            // Ручное управление. Стоп
            byte[] buffer = new byte[] { Convert.ToByte("S") };
            port.Write(buffer, 0, 1);
        }

        //ЗАГРУЗЧИК

        private void button8_Click(object sender, EventArgs e)
        {
            // Загрузчик. Открытие файлов в asm формате
            OpenFileDialog openFile1 = new OpenFileDialog();
            openFile1.DefaultExt = "*.asm";
            openFile1.Filter = "ASM Files (*.asm)|*.asm";
            if (openFile1.ShowDialog() == System.Windows.Forms.DialogResult.OK &&
               openFile1.FileName.Length > 0)
            {
                string opentext = System.IO.File.ReadAllText(openFile1.FileName).Replace("\n", "");
                richTextBox1.Text = opentext;
            }
        }

        private void button9_Click(object sender, EventArgs e)
        {
            // Загрузчик. Сохранение файлов в asm формат
            saveFileDialog1.Filter = "ASM Files (*.asm)|*.asm";
            if (saveFileDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK
                && saveFileDialog1.FileName.Length > 0)
            {
                richTextBox1.SaveFile(saveFileDialog1.FileName,
                    RichTextBoxStreamType.PlainText);
            }
        }

        private void button40_Click(object sender, EventArgs e)
        {
            // Алгоритмизация. Открытие файлов в cki формате
            OpenFileDialog openFile1 = new OpenFileDialog();
            openFile1.DefaultExt = "*.cki";
            openFile1.Filter = "CKI Files (*.cki)|*.cki";
            if (openFile1.ShowDialog() == System.Windows.Forms.DialogResult.OK &&
               openFile1.FileName.Length > 0)
            {
                string opentext = System.IO.File.ReadAllText(openFile1.FileName).Replace("\n", "");
                richTextBox3.Text = opentext;
            }
        }

        private void button39_Click(object sender, EventArgs e)
        {
            // Алгоритмизация. Сохранение файлов в cki формат
            saveFileDialog1.Filter = "CKI Files (*.cki)|*.cki";
            if (saveFileDialog1.ShowDialog() == System.Windows.Forms.DialogResult.OK
                && saveFileDialog1.FileName.Length > 0)
            {
                richTextBox3.SaveFile(saveFileDialog1.FileName,
                    RichTextBoxStreamType.PlainText);
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            WshShell shell = new WshShell();       
            // Загрузчик. Вызов транслятора
            string path = System.IO.Directory.GetCurrentDirectory();
            string path0 = path + "\\translation\\DOSbox\\Tasm\\start.asm";
            string path1 = path + "\\translation\\DOSbox\\Tasm\\start.hex";
            string path2 = path + "\\translation\\DOSbox\\Tasm\\START.LST";
            string path3 = path + "\\translation\\DOSbox\\Tasm\\startconf1.conf";
            string path4 = path + "\\translation\\DOSbox\\Tasm\\startconf2.conf";
            string path5 = path + "\\translation\\DOSbox\\Tasm\\start1.lnk";
            string path6 = path + "\\translation\\DOSbox\\Tasm\\start2.lnk";
            string path7 = path + "\\translation\\DOSbox\\Tasm\\t2.exe";
            string path8 = path + "\\translation\\DOSBox\\StartDOS.lnk";
            string path9 = path + "\\translation\\DOSBox\\DOSBox.exe";
            string path10 = path + "\\translation\\DOSBox";
            string path11 = path + "\\translation\\DOSbox\\Tasm";
            System.IO.File.Delete(path0);
            System.IO.File.Delete(path1);
            System.IO.File.Delete(path2);
            System.IO.File.Delete(path3);
            System.IO.File.Delete(path4);
            System.IO.File.Delete(path5);
            System.IO.File.Delete(path6);
        //    System.IO.File.Delete(path8);
            //создаем объект ярлыка
            IWshShortcut shortcut1 = (IWshShortcut)shell.CreateShortcut(path5);
            IWshShortcut shortcut2 = (IWshShortcut)shell.CreateShortcut(path6);
            IWshShortcut shortcut3 = (IWshShortcut)shell.CreateShortcut(path8);
            //задаем свойства для ярлыка
            //путь к самой программе
            shortcut1.TargetPath = path7;
            shortcut2.TargetPath = path7;
            shortcut3.TargetPath = path9;
            // Доабвляем аргументы для загрузки
            shortcut1.Arguments = "startconf1.conf";
            shortcut2.Arguments = "startconf2.conf";
            shortcut3.Arguments = "-conf tasmmounted.conf";
            //Путь к рабочей папке
            shortcut1.WorkingDirectory = path11;
            shortcut2.WorkingDirectory = path11;
            shortcut3.WorkingDirectory = path10;
            //Создаем ярлык
            shortcut1.Save();
            shortcut2.Save();
            shortcut3.Save();
            //Пересоздаем файлы настройки для t2
            string startconf1 = downloadadr + " addhexstart start.hex bye";
            string startconf2 = speed2 + " openchannel " + comboBox1.Text + " loadhex start.hex bye";
            StreamWriter conf1 = new StreamWriter(new FileStream(path3, FileMode.Create, FileAccess.Write));
            conf1.Write(startconf1);
            conf1.Close();
            StreamWriter conf2 = new StreamWriter(new FileStream(path4, FileMode.Create, FileAccess.Write));
            conf2.Write(startconf2);
            conf2.Close();
            //Вывод информации в Debug
            richTextBox1.SaveFile(saveFileDialog1.FileName = path0, RichTextBoxStreamType.PlainText);
            System.Diagnostics.ProcessStartInfo cmd1 = new System.Diagnostics.ProcessStartInfo("cmd", "/c cls && translation\\DOSBox\\StartDOS.lnk");
            Encoding cp866 = Encoding.GetEncoding("cp866");
            cmd1.StandardOutputEncoding = cp866;
            cmd1.RedirectStandardOutput = true;
            cmd1.UseShellExecute = false;
            cmd1.CreateNoWindow = true;
            System.Diagnostics.Process proc = new System.Diagnostics.Process();
            proc.StartInfo = cmd1;
            proc.Start();
            Thread.Sleep(ThreadSleep);
            richTextBox2.Text = System.IO.File.ReadAllText(path2).Replace("\n", "");
        }

        private void button6_Click(object sender, EventArgs e)
        {
            // Загрузчик. Добавление стартового адреса
            System.Diagnostics.ProcessStartInfo cmd2 = new System.Diagnostics.ProcessStartInfo("cmd", "/c cls && translation\\DOSBox\\Tasm\\start1.lnk");
            Encoding cp866 = Encoding.GetEncoding("cp866");
            cmd2.StandardOutputEncoding = cp866;
            cmd2.RedirectStandardOutput = true;
            cmd2.UseShellExecute = false;
            cmd2.CreateNoWindow = true;
            System.Diagnostics.Process proc = new System.Diagnostics.Process();
            proc.StartInfo = cmd2;
            proc.Start();
            string result2 = proc.StandardOutput.ReadToEnd();
            richTextBox2.Text = result2;      
        }

        private void button7_Click(object sender, EventArgs e)
        {
            // Загрузчик. Загрузка образа программы
            System.Diagnostics.ProcessStartInfo cmd3 = new System.Diagnostics.ProcessStartInfo("cmd", "/c cls && translation\\DOSBox\\Tasm\\start2.lnk");
            Encoding cp866 = Encoding.GetEncoding("cp866");
            cmd3.StandardOutputEncoding = cp866;
            cmd3.RedirectStandardOutput = true;
            cmd3.UseShellExecute = false;
            cmd3.CreateNoWindow = true;
            System.Diagnostics.Process proc = new System.Diagnostics.Process();
            proc.StartInfo = cmd3;
            proc.Start();
            string result2 = proc.StandardOutput.ReadToEnd();
            richTextBox2.Text = result2;  
        }

        private void Подключить_Click(object sender, EventArgs e)
        {
            // Основная программа. Подключение к COM порту
            if (Подключить.Text == "Подключить") 
                {
                    port = new SerialPort(comboBox5.Text);
                    port.BaudRate = Convert.ToInt32(comboBox2.Text); // Скорость передачи
                    port.DataBits = Convert.ToInt32(textBox4.Text); // Число битов данных
                    if (comboBox4.SelectedIndex == 0) { port.StopBits = StopBits.None; } // Количество стоп битов
                    if (comboBox4.SelectedIndex == 1) { port.StopBits = StopBits.One; }
                    if (comboBox4.SelectedIndex == 2) { port.StopBits = StopBits.OnePointFive; }
                    if (comboBox4.SelectedIndex == 3) { port.StopBits = StopBits.Two; }
                    port.DtrEnable = checkBox1.Checked; // хз
                    try
                    {
                        port.Open();
                        MessageBox.Show("Порт " + comboBox5.Text + " подключен.");
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show("Ошибка: " + ex.Message);
                        return;
                    }
                    port.DataReceived += new SerialDataReceivedEventHandler(serialPort1_DataReceived); // Событие для приема данных
                    if (port.IsOpen == true) {  radioButton1.Checked = true; Подключить.Text = "Отключить"; }
                    if (port.IsOpen == true) button23.Enabled = false;
                    if (port.IsOpen == true) button36.Enabled = true;
                } 
            else
                {
                    if (port.IsOpen == true) { port.Close(); };
                    Thread.Sleep(1000);
                    if (port.IsOpen == false) { radioButton1.Checked = false; Подключить.Text = "Подключить"; };
                    if (port.IsOpen == false) button23.Enabled = true; 
                    if (port.IsOpen == false) button36.Enabled = false; 
                }
        }

        private void button23_Click(object sender, EventArgs e)
        {
            // Ручное управление. Подключение к COM порту
            if (button23.Text == "Подключить")
            {
                port = new SerialPort(comboBox5.Text);
                port.BaudRate = Convert.ToInt32(comboBox2.Text); // Скорость передачи
                port.DataBits = Convert.ToInt32(textBox4.Text); // Число битов данных
                if (comboBox4.SelectedIndex == 0) { port.StopBits = StopBits.None; } // Количество стоп битов
                if (comboBox4.SelectedIndex == 1) { port.StopBits = StopBits.One; }
                if (comboBox4.SelectedIndex == 2) { port.StopBits = StopBits.OnePointFive; }
                if (comboBox4.SelectedIndex == 3) { port.StopBits = StopBits.Two; }
                port.DtrEnable = checkBox1.Checked; // хз
                try
                {
                    port.Open();
                    MessageBox.Show("Порт " + comboBox5.Text + " подключен.");
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Ошибка: " + ex.Message);
                    return;
                }
                port.DataReceived += new SerialDataReceivedEventHandler(serialPort1_DataReceived); // Событие для приема данных
                if (port.IsOpen == true) { radioButton5.Checked = true; button23.Text = "Отключить"; }
                if (port.IsOpen == true) { Подключить.Enabled = false; }
                if (port.IsOpen == true)
                {
                    
                    button13.Enabled = true;
                    button17.Enabled = true;
                    button16.Enabled = true;
                    button18.Enabled = true;
                    button14.Enabled = true;
                    button19.Enabled = true;
                    button21.Enabled = true;
                    button15.Enabled = true;
                    button12.Enabled = true;
                    button11.Enabled = true;
                    button10.Enabled = true;
                    button20.Enabled = true;
                     
                }
            }
            else
            {
                if (port.IsOpen == true) { port.Close(); };
                Thread.Sleep(1000);
                if (port.IsOpen == false) { radioButton5.Checked = false; button23.Text = "Подключить"; };
                if (port.IsOpen == false) { Подключить.Enabled = true; }
                if (port.IsOpen == false)
                {
                   /* button13.Enabled = false;
                    button17.Enabled = false;
                    button16.Enabled = false;
                    button18.Enabled = false;
                    button14.Enabled = false;
                    button19.Enabled = false;
                    button21.Enabled = false;
                    button15.Enabled = false;
                    button12.Enabled = false;
                    button11.Enabled = false;
                    button10.Enabled = false;
                    button20.Enabled = false;
                    */
                }
            }
        }



        // Мелкие функции



        private void button35_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Возврат в исходное состояние
            richTextBox3.Text = richTextBox3.Text + "Возврат в исходное состояние\n";
        }
        
        private void button24_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Движение по оси X влево
            richTextBox3.Text = richTextBox3.Text + "Движение влево по оси X на " + textBox5.Text + " мм\n";
        }

        private void button25_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Движение по оси X вправо
            richTextBox3.Text = richTextBox3.Text + "Движение вправо по оси X на " + textBox5.Text + " мм\n";
        }

        private void button27_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Движение по оси Z влево
            richTextBox3.Text = richTextBox3.Text + "Движение вверх по оси Z на " + textBox6.Text + " мм\n";
        }

        private void button26_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Движение по оси Z вправо
            richTextBox3.Text = richTextBox3.Text + "Движение вниз по оси Z на " + textBox6.Text + " мм\n";
        }

      /*  private void button29_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Движение по оси Y вверх
            richTextBox3.Text = richTextBox3.Text + "Движение вверх по оси Y на " + textBox7.Text + " мм\n";
        }

        private void button28_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Движение по оси Y вниз
            richTextBox3.Text = richTextBox3.Text + "Движение вниз по оси Y на " + textBox7.Text + " мм\n";
        } */

        private void button31_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Задать время ожидания
            richTextBox3.Text = richTextBox3.Text + "Время сушки " + textBox8.Text + " сек\n";
        }

        private void button32_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Вентилятор. Включить
            richTextBox3.Text = richTextBox3.Text + "Включить вентилятор\n";
        }

        private void button30_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Вентилятор. Выключить
            richTextBox3.Text = richTextBox3.Text + "Выключить вентилятор\n";
        }

        private void button34_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Нагреватель. Выключить
            richTextBox3.Text = richTextBox3.Text + "Включить нагреватель\n";
        }

        private void button33_Click(object sender, EventArgs e)
        {
            //Алгоритмизация. Нагреватель. Выключить
            richTextBox3.Text = richTextBox3.Text + "Выключить нагреватель\n";
        }

        private void button28_Click(object sender, EventArgs e)
        {
            //Основная программа. Движение по датчику. Влево по X
            richTextBox3.Text = richTextBox3.Text + "Движение влево по оси X до " + comboBox3.Text + "\n";
        }

        private void button29_Click(object sender, EventArgs e)
        {
            //Основная программа. Движение по датчику. Вправо по X
            richTextBox3.Text = richTextBox3.Text + "Движение вправо по оси X до " + comboBox6.Text + "\n";
        }

        private void button37_Click(object sender, EventArgs e)
        {
            //Основная программа. Движение по датчику. Вверх по Z
            richTextBox3.Text = richTextBox3.Text + "Движение вверх по оси Z до дат.1(Z)\n";
        }

        private void button38_Click(object sender, EventArgs e)
        {
            //Основная программа. Движение по датчику. Вниз по Z
            richTextBox3.Text = richTextBox3.Text + "Движение вниз по оси Z до дат.2(Z)\n";
        }
        

        private void textBox2_TextChanged(object sender, EventArgs e)
        {
            // Загрузчик. Если изменился адрес загрузки программы
            downloadadr = textBox2.Text;
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {
            // Загрузчик. Задаю новое время ожидания транслятора
            ThreadSleep = Convert.ToInt32(textBox1.Text);
        }

        private void textBox3_TextChanged(object sender, EventArgs e)
        {
            // Загрузчик. Задаем скорость соединения (в бодах)
            speed2 = Convert.ToInt32(textBox3.Text);
        }


        private void button1_Click(object sender, EventArgs e)
        {
            panel1.Visible = true;
            panel2.Visible = false;
            panel3.Visible = false;
            panel4.Visible = false;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            panel1.Visible = false;
            panel2.Visible = true;
            panel3.Visible = false;
            panel4.Visible = false;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            panel1.Visible = false;
            panel2.Visible = false;
            panel3.Visible = true;
            panel4.Visible = false;
        }

        private void button4_Click(object sender, EventArgs e)
        {
            panel1.Visible = false;
            panel2.Visible = false;
            panel3.Visible = false;
            panel4.Visible = true;
        }

        private void textBox1_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Загрузчик. Ввод только чисел (время ожидания транслятора)
            e.Handled = true;
            string text = textBox1.Text;
            int k = 0;
            for (int i = 0; i < text.Length; i++)
            {
                if (text[i] == ',') k++;
            }
            if (Char.IsDigit(e.KeyChar) || Char.IsControl(e.KeyChar) || (e.KeyChar == ',' && k < 1)) e.Handled = false;
        }

        private void textBox4_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Основная программа. Ввод только чисел 
            e.Handled = true;
            string text = textBox1.Text;
            int k = 0;
            for (int i = 0; i < text.Length; i++)
            {
                if (text[i] == ',') k++;
            }
            if (Char.IsDigit(e.KeyChar) || Char.IsControl(e.KeyChar) || (e.KeyChar == ',' && k < 1)) e.Handled = false;
        }

        private void textBox3_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Загрузчик. Ввод только чисел 
            e.Handled = true;
            string text = textBox1.Text;
            int k = 0;
            for (int i = 0; i < text.Length; i++)
            {
                if (text[i] == ',') k++;
            }
            if (Char.IsDigit(e.KeyChar) || Char.IsControl(e.KeyChar) || (e.KeyChar == ',' && k < 1)) e.Handled = false;
        }

        private void textBox5_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Алгоритмизация. Ввод только чисел 
            e.Handled = true;
            string text = textBox1.Text;
            int k = 0;
            for (int i = 0; i < text.Length; i++)
            {
                if (text[i] == ',') k++;
            }
            if (Char.IsDigit(e.KeyChar) || Char.IsControl(e.KeyChar) || (e.KeyChar == ',' && k < 1)) e.Handled = false; 
        }

        private void textBox6_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Алгоритмизация. Ввод только чисел 
            e.Handled = true;
            string text = textBox1.Text;
            int k = 0;
            for (int i = 0; i < text.Length; i++)
            {
                if (text[i] == ',') k++;
            }
            if (Char.IsDigit(e.KeyChar) || Char.IsControl(e.KeyChar) || (e.KeyChar == ',' && k < 1)) e.Handled = false; 
        }

        private void textBox7_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Алгоритмизация. Ввод только чисел 
            e.Handled = true;
            string text = textBox1.Text;
            int k = 0;
            for (int i = 0; i < text.Length; i++)
            {
                if (text[i] == ',') k++;
            }
            if (Char.IsDigit(e.KeyChar) || Char.IsControl(e.KeyChar) || (e.KeyChar == ',' && k < 1)) e.Handled = false; 
        }

        private void textBox8_KeyPress(object sender, KeyPressEventArgs e)
        {
            // Алгоритмизация. Ввод только чисел 
            e.Handled = true;
            string text = textBox1.Text;
            int k = 0;
            for (int i = 0; i < text.Length; i++)
            {
                if (text[i] == ',') k++;
            }
            if (Char.IsDigit(e.KeyChar) || Char.IsControl(e.KeyChar) || (e.KeyChar == ',' && k < 1)) e.Handled = false;
        }

        private void button22_Click(object sender, EventArgs e)
        {
            // СПРАВКА
        }

        private void button41_Click(object sender, EventArgs e)
        {
            //Основаня программа. Очистить окно алгоритмизации
            richTextBox3.Text = "";
        }

        private void Aldnoah_FormClosed(object sender, FormClosedEventArgs e)
        {
            if (Thread1.IsAlive == true) Thread1.Abort();
            if (Thread2.IsAlive == true) Thread2.Abort();
        }

        private void button43_Click(object sender, EventArgs e)
        {
            checkBox23.Checked = true;
            checkBox20.Checked = true;
        }





    }
}
