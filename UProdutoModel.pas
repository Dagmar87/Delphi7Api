unit UProdutoModel;

interface

type
  TProduto = class
  private
    FId: Integer;
    FNome: string;
    FPreco: Double;
  public
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property Preco: Double read FPreco write FPreco;
  end;

implementation

end.
