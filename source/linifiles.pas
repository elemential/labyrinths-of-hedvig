unit LIniFiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles, FileUtil, LTypes, strutils, Graphics, LSize;

type
  TLIniFile=class(TIniFile)
  public
    {types and variables}
    type
      TLIniFileArray=array of TLIniFile;
  public
    {functions and procedures}
    //constructor Create(const AFileName: string; AEscapeLineFeeds: Boolean=False);
    procedure ParseFn(var AFn: TLFn);
    function ReadFn(const Section, Ident: String; Default: TLFn): TLFn;
    function ReadFnArray(const Ident: String): TLFnArray;
    procedure WriteFn(const Section, Ident: String; Value: TLFn);
    function ReadIni(const Section, Ident: String; Default: TLIniFile=Nil): TLIniFile;
    function ReadIniArray(const Ident: String): TLIniFileArray;
    procedure WriteIni(const Section, Ident: String; Value: TLIniFile);
    function ReadPoint(const Section, Ident: String; Default: TPoint): TPoint;
    procedure WritePoint(const Section, Ident: String; Value: TPoint);
    function ReadL2DSize(const Section, Ident: String; Default: TL2DSize=Nil): TL2DSize;
    procedure WriteL2DSize(const Section, Ident: String; Value: TL2DSize);
    function ReadL3DSize(const Section, Ident: String; Default: TL3DSize=Nil): TL3DSize;
    procedure WriteL3DSize(const Section, Ident: String; Value: TL3DSize);
    function ReadBitmap(const Section, Ident: String; Default: TBitmap): TBitmap;
  end;

  TLIniFileArray=TLIniFile.TLIniFileArray;

implementation

procedure TLIniFile.ParseFn(var AFn: TLFn);
var appname, appdir, inipath, inidir: TLFn;
begin
  (*
  appname:=ApplicationName;
  appdir:=ExtractFileDir(appdir);
  inipath:=CreateAbsolutePath(FileName, appdir);
  *)
  inipath:=ExpandFileName(FileName);
  inidir:=ExtractFileDir(inipath);
  AFn:=CreateAbsolutePath(AFn, inidir);
end;

function TLIniFile.ReadFn(const Section, Ident: String; Default: TLFn):TLFn;
begin
  Result:=ReadString(Section, Ident, '');
  if Result='' then Result:=Default;
  ParseFn(Result);
end;

function TLIniFile.ReadFnArray(const Ident: String): TLFnArray;
var t: Text;
    strings: TStringList;
    section: String;
    i: Integer;
begin
  section:=UpperCase(LeftStr(Ident, 1))+RightStr(Ident, Length(Ident)-1);
  strings:=TStringList.Create;

  ReadSectionRaw(section, strings);

  SetLength(Result, strings.Count);
  for i:=0 to strings.Count-1 do
  begin
    Result[i]:=strings.Strings[i];
    ParseFn(Result[i]);
  end;
end;

procedure TLIniFile.WriteFn(const Section, Ident: String; Value: TLFn);
var fnFrom, fnTo: TLFn;
begin
  fnFrom:=Value;
  fnTo:=ReadFn(Section, Ident, 'RAND_'+IntToStr(Random(MaxInt))+'.ini');
  CopyFile(fnFrom, fnTo);
end;

function TLIniFile.ReadIni(const Section, Ident: String; Default: TLIniFile=Nil): TLIniFile;
var fn: TLFn;
begin
  fn:=ReadFn(Section, Ident, '');
  if fn<>'' then
  begin
    Result:=TLIniFile.Create(fn, EscapeLineFeeds);
  end
  else
  begin
    if Default=Nil then
    begin
      Result:=Self;
    end
    else
    begin
      Result:=Default;
    end;
  end;
end;

function TLIniFile.ReadIniArray(const Ident: String): TLIniFileArray;
var fns: TLFnArray;
    i: Integer;
begin
  fns:=ReadFnArray(Ident);

  SetLength(Result, Length(fns));
  for i:=0 to Length(fns)-1 do
  begin
    Result[i]:=TLIniFile.Create(fns[i]);
  end;
end;

procedure TLIniFile.WriteIni(const Section, Ident: String; Value: TLIniFile);
var fn: TLFn;
begin
  fn:=Value.FileName;
  Value.Free;
  WriteFn(Section, Ident, fn);
end;

function TLIniFile.ReadPoint(const Section, Ident: String; Default: TPoint): TPoint;
var s: String;
    Strings: TStringList;
begin
  s:=ReadString(Section, Ident, PointToStr(Default));
  Result:=StrToPoint(s);
end;

procedure TLIniFile.WritePoint(const Section, Ident: String; Value: TPoint);
begin
  WriteString(Section, Ident, PointToStr(Value));
end;

function TLIniFile.ReadL2DSize(const Section, Ident: String; Default: TL2DSize): TL2DSize;
var s: String;
begin
  if Default=Nil then Default:=TL2DSize.Create;
  s:=ReadString(Section, Ident, L2DSizeToStr(Default));
  Result:=StrToL2DSize(s);
end;

procedure TLIniFile.WriteL2DSize(const Section, Ident: String; Value: TL2DSize);
begin
  WriteString(Section, Ident, L2DSizeToStr(Value));
end;

function TLIniFile.ReadL3DSize(const Section, Ident: String; Default: TL3DSize): TL3DSize;
var s: String;
begin
  if Default=Nil then Default:=TL3DSize.Create;
  s:=ReadString(Section, Ident, L3DSizeToStr(Default));
  Result:=StrToL3DSize(s);
end;

procedure TLIniFile.WriteL3DSize(const Section, Ident: String; Value: TL3DSize);
begin
  WriteString(Section, Ident, L3DSizeToStr(Value));
end;

function TLIniFile.ReadBitmap(const Section, Ident: String; Default: TBitmap): TBitmap;
var fn: TLFn;
begin
  Result:=TBitmap.Create;
  fn:=ReadFn(Section, Ident, '');
  if fn<>'' then
  begin
    Result.LoadFromFile(fn);
  end
  else
  begin
    Result:=Default;
  end;
end;

end.

