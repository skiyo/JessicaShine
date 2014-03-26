unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,shellApi, WinSkinData;

type
  TJessicaShineForm = class(TForm)
    Button1: TButton;
    SkinData1: TSkinData;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  JessicaShineForm: TJessicaShineForm;
  function HookOn(lpHwnd:HWND;lpType:Longint):Longint;stdcall;external 'Hook32.dll' name 'HookOn';
  function HookOff:Boolean;stdcall;external 'Hook32.dll' name 'HookOff';
implementation

{$R *.dfm}

procedure TJessicaShineForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  hookoff;
end;



procedure TJessicaShineForm.FormCreate(Sender: TObject);
var
  mhwnd:HWND;
begin
  mhwnd:=FindWindow(NIL,'FiestaOnline');//这是窗口的句柄，要自己找到后，填写入。
  if mhwnd <> 0 then
    HookOn(mhwnd,WH_KEYBOARD);
end;

procedure TJessicaShineForm.Button1Click(Sender: TObject);
begin
  hookoff;
end;

end.
