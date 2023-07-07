unit UtamaHrms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,StdCtrls,
  CSSCtrls,cssbase,uConnect,ZDataset, DB,TypInfo  ;
type
  TMyFormClass=Class of TForm;
  TMyTabSheet= Class(TTabSheet)
    Private
      TabForm:TForm;
      fFormClass:TMyFormClass;

    Protected
       Constructor Create(Aowner:TComponent); Reintroduce;
    Public
       Constructor New(Aowner:TComponent; YourFormClass:TMyFormClass);
       Property FormClass:TMyFormClass Read fFormClass;
  end;

type

  { TMenuHrms }

  TMenuHrms = class(TForm)
    PanelAtas: TPanel;
    PGC1: TPageControl;
    MenuScrollBox: TScrollBox;
    StatusBar: TStatusBar;
    UtamaFormsScb: TScrollBox;
    procedure FormCreate(Sender: TObject);

    procedure OnItemClick(Sender: TObject);
    procedure buka(Sender: TObject);
  private
  //membuat tab baru pada page control
  function BuatTab(FormClass:TMyFormClass): TMyTabSheet;

  //menampilkan form yang page page control
  procedure TampilForm(NewFormClass: TMyFormClass; ImgIndex: Integer);

  //cek apakah form sudah ditampilkan pada page control
  function CekFormSudahAda(FormClass:TMyFormClass): TMyTabSheet;

  public

  end;

var
  MenuHrms: TMenuHrms;

implementation
uses
   utransaksi , Unit1;

{$R *.lfm}

{ TMenuHrms }

procedure TMenuHrms.FormCreate(Sender: TObject);

  procedure AddLogo;
    var
      Item: TCSSShape;
    begin
      Item := TCSSShape.Create(Self);
      Item.Align := alTop;
      Item.AutoSize := True;
      Item.Body.InlineStyle := 'color:rgb(173, 181, 189);margin-bottom:10px;';
      //Item.Body.OnClick := @Button2Click;
      Item.Body.AddNode( HTMLFa('font:30px;margin-left:20px;color:#47BAC1;', 'f1cb').SetHover('color:red;'));  // main icon
      Item.Body.AddNode( HTMLSpan('font:18px;color:white; padding:15px 10px; padding-right:0px;', 'AppHrms')); // app name
      Item.Body.AddNode( HTMLSpan('display:inline-block;font:9px;color:white;margin-left:20px;margin-top:20px;', 'Main'));               // main text
      Item.Top := 0;
      Item.Parent := MenuScrollBox;
    end;

  procedure AddItem(AName: String; AIcon: String; msfid: String);
    var
      Item: TCSSShape;
      header,
      container, node: THtmlNode;
      I: Integer;
      Connect: TConnect;
      Query: TZQuery;

    begin

      Item := TCSSShape.Create(Self);
      Item.Align := alTop;
      Item.AutoSize := True;

      // create "section" header
      //header := THtmlNode.Create('color:rgb(173, 181, 189);cursor:pointer;').SetHover('background-color:#2D3646; color:#e9ecef;').SetOnClick(@OnItemClick);
      header := THtmlNode.Create('color:rgb(173, 181, 189);cursor:pointer;').SetHover('color:white; background-color:#005a9e;').SetOnClick(@OnItemClick);
      header.Id := AName;

      if AIcon = '' then AIcon := 'f2b9';
      header.AddNode( HTMLFa('font:18px;padding-left:20px;cursor:move;', AIcon));             // left category icon
      header.AddNode( HTMLSpan('font:10px;color:white;padding:15px 10px; padding-right:0px;', AName));   // category caption
      header.AddNode( HTMLFa('font:15px;', 'f107'));                                          // drop down icon

      header.AddNode( HTMLSpan('font:7px;font-weight:bold;margin-left:10px; padding:2px 5px; color:white; background-color:#47BAC1', 'New')) ;

      // some random badges for section
     { if MenuScrollBox.ControlCount mod 4 = 0 then header.AddNode( HTMLSpan('font:7px;font-weight:bold;margin-left:10px; padding:2px 5px; color:white; background-color:#47BAC1', 'New'))
      else
      if MenuScrollBox.ControlCount mod 3 = 0 then  header.AddNode( HTMLSpan('font:7px;margin-left:10px; padding:2px 5px; color:white; background-color:#A180DA', 'Special'));
      }

      // sub items for section
      container := THtmlNode.Create('display:none');
      container.Id := 'container';

      Connect := TConnect.Create();
      try
        if Connect.Connect then
        begin
          Query := Connect.ExecuteQuery('select ms_descp from hrms.ms_forms where msf_parent_id='+QuotedStr(msfid));
          if Query <> nil then
          begin
            // menggunakan TDataSource yang telah ditambahkan
            Connect.DataSource.DataSet := Query;
                                                                          //    Query.FieldByName('descp').AsString
            while not Query.EOF do
            begin
               node   := THtmlNode.Create('').SetHover('background-color:white;color:red');
               node.id:= Query.FieldByName('ms_descp').AsString;
               //node.AddNode( HTMLSpan('color:rgb(173, 181, 189); padding:5px 0px 5px 50px;', 'Sub item ' + I.ToString));
               node.SetOnClick(@buka);
               node.AddNode( HTMLSpan('color:rgb(173, 181, 189); padding:5px 0px 5px 50px;',Query.FieldByName('ms_descp').AsString));
               container.AddNode( node);
               Query.Next;
            end;
          end;
        end
        else
          ShowMessage(Connect.Logger);
      finally
        Connect.Free;
      end;

      Item.Body.AddNode( header);
      Item.Body.AddNode( container);

      Item.Changed;
      Item.Parent := MenuScrollBox;
      Item.Top :=  1000 + MenuScrollBox.ControlCount;
    end;

var
  Connect: TConnect;
  Query: TZQuery;
  DataSource:TDataSource;

begin
  AddLogo;

  Connect := TConnect.Create();
  try
    if Connect.Connect then
    begin
      Query := Connect.ExecuteQuery(' SELECT t1.msf_id id, t1.ms_descp descp,t1.msf_parent_id parent_id FROM' +
                                    ' hrms.ms_forms AS t1 LEFT JOIN hrms.ms_forms as t2 '+
                                    ' ON t1.msf_id = t2.msf_parent_id '+
                                    ' WHERE t2.msf_parent_id IS not NULL'+
                                    ' group by t1.msf_id');
      if Query <> nil then
      begin
        // menggunakan TDataSource yang telah ditambahkan
        Connect.DataSource.DataSet := Query;

        while not Query.EOF do
        begin
           AddItem(Query.FieldByName('descp').AsString, 'f080',Query.FieldByName('id').AsString);
           Query.Next;
        end;
      end;
    end
    else
      ShowMessage(Connect.Logger);
  finally
    Connect.Free;
  end;
end;



Constructor TMyTabSheet.New(Aowner: TComponent; YourFormClass: TMyFormClass);
begin
  Inherited Create(Aowner);
  fFormClass:=YourFormClass;
end;

Constructor TMyTabSheet.Create(Aowner: TComponent);
begin
  Inherited Create(Aowner);
end;

procedure TMenuHrms.OnItemClick(Sender: TObject);
var
  Node: THtmlNode;
begin
  Node := THtmlNode(Sender);  // this is 'header' node
  Node := Node.GetNext(Node); // next sibling is 'container' (see AddItem in FormCreate) with "display:none"
  if Node.CompStyle.Display = cdtBlock then       // change current computed style
    Node.CompStyle.Display := cdtNone
  else
    Node.CompStyle.Display := cdtBlock;

  Node.Style.Display := Node.CompStyle.Display;   // change "default" style (after no more :hover)
  TCSSShape(Node.RootNode.ParentControl).Changed; // relayout and repaint
end;

procedure TMenuHrms.buka(Sender: TObject);

var
  html:THtmlNode;
begin

  if sender is THtmlNode then
    begin
      html := THtmlNode(Sender);
      //ShowMessage('masuk sini  -> : '+html.Id);
      if html.Id='Master Forms' then
        TampilForm(TTransaksi,0);
      if html.Id='Master User' then
        TampilForm(TForm1,0);

    end
end;

function TMenuHrms.BuatTab(FormClass: TMyFormClass): TMyTabSheet;
Var H:TMyTabSheet;
begin
  {fungsi digunakan untuk membuat tabsheet baru, kemudian tab tersebut 'ditancapkan'
   pada page control yang diinginkan, dan otomatis menjadikannya sebagai tab yang aktif
   saat itu}
  Result:=Nil;
  if Assigned(CekFormSudahAda(FormClass)) then Exit;
  H:=TMyTabSheet.New(Self,FormClass);
  H.PageControl:=PGC1;
  H.TabForm:=H.FormClass.Create(Application);
  H.TabForm.BorderStyle:=bsNone;
  H.Caption:=H.TabForm.Caption;
  H.TabForm.Parent:=H;
  H.TabForm.Align:=AlClient;
  PGC1.ActivePageIndex:=PGC1.PageCount - 1;
  H.TabForm.Show;
  Result:=H;
end;

procedure TMenuHrms.TampilForm(NewFormClass: TMyFormClass; ImgIndex: Integer);
var tab: TTabSheet;
begin
  {jika form sudah ada / ditampilkan dalam tab, maka tab tersebut diaktifkan
  (dijadikan tab aktif. Jika Form belum ada, maka tab baru dibuat, dan form yang
  dimaksudkan diletakkan di tab tersebut}
  if Assigned(CekFormSudahAda(NewFormClass)) then
    pgc1.ActivePageIndex:=CekFormSudahAda(NewFormClass).TabIndex
  else begin
    Tab:=BuatTab(NewFormClass);
    if Assigned(Tab) then
       Tab.ImageIndex:=ImgIndex;
  end;

end;

function TMenuHrms.CekFormSudahAda(FormClass: TMyFormClass): TMyTabSheet;
var i: Integer;
    H:TMyTabSheet;
begin
  {nilai awal result adalah nil. Jika tab yang mengandung form
   ditemukan, maka fungsi ini akan mengembalikan referensi dari
   tab tersebut. jika tidak ada maka fungsi mengembalikan nilai
   nil. Penting untuk memberikan nilai awal nil, karena jika
   tidak, fungsi Assigned(CekFormSudahAda) akan selalu
   mengembalikan nilai True, baik form tersebut sudah ada
   atau tidak.}
  Result:= nil;
  if PGC1.PageCount<1 then Exit;


  {cek berdasar caption tab}
  H:=Nil;
  for i := 0 to pgc1.PageCount-1 do
    if TMyTabSheet(PGC1.Pages[i]).FormClass=FormClass then begin
       H:=TMyTabSheet(PGC1.Pages[i]);
       Break;
    end;
  Result:=H;
end;

end.

