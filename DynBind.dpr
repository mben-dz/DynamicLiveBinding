program DynBind;

uses
  Vcl.Forms,
  API.Types in 'API\API.Types.pas',
  ListView.Helper in 'API\ListView.Helper.pas',
  Entity.Person in 'API\Entity.Person.pas',
  API.Generics in 'API\API.Generics.pas',
  Main.View in 'Main.View.pas' {MainView};

{$R *.res}
var
  MainView: TMainView;
begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
