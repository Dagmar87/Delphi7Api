unit Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  IdHTTPServer,
  IdCustomHTTPServer,
  IdContext,
  UProdutoModel;

type
  TForm1 = class(TForm)
    MemoLog: TMemo;
    btnStart: TButton;
    btnStop: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    HttpServer: TIdHTTPServer;
    Produtos: TObjectList<TProduto>;

    procedure CarregarProdutos;

    procedure OnGetRequest(
      AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);

    procedure RetornarProdutos(
      Response: TIdHTTPResponseInfo);

    procedure RetornarProdutoPorId(
      Url: string;
      Response: TIdHTTPResponseInfo);

    procedure CriarProduto(
      Request: TIdHTTPRequestInfo;
      Response: TIdHTTPResponseInfo);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Produtos := TObjectList<TProduto>.Create(True);
  HttpServer := nil;

  CarregarProdutos;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(HttpServer);
  FreeAndNil(Produtos);
end;

procedure TForm1.CarregarProdutos;
var
  P: TProduto;
begin
  P := TProduto.Create;
  P.Id := 1;
  P.Nome := 'Notebook';
  P.Preco := 3500;
  Produtos.Add(P);

  P := TProduto.Create;
  P.Id := 2;
  P.Nome := 'Mouse';
  P.Preco := 120;
  Produtos.Add(P);
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
  if Assigned(HttpServer) then
  begin
    MemoLog.Lines.Add('Servidor já iniciado.');
    Exit;
  end;

  HttpServer := TIdHTTPServer.Create(nil);

  try
    HttpServer.DefaultPort := 8080;

    HttpServer.OnCommandGet := OnGetRequest;

    HttpServer.Active := True;

    MemoLog.Lines.Add('API ONLINE - Porta 8080');

  except
    on E: Exception do
    begin
      MemoLog.Lines.Add('Erro: ' + E.Message);
      FreeAndNil(HttpServer);
    end;
  end;
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  if Assigned(HttpServer) then
  begin
    HttpServer.Active := False;
    FreeAndNil(HttpServer);
  end;

  MemoLog.Lines.Add('API OFFLINE');
end;

procedure TForm1.OnGetRequest(
  AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo;
  AResponseInfo: TIdHTTPResponseInfo);
begin

  MemoLog.Lines.Add(
    Format(
      '[%s] %s',
      [
        ARequestInfo.Command,
        ARequestInfo.Document
      ]
    )
  );

  // ==========================
  // POST /api/produtos
  // ==========================
  if SameText(ARequestInfo.Command, 'POST') then
  begin

    if SameText(
         ARequestInfo.Document,
         '/api/produtos'
       ) then
    begin
      CriarProduto(
        ARequestInfo,
        AResponseInfo
      );

      Exit;
    end;
  end;

  // ==========================
  // GET /api/status
  // ==========================
  if SameText(ARequestInfo.Command, 'GET') then
  begin

    if SameText(
         ARequestInfo.Document,
         '/api/status'
       ) then
    begin
      AResponseInfo.ContentType :=
        'application/json';

      AResponseInfo.ContentText :=
        '{"status":"online"}';

      Exit;
    end;

    // ==========================
    // GET /api/produtos
    // ==========================
    if SameText(
         ARequestInfo.Document,
         '/api/produtos'
       ) then
    begin
      RetornarProdutos(AResponseInfo);
      Exit;
    end;

    // ==========================
    // GET /api/produtos/{id}
    // ==========================
    if Pos(
         '/api/produtos/',
         ARequestInfo.Document
       ) = 1 then
    begin
      RetornarProdutoPorId(
        ARequestInfo.Document,
        AResponseInfo
      );

      Exit;
    end;
  end;

  AResponseInfo.ResponseNo := 404;
  AResponseInfo.ContentType :=
    'application/json';

  AResponseInfo.ContentText :=
    '{"erro":"rota nao encontrada"}';
end;

procedure TForm1.RetornarProdutos(
  Response: TIdHTTPResponseInfo);
var
  Produto: TProduto;
  JsonArray: TJSONArray;
  JsonObj: TJSONObject;
begin
  JsonArray := TJSONArray.Create;

  try

    for Produto in Produtos do
    begin
      JsonObj := TJSONObject.Create;

      JsonObj.AddPair('id', TJSONNumber.Create(Produto.Id));
      JsonObj.AddPair('nome', Produto.Nome);
      JsonObj.AddPair('preco', TJSONNumber.Create(Produto.Preco));

      JsonArray.AddElement(JsonObj);
    end;

    Response.ContentType := 'application/json';
    Response.ContentText := JsonArray.ToJSON;

  finally
    JsonArray.Free;
  end;
end;

procedure TForm1.RetornarProdutoPorId(
  Url: string;
  Response: TIdHTTPResponseInfo);
var
  Produto: TProduto;
  Id: Integer;
  JsonObj: TJSONObject;
begin

  Id := StrToIntDef(
    Copy(
      Url,
      Length('/api/produtos/') + 1,
      MaxInt
    ),
    0
  );

  for Produto in Produtos do
  begin
    if Produto.Id = Id then
    begin
      JsonObj := TJSONObject.Create;

      try
        JsonObj.AddPair('id',
          TJSONNumber.Create(Produto.Id));

        JsonObj.AddPair('nome',
          Produto.Nome);

        JsonObj.AddPair('preco',
          TJSONNumber.Create(Produto.Preco));

        Response.ContentType :=
          'application/json';

        Response.ContentText :=
          JsonObj.ToJSON;

      finally
        JsonObj.Free;
      end;

      Exit;
    end;
  end;

  Response.ResponseNo := 404;
  Response.ContentType := 'application/json';
  Response.ContentText :=
    '{"erro":"produto nao encontrado"}';
end;

procedure TForm1.CriarProduto(
  Request: TIdHTTPRequestInfo;
  Response: TIdHTTPResponseInfo);
var
  Stream: TStringStream;
  Body: string;
  Json: TJSONObject;
  Produto: TProduto;
begin

  if not Assigned(Request.PostStream) then
  begin
    Response.ResponseNo := 400;
    Response.ContentType := 'application/json';
    Response.ContentText :=
      '{"erro":"body nao informado"}';

    Exit;
  end;

  Stream := TStringStream.Create('', TEncoding.UTF8);

  try

    Request.PostStream.Position := 0;

    Stream.CopyFrom(
      Request.PostStream,
      Request.PostStream.Size);

    Body := Stream.DataString;

    MemoLog.Lines.Add('BODY RECEBIDO:');
    MemoLog.Lines.Add(Body);

    Json :=
      TJSONObject.ParseJSONValue(Body)
      as TJSONObject;

    if Json = nil then
    begin
      Response.ResponseNo := 400;
      Response.ContentType := 'application/json';

      Response.ContentText :=
        '{"erro":"json invalido"}';

      Exit;
    end;

    try

      Produto := TProduto.Create;

      Produto.Id :=
        Json.GetValue<Integer>('id');

      Produto.Nome :=
        Json.GetValue<string>('nome');

      Produto.Preco :=
        Json.GetValue<Double>('preco');

      Produtos.Add(Produto);

      MemoLog.Lines.Add(
        Format(
          'Produto adicionado: %d - %s',
          [
            Produto.Id,
            Produto.Nome
          ]
        )
      );

      Response.ContentType :=
        'application/json';

      Response.ContentText :=
        '{"mensagem":"produto criado com sucesso"}';

    finally
      Json.Free;
    end;

  finally
    Stream.Free;
  end;
end;

end.
