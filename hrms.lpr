program hrms;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, UtamaHrms, uConnect, zcomponent, utransaksi, Unit1;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMenuHrms, MenuHrms);
  Application.CreateForm(TTransaksi, Transaksi);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

