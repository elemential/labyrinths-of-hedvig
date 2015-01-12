unit LPoint;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LTypes, LLevel, LPosition, LIniFiles, LMap, LPixelStorage,
  LSize;

type
  TLPoint=class(TObject)
  private //types and vars
    var
      FFx, FFy, FFz: Extended;
  public //procedures
    constructor Create(Ax: Extended=0; Ay: Extended=0; Az: Extended=0);
    destructor Destroy; override;
    procedure move(ADirection: TLDirection=0; ASteps: Integer=1; ADirectionZ: TLDirection=0);
  public //propertyes
    property Fx: Extended read FFx write FFx;
    property Fy: Extended read FFy write FFy;
    property Fz: Extended read FFz write FFz;
    function getx: Integer;
    procedure setx(Value: Integer);
    property x: Integer read getX write setx;
    function gety: Integer;
    procedure sety(Value: Integer);
    property y: Integer read getY write sety;
    function getz: Integer;
    procedure setz(Value: Integer);
    property z: Integer read getz write setz;
  end;

implementation

constructor TLPoint.Create(Ax: Extended=0; Ay: Extended=0; Az: Extended=0);
begin
  inherited Create;
  FFx:=Ax;
  FFy:=Ay;
  FFz:=Az;
end;

destructor TLPoint.Destroy;
begin
  inherited Destroy;
end;

procedure TLPoint.move(ADirection: TLDirection=0; ASteps: Integer=1; ADirectionZ: TLDirection=0);
var dir: TLDirection;
begin
  Fx:=Fx+sin(ADirection)*ASteps;
  Fy:=Fy-cos(ADirection)*ASteps;
  Fz:=Fz+sin(ADirectionZ)*ASteps;
end;

function TLPoint.getx: Integer;
begin
  Result:=round(Fx);
end;

procedure TLPoint.setx(Value: Integer);
begin
  Fx:=Value;
end;

function TLPoint.gety: Integer;
begin
  Result:=round(Fy);
end;

procedure TLPoint.sety(Value: Integer);
begin
  Fy:=Value;
end;

function TLPoint.getz: Integer;
begin
  Result:=round(Fz);
end;

procedure TLPoint.setz(Value: Integer);
begin
  Fz:=Value;
end;

end.

