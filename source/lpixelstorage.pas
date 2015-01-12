unit LPixelStorage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, LPixel, LTypes, LSize;

type
  TLPixelStorage = class
  public
    type
      TLPixelArray=array of TLPixel;
  private
    var
      FPixels: TLPixelArray;
      FSize: TL3DSize;
  private
    function calcIndex(Ax, Ay, Az: Integer): TLIndex;
  public
    function getPixel(Ax, Ay, Az: Integer): TLPixel;
    procedure setPixel(Ax, Ay, Az: Integer; Value: TLPixel);
    property Pixels[Ax, Ay, Az: Integer]: TLPixel read getPixel write setPixel;
  end;

  TLTexture=TLPixelStorage;

implementation

function TLPixelStorage.calcIndex(Ax, Ay, Az: Integer): TLIndex;
begin

end;

function TLPixelStorage.getPixel(Ax, Ay, Az: Integer): TLPixel;
begin

end;

procedure TLPixelStorage.setPixel(Ax, Ay, Az: Integer; Value: TLPixel);
begin

end;

end.

