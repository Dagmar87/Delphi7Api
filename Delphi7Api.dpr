program Delphi7Api;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  UProdutoModel in 'UProdutoModel.pas',
  UDM in 'UDM.pas' {DM};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm1, Form1);

  Application.Run;
end.
