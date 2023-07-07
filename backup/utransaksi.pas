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
  private

  public

  end;

var
  Transaksi: TTransaksi;

implementation

{$R *.lfm}

end.

