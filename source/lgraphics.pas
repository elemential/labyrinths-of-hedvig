unit LGraphics;

{$mode objfpc}{$H+}{$Define LGRAPHICS}

interface

uses
  Classes, SysUtils, Graphics, ExtCtrls, Forms,
  LTypes, LLevel, LIniFiles, LSize, LPosition;

type

  TVisualisator=class(TImage)
  private
    {types and vars}
    var
      //FScreen: TCanvas;
      FLevel: TLLevel;
      FDbg, FAnimate, FDrawcorner: Boolean;
      Fini: TLIniFile;

    const
      iniSection='Visualisator';
  public
    {functions and procedures}
    constructor Create(AOwner: TForm; Aini: TLIniFile);
    //procedure drawAll();
    procedure drawpixel(AColor: TColor; ARel: TL3DPosition);
    procedure draw;
    destructor Destroy; override;
  private
    {propertyes}
    property ini: TLIniFile read Fini write Fini;
  public
    {propertyes}
    procedure setLevel(Value: TLLevel);
    property Level: TLLevel read FLevel write setLevel;
    property dbg: Boolean read FDbg write FDbg;
    property Animate: Boolean read FAnimate write FAnimate;
    property DrawCorner: Boolean read FDrawcorner write FDrawcorner;
    function getPos: TPoint;
    procedure setPos(value: TPoint);
    property Pos: TPoint read getPos write setPos;
    function getSize: TL2DSize;
    procedure setSize(Value: TL2DSize);
    property Size: TL2DSize read getSize write setSize;
  end;

implementation

constructor TVisualisator.Create(AOwner: TForm; Aini: TLIniFile);
begin
  inherited Create(AOwner);
  Fini:=Aini;
  Pos:=ini.ReadPoint(iniSection, 'pos', Pos);
  Size:=ini.ReadL2DSize(iniSection, 'size', Size);
  //Level:=TLLevel.Create(TIniFile.Create(ini.ReadFn('level', 'ini', '')));
  {
  FScreen:=TCanvas.Create;
  FScreen.Width:=FMap.data.Width;
  FScreen.Height:=FMap.data.Height;
  }
  Parent:=AOwner;
  Picture.Bitmap:=ini.ReadBitmap(iniSection, 'splash', nil);
  dbg:=ini.ReadBool(iniSection, 'dbg', false);
  Animate:=ini.ReadBool(iniSection, 'animate', false);
  DrawCorner:=ini.ReadBool(iniSection, 'drawcorner', true);
end;

procedure TVisualisator.setLevel(Value: TLLevel);
begin
  FLevel:=Value;
  draw;
end;

procedure TVisualisator.drawpixel(AColor: TColor; ARel: TL3DPosition);
var
  ximax, ximin, xi, yimax, yimin, yi: Integer;
  currviewsize: TL3Dsize;
  xdiv, ydiv, zdiv: Extended;
begin
  currviewsize:=Level.ViewSize;
  ydiv:=currviewsize.Y/ARel.y;
  currviewsize.X:=round(currviewsize.X*ydiv);
  currviewsize.Z:=round(currviewsize.Z*ydiv);
  xdiv:=currviewsize.X/ARel.x/2;
  zdiv:=currviewsize.Z/ARel.z/2;

  ximin:=round(Canvas.Width/2-Canvas.Width/2*xdiv);
  ximax:=round(Canvas.Width/2-Canvas.Width/2*xdiv);
  yimin:=round(Canvas.Height/2-Canvas.Height/2*zdiv);
  yimin:=round(Canvas.Height/2-Canvas.Height/2*zdiv);

  for xi:=ximin to ximax do
  begin
    for yi:=yimin to yimax do
    begin
      Canvas.Pixels[xi, yi]:=AColor;
    end;
  end;
end;

procedure TVisualisator.draw;
//(*
  procedure drawPixelI(
    X, Y, i, j: Extended;
    cl: TColor
  );
  var
    Xmax, Ymax, cXmax, cYmax: Extended;
  begin
    Ymax:=Level.ViewSize.y;
    Xmax:=Level.ViewSize.x/2;
    Xmax:=Xmax*(Y)/Ymax;
    cXmax:=canvas.Width/2;
    cYmax:=Canvas.Height/2;
    {$IfDef WINDOWS}
      if xmax=0 then xmax:=1;
    {$EndIf}
    Canvas.Pixels[
      round(cXmax+cXmax*X/Xmax+j),
      round(cYmax+i)
    ]:=cl;
  end;
  procedure drawPixelI(X, Y, i, imax, j, jmax: Extended);
  var
    cl: TColor;
    //imax: Integer;
  begin
    //imax:=10;
    if (imax>0) then
      cl:=RGBToColor(round(255*(Y*Y)/(Level.ViewSize.y*Level.ViewSize.y)),
                     round(255*abs(imax+i)/abs(imax+imax)),
                     round(255*Y/Level.ViewSize.y/2)
      );
    drawPixelI(X, Y, i, j, cl);
  end;
var
  fullPosition: TLPlayerPosition;
  X, Xmax, Y, Ymax, imax, jmax, dir:Extended;
  mX, mY, i, j: Integer;
begin
  if not (dbg or animate) then Visible:=False;
  Canvas.Clear;
  Ymax:=Level.ViewSize.y;
  for mY:=-round(Ymax) to 0 do
  begin
    Y:=-mY;
    Xmax:=Level.ViewSize.x/2;
    Xmax:=Xmax*(Y)/Ymax;
    for mX:=-round(Xmax) to round(Xmax) do
    begin
      X:=-mX;
      {$IfNDef WINDOWS}
        if animate then Sleep(1);
      {$EndIf}
      if dbg or Animate then Application.ProcessMessages;
      dir:=Level.PlayerPosition.direction;
      fullPosition:=TLPlayerPosition.Create;
      fullPosition.X:=Level.PlayerPosition.coords.X+round(sin(dir)*Y+cos(dir)*X);
      fullPosition.Y:=Level.PlayerPosition.coords.Y-round(cos(dir)*Y-sin(dir)*X);
      fullPosition.direction:=Level.PlayerPosition.direction+0;
      if Level.isPlayerPosition(fullPosition) then
      begin
        if dbg then Canvas.Pixels[fullPosition.coords.X, fullPosition.coords.Y]:=clGreen;
        if Level.data.Canvas.Pixels[fullPosition.coords.X, fullPosition.coords.Y]=clBlack then
        begin
          if dbg then Canvas.Pixels[fullPosition.coords.X, fullPosition.coords.Y]:=clRed;
          imax:=Ymax-(Canvas.Height/2*Y/Ymax);
          {$IfDef WINDOWS}
            if xmax=0 then xmax:=1;
          {$EndIf}
          jmax:=Canvas.Width/Xmax/2;
          //if animate then jmax:=0;
          for j:=-round(jmax) to round(jmax) do
          begin
            for i:=-round(imax) to round(imax) do
              drawPixelI(x, y, i, imax, j, jmax);
            if not animate and DrawCorner then
            begin
              drawPixelI(x, y, -imax, j, clBlack);
              drawPixelI(x, y, +imax, j, clBlack);
            end;
          end;
        end;
      end;
    end;
  end;
  Visible:=True;
  //if animate then Animate:=False;
end;
(*
var ximin, ximax, xi, yimin, yimax, yi, zimin, zimax, zi: Integer;
begin
  if not (dbg or animate) then Visible:=False;
  Canvas.Clear;
  ximin:=Level.PlayerPosition.X;
  ximax:=ximin+Level.ViewSize.X;
  for xi:=ximin to ximax do
  begin
    yimin:=1;
    yimax:=Level.ViewSize.Y;
    for yi:=1 to Level.ViewSize.Y do
    begin
      if Level.isWall[xi, yi] then
      begin
        zimin:=0;
        zimax:=Level.ViewSize.Z;
        for zi:=zimin to zimax do
        begin
          drawpixel(clBlack, TL3DPosition.Create(xi, yi, zi));
        end;
      end;
    end;
  end;
  Visible:=True;
  //if animate then Animate:=False;
end;
*)

destructor TVisualisator.Destroy;
begin
  inherited Destroy;
end;

function TVisualisator.getPos:TPoint;
begin
  Result.X:=Left;
  Result.Y:=Top;
end;

procedure TVisualisator.setPos(Value: TPoint);
begin
  Left:=Value.X;
  Top:=Value.Y;
end;

function TVisualisator.getSize: TL2DSize;
begin
  Result:=TL2DSize.Create(Width, Height);
end;

procedure TVisualisator.setSize(Value: TL2DSize);
begin
  Width:=Value.x;
  Height:=Value.y;
end;

end.

