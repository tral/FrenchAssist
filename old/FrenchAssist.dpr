program FrenchAssist;

uses
  Forms,
  Windows,
  Main in 'Main.pas' {Form1},
  AboutBx in 'AboutBx.pas' {AboutBox},
  frmSettings in 'frmSettings.pas' {fSettings};

// Уменьшаем размер exe-файла
{$SETPEFLAGS IMAGE_FILE_RELOCS_STRIPPED or IMAGE_FILE_DEBUG_STRIPPED or IMAGE_FILE_LINE_NUMS_STRIPPED}

{$R *.res}

begin
  // Проверка наличия одного экземпляра
  CreateMutex(nil, True, PChar('MutexKeyForProgrammFrenchAssist'));
  if GetLastError = ERROR_ALREADY_EXISTS then
     Application.Terminate
  else
  begin
    Application.ShowMainForm := False;
    Application.Initialize;
    Application.MainFormOnTaskbar := False;
    Application.Title := 'FrenchAssist - программа для вставки французских символов';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TfSettings, fSettings);
  ShowWindow(Application.Handle, SW_HIDE);
    Application.Run;
  end;
end.
