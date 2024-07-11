unit ListView.Helper;

interface

uses
  Vcl.ComCtrls
  ;

type
  TListViewHelper = class helper for TListView
  public
    procedure Add_Column(const ACaption: string; AWidth: Integer = 50);
  end;

implementation

{ TListViewHelper }

procedure TListViewHelper.Add_Column(const ACaption: string; AWidth: Integer = 50);
var
  L_Col: TListColumn;
begin
  L_Col := Self.Columns.Add;
  L_Col.Caption := ACaption;
  L_Col.Width   := AWidth;
end;

end.
