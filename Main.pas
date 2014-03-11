unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellApi, Menus, ExtCtrls, jpeg, Buttons, Registry,
  CategoryButtons, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, DateUtils;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    cm_winautoload: TMenuItem;
    cm_quit: TMenuItem;
    N2: TMenuItem;
    cm_about: TMenuItem;
    N5: TMenuItem;
    cm_settings: TMenuItem;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton29: TSpeedButton;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    SpeedButton32: TSpeedButton;
    SpeedButton33: TSpeedButton;
    SpeedButton17: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Shape1: TShape;
    N1: TMenuItem;
    IdHTTP1: TIdHTTP;
    cm_checkupdates: TMenuItem;
    ChUpdTimer: TTimer;
    updlabel: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cm_winautoloadClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure cm_quitClick(Sender: TObject);
    procedure cm_aboutClick(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton18Click(Sender: TObject);
    procedure SpeedButton28Click(Sender: TObject);
    procedure SpeedButton27Click(Sender: TObject);
    procedure SpeedButton26Click(Sender: TObject);
    procedure SpeedButton25Click(Sender: TObject);
    procedure SpeedButton24Click(Sender: TObject);
    procedure SpeedButton23Click(Sender: TObject);
    procedure SpeedButton22Click(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure SpeedButton30Click(Sender: TObject);
    procedure SpeedButton31Click(Sender: TObject);
    procedure SpeedButton15Click(Sender: TObject);
    procedure SpeedButton29Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton32Click(Sender: TObject);
    procedure SpeedButton33Click(Sender: TObject);
    procedure cm_settingsClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure cm_checkupdatesClick(Sender: TObject);
    procedure ChUpdTimerTimer(Sender: TObject);
    procedure updlabelClick(Sender: TObject);

  private
    procedure WMHotkey(var msg: TWMHotkey); message WM_HOTKEY;
    procedure ShowMainWindow();
    procedure InsLetter(Text: string);
    procedure TryCheckUpdatesIfNeeded();
    procedure RefreshUpdateFlag();
  public
    function RegHotKey(HotKey: TShortCut; a: Integer): boolean;
    procedure MyRegWriteString(dwRootKey: DWord; const Key, Param, Val: String);
    procedure MyRegDelete(dwRootKey: DWord; const Key, Param: String);
    function MyRegReadString(dwRootKey: DWord;
      const Key, Param: String): String;
    function MyRegReadInteger(dwRootKey: DWord;
      const Key, Param: String): Integer;
    procedure IconCallBackMessage(var Mess: TMessage); message WM_USER + 100;
    procedure ReloadAndApplySettings();
    function GetAppName(): string;
  end;

type
  MyThread = class(TThread)
  protected
    procedure ShowResult1;
    procedure ShowResult2;
    procedure Execute; override;
  end;

var
  Form1: TForm1;
  Moving: boolean;
  OldLeft, OldTop: Integer;
  IsNeedCheckUpdates: boolean; // нужно ли проверить обновления
  IsHideAfterInsert: boolean;

const
  AppVersion = '1.1.7';
  AppName = 'French_Assist';
  AppDesc = 'программа для вставки французских символов';
  UpdatePath = 'http://hb.perm.ru/french/newversioncheck.php';
  ProgramSite = 'http://hb.perm.ru/french/frenchassist/index.php';
  DaysBetweenUpdate = 2;
  UpdateConnectionTimeout = 10000;

  KEYEVENTF_EXTENDEDKEY = 1;
  KEYEVENTF_KEYUP = 2;
  KEYEVENTF_UNICODE = 4;
  KEYEVENTF_SCANCODE = 8;

implementation

uses AboutBx, frmSettings;
{$R *.dfm}

function TForm1.GetAppName(): string;
begin
  Result := AppName;
end;

// Write TDateTime to Registry
procedure Reg_WriteDateTime(dwRootKey: DWord; const sKey: string;
  const sField: string; aDate: TDateTime);
begin
  with TRegistry.Create do
    try
      RootKey := dwRootKey;
      if OpenKey(sKey, True) then
      begin
        try
          WriteBinaryData(sField, aDate, SizeOf(aDate));
        finally
          CloseKey;
        end;
      end;
    finally
      Free;
    end;
end;

// Read TDateTime from Registry
function Reg_ReadDateTime(dwRootKey: DWord; const sKey: string;
  const sField: string): TDateTime;
begin
  Result := 0; // default Return value
  with TRegistry.Create do
  begin
    RootKey := dwRootKey;
    if OpenKey(sKey, False) then
    begin
      try
        ReadBinaryData(sField, Result, SizeOf(Result));
      finally
        CloseKey;
      end;
    end;
    Free;
  end;
end;

// simple = true, значит просто посылаем sendinput
// simple = false, значит посылаем sendinput и контролируем нажатие системных клавиш
procedure DoSendText(const Text: string; simple: boolean);
type
  // Эта запись преследует собой одну цель - затолкать всю информацию о клавишах в 4 байта, чтобы
  // всю информацию можно было заюзать в TList без лишних извратов.
  PKey = ^TKey;

  TKey = packed record
    Code: Word;
    Flags: Word;
  end;

  // Все просто - процедурка добавляет клавишу в список. По умолчанию - в конец списка, но можно
  // указать и любой другой индекс вставки
  procedure AddKey(List: TList; Code, Flags: Word; Index: Integer = -1);
  var
    Key: TKey;
  begin
    Key.Code := Code;
    Key.Flags := Flags;
    if Index = -1 then
      List.Add(Pointer(Key))
    else
      List.Insert(Index, Pointer(Key))
  end;

// Процедура преобразует клавиши из списка List в массив, пригодный для SendInput. Ну и, собственно,
// вызывает эту самую SendInput
  procedure SendListKeys(List: TList);
  var
    Inputs: array of TInput;
    Step: Integer;
  begin
    SetLength(Inputs, List.Count);
    for Step := 0 to List.Count - 1 do
    begin
      Inputs[Step].Itype := INPUT_KEYBOARD; // стандартно
      Inputs[Step].ki.time := 123; // х.з. почему тут это число, сам в шоке. но работает. будем считать за магию
      Inputs[Step].ki.dwExtraInfo := 0; // стандартно
      with TKey(List[Step]) // дальше показано как из 4 байт записи TKey можно
        do
      begin // получить массу полезной пинформации
        if (Flags and KEYEVENTF_UNICODE) <> 0 then
        begin
          Inputs[Step].ki.wVk := 0;
          Inputs[Step].ki.wScan := Code
        end
        else
        begin
          Inputs[Step].ki.wVk := Code;
          Inputs[Step].ki.wScan := 0
        end;
        Inputs[Step].ki.dwFlags := Flags
      end
    end;
    SendInput(List.Count, Inputs[0], SizeOf(TInput))
    // то, ради чего все затевалось
  end;

var
  Step: Integer;
  Keys, // список, который призван эмулировать нажатие требуемого текста
  Start, // список, который призван эмулировать отжатие функц. клавиш перед вставкой текста
  Finish: TList; // список, который призван эмулировать обратное нажатие функц. клавиш после вставки текста
begin
  Keys := TList.Create;
  Start := TList.Create;
  Finish := TList.Create;
  try
    // ----------------------------------------------------------------------------------------------
    // Первый этап - простое копирование текста в основной список клавиш
    // ----------------------------------------------------------------------------------------------
    for Step := 1 to Length(Text) do
    begin
      AddKey(Keys, Word(Text[Step]), KEYEVENTF_UNICODE);
      AddKey(Keys, Word(Text[Step]), KEYEVENTF_UNICODE or KEYEVENTF_KEYUP);
    end;


    // перед вводом символа нужно сэмулировать сначала отжатие контрольной клавиши, а потом её нажатие
    // AddKey(Start,  ControlKey, KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP);
    // AddKey(Finish, ControlKey, KEYEVENTF_EXTENDEDKEY);


    // ----------------------------------------------------------------------------------------------
    // Заключительный этап - вызываем SendInput
    // ----------------------------------------------------------------------------------------------
    // isMyKeyDownUp := true;

    if not simple then
    begin
      SendListKeys(Start); // Пытался экспериментировать с таймаутами мужду эмуляцей _отжатия_ функц. клавиш
      // Sleep(50);
      SendListKeys(Keys); // эмуляцией нажатия/отжатия основных клавиш
      // Sleep(50);
      SendListKeys(Finish); // и эмуляцией _нажатия_ функц. клавиш.
      // Итог один - без таймаутов все работает лучше :-)
      // А вот единственный вызов SendListKeys (а не тройной, как сейчас) - наоборот, хуже
    end
    else
    begin
      SendListKeys(Keys);
    end;

    // isMyKeyDownUp := false;

  finally
    FreeAndNil(Keys);
    FreeAndNil(Start);
    FreeAndNil(Finish)
  end

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  nid: TNotifyIconData;
begin
  // В событии OnClose удаляем горячие клавиши:
  UnRegisterHotkey(Handle, 1);
  UnRegisterHotkey(Handle, 2);
  UnRegisterHotkey(Handle, 3);
  UnRegisterHotkey(Handle, 4);
  UnRegisterHotkey(Handle, 5);
  UnRegisterHotkey(Handle, 6);
  UnRegisterHotkey(Handle, 7);

  with nid do
  begin
    cbSize := SizeOf(TNotifyIconData);
    Wnd := Form1.Handle;
    uID := 1;
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
    uCallbackMessage := WM_USER + 100;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, AppName + ' v' + AppVersion + ' - ' + AppDesc);
  end;
  Shell_NotifyIcon(NIM_DELETE, @nid);
  // Удаляем иконку из трея. Параметры мы вводим для того,
  // чтобы функция точно знала, какую именно иконку надо удалять.
  // Обратите внимание, что здесь мы исползуем константу
  // NIM_DELETE (удаление иконки).
end;

procedure TForm1.WMHotkey(var msg: TWMHotkey);
begin
  if msg.HotKey = 1 then
    ShowMainWindow();

  if msg.HotKey = 2 then
    InsLetter('à');

  if msg.HotKey = 3 then
    InsLetter('ô');

  if msg.HotKey = 4 then
    InsLetter('é');

  if msg.HotKey = 5 then
    InsLetter('è');

  if msg.HotKey = 6 then
    InsLetter('î');

  if msg.HotKey = 7 then
    InsLetter('ç');

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  nid: TNotifyIconData;
begin
  IdHTTP1.ConnectTimeout := UpdateConnectionTimeout;
  IdHTTP1.ReadTimeout := UpdateConnectionTimeout;

  RegisterHotkey(Handle, 2, MOD_CONTROL + MOD_ALT, ord('A'));
  RegisterHotkey(Handle, 3, MOD_CONTROL + MOD_ALT, ord('O'));
  RegisterHotkey(Handle, 4, MOD_CONTROL + MOD_SHIFT, ord('E'));
  RegisterHotkey(Handle, 5, MOD_CONTROL + MOD_ALT, ord('E'));
  RegisterHotkey(Handle, 6, MOD_CONTROL + MOD_ALT, ord('I'));
  RegisterHotkey(Handle, 7, MOD_CONTROL + MOD_ALT, ord('C'));

  // Добавляем иконку в трей при старте программы:
  with nid do // Указываем параметры иконки, для чего используем структуру
  // TNotifyIconData.
  begin
    cbSize := SizeOf(TNotifyIconData); // Размер все структуры
    Wnd := Form1.Handle; // Здесь мы указывает Handle нашей главной формы
    // которая будет получать сообщения от иконки.
    uID := 1; // Идентификатор иконки
    uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP; // Обозначаем то, что в
    // параметры входят:
    // Иконка, сообщение и текст
    // подсказки (хинта).
    uCallbackMessage := WM_USER + 100; // Здесь мы указываем, какое
    // сообщение должна  высылать
    // иконочка нашей главной форме,
    // в тот момент, когда на ней
    // (иконке)  происходят
    // какие-либо события
    hIcon := Application.Icon.Handle; // Указываем на Handle
    // иконки (изображения)
    // (в данной случае берем
    // иконку основной формы
    // приложения. Ниже Вы увидите
    // как можно ее изменить)
    StrPCopy(szTip, AppName + ' v' + AppVersion + ' - ' + AppDesc);
    // Указываем текст всплывающей
    // посдказки, который берем из
    // компонента ToolTip,
    // расположенного на главной
    // форме.
  end;
  Shell_NotifyIcon(NIM_ADD, @nid);
  // Собственно добавляем иконку в трей:)
  // Обратите внимание, что здесь мы исползуем константу
  // NIM_ADD (добавление иконки).
  // IconFile.Text:=Application.ExeName;
  // Выводим на главной форме пусть к файлу, который содержит
  // иконку (изображение):)
  // Icon.Picture.Icon:=Application.Icon;
  // Теперь выводим на главной форме изображение
  // иконки (изображения) в увеличенном виде

  // Form1.InitSettings();
  Form1.ReloadAndApplySettings();
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Coordinates: Longword;
  aX, aY: Integer;
begin
  if Key = VK_ESCAPE then
    Form1.Hide;

  if Key = VK_RIGHT then
    if ((Shape1.Left < 370) or (Shape1.Top > 195) and (Shape1.Left < 420)) then
      Shape1.Left := Shape1.Left + 52;

  if Key = VK_LEFT then
    if Shape1.Left > 10 then
      Shape1.Left := Shape1.Left - 52;

  if Key = VK_DOWN then
    if Shape1.Top < 195 then
      Shape1.Top := Shape1.Top + 65;

  if Key = VK_UP then
    if Shape1.Top > 10 then
      Shape1.Top := Shape1.Top - 65;

  if Key = VK_RETURN then
  begin
    aX := Shape1.Left + 10;
    aY := Shape1.Top + 10;
    Coordinates := aX or (aY shl 16);
    SendMessage(Form1.Handle, WM_LBUTTONDOWN, MK_LBUTTON, Coordinates);
    SendMessage(Form1.Handle, WM_LBUTTONUP, MK_LBUTTON, Coordinates);
  end;

end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    // нас интересует только левая кнопка
    OldLeft := X;
    // сохраняем текущую позицию
    OldTop := Y;
    Moving := True;
  end;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  // Если необходимо переместить окно относительно своей оригинальной позиции
  if Moving then
    Self.SetBounds(Self.Left + X - OldLeft, Self.Top + Y - OldTop, Self.width,
      Self.height);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
    Moving := False;
  // Останавливаем перемещение
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  // Скрываем кнопку с панели задач
  ShowWindow(Application.Handle, sw_Hide);
end;

procedure TForm1.ShowMainWindow();
begin

  if (Form1.Visible) then
    Form1.Hide
  else
  begin
    Form1.Show;
    SetForegroundWindow(Application.Handle);
  end;

end;

procedure TForm1.SpeedButton10Click(Sender: TObject);
begin
  InsLetter('É');
end;

procedure TForm1.SpeedButton11Click(Sender: TObject);
begin
  InsLetter('Ë');
end;

procedure TForm1.SpeedButton12Click(Sender: TObject);
begin
  InsLetter('Œ');
end;

procedure TForm1.SpeedButton13Click(Sender: TObject);
begin
  InsLetter('ê');
end;

procedure TForm1.SpeedButton14Click(Sender: TObject);
begin
  InsLetter('æ');
end;

procedure TForm1.SpeedButton15Click(Sender: TObject);
begin
  InsLetter('Æ');
end;

procedure TForm1.SpeedButton16Click(Sender: TObject);
begin
  InsLetter('ÿ');
end;

procedure TForm1.SpeedButton17Click(Sender: TObject);
begin
  InsLetter('û');
end;

procedure TForm1.SpeedButton18Click(Sender: TObject);
begin
  InsLetter('ë');
end;

procedure TForm1.SpeedButton19Click(Sender: TObject);
begin
  InsLetter('Û');
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  InsLetter('«');
end;

procedure TForm1.SpeedButton20Click(Sender: TObject);
begin
  InsLetter('Ÿ');
end;

procedure TForm1.SpeedButton21Click(Sender: TObject);
begin
  InsLetter('ù');
end;

procedure TForm1.SpeedButton22Click(Sender: TObject);
begin
  InsLetter('Ù');
end;

procedure TForm1.SpeedButton23Click(Sender: TObject);
begin
  InsLetter('ô');
end;

procedure TForm1.SpeedButton24Click(Sender: TObject);
begin
  InsLetter('Ô');
end;

procedure TForm1.SpeedButton25Click(Sender: TObject);
begin
  InsLetter('ï');
end;

procedure TForm1.SpeedButton26Click(Sender: TObject);
begin
  InsLetter('Ï');
end;

procedure TForm1.SpeedButton27Click(Sender: TObject);
begin
  InsLetter('î');
end;

procedure TForm1.SpeedButton28Click(Sender: TObject);
begin
  InsLetter('Î');
end;

procedure TForm1.SpeedButton29Click(Sender: TObject);
begin
  InsLetter('œ');
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  InsLetter('é');
end;

procedure TForm1.SpeedButton30Click(Sender: TObject);
begin
  InsLetter('Ç');
end;

procedure TForm1.SpeedButton31Click(Sender: TObject);
begin
  InsLetter('ç');
end;

procedure TForm1.SpeedButton32Click(Sender: TObject);
begin
  InsLetter('»');
end;

procedure TForm1.SpeedButton33Click(Sender: TObject);
begin
  InsLetter('€');
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  InsLetter('à');
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
  InsLetter('â');
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  InsLetter('À');
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
  InsLetter('È');
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
  InsLetter('Â');
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
  InsLetter('è');
end;

procedure TForm1.SpeedButton9Click(Sender: TObject);
begin
  InsLetter('Ê');
end;

procedure TForm1.cm_aboutClick(Sender: TObject);
var
  l: UnicodeString;
begin
  AboutBox.Show;
  AboutBox.ProductName.Caption := AppName + ' v' + AppVersion;
  AboutBox.Comments.Caption := AppDesc;
  l := '(c) Трубников Алексей';
  AboutBox.Copyright.Caption := l;
  AboutBox.Label1.Caption := 'tralmail@gmail.com';
  AboutBox.License.Caption := 'Программа распространяется по лицензии GNU GPL';
end;

procedure TForm1.cm_checkupdatesClick(Sender: TObject);
begin

  if (Length(MyRegReadString(HKEY_CURRENT_USER, '\Software\' + AppName,
        'AutoUpdates')) > 0) then
  begin
    MyRegDelete(HKEY_CURRENT_USER, '\Software\' + AppName, 'AutoUpdates');
    cm_checkupdates.Checked := False;
  end
  else
  begin
    MyRegWriteString(HKEY_CURRENT_USER, '\Software\' + AppName, 'AutoUpdates',
      'Yes');
    cm_checkupdates.Checked := True;
  end;

end;

procedure TForm1.cm_quitClick(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.cm_settingsClick(Sender: TObject);
begin
  fSettings.Show();
end;

procedure TForm1.cm_winautoloadClick(Sender: TObject);
begin

  if (Length(MyRegReadString(HKEY_CURRENT_USER,
        '\Software\Microsoft\Windows\CurrentVersion\Run', AppName)) > 0) then
  begin
    MyRegDelete(HKEY_CURRENT_USER,
      '\Software\Microsoft\Windows\CurrentVersion\Run', AppName);
    cm_winautoload.Checked := False;
  end
  else
  begin
    MyRegWriteString(HKEY_CURRENT_USER,
      '\Software\Microsoft\Windows\CurrentVersion\Run', AppName,
      Application.ExeName);
    cm_winautoload.Checked := True;
  end;

end;

function TForm1.RegHotKey(HotKey: TShortCut; a: Integer): boolean;
var
  TheKey: Word;
  TheShiftState: TShiftState;
  Modifiers: Cardinal;
begin
  UnRegisterHotkey(Handle, a);
  ShortCutToKey(HotKey, TheKey, TheShiftState);
  Modifiers := 0;
  if ssAlt in TheShiftState then
    Modifiers := Modifiers or MOD_ALT;
  if ssShift in TheShiftState then
    Modifiers := Modifiers or MOD_SHIFT;
  if ssCtrl in TheShiftState then
    Modifiers := Modifiers or MOD_CONTROL;
  Result := RegisterHotkey(Handle, a, Modifiers, TheKey);
end;

procedure TForm1.RefreshUpdateFlag();
begin

  // Проверяем настройку  автообновлений
  if (Length(MyRegReadString(HKEY_CURRENT_USER, '\Software\' + AppName,
        'AutoUpdates')) > 0) then
    cm_checkupdates.Checked := True
  else
    cm_checkupdates.Checked := False;

  // Делать ли проверку обновлений (должно идти до напоминалки!)
  if ((cm_checkupdates.Checked) and (DaysBetween(Now(),
        Reg_ReadDateTime(HKEY_CURRENT_USER, '\Software\' + AppName,
          'LastUpdate')) > DaysBetweenUpdate)) then
    IsNeedCheckUpdates := True
  else
    IsNeedCheckUpdates := False;

  // Напоминалка про обновлении (должно идти после проверки необходимости проверки обновлений!)
  if (Length(MyRegReadString(HKEY_CURRENT_USER, '\Software\' + AppName,
        'NewVersionExists')) > 0) then
    if (MyRegReadString(HKEY_CURRENT_USER, '\Software\' + AppName,
        'NewVersionExists') = AppVersion) then
      MyRegDelete(HKEY_CURRENT_USER, '\Software\' + AppName, 'NewVersionExists')
    else
    begin
      updlabel.Visible := True;
      updlabel.Caption := 'Доступна новая версия программы (' + MyRegReadString
        (HKEY_CURRENT_USER, '\Software\' + AppName, 'NewVersionExists') + ')';
      IsNeedCheckUpdates := False; // и так есть обновление - проверять ни к чему
    end;

end;

procedure TForm1.ReloadAndApplySettings();
begin

  // При первом запуске выставляем автозагрузку, прописываем автообновления
  if (Length(MyRegReadString(HKEY_CURRENT_USER, '\Software\' + AppName,
        'NotFirstLaunch')) < 1) then
  begin
    MyRegWriteString(HKEY_CURRENT_USER, '\Software\' + AppName,
      'NotFirstLaunch', 'Yes');
    MyRegWriteString(HKEY_CURRENT_USER, '\Software\' + AppName, 'AutoUpdates',
      'Yes');
    Reg_WriteDateTime(HKEY_CURRENT_USER, '\Software\' + AppName, 'LastUpdate',
      Now());
    MyRegWriteString(HKEY_CURRENT_USER,
      '\Software\Microsoft\Windows\CurrentVersion\Run', AppName,
      Application.ExeName);
  end;

  // Проверяем настройку автозапуска
  if (Length(MyRegReadString(HKEY_CURRENT_USER,
        '\Software\Microsoft\Windows\CurrentVersion\Run', AppName)) > 0) then
    cm_winautoload.Checked := True
  else
    cm_winautoload.Checked := False;

  RefreshUpdateFlag();

  // Цвет формы
  if (Length(MyRegReadString(HKEY_CURRENT_USER, '\Software\' + AppName,
        'WindowColor')) > 0) then
    Form1.Color := StrToInt(MyRegReadString(HKEY_CURRENT_USER,
        '\Software\' + AppName, 'WindowColor'))
  else
    Form1.Color := clSkyBlue;

  // Скрывать ли форму после вставки каждого символа
  IsHideAfterInsert := False;
  if (Length(MyRegReadString(HKEY_CURRENT_USER, '\Software\' + AppName,
        'FrmHideToggle')) > 0) then
    if (MyRegReadString(HKEY_CURRENT_USER, '\Software\' + AppName,
        'FrmHideToggle') = 'no') then
      IsHideAfterInsert := True;

  // Горячие клавиши
  UnRegisterHotkey(Handle, 1);
  if (MyRegReadInteger(HKEY_CURRENT_USER, '\Software\' + AppName,
      'HotKey0') = 0) then
    RegisterHotkey(Handle, 1, MOD_ALT, ord('Z'))
  else if not RegHotKey(MyRegReadInteger(HKEY_CURRENT_USER,
      '\Software\' + AppName, 'HotKey0'), 1) then
    ShowMessage('Не могу назначить горячую клавишу!');

end;

procedure TForm1.IconCallBackMessage(var Mess: TMessage);
var
  cursorPosition: TPoint;
begin
  case Mess.lParam of
    // Здесь Вы можете обрабатывать все события, происходящие на иконке:)
    // На главнй форме я специально расположил две метки, в которых,
    // при возникновении какого-либо события будет писаться что именно произошло:)
    // Но, теперь во второй части во время некоторых событий будут происходит
    // реальные процессы.
    {
      WM_LBUTTONDBLCLK  : TI_DC.Caption   := 'Двойной щелчок левой кнопкой'       ;

      WM_LBUTTONUP      : TI_Event.Caption:= 'Отжатие левой кнопки мыши'          ;
      WM_MBUTTONDBLCLK  : TI_DC.Caption   := 'Двойной щелчок средней кнопкой мыши';
      WM_MBUTTONDOWN    : TI_Event.Caption:= 'Нажатие средней кнопки мыши'        ;
      WM_MBUTTONUP      : TI_Event.Caption:= 'Отжатие средней кнопки мыши'        ;
      WM_MOUSEMOVE      : TI_Event.Caption:= 'Перемещение мыши'                   ;
      WM_MOUSEWHEEL     : TI_Event.Caption:= 'Вращение колесика мыши'             ;
      WM_RBUTTONDBLCLK  : TI_DC.Caption   := 'Двойной щелчок правой кнопкой'      ;
      WM_RBUTTONDOWN    : TI_Event.Caption:= 'Нажатие правой кнопки мыши'         ;
      WM_RBUTTONUP      : TI_Event.Caption:= 'Отжатие правой кнопки мыши'         ;
      }
    WM_LBUTTONDOWN:
      ShowMainWindow();
    WM_RBUTTONDOWN:
      begin
        GetCursorPos(cursorPosition);
        PopupMenu1.Popup(cursorPosition.X, cursorPosition.Y);
      end;
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  InsLetter('Œ');
end;

procedure TForm1.InsLetter(Text: string);
begin
  Form1.Hide;
  DoSendText(Text, True);
  sleep(50);

  if IsHideAfterInsert then
  begin
    Form1.Show;
    SetForegroundWindow(Application.Handle);
  end;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  ShowMainWindow();
end;

procedure TForm1.ChUpdTimerTimer(Sender: TObject);
begin
  // Смотрим надо ли проверять обновления, если надо - проверим
  RefreshUpdateFlag();
  if (IsNeedCheckUpdates) then
    TryCheckUpdatesIfNeeded();
end;

procedure MyThread.ShowResult1;
begin
  Form1.Label7.Caption := Form1.Label7.Caption + 'o';
end;

procedure MyThread.ShowResult2;
begin
  Form1.ReloadAndApplySettings();
end;

procedure MyThread.Execute;
var
  Ver: String;
begin

  inherited;

  // Synchronize(ShowResult1);

  try
    Ver := Form1.IdHTTP1.Get(UpdatePath);
  except
    Ver := 'UNKNOWN';
  end;

  if (Ver <> 'UNKNOWN') then
  begin

    if (AppVersion <> Ver) then
    begin
      // обновиться надо
      Form1.MyRegWriteString(HKEY_CURRENT_USER, '\Software\' + AppName,
        'NewVersionExists', Ver);
      Synchronize(ShowResult2);
    end;

    // сдвигаем дату следующей проверки
    Reg_WriteDateTime(HKEY_CURRENT_USER, '\Software\' + AppName, 'LastUpdate',
      Now());

  end;

end;

procedure TForm1.TryCheckUpdatesIfNeeded;
var
  ThreadBegin: MyThread;
begin

  // В отдельном потоке проверяем обновления
  ThreadBegin := MyThread.Create(False);
  ThreadBegin.Priority := tpNormal;
  ThreadBegin.FreeOnTerminate := True;
  ThreadBegin.Resume;

end;

procedure TForm1.updlabelClick(Sender: TObject);
begin
  ShellExecute(0, 'open', ProgramSite, nil, nil, SW_SHOWNORMAL);
end;

function TForm1.MyRegReadString(dwRootKey: DWord;
  const Key, Param: String): String;
var
  Res: String;
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := dwRootKey;
  Reg.OpenKey(Key, True);
  Res := Reg.ReadString(Param);
  Reg.Free;
  Result := Res;
end;

function TForm1.MyRegReadInteger(dwRootKey: DWord;
  const Key, Param: String): Integer;
var
  Res: Integer;
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := dwRootKey;
  Reg.OpenKey(Key, True);
  try
    Res := Reg.ReadInteger(Param);
  except
    Res := 0;
  end;
  Reg.Free;
  Result := Res;
end;

procedure TForm1.MyRegWriteString(dwRootKey: DWord;
  const Key, Param, Val: String);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := dwRootKey;
  Reg.OpenKey(Key, True);
  Reg.WriteString(Param, Val);
  Reg.Free;
end;

procedure TForm1.MyRegDelete(dwRootKey: DWord; const Key, Param: String);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := dwRootKey;
  Reg.OpenKey(Key, True);
  Reg.DeleteValue(Param);
  Reg.Free;
end;

end.
