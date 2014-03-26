unit JessicaShine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,shellApi, WinSkinData, Menus, RzTray, ImgList, ExtCtrls,
  jpeg,IniFiles;

type
  TJessicaShineForm = class(TForm)
    SkinData1: TSkinData;
    ImageList1: TImageList;
    RzTrayIcon1: TRzTrayIcon;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    Timer1: TTimer;
    Image1: TImage;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    OpenDialog1: TOpenDialog;
    Label6: TLabel;
    N3: TMenuItem;
    Label7: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  JessicaShineForm: TJessicaShineForm;
  function HookOn(lpHwnd:HWND;lpType:Longint):Longint;stdcall;external 'JessicaHook.dll' name 'HookOn';
  function HookOff:Boolean;stdcall;external 'JessicaHook.dll' name 'HookOff';

implementation
var
  JessicaINI:Tinifile;
    mhwnd:HWND;
{$R *.dfm}

procedure TJessicaShineForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  hookoff;
end;



procedure TJessicaShineForm.FormCreate(Sender: TObject);
var

  temp:string;
begin
//  mhwnd:=FindWindow(NIL,'FiestaOnline');//这是窗口的句柄，要自己找到后，填写入。
//  if mhwnd <> 0 then
//    HookOn(mhwnd,WH_KEYBOARD);
  //INI操作
  JessicaINI:=TIniFile.Create(GetCurrentDir()+'\'+'JessicaSET.Ini');
  Edit1.Text := JessicaINI.ReadString('Jessica','Path','请点右边的按钮设置游戏路径');
  temp := '请点右边的按钮设置游戏路径';
  if temp <> edit1.Text then
    button2.Enabled := true;

end;

procedure TJessicaShineForm.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edit1.text := OpenDialog1.FileName;
  button2.Enabled := true;
  JessicaINI.WriteString('Jessica','Path',edit1.Text);
end;



procedure TJessicaShineForm.N1Click(Sender: TObject);
begin
  ShellExecute(Handle,'open',pchar('http://bbs.jessicas.cn'),nil,nil,SW_SHOW);
end;

procedure TJessicaShineForm.Timer1Timer(Sender: TObject);
begin
  mhwnd:=FindWindow(NIL,'FiestaOnline');//这是窗口的句柄，要自己找到后，填写入。
  if mhwnd <> 0 then
  begin
    HookOn(mhwnd,WH_KEYBOARD);
    timer1.Enabled := false;
  end;
end;



procedure TJessicaShineForm.Image1Click(Sender: TObject);
begin
  ShellExecute(Handle,'open',pchar('http://bbs.jessicas.cn'),nil,nil,SW_SHOW);
end;

procedure TJessicaShineForm.Label5Click(Sender: TObject);
begin
  ShellExecute(Handle,'open',pchar('http://bbs.jessicas.cn'),nil,nil,SW_SHOW);
end;

procedure TJessicaShineForm.Button2Click(Sender: TObject);
begin
  WinExec(Pchar(edit1.text), SW_SHOWNORMAL);
  JessicaINI.WriteString('Jessica','Path',edit1.Text );
  application.Minimize;

//  JessicaINI.WriteString('Jessica','Path',Edit1.Text);
end;

procedure TJessicaShineForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := Application.MessageBox('请退出游戏后再关闭本程序！你确认要关闭吗？', '确认', 36) = 6;
end;

procedure TJessicaShineForm.N3Click(Sender: TObject);
begin
  Close;
end;

procedure TJessicaShineForm.N2Click(Sender: TObject);
begin
  RzTrayIcon1.RestoreApp;
end;

procedure TJessicaShineForm.Button4Click(Sender: TObject);
begin
    ShowWindow(mhwnd,SW_HIDE);
end;

procedure TJessicaShineForm.Button5Click(Sender: TObject);
begin
  ShowWindow(mhwnd,SW_SHOW);
end;

procedure TJessicaShineForm.Button3Click(Sender: TObject);
begin
  Application.Minimize;
end;

end.
