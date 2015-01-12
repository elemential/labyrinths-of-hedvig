unit LPosition;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LTypes;

type
  TL2DPosition=class
    private
      type
        TLPositionLink=function(Value: Extended=-1): Extended;
      var
        FFx: Extended;
        FXLink: TLPositionLink;
        FFy: Extended;
        FYLink: TLPositionLink;
    public
      constructor Create(Ax: Extended=0; Ay: Extended=0);
      function getFx: Extended;
      procedure setFx(Value: Extended);
      property Fx: Extended read getFx
                            write setFx;
      function getFy: Extended;
      procedure setFy(Value: Extended);
      property Fy: Extended read getFy
                            write setFy;
      function getx: Integer;
      procedure setx(Value: Integer);
      property X: Integer read getx
                          write setx;
      property XLink: TLPositionLink read FXLink
                                 write FXLink;
      function gety: Integer;
      procedure sety(Value: Integer);
      property Y: Integer read gety
                          write sety;
      property YLink: TLPositionLink read FYlink
                                 write FYlink;
      property Width: Integer read getx
                              write setx;
      property Height: Integer read gety
                               write sety;
  end;

  TL3DPosition=class(TL2DPosition)
  private
    var
      FFz: Extended;
      FZlink: TLPositionLink;
  public
    constructor Create(Ax: Extended=0; Ay: Extended=0; Az: Extended=0);
    function getFz: Extended;
    procedure setFz(Value: Extended);
    property Fz: Extended read getFz
                          write setFz;
    function getz: Integer;
    procedure setz(Value: Integer);
    property Z: Integer read getx
                        write setz;
    property ZLink: TLPositionLink read FZlink
                               write FZlink;
    property Depth: Integer read getz
                            write setz;
  end;

  TLPlayerPosition=class(TL2DPosition)
  private
    type
      TDirection=Extended;
    var
      FDirection: TDirection;
  public
    procedure move(ADirection: TDirection=0; ASteps: Integer=1);
    property direction: TDirection read FDirection write FDirection;
    function getCoords: TPoint;
    procedure setCoords(Value: TPoint);
    property coords: TPoint read getCoords write setCoords;
  end;
  TLDirection=TLPlayerPosition.TDirection;

  function StrToL2DPosition(Value: String): TL2DPosition;
  function L2DPositionToStr(Value: TL2DPosition): String;
  function StrToL3DPosition(Value: String): TL3DPosition;
  function L3DPositionToStr(Value: TL3DPosition): String;

implementation

constructor TL2DPosition.Create(Ax: Extended=0; Ay: Extended=0);
begin
  FFx:=Ax;
  FFy:=Ay;
end;

constructor TL3DPosition.Create(Ax: Extended=0; Ay: Extended=0; Az: Extended=0);
begin
  inherited Create(Ax, Ay);
  FFz:=Az;
end;

function TL2DPosition.getFx: Extended;
begin
  if (Assigned(XLink)) then FFx:=XLink();
  Result:=FFx;
end;

procedure TL2DPosition.setFx(Value: Extended);
begin
  if (Assigned(XLink)) then FFx:=XLink(Value)
                       else FFx:=Value;
end;

function TL2DPosition.getx: Integer;
begin
  Result:=round(Fx);
end;

procedure TL2DPosition.setx(Value: Integer);
begin
  Fx:=Value;
end;

function TL2DPosition.getFy: Extended;
begin
  if (Assigned(XLink)) then FFy:=YLink();
  Result:=FFy;
end;

procedure TL2DPosition.setFy(Value: Extended);
begin
  if (Assigned(YLink)) then FFy:=YLink(Value)
                       else FFy:=Value;
end;

function TL2DPosition.gety: Integer;
begin
  Result:=round(Fy);
end;

procedure TL2DPosition.sety(Value: Integer);
begin
  Fy:=Value;
end;

function TL3DPosition.getFz: Extended;
begin
  if (Assigned(ZLink)) then FFz:=ZLink();
  Result:=FFz;
end;

procedure TL3DPosition.setFz(Value: Extended);
begin
  if (Assigned(ZLink)) then FFz:=ZLink(Value)
                       else FFz:=Value;
end;

function TL3DPosition.getz: Integer;
begin
  Result:=round(Fz);
end;

procedure TL3DPosition.setz(Value: Integer);
begin
  Fz:=Value;
end;

function StrToL2DPosition(Value: String): TL2DPosition;
var arr: TStringArray;
begin
  Result:=TL2DPosition.Create;
  arr:=StrToArray(Value, ';');
  Result.Fx:=StrToFloat(arr[0]);
  Result.Fy:=StrToFloat(arr[1]);
end;

function L2DPositionToStr(Value: TL2DPosition): String;
var arr: TStringArray;
begin
  SetLength(arr, 2);
  arr[0]:=FloatToStr(Value.Fx);
  arr[1]:=FloatToStr(Value.Fy);
  Result:=ArrayToStr(arr, ';');
end;

function StrToL3DPosition(Value: String): TL3DPosition;
var arr: TStringArray;
begin
  Result:=TL3DPosition.Create;
  arr:=StrToArray(Value, ';');
  Result.Fx:=StrToFloat(arr[0]);
  Result.Fy:=StrToFloat(arr[1]);
  Result.Fz:=StrToFloat(arr[2]);
end;

function L3DPositionToStr(Value: TL3DPosition): String;
var arr: TStringArray;
begin
  SetLength(arr, 3);
  arr[0]:=FloatToStr(Value.Fx);
  arr[1]:=FloatToStr(Value.Fy);
  arr[2]:=FloatToStr(Value.Fz);
  Result:=ArrayToStr(arr, ';');
end;

procedure TLPlayerPosition.move(ADirection: TLDirection=0; ASteps: Integer=1);
var dir: TLDirection;
begin
  dir:=direction+ADirection;
  Fx:=Fx+sin(dir)*ASteps;
  Fy:=Fy-cos(dir)*ASteps;
end;

function TLPlayerPosition.getCoords:TPoint;
begin
  Result:=Point(x, y);
end;

procedure TLPlayerPosition.setCoords(Value: TPoint);
begin
  x:=Value.X;
  y:=Value.Y;
end;

end.

