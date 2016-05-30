unit Dipl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl;

type
  TForm1 = class(TForm)
    Button1: TButton;
    DriveComboBox1: TDriveComboBox;
    FilterComboBox1: TFilterComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FileListBox1DblClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FilterComboBox1Change(Sender: TObject);
    procedure FileListBox1Click(Sender: TObject);
 

 
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  s1:string;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
        form1.Close;
end;


procedure TForm1.FileListBox1DblClick(Sender: TObject);
var
s : string;
pc: array[0..100] of Char;
sEnd : string;
begin
        s := FileListBox1.Items[FileListBox1.ItemIndex];
        if (form1.FilterComboBox1.Mask='*.exe') then
        begin
                sEnd := DirectoryListBox1.Directory + '\' +  s
        end;
 //       if ((s[Length(s)] = 't') or (s[Length(s)] = 'T') and (s[Length(s)-1] = 'x') or (s[Length(s)-1] = 'X') and (s[Length(s)-2] = 't') or (s[Length(s)-2] = 'T')) then
 //       sEnd := 'notepad ' + DirectoryListBox1.Directory + '\' +  s;

        if (form1.FilterComboBox1.Mask='*.bat') then
        sEnd := DirectoryListBox1.Directory + '\' +  s;
 //       form1.FileListBox1.Cursor:= crHandPoint;

        if (form1.FilterComboBox1.Mask='*.doc') then
        sEnd := 'Explorer ' + DirectoryListBox1.Directory + '\' +  s;

        if (form1.FilterComboBox1.Mask='*.asm') then
        sEnd := 'notepad ' + DirectoryListBox1.Directory + '\' +  s;

        if (form1.FilterComboBox1.Mask='*.hex') then
        sEnd := 'notepad ' + DirectoryListBox1.Directory + '\' +  s;

        if (form1.FilterComboBox1.Mask='*.txt') then
        sEnd := 'notepad ' + DirectoryListBox1.Directory + '\' +  s;


        //sEnd := 'explorer ' + DirectoryListBox1.Directory + '\' +  s;
        StrPCopy(pc,sEnd);
        Form1.Caption := pc;
        WinExec(pc,SW_SHOWNORMAL);


end;

procedure TForm1.Button2Click(Sender: TObject);
var
//s1 : string;
pc: array[0..100] of Char;
sEnd1 : string;
begin

        s1 := FileListBox1.Items[FileListBox1.ItemIndex];
        if ((s1[Length(s1)] = 't') or (s1[Length(s1)] = 'T') and (s1[Length(s1)-1] = 'a') or (s1[Length(s1)-1] = 'A')and (s1[Length(s1)-2] = 'b') or (s1[Length(s1)-2] = 'B')) then
        begin
                 sEnd1 := 'notepad ' + DirectoryListBox1.Directory + '\' +  s1
        end;
        StrPCopy(pc,sEnd1);
        Form1.Caption := pc;
        WinExec(pc,SW_SHOWNORMAL);
        Form1.Button2.Visible:=false;
end;


procedure TForm1.FilterComboBox1Change(Sender: TObject);
begin
   //     if (form1.FilterComboBox1.Mask='*.bat') then
     //   form1.Button2.Visible:=true
       // else form1.Button2.Visible:=false;
end;

procedure TForm1.FileListBox1Click(Sender: TObject);
begin
         if (form1.FilterComboBox1.Mask='*.bat') then
         form1.Button2.Visible:=true
         else form1.Button2.Visible:=false;
end;

end.
