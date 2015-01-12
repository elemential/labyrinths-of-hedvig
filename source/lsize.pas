unit LSize;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LTypes;

type
  TL2DSize=class
    private
      type
        TLSizeLink=function(Value: Integer=-1): Integer;
      var
        Fx: Integer;
        FXLink: TLSizeLink;
        Fy: Integer;
        FYLink: TLSizeLink;
    public
      constructor Create(Ax: Integer=0; Ay: Integer=0);
      function getx: Integer;
      procedure setx(Value: Integer);
      property X: Integer read getx
                          write setx;
      property XLink: TLSizeLink read FXLink
                                 write FXLink;
      function gety: Integer;
      procedure sety(Value: Integer);
      property Y: Integer read gety
                          write sety;
      property YLink: TLSizeLink read FYlink
                                 write FYlink;
      property Width: Integer read getx
                              write setx;
      property Height: Integer read gety
                               write sety;
  end;

  TL3Dsize=class(TL2DSize)
  private
    var
      Fz: Integer;
      FZlink: TLSizeLink;
  public
    constructor Create(Ax: Integer=0; Ay: Integer=0; Az: Integer=0);
    function getz: Integer;
    procedure setz(Value: Integer);
    property Z: Integer read getx
                        write setz;
    property ZLink: TLSizeLink read FZlink
                               write FZlink;
    property Depth: Integer read getz
                            write setz;
  end;

  function StrToL2DSize(Value: String): TL2DSize;
  function L2DSizeToStr(Value: TL2DSize): String;
  function StrToL3DSize(Value: String): TL3DSize;
  function L3DSizeToStr(Value: TL3DSize): String;

implementation

constructor TL2DSize.Create(Ax: Integer=0; Ay: Integer=0);
begin
  Fx:=Ax;
  Fy:=Ay;
end;

constructor TL3Dsize.Create(Ax: Integer=0; Ay: Integer=0; Az: Integer=0);
begin
  inherited Create(Ax, Ay);
  Fz:=Az;
end;

function TL2DSize.getx: Integer;
begin
  if (Assigned(XLink)) then Fx:=XLink();
  Result:=Fx;
end;

procedure TL2DSize.setx(Value: Integer);
begin
  if (Assigned(XLink)) then Fx:=XLink(Value)
                       else Fx:=Value;
end;

function TL2DSize.gety: Integer;
begin
  if (Assigned(XLink)) then Fy:=YLink();
  Result:=Fy;
end;

procedure TL2DSize.sety(Value: Integer);
begin
  if (Assigned(YLink)) then Fy:=YLink(Value)
                       else Fy:=Value;
end;

function TL3DSize.getz: Integer;
begin
  if (Assigned(ZLink)) then Fz:=ZLink();
  Result:=Fz;
end;

procedure TL3DSize.setz(Value: Integer);
begin
  if (Assigned(ZLink)) then Fz:=ZLink(Value)
                       else Fz:=Value;
end;

function StrToL2DSize(Value: String): TL2DSize;
var arr: TStringArray;
begin
  Result:=TL2DSize.Create;
  arr:=StrToArray(Value, ';');
  Result.x:=StrToInt(arr[0]);
  Result.y:=StrToInt(arr[1]);
end;

function L2DSizeToStr(Value: TL2DSize): String;
var arr: TStringArray;
begin
  SetLength(arr, 2);
  arr[0]:=IntToStr(Value.x);
  arr[1]:=IntToStr(Value.y);
  Result:=ArrayToStr(arr, ';');
end;

function StrToL3DSize(Value: String): TL3DSize;
var arr: TStringArray;
begin
  Result:=TL3DSize.Create;
  arr:=StrToArray(Value, ';');
  Result.x:=StrToInt(arr[0]);
  Result.y:=StrToInt(arr[1]);
  Result.z:=StrToInt(arr[2]);
end;

function L3DSizeToStr(Value: TL3DSize): String;
var arr: TStringArray;
begin
  SetLength(arr, 3);
  arr[0]:=IntToStr(Value.x);
  arr[1]:=IntToStr(Value.y);
  arr[2]:=IntToStr(Value.z);
  Result:=ArrayToStr(arr, ';');
end;

end.

