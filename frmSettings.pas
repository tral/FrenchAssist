unit frmSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ColorGrd, StdCtrls, TeCanvas, ActnColorMaps, ActnMan, ExtCtrls, Registry,
  Buttons, ComCtrls;

type
  TfSettings = class(TForm)
    ButtonColor1: TButtonColor;
    Button1: TButton;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    HotKey0: THotKey;
    Label1: TLabel;
    hfrmToggle: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSettings: TfSettings;

implementation

uses Main;

{$R *.dfm}

procedure TfSettings.Button1Click(Sender: TObject);
 var Reg: TRegistry;
     b : string;
begin
  Reg:=TRegistry.Create;

  Reg.RootKey:=HKEY_CURRENT_USER;
  Reg.OpenKey('\Software\'+Form1.GetAppName,True);
  Reg.WriteString('WindowColor', IntToStr(ButtonColor1.SymbolColor));

  if (hfrmToggle.Checked)
  then b := 'yes'
  else b := 'no';
  Reg.WriteString('FrmHideToggle', b);

  // Горячие клавиши
  Reg.WriteInteger('HotKey0', HotKey0.HotKey);

  Reg.Free;

  // Перечитаем и применим заново настройки
  Form1.ReloadAndApplySettings();

  fSettings.Close;

end;

procedure TfSettings.Button2Click(Sender: TObject);
begin
  fSettings.Close;
end;

procedure TfSettings.FormShow(Sender: TObject);
 var Reg: TRegistry;
begin
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  Reg.OpenKey('\Software\'+Form1.GetAppName,True);

  if (length(Reg.ReadString('WindowColor')) > 0)
  then ButtonColor1.SymbolColor:=StrToInt(Reg.ReadString('WindowColor'))
  else
  begin
    Reg.WriteString('WindowColor', IntToStr(15780518));
    ButtonColor1.SymbolColor := 15780518;
  end;

    if (length(Reg.ReadString('FrmHideToggle')) > 0)
  then
    begin
     if (Reg.ReadString('FrmHideToggle') = 'no') then hfrmToggle.Checked := false
                                                  else hfrmToggle.Checked := true
    end
  else
    hfrmToggle.Checked := true;

  // Горячие клавиши

  try
    HotKey0.HotKey := Reg.ReadInteger('HotKey0')
  except
    HotKey0.Hotkey :=32858;
  end;

  Reg.Free;
end;

procedure TfSettings.SpeedButton1Click(Sender: TObject);
 var Reg: TRegistry;
begin
  // Удаляем ключи
  Reg:=TRegistry.Create;
  Reg.RootKey:=HKEY_CURRENT_USER;
  Reg.OpenKey('\Software\'+Form1.GetAppName,True);

  Reg.DeleteValue('WindowColor');
  Reg.DeleteValue('HotKey0');

  Reg.Free;

  // Перечитаем и применим заново настройки
  Form1.ReloadAndApplySettings();

  fSettings.Close;
end;

end.
