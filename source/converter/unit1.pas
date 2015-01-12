unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LTypes, strutils, math, LGraphics, LIniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    f4ListBox: TListBox;
    OpenDialog: TOpenDialog;
    PanelCenter: TPanel;
    vxListBox: TListBox;
    vyListBox: TListBox;
    vzListBox: TListBox;
    OpenButton: TButton;
    vLabel: TLabel;
    fLabel: TLabel;
    vListBox: TListBox;
    fListBox: TListBox;
    f3ListBox: TListBox;
    f2ListBox: TListBox;
    f1ListBox: TListBox;
    vPanel: TPanel;
    fPanel: TPanel;
    procedure fListBoxChangeBounds(Sender: TObject);
    procedure fListBoxSelectionChange(Sender: TObject; User: boolean);
    procedure FormCreate(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
    procedure vListBoxChangeBounds(Sender: TObject);
    procedure vListBoxSelectionChange(Sender: TObject; User: boolean);
  private
    { private declarations }
  public
    { public declarations }
    procedure load;
  end;

var
  Form1: TForm1;
  obj: TStringList;
  visualisator: TVisualisator;
  ini: TLIniFile;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.load;
var
  i: Integer;
  l: String;
begin
  for i:=0 to obj.Count-1 do
  begin
    l:=obj[i];
    case LeftStr(l, 1) of
    'v':
      begin
        vListBox.Items.Add(ReplaceStr(RightStr(l, Length(l)-2), ' ', ';'));
        //vListBoxChangeBounds(nil);
      end;
    'f':
      begin
        fListBox.Items.Add(ReplaceStr(RightStr(l, Length(l)-2), ' ', ';'));
        //fListBoxChangeBounds(nil);
      end;
    end;
    //Application.ProcessMessages;
  end;
  vListBoxChangeBounds(nil);
  fListBoxChangeBounds(nil);
end;

procedure TForm1.OpenButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    if Assigned(obj) then obj.Destroy;
    obj:=TStringList.Create;
    obj.LoadFromFile(OpenDialog.FileName);
    visualisator:=TVisualisator.Create(Form1, ini.ReadIni('Visualisator', 'ini'));
    load;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ini:=TLIniFile.Create('../../main.ini');
end;

procedure TForm1.fListBoxChangeBounds(Sender: TObject);
var
  i: Integer;
  arr: TStringArray;
  index: Integer;
  fPanelVisible: Boolean;
begin
  fPanelVisible:=fPanel.Visible;
  index:=vListBox.ItemIndex;
  fPanel.Visible:=False;

  f1ListBox.Clear;
  f2ListBox.Clear;
  f3ListBox.Clear;
  f4ListBox.Clear;
  for i:=0 to fListBox.Items.Count-1 do
  begin
    arr:=StrToArray(fListBox.Items[i], ';');
    f1ListBox.Items.Add(vListBox.Items[StrToInt(arr[0])-1]);
    f2ListBox.Items.Add(vListBox.Items[StrToInt(arr[1])-1]);
    f3ListBox.Items.Add(vListBox.Items[StrToInt(arr[2])-1]);
    f4ListBox.Items.Add(vListBox.Items[StrToInt(arr[3])-1]);
  end;

  fPanel.Visible:=fPanelVisible;
  //Application.ProcessMessages;
end;

procedure TForm1.fListBoxSelectionChange(Sender: TObject; User: boolean);
var index: Integer;
begin
  index:=fListBox.ItemIndex;
  f1ListBox.ItemIndex:=index;
  f2ListBox.ItemIndex:=index;
  f3ListBox.ItemIndex:=index;
  f4ListBox.ItemIndex:=index;
end;

procedure TForm1.vListBoxChangeBounds(Sender: TObject);
var
  i: Integer;
  arr: TStringArray;
  vPanelVisible: Boolean;
begin
  vPanelVisible:=vPanel.Visible;
  vPanel.Visible:=False;

  vxListBox.Clear;
  vyListBox.Clear;
  vzListBox.Clear;
  for i:=0 to vListBox.Items.Count-1 do
  begin
    arr:=StrToArray(vListBox.Items[i], ';');
    vxListBox.Items.Add(arr[0]);
    vyListBox.Items.Add(arr[1]);
    vzListBox.Items.Add(arr[2]);
  end;

  vPanel.Visible:=vPanelVisible;
  //Application.ProcessMessages;
end;

procedure TForm1.vListBoxSelectionChange(Sender: TObject; User: boolean);
var index: Integer;
begin
  index:=vListBox.ItemIndex;
  vxListBox.ItemIndex:=index;
  vyListBox.ItemIndex:=index;
  vzListBox.ItemIndex:=index;
end;

end.

