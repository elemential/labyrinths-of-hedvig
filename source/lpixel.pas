unit LPixel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

type
  TLPixel=class
    FColor: TColor;
  public
    property Color: TColor read FColor write FColor;
  end;

implementation

end.

