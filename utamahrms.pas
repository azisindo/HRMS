unit UtamaHrms;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,StdCtrls,
  CSSCtrls,cssbase ;
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

  private

  public

  end;

var
  MenuHrms: TMenuHrms;

implementation

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

  procedure AddItem(AName: String; AIcon: String);
    var
      Item: TCSSShape;
      Item2: TCSSShape;
      x,
      header,
      container, node: THtmlNode;
      I: Integer;

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
        for I := 0 to Random(6) do  begin
          node := THtmlNode.Create('').SetHover('background-color:white;color:red');
          if I=0 then
            node.Id:='Transaksi0';
          if I=1 then
            node.Id:='Transaksi1';
          if I=2 then
            node.Id:='Transaksi2';
          if I=3 then
            node.id:='Transaksi3';

          //node.SetOnClick(@buka);
          node.AddNode( HTMLSpan('color:rgb(173, 181, 189); padding:5px 0px 5px 50px;', 'Sub item ' + I.ToString));
          container.AddNode( node);
        end;

       Item.Body.AddNode( header);

       Item.Body.AddNode( container);

       Item.Changed;
      Item.Parent := MenuScrollBox;
      Item.Top :=  1000 + MenuScrollBox.ControlCount;
    end;
begin
    AddLogo;
    AddItem('Dashboard', 'f080');
    AddItem('Pages','f0f6');
    AddItem('Auth', 'f084');
    AddItem('Layouts', 'f26c');
    AddItem('Forms', 'f2d2');
    AddItem('Icons', 'f08a');
    AddItem('Tables', 'f0ce');
    AddItem('Buttons', 'f0ca');
    AddItem('Calendar', 'f073');
    AddItem('Maps', 'f278');
    AddItem('Settings', 'f013');
    AddItem('Settings is soooo long how can we handle this under this html file', 'f013');

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

end.

