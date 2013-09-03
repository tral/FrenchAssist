unit AboutBx;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellAPI;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    procedure Label1Click(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OKButtonKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then AboutBox.Close;
end;

procedure TAboutBox.Label1Click(Sender: TObject);
begin
ShellExecute(0, 'open', 'mailto:tralmail@gmail.com', nil, nil, SW_SHOWNORMAL);
//  WinExec('iexplore mailto:tralmail@gmail.com',SW_SHOWNORMAL);
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
   AboutBox.Close;
end;

procedure TAboutBox.OKButtonKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then AboutBox.Close;
end;

end.
 
