unit Main.View;

interface

uses
{$REGION '  Use[Winapi''s] ..'}
  Winapi.Windows
, Winapi.Messages
{$ENDREGION}
{$REGION '  Use[System''s] ..'}
, System.SysUtils
, System.Variants
, System.Rtti
, System.Bindings.Outputs
, System.Classes
, System.Generics.Collections
{$ENDREGION}
{$REGION '  Use[Vcl''s] ..'}
, Vcl.Graphics
, Vcl.Controls
, Vcl.Forms
, Vcl.Dialogs
, Vcl.ComCtrls
, Vcl.StdCtrls
//, Vcl.Bind.DBEngExt
//, Vcl.Bind.Editors
, Vcl.ExtCtrls
, Vcl.Buttons
, Vcl.Bind.Navigator
{$ENDREGION}
{$REGION '  Use[Data.Bind''s] ..'}
, Data.Bind.Controls
//, Data.Bind.Components
//, Data.Bind.ObjectScope
//, Data.Bind.EngExt
{$ENDREGION}
, Entity.Person
, API.Generics
;

type
  TMainView = class(TForm)
  {$REGION '  [Components] ..'}
    LV_Person: TListView;
    BindNav_Person: TBindNavigator;
  {$ENDREGION}
    procedure FormCreate(Sender: TObject);
  private
    fPersonList: TDynamicObjectList<TPerson>;
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  MainView: TMainView;
implementation

{$R *.dfm}

procedure TMainView.FormCreate(Sender: TObject);
begin
  fPersonList := TDynamicObjectList<TPerson>.Create('ID');
  try
    fPersonList.Add(TPerson.Create(2, 'Gomez', 'Addams', 40));
    fPersonList.Add(TPerson.Create(4, 'Morticia', 'Addams', 38));
    fPersonList.Add(TPerson.Create(1, 'Pugsley', 'Addams', 8));
    fPersonList.Add(TPerson.Create(6, 'Wednesday', 'Addams', 12));
    fPersonList.Add(TPerson.Create(3, 'Uncle', 'Fester', 55));
    fPersonList.Add(TPerson.Create(5, 'Grandmama', 'Frump', 72));
    fPersonList.Add(TPerson.Create(9, 'Test', 'Lurch', 50));
    fPersonList.Add(TPerson.Create(8, 'Thing T.', 'Thing', 99));
    fPersonList.Add(TPerson.Create(7, 'Cousin', 'Itt', 21));
  finally
   fPersonList.Sort;
   fPersonList
     .Bind_List(Self, LV_Person, True)
     .BindNavigator(BindNav_Person);
  end;


end;

end.
