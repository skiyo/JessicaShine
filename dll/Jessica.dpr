program Jessica;

uses
  Forms,
  JessicaShine in 'JessicaShine.pas' {JessicaShineForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '��֮���� - JessicaС��V2.3';
  Application.CreateForm(TJessicaShineForm, JessicaShineForm);
  Application.Run;
end.
