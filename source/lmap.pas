unit LMap;

{$mode objfpc}{$H+}{$Define LMAP}

interface

uses
  Classes, SysUtils, IniFiles, Graphics, LTypes, LIniFiles, LPixelStorage, LSize;

type
  TLMap=class(TObject)
  private
    {types and vars}
    var
      FData: TBitmap;
      FTexture: TLTexture;
      Fini: TLIniFile;
      FSize: TL3Dsize;
  public
    {functions and procedures}
    constructor Create(Aini: TLIniFile);
    destructor Destroy; override;
  private
    {propertyes}
    property ini: TLIniFile read Fini write Fini;
  public
    {propertyes}
    property data: TBitmap read FData write FData;
    //procedure setTextures(Value: TLTextures);
    property texture: TLTexture read FTexture write FTexture;
    function getSize: TL3DSize;
    procedure setSize(Value: TL3DSize);
    property Size: TL3DSize read FSize write FSize;
  end;

implementation

constructor TLMap.Create(AIni: TLIniFile);
begin
  inherited Create;
  Fini:=AIni;
  data:=ini.ReadBitmap('Pictures', 'data', nil);
  Size:=getSize;
end;

destructor TLMap.Destroy;
begin
  inherited Destroy;
  setSize(Size);
end;

{
procedure TLMap.setTextures(Value: TLTextures);
var i: integer;
begin
  if Value=Nil then FTextures:=Nil
  else
  begin
    SetLength(FTextures, Length(Value));
    for i:=0 to Length(Value) do
      FTextures[i]:=Value[i];
  end;
end;
}

function TLMap.getSize: TL3DSize;
begin
  Result:=ini.ReadL3DSize('Map', 'size');
end;

procedure TLMap.setSize(Value: TL3DSize);
begin
  ini.WriteL3DSize('Map', 'size', Value);
end;

end.

