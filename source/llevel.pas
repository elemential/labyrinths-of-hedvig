unit LLevel;

{$mode objfpc}{$H+}{$Define LLEVEL}

interface

uses
  Classes, SysUtils, IniFiles, Graphics, LMap, LTypes, LIniFiles, LPosition,
  LSize;

type
  TLLevel=class(TObject)
  private
    {types and vars}
    var
      FIni: TLIniFile;
      FMap: TLMap;
      FPlayerPosition: TLPlayerPosition;
  public
    {types and vars}
    type
      TLLevelArray=array of TLLevel;
  public
    {functions and procedures}
    constructor Create(Aini: TLIniFile);
    destructor Destroy; override;
  private
    {propertyes}
    property ini: TLIniFile read FIni write FIni;
    property Map: TLMap read FMap write FMap;
  public
    {propertyes}
    procedure setPlayerPosition(Value: TLPlayerPosition);
    function isPlayerPosition(Value: TLPlayerPosition): Boolean;
    property PlayerPosition: TLPlayerPosition read FPlayerPosition write setPlayerPosition;
    function getWidth: Integer;
    procedure setWidth(Value: Integer);
    property Width: Integer read getWidth write setWidth;
    function getHeight: Integer;
    procedure setHeight(Value: Integer);
    property Height: Integer read getHeight write setHeight;
    function getdata: TBitmap;
    property data: TBitmap read getdata;
    function getViewSize: TL3DSize;
    procedure setViewSize(Value: TL3DSize);
    property ViewSize: TL3DSize read getViewSize write setViewSize;
    function getIsWall(Ax, Ay: Integer): Boolean;
    property isWall[Ax, Ay: Integer]: Boolean read getIsWall;
  end;

TLLevelArray=TLLevel.TLLevelArray;

function ReadLevelArray(const Ident: String; var ini: TLIniFile): TLLevelArray;

implementation

constructor TLLevel.Create(AIni: TLIniFile);
begin
  inherited Create;
  Fini:=AIni;
  FMap:=TLMap.Create(ini.ReadIni('Map', 'ini'));
  FPlayerPosition:=TLPlayerPosition.Create;
  PlayerPosition.coords:=ini.ReadPoint('Player', 'coords', Point(round(Width/2), round(Height/2)));
  PlayerPosition.direction:=ini.ReadFloat('Player', 'direction', 0);
end;

destructor TLLevel.Destroy;
begin
  inherited Destroy;
end;

function TLLevel.isPlayerPosition(Value: TLPlayerPosition):Boolean;
var minx, maxx, miny, maxy: Integer;
begin
  minx:=1;
  maxx:=Map.Size.Width;
  miny:=1;
  maxy:=Map.Size.Height;
  Result:=(
    //((0<=Value.direction) and (Value.direction<=1)) and
    ((0<=Value.X) and (Value.X<=maxx)) and
    ((0<=Value.Y) and (Value.Y<=maxy))
  );
end;

procedure TLLevel.setPlayerPosition(Value: TLPlayerPosition);
begin
  if isPlayerPosition(Value) and (Map.data.Canvas.Pixels[Value.coords.x, Value.coords.y]<>clBlack) then
  begin
    FPlayerPosition:=Value;
  end;
end;

function TLLevel.getWidth: Integer;
begin
  Result:=Map.Size.Height;
end;

procedure TLLevel.setWidth(Value: Integer);
begin
  Map.Size.Width:=Value;
end;

function TLLevel.getHeight: Integer;
begin
  Result:=Map.Size.Height;
end;

procedure TLLevel.setHeight(Value: Integer);
begin
  Map.Size.Height:=Value;
end;

function TLLevel.getdata: TBitmap;
begin
  Result:=Map.data;
end;

function TLLevel.getViewSize: TL3DSize;
begin
  Result:=ini.ReadL3DSize('Player', 'viewsize');
end;

procedure TLLevel.setViewSize(Value:TL3DSize);
begin
  ini.WriteL3DSize('Player', 'viewsize', Value);
end;

function TLLevel.getIsWall(Ax, Ay: Integer): Boolean;
begin
  Result:=data.Canvas.Pixels[Ax, Ay]=clBlack;
end;

function ReadLevelArray(const Ident: String; var ini: TLIniFile): TLLevelArray;
var inis: TLIniFileArray;
    i: Integer;
begin
  inis:=ini.ReadIniArray(Ident);

  SetLength(Result, Length(inis));
  for i:=0 to Length(inis)-1 do
  begin
    Result[i]:=TLLevel.Create(inis[i]);
  end;
end;

end.

