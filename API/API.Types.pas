unit API.Types;

interface

uses
  Data.DB
, Data.Bind.ObjectScope
, System.Rtti
  ;

type
  TSort = (sNone, sAsc, sDes);

  Column_Attribute = class(TCustomAttribute)
  private
    fCaption: string;
    fWidth: Integer;
  public
    constructor Create(const aCaption: string; aWidth: Integer);
    property Caption: string read fCaption; // Readonly ..
    property Width: Integer read fWidth; // Readonly ..
  end;

  TRttiPropertyHelper = class helper for TRttiProperty
  public
    function ColumnWidth: Integer;

    function TypeKind: TTypeKind;
    function GeneratorFieldType: TGeneratorFieldType;
    function FieldType: TFieldType;
  end;

  TObjectHelper = class helper for TObject
  private
    function Get_RTTI_Properties: TArray<TRttiProperty>;
    function Get_RTTI_Property(const aPropertyName: string): TRttiProperty;
  public
    property RTTI_Properties: TArray<TRttiProperty> read Get_RTTI_Properties; // Readonly ..
    property RTTI_Property[const aPropertyName: string]: TRttiProperty read Get_RTTI_Property; // Readonly ..
  end;


  TTypeKindHelper = record helper for TTypeKind

    function ToString: string;
  end;


implementation

uses
  System.SysUtils  // Use [Exception] ..
, System.Classes   // Use [TStream] ..
, Vcl.Graphics     // Use [TBitmap] ..
, Vcl.Imaging.jpeg
, Vcl.Imaging.pngimage
  ;
{ ColumnAttribute }

constructor Column_Attribute.Create(const aCaption: string; aWidth: Integer);
begin
  fCaption := aCaption;
  fWidth   := aWidth;
end;

{ TRttiPropertyHelper }

function TRttiPropertyHelper.ColumnWidth: Integer;
var
  Attr: TCustomAttribute;
begin
  for Attr in Self.GetAttributes do
  begin
    if Attr is Column_Attribute then
    begin
      Result := Column_Attribute(Attr).Width;
      Exit;
    end;
  end;
  raise Exception.CreateFmt('ColumnAttribute not found for property "%s"', [Self.Name]);
end;

function TRttiPropertyHelper.TypeKind: TTypeKind;
begin
  Result := Self.PropertyType.TypeKind;
end;

function TRttiPropertyHelper.GeneratorFieldType: TGeneratorFieldType;
type
  TClass_GenFieldType_Pair = record
    ClassType   : TClass;
    GenFieldType: TGeneratorFieldType;
  end;

const
  Class_GeneratorType_Map: array[0..3] of TClass_GenFieldType_Pair = (
    (ClassType: TStream;    GenFieldType: TGeneratorFieldType.ftTStrings),
    (ClassType: TBitmap;    GenFieldType: TGeneratorFieldType.ftBitmap),
    (ClassType: TJPEGImage; GenFieldType: TGeneratorFieldType.ftBitmap),
    (ClassType: TPngImage;  GenFieldType: TGeneratorFieldType.ftBitmap) // etc ..
  );
var
  L_PropertyType: TRttiType;
  L_MetaClass   : TClass;
  I             : Integer;
begin
  L_PropertyType := Self.PropertyType;

  case L_PropertyType.TypeKind of
    tkInteger, tkInt64:
      Result := TGeneratorFieldType.ftInteger;
    tkChar, tkWChar:
      Result := TGeneratorFieldType.ftString;
    tkEnumeration:
      Result := TGeneratorFieldType.ftBoolean;
    tkFloat:
      Result := TGeneratorFieldType.ftSingle;
    tkString, tkLString, tkWString, tkUString:
      Result := TGeneratorFieldType.ftString;
    tkUnknown, tkSet, tkMethod, tkVariant, tkArray,
    tkRecord, tkInterface, tkClassRef, tkPointer, tkProcedure:
      Result := TGeneratorFieldType.ftString;
    tkClass:
      if (L_PropertyType is TRttiInstanceType) then begin
         L_MetaClass := TRttiInstanceType(L_PropertyType).MetaclassType;

         for I := Low(Class_GeneratorType_Map) to High(Class_GeneratorType_Map) do begin
           if L_MetaClass = Class_GeneratorType_Map[I].ClassType then begin

             Result := Class_GeneratorType_Map[I].GenFieldType;
             Break;
           end
         else
           Result := TGeneratorFieldType.ftString;
         end
      end else
      Result := TGeneratorFieldType.ftString;
  else
    Result := TGeneratorFieldType.ftString;
  end;
end;

function TRttiPropertyHelper.FieldType: TFieldType;
type
  TClass_FieldType_Pair = record
    ClassType: TClass;
    FieldType: TFieldType;
  end;

const
  Class_FieldType_Map: array[0..3] of TClass_FieldType_Pair = (
    (ClassType: TStream; FieldType: TFieldType.ftBlob),
    (ClassType: TBitmap; FieldType: TFieldType.ftGraphic),
    (ClassType: TJPEGImage; FieldType: TFieldType.ftGraphic),
    (ClassType: TPngImage; FieldType: TFieldType.ftGraphic) // etc ..
  );

var
  L_PropertyType: TRttiType;
  L_MetaClass   : TClass;
  I             : Integer;
begin
  L_PropertyType := Self.PropertyType;

  case L_PropertyType.TypeKind of
    tkString, tkLString, tkWString, tkUString:
      Result := TFieldType.ftString;
    tkInteger:
      Result := TFieldType.ftInteger;
    tkInt64:
      Result := TFieldType.ftLargeint;
    tkFloat:
      Result := TFieldType.ftFloat;
    tkEnumeration:
      Result := TFieldType.ftBoolean;
    tkClass:
      if (L_PropertyType is TRttiInstanceType) then begin
         L_MetaClass := TRttiInstanceType(L_PropertyType).MetaclassType;

         for I := Low(Class_FieldType_Map) to High(Class_FieldType_Map) do begin
           if L_MetaClass = Class_FieldType_Map[I].ClassType then begin

             Result := Class_FieldType_Map[I].FieldType;
             Break;
           end
         else
           Result := TFieldType.ftUnknown;
         end
      end else
        Result := TFieldType.ftUnknown;
  else
    Result := TFieldType.ftUnknown;
  end;
end;

{ TTypeKindHelper }

const
  TypeKindNames: array[TTypeKind] of string = (
    'Unknown', 'Integer', 'Char', 'Enumeration', 'Float', 'String', 'Set',
    'Class', 'Method', 'WideChar', 'LongString', 'WideString', 'Variant',
    'Array', 'Record', 'Interface', 'Int64', 'DynamicArray', 'UnicodeString',
    'ClassReference', 'Pointer', 'Procedure', 'ManagedRecord'
  );

function TTypeKindHelper.ToString: string;
begin
  Result := TypeKindNames[Self];
end;

{ TObject }
{$REGION '  [TObject] Helper ..'}

{$REGION '  [Get RTTI] .. '}
function TObjectHelper.Get_RTTI_Properties: TArray<TRttiProperty>;
var
  L_Context   : TRttiContext;
  L_RttiType  : TRttiType;
  L_Properties: TArray<TRttiProperty>;
begin
  L_Context := TRttiContext.Create;
  try
    L_RttiType := L_Context.GetType(Self.ClassType);
    if Assigned(L_RttiType) then begin
      L_Properties := L_RttiType.GetProperties;
      if Assigned(L_Properties) then
       Result := L_Properties else
       raise Exception.CreateFmt('there is no Properties for "%s" ', [Self.ClassType]);
    end else
      raise Exception.CreateFmt('can''t get TRttiType for "%s" ', [Self.ClassType]);
  finally
    L_Context.Free;
  end;
end;

function TObjectHelper.Get_RTTI_Property(
  const aPropertyName: string): TRttiProperty;
var
  L_Context : TRttiContext;
  L_RttiType: TRttiType;
  L_RttiProp: TRttiProperty;
begin
  L_Context := TRttiContext.Create;
  try
    L_RttiType := L_Context.GetType(Self.ClassType);
    if Assigned(L_RttiType) then begin
     L_RttiProp := L_RttiType.GetProperty(aPropertyName);
     if Assigned(L_RttiProp) then
       Result   := L_RttiProp else
       raise Exception.CreateFmt('Property "%s" not found', [aPropertyName]);
    end else
      raise Exception.CreateFmt('can''t get TRttiType for "%s" ', [Self.ClassType]);
  finally
    L_Context.Free;
  end;
end;
{$ENDREGION}
{$ENDREGION}

end.
