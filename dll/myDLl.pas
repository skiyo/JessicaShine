unit myDLl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,ShellAPI,IniFiles,  WinSkinData, RzTray;

type
  TForm1 = class(TForm)
    PickTimer: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    NameEdit: TEdit;
    HPEdit: TEdit;
    mpEdit: TEdit;
    MonsterNameEdit: TEdit;
    Stop1Edit: TEdit;
    Stop2Edit: TEdit;
    Stop3Edit: TEdit;
    buHP: TEdit;
    buMP: TEdit;
    PickCheckBox: TCheckBox;
    Label17: TLabel;
    Label18: TLabel;
    Button1: TButton;
    Button2: TButton;
    StateTimer: TTimer;
    AttackTimer: TTimer;
    RoundTimer: TTimer;
    HPTimer: TTimer;
    MPTimer: TTimer;
    MonsterEdit: TEdit;
    Button3: TButton;
    Button4: TButton;
    SbuHP: TTimer;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    SHPEdit: TEdit;
    SMPEdit: TEdit;
    SbuMP: TTimer;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    S3CheckBox: TCheckBox;
    Edit1: TEdit;
    S4CheckBox: TCheckBox;
    Edit2: TEdit;
    S5CheckBox: TCheckBox;
    Edit3: TEdit;
    Label26: TLabel;
    S3Timer: TTimer;
    S4Timer: TTimer;
    S5Timer: TTimer;
    SkinData1: TSkinData;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    HomeHP: TEdit;
    HomeMP: TEdit;
    HomeHPCheck: TCheckBox;
    HomeMPCheck: TCheckBox;
    HomeHPTimer: TTimer;
    HomeMPTimer: TTimer;
    StopHomeHPTimer: TTimer;
    StopHomeMPTimer: TTimer;
    BloodTimer: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PickTimerTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AttackTimerTimer(Sender: TObject);
    procedure StateTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure buHPKeyPress(Sender: TObject; var Key: Char);
    procedure buMPKeyPress(Sender: TObject; var Key: Char);
    procedure MPTimerTimer(Sender: TObject);
    procedure HPTimerTimer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RoundTimerTimer(Sender: TObject);
    procedure Label18Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SbuHPTimer(Sender: TObject);
    procedure SbuMPTimer(Sender: TObject);
    procedure S3TimerTimer(Sender: TObject);
    procedure S4TimerTimer(Sender: TObject);
    procedure S5TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HomeHPTimerTimer(Sender: TObject);
    procedure HomeMPTimerTimer(Sender: TObject);
    procedure StopHomeHPTimerTimer(Sender: TObject);
    procedure StopHomeMPTimerTimer(Sender: TObject);
    procedure BloodTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type  // ---- 定义参数指针
  P1_STR = packed record
  Param1: DWORD;
  Param2: DWORD;
  end;
  PP1_STR = ^P1_STR;

var
  Form1: TForm1;
  function HookProc(nCode:Integer;WParam: WPARAM;LParam:LPARAM):LRESULT;stdcall; 
  function HookOn(lpHwnd:HWND;lpType:Longint):Longint;stdcall;export;
  function HookOff:Boolean;stdcall;export;
implementation

{$R *.dfm}
var
  hHk: HHOOK=0;
  hMOUSEHk: HHOOK=0;
  mhwnd:HWND=0;
  bShow:integer=0;
  myKey:Byte=VK_F12;
 // kbArray:TKeyboardState;
  hThread: Cardinal;
  hmod: Pointer; //Hinstance
//  hProcessId: Cardinal;
  Base, BaseD: Integer;
  HP, MP,MaxHP, MaxMP: Integer;
  monster : Integer  ;
  MyHwnd:Hwnd;
  hProcess_N: THandle;
  ByteRead: Cardinal;
  ThreadID: DWORD;
  JessicaINI:Tinifile;
  flag:bool=false;
  HomeHPFlag:bool=false;
  HomeMPFlag:bool=false;
  BloodFlag:bool=false;
// KeyHookStruct:^THardwareHookStruct; 
//mMode:Integer;

function HookProc(nCode:Integer;WParam: WPARAM;LParam:LPARAM):LRESULT;stdcall;
begin
  Result :=0;
  if nCode<0 then
    Result := CallNextHookEx(hHk,nCode,WParam,LParam)
  else
  begin
    //kbArray[myKey] := 1;
    //SetKeyboardState(kbArray);
    //GetKeyboardState(kbArray);
    if (bShow = 0) And (wParam=VK_F12 ) then
    begin
      bShow:=1;
      Form1:=TForm1.Create(nil);
      Result :=1;
      SuspendThread(hThread);
      Form1.Show;
      ShowCursor(true);
      ResumeThread(hThread);
     // kbArray[myKey] := 0;
     // SetKeyboardState(kbArray);
    end;
    if (bshow = 2) and (wParam=VK_F12 ) then
    begin
      Result :=1 ;
      bshow := 1;
      Form1.Show;
      ShowCursor(true);
      ResumeThread(hThread);
     // kbArray[myKey] := 0;
     // SetKeyboardState(kbArray);
    end;
end;
end;

function HookOn(lpHwnd:HWND;lpType:Longint): Longint;stdcall; export;
begin
  mhwnd:=lpHwnd;
  if hHk<>0 then UnHookWindowsHookEx(hHk);
  hThread :=GetWindowThreadProcessId(mhwnd,hmod);
  hHk :=SetWindowsHookEx(lpType,@HookProc,hInstance,hThread); // WH_KEYBOARD
  Result :=hHk
end;

function HookOff:Boolean;stdcall; export;
begin
  if hHk<>0 then
  begin
    UnHookWindowsHookEx(hHk);
    hHk :=0;
    Result :=true;
  end
  else
  Result :=false;
end;

function getdlldir:widestring;
var
  Buffer: array[0..255] of Char;
begin
  Windows.GetModuleFileName(GetModuleHandle('JessicaHook.dll'), Buffer, 255);
  result:=buffer;
  result:=copy(result,1,length(result)-15);
end;
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  bShow:=0;
  UnHookWindowsHookEx(hHk);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  bShow:=0;
  UnHookWindowsHookEx(hHk);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ShowCursor(true);
end;

procedure Tab; Stdcall;
var
  Address:pointer;
begin
  Address:=Pointer($43B9C0);
  asm
    pushad
    mov esi,[$754EA4]
    mov ecx,esi
    call Address
    popad
  end;
end;

procedure Home; Stdcall;
var
  Address:pointer;
begin
  Address:=Pointer($43A8D0);
  asm
    pushad
    mov esi,[$754EA4]
    mov ecx,esi
    call Address
    popad
  end;
end;

procedure AnJian(P1:Dword); Stdcall;
var
  Address: pointer;
begin
  Address:=Pointer($43ABC0);
  asm
    pushad
    mov esi,[$754EA4]
    push 1
    push p1
    mov ecx,esi
    call Address
    popad
  end;
end;

procedure TForm1.PickTimerTimer(Sender: TObject);
begin
  AnJian($3);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if PickCheckBox.Checked = true then
    PickTimer.Enabled := true
  else
    PickCheckBox.Checked := false ;
  Stop1Edit.Enabled := false;
  Stop2Edit.Enabled := false;
  Stop3Edit.Enabled := false;
  buHP.Enabled := false;
  buMP.Enabled := false;
  button1.Enabled := false;
  button2.Enabled := true;
  if S3CheckBox.Checked then
  begin
     S3Timer.Interval := StrToInt(Edit1.Text);
     S3Timer.Enabled := true;
  end;
  Edit1.Enabled := false;
  S3CheckBox.Enabled := false;
  if S4CheckBox.Checked then
  begin
     S4Timer.Interval := StrToInt(Edit2.Text);
     S4Timer.Enabled := true;
  end;
  S4CheckBox.Enabled := false;
  Edit2.Enabled := false;
  if S5CheckBox.Checked then
  begin
     S5Timer.Interval := StrToInt(Edit3.Text);
     S5Timer.Enabled := true;
  end;
  if HomeHPCheck.Checked then
  begin
    HomeHPTimer.Enabled := true;
    StopHomeHPTimer.Enabled := true;
  end;
  if HomeMPCheck.Checked then
  begin
    HomeMPTimer.Enabled := true;
    StopHomeMPTimer.Enabled := true;
  end;

  HomeHPCheck.Enabled := false;
  HomeMPCheck.Enabled := false;
  HomeHP.Enabled := false;
  HomeMP.Enabled := false;
  S5CheckBox.Enabled := false;
  Edit3.Enabled := false;
  SHPEdit.Enabled := false;
  SMPEdit.Enabled := false;
  Tab;
  AttackTimer.Enabled := true;
  Roundtimer.Enabled := true;
  

end;

procedure TForm1.AttackTimerTimer(Sender: TObject);
begin
  if MonsterEdit.Text <> '0' then
  begin
    if (MonsterNameEdit.Text = Stop1edit.Text) or (MonsterNameEdit.Text = Stop2Edit.Text) or (MonsterNameEdit.Text = Stop3Edit.Text)  then
    begin
    tab;
    flag := true;
    exit;
    end;
    flag := false;
    Anjian($2);
  end
  else
    Tab;
end;

procedure TForm1.StateTimerTimer(Sender: TObject);
var
  MonsterName: array [0..16] of Char;
begin
  ReadProcessMemory(hProcess_N, Pointer(Base), @BaseD, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer(BaseD+($23c)), @HP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer(BaseD+($988)),  @monster, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer(monster+($1FA)),  @MonsterName, 16, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer($75d5b8), @MaxHP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer(BaseD+($244)), @MP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer($75d5bc), @MaxMP, 4, ByteRead);
  HPEdit.Text := inttostr(HP) + '/' + inttostr(MaxHP);
  MPedit.Text := inttostr(MP) + '/' + inttostr(MaxMP);
  MonsterEdit.Text := inttostr(Monster);
  MonsterNameEdit.Text := MonsterName;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Name: array [0..16] of Char;
  Tab : single;
  OldProtect: Cardinal;
begin
  Tab := 2000;
  MyHwnd:=findwindow(nil, 'FiestaOnline');
  GetWindowThreadProcessId(MyHwnd, @ThreadID);
  hProcess_N := OpenProcess(PROCESS_ALL_ACCESS, False, ThreadID);
  Base:=$75cf60;
  ReadProcessMemory(hProcess_N, Pointer(Base), @BaseD, 4, ByteRead);
  //ReadProcessMemory(hProcess_N, Pointer(BaseD+($988)),  @monster, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer(BaseD+($23c)), @HP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer($75d5b8), @MaxHP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer(BaseD+($244)), @MP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer($75d5bc), @MaxMP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer(BaseD+($1fa)), @Name, 16, ByteRead);
  VirtualProtectEx(hProcess_N, Pointer($6D9FAC), SizeOf(single),PAGE_EXECUTE_READWRITE,OldProtect);
  WriteProcessMemory(hProcess_N, Pointer($6D9FAC), @Tab, SizeOf(Tab), ByteRead);
  NameEdit.Text := name;
  HPEdit.Text := inttostr(HP) + '/' + inttostr(MaxHP);
  MPedit.Text := inttostr(MP) + '/' + inttostr(MaxMP);
  //以下为INI操作
  JessicaINI:=TInifile.Create(getdlldir + '\' + 'JessicaSET.ini');
  //读取INI
  if fileexists(getdlldir + '\' + 'JessicaSET.ini') then
  begin
    Stop1Edit.Text := JessicaINI.ReadString('Jessica','Stop1','');
    Stop2Edit.Text := JessicaINI.ReadString('Jessica','Stop2','');
    Stop3Edit.Text := JessicaINI.ReadString('Jessica','Stop3','');
    buHP.Text := JessicaINI.ReadString('Jessica','HP','100');
    buMP.Text := JessicaINI.ReadString('Jessica','MP','100');
    PickCheckBox.Checked := JessicaINI.ReadBool('Jessica','AutoPick',PickcheckBox.Checked);
    SHPEdit.Text := JessicaINI.ReadString('Jessica','SHP','100');
    SMPEdit.Text := JessicaINI.ReadString('Jessica','SMP','100');
    S3CheckBox.Checked := JessicaINI.ReadBool('Jessica','S3',S3CheckBox.Checked);
    S4CheckBox.Checked := JessicaINI.ReadBool('Jessica','S4',S4CheckBox.Checked);
    S5CheckBox.Checked := JessicaINI.ReadBool('Jessica','S5',S5CheckBox.Checked);
    Edit1.Text := JessicaINI.ReadString('Jessica','S3Time','1000');
    Edit2.Text := JessicaINI.ReadString('Jessica','S4Time','1000');
    Edit3.Text := JessicaINI.ReadString('Jessica','S5Time','1000');
    HomeHPCheck.Checked := JessicaINI.ReadBool('Jessica','HomeHPCheck',HomeHPCheck.Checked);
    HomeMPCheck.Checked := JessicaINI.ReadBool('Jessica','HomeMPCheck',HomeMPCheck.Checked);
    HomeHP.Text := JessicaINI.ReadString('Jessica','HomeHP','100');
    HomeMP.Text := JessicaINI.ReadString('Jessica','HomeMP','100');
  end;
end;

procedure TForm1.buHPKeyPress(Sender: TObject; var Key: Char);
begin
 if not (Key in ['0'..'9']) then Key:=#0;
end;

procedure TForm1.buMPKeyPress(Sender: TObject; var Key: Char);
begin
 if not (Key in ['0'..'9']) then Key:=#0;
end;

procedure TForm1.MPTimerTimer(Sender: TObject);
begin
  if (HP < (StrToInt(buHP.Text))) then
    AnJian($0);
end;

procedure TForm1.HPTimerTimer(Sender: TObject);
begin
  if (MP < (StrToInt(buMP.Text))) then
    AnJian($1);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Stop1Edit.Enabled := true;
  Stop2Edit.Enabled := true;
  Stop3Edit.Enabled := true;
  buHP.Enabled := true;
  buMP.Enabled := true;
  button1.Enabled := true;
  button2.Enabled := false;
  AttackTimer.Enabled := false;
  //PickTimer.Enabled := false;
  RoundTimer.Enabled := false;
  S3Timer.Enabled := false;
  S4Timer.Enabled := false;
  S5Timer.Enabled := false;
  S3CheckBox.Enabled := true;
  S4CheckBox.Enabled := true;
  S5CheckBox.Enabled := true;
  Edit1.Enabled := true;
  Edit2.Enabled := true;
  Edit3.Enabled := true;
  SHPEdit.Enabled := true;
  SMPEdit.Enabled := true;
  HomeHPCheck.Enabled := true;
  HomeMPCheck.Enabled := true;
  HomeHP.Enabled := true;
  HomeMP.Enabled := true;
  HomeHPTimer.Enabled := false;
  HomeMPTimer.Enabled := false;
  StopHomeHPTimer.Enabled := false;
  StopHomeHPTimer.Enabled := false;
end;

procedure TForm1.RoundTimerTimer(Sender: TObject);
var
  Num: cardinal;
  Round: Integer;

begin
    ReadProcessMemory(hProcess_N, Pointer($7E9656), @Round,   4,   Num);
    Round := Round + 100;
    WriteProcessMemory(hProcess_N, Pointer($7E9656), @Round, SizeOf(Round), Num);
end;

procedure TForm1.Label18Click(Sender: TObject);
begin
  ShellExecute(Handle,'open',pchar('http://bbs.jessicas.cn'),nil,nil,SW_SHOW);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Form1.Hide;
  bShow := 2;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  JessicaINI.WriteString('Jessica','Stop1',Stop1Edit.Text);
  JessicaINI.WriteString('Jessica','Stop2',Stop2Edit.Text);
  JessicaINI.WriteString('Jessica','Stop3',Stop3Edit.Text);
  JessicaINI.WriteString('Jessica','HP',buHP.Text);
  JessicaINI.WriteString('Jessica','MP',buMP.Text);
  JessicaINI.WriteBool('Jessica','AutoPick',PickCheckBox.Checked);
  JessicaINI.WriteString('Jessica','SHP',SHPEdit.Text);
  JessicaINI.WriteString('Jessica','SMP',SMPEdit.Text);
  JessicaINI.WriteBool('Jessica','S3',S3CheckBox.Checked);
  JessicaINI.WriteBool('Jessica','S4',S4CheckBox.Checked);
  JessicaINI.WriteBool('Jessica','S5',S5CheckBox.Checked);
  JessicaINI.WriteString('Jessica','S3Time',Edit1.Text);
  JessicaINI.WriteString('Jessica','S4Time',Edit2.Text);
  JessicaINI.WriteString('Jessica','S5Time',Edit3.Text);
  JessicaINI.WriteBool('Jessica','HomeHPCheck',HomeHPCheck.Checked);
  JessicaINI.WriteBool('Jessica','HomeMPCheck',HomeMPCheck.Checked);
  JessicaINI.WriteString('Jessica','HomeHP',HomeHP.Text);
  JessicaINI.WriteString('Jessica','HomeMP',HomeMP.Text);
end;

procedure TForm1.SbuHPTimer(Sender: TObject);
begin
  if (HP < (StrToInt(SHPEdit.Text))) then
    AnJian($12);
end;

procedure TForm1.SbuMPTimer(Sender: TObject);
begin
  if (MP < (StrToInt(SMPEdit.Text))) then
    AnJian($13);
end;

procedure TForm1.S3TimerTimer(Sender: TObject);
begin
  if flag = false then
    Anjian($14);
end;

procedure TForm1.S4TimerTimer(Sender: TObject);
begin
  if flag = false then
    Anjian($15);
end;

procedure TForm1.S5TimerTimer(Sender: TObject);
begin
  if flag = false then
    Anjian($16);
end;

procedure TForm1.FormShow(Sender: TObject);
var
  Name: array [0..16] of Char;
  Tab : single;
  OldProtect: Cardinal;
begin
  Tab := 2000;
  MyHwnd:=findwindow(nil, 'FiestaOnline');
  GetWindowThreadProcessId(MyHwnd, @ThreadID);
  hProcess_N := OpenProcess(PROCESS_ALL_ACCESS, False, ThreadID);
  Base:=$75cf60;
  ReadProcessMemory(hProcess_N, Pointer(Base), @BaseD, 4, ByteRead);
  //ReadProcessMemory(hProcess_N, Pointer(BaseD+($988)),  @monster, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer(BaseD+($23c)), @HP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer($75d5b8), @MaxHP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer(BaseD+($244)), @MP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer($75d5bc), @MaxMP, 4, ByteRead);
  ReadProcessMemory(hProcess_N, Pointer(BaseD+($1fa)), @Name, 16, ByteRead);
  VirtualProtectEx(hProcess_N, Pointer($6D9FAC), SizeOf(single),PAGE_EXECUTE_READWRITE,OldProtect);
  WriteProcessMemory(hProcess_N, Pointer($6D9FAC), @Tab, SizeOf(Tab), ByteRead);
  NameEdit.Text := name;
  HPEdit.Text := inttostr(HP) + '/' + inttostr(MaxHP);
  MPedit.Text := inttostr(MP) + '/' + inttostr(MaxMP);
end;

procedure TForm1.HomeHPTimerTimer(Sender: TObject);
begin
  if ((HP < (StrToInt(HomeHP.Text))) and (MonsterEdit.Text = '0')) then
  begin
    Home;
    HomeHPFlag := true;
  end;
end;

procedure TForm1.HomeMPTimerTimer(Sender: TObject);
begin
  if ((MP < (StrToInt(HomeMP.Text))) and (MonsterEdit.Text = '0')) then
  begin
    Home;
    HomeMPFlag := true;
  end;
end;

procedure TForm1.StopHomeHPTimerTimer(Sender: TObject);
begin
  if ((HP = MaxHP ) and (HomeHPFlag = true)) or ((BloodFlag = true) and (HomeHPFlag = true)) then
  begin
    Home;
    HomeHPFlag := false;
  end;
end;

procedure TForm1.StopHomeMPTimerTimer(Sender: TObject);
begin
  if (MP = MaxMP ) and (HomeMPFlag = true) then
  begin
    Home;
    HomeMPFlag := false;
  end;
end;


procedure TForm1.BloodTimerTimer(Sender: TObject);
var
  tempHP:integer;
begin
  ReadProcessMemory(hProcess_N, Pointer(BaseD+($23c)), @tempHP, 4, ByteRead);
  if tempHP >= HP then
    BloodFlag := false
  else
    BloodFlag := true;
end;

end.
