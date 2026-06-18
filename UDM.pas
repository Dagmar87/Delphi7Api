unit UDM;

interface

uses
  System.SysUtils,
  System.Classes,

  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Stan.Param,
  FireDAC.Phys,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.UI.Intf,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Pool, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet;

type
  TDM = class(TDataModule)
    FDConnection: TFDConnection;
    FDQueryProdutos: TFDQuery;
  public
    procedure Conectar;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.Conectar;
begin

  if Self.FDConnection.Connected then
    Exit;

  FDConnection.Params.Clear;

  FDConnection.Params.Add('DriverID=FB');

  FDConnection.Params.Add(
    'Database=C:\Users\jdfss\Documents\Embarcadero\Studio\Projects\database\produtos.fdb');

  FDConnection.Params.Add(
    'User_Name=SYSDBA');

  FDConnection.Params.Add(
    'Password=masterkey');

  FDConnection.LoginPrompt := False;

  FDConnection.Connected := True;

  FDQueryProdutos.Connection := FDConnection;
end;

end.
