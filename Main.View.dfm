object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 252
  ClientWidth = 289
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LV_Person: TListView
    Left = 16
    Top = 40
    Width = 250
    Height = 150
    Columns = <
      item
      end
      item
      end
      item
      end>
    TabOrder = 0
  end
  object BindNav_Person: TBindNavigator
    Left = 16
    Top = 196
    Width = 250
    Height = 25
    Orientation = orHorizontal
    TabOrder = 1
  end
end