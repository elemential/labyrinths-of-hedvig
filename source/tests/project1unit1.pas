unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LIniFiles, LLevel, LGraphics, LTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure Timer1Timer(Sender: TObject);
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

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  ini:=TLIniFile.Create('main.ini');
  Visualisator:=TVisualisator.Create(Form1, ini.ReadIni('Visualisator', 'ini'));
  levelsini:=ini.ReadIni('Form', 'levelsini');
  levels:=ReadLevelArray('levels', levelsini);
  //Visualisator.Level:=levels[0];
  Color:=clGreen;
  Repaint;
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
    'c': FormCreate(Sender);
    '0': Visualisator.Level:=levels[0];
    '1': Visualisator.Level:=levels[1];
    '2': Visualisator.Level:=levels[2];
    'w': Visualisator.Level.PlayerPosition.move(0*right_angle);
    'a': Visualisator.Level.PlayerPosition.move( -right_angle);
    's': Visualisator.Level.PlayerPosition.move(2*right_angle);
    'd': Visualisator.Level.PlayerPosition.move( +right_angle);
    ' ': Visualisator.draw;
    #08: FormDestroy(Self);
    #27: Close;
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

end.

