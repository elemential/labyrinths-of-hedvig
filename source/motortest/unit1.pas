unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  LIniFiles, LGraphics, LLevel, LTypes, fphttpclient, windows;

type

  { TForm1 }

  TForm1 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  ini, levelsini: TLIniFile;
  levels: TLLevelArray;
  Visualisator: TVisualisator;
  net: TFPHTTPClient;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var cini: TLIniFile;
    stream: TStringStream;
begin
  //stream:=TStringStream.Create;
  //;
  //cini:=TLIniFile.Create(stream);
  ini:=TLIniFile.Create('../../main.ini');
  Visualisator:=TVisualisator.Create(Form1, ini.ReadIni('Visualisator', 'ini'));
  levelsini:=ini.ReadIni('Form', 'levelsini');
  levels:=ReadLevelArray('levels', levelsini);
  //Visualisator.Level:=levels[0];
  Color:=clGreen;
  Repaint;
  Timer2.Enabled:=ini.ReadBool('Form', 'timer', Timer2.Enabled);
  Timer2.Interval:=ini.ReadInteger('Form', 'timerinterval', Timer2.Interval);
  Timer3.Interval:=ini.ReadInteger('Form', 'keydetect', Timer3.Interval);
end;

procedure TForm1.FormDeactivate(Sender: TObject);
begin

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Assigned(Visualisator) then Visualisator:=nil;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  //Color:=RGBToColor(Random(255), Random(255), Random(255));
  Color:=clRed;
  Repaint;
  case Key of
    'o':  FormCreate(Sender);
    '0':  Visualisator.Level:=levels[0];
    '1':  Visualisator.Level:=levels[1];
    '2':  Visualisator.Level:=levels[2];
    ' ':  Visualisator.draw;
    //'.':  Visualisator.drawNewGen;
    #208: Visualisator.dbg:=not Visualisator.dbg;                 //Dbg
    #38:  Visualisator.DrawCorner:=not Visualisator.DrawCorner;   //drawCorner
    #228: Visualisator.Animate:=not Visualisator.Animate;         //Animate
    //#163: Visualisator.DrawDirect:=not Visualisator.DrawDirect;   //Lowmem
    '[':  begin                                                   //Fullscreen
            Visualisator.Width:=Width;
            Visualisator.Height:=Height;
          end;
    #08:  FormDestroy(Self);                                      //backspace
    #27:  Close;                                                  //ESCape
    else
      begin
        Color:=clYellow;
        Repaint;
        //Timer1.Enabled:=True;
      end;
  end;
  Repaint;
  Color:=clDefault;
  Repaint;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Color:=clDefault;
  Enabled:=False;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  Color:=clRed;
  Repaint;
  if Visualisator.Level<>Nil then
  begin
    Visualisator.draw;
  end;
  Color:=clDefault;
  Repaint;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var i: Integer;
begin
  for i:=1 to 255 do
  begin
    if GetAsyncKeyState(i)<0 then
    begin
      case chr(i) of
        'W':  Visualisator.Level.PlayerPosition.move(0*right_angle, 3);
        'A':  Visualisator.Level.PlayerPosition.move( -right_angle, 3);
        'S':  Visualisator.Level.PlayerPosition.move(2*right_angle, 3);
        'D':  Visualisator.Level.PlayerPosition.move( +right_angle, 3);
        #226: Visualisator.Level.PlayerPosition.direction:=Visualisator.Level.PlayerPosition.direction-0.1; //í
        'C':  Visualisator.Level.PlayerPosition.direction:=Visualisator.Level.PlayerPosition.direction+0.1;
        else Caption:='Pressed:'+chr(i)+'['+IntToStr(i)+']';
      end;
    end;
  end;
end;

end.

