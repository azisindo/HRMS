unit utransaksi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  BCImageButton, BCMaterialDesignButton,ComCtrls;

type

  { TTransaksi }

  TTransaksi = class(TForm)
    BcClose: TBCMaterialDesignButton;
    BCMaterialDesignButton1: TBCMaterialDesignButton;
    procedure BcCloseClick(Sender: TObject);
  private

  public

  end;

var
  Transaksi: TTransaksi;

implementation

{$R *.lfm}

{ TTransaksi }

procedure TTransaksi.BcCloseClick(Sender: TObject);
var
  TabSheet: TTabSheet;
begin
  TabSheet := Parent as TTabSheet;

  if TabSheet <> nil then
  begin
    TabSheet.Free;
  end;

end;

end.

