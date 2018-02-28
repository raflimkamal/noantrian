unit Antrian;

{$mode objfpc}{$H+}

interface

uses
  Classes,mmsystem, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

const
     MaxAntrian=1000;
type
  {Queue linked list}
  PointerQueue=^SimpulQueue;
    SimpulQueue=record
      info:string;
      next,prev:PointerQueue
    end;
    NAntrian=array[0..MaxAntrian]of string;

  { TForm1 }

  TForm1 = class(TForm)
    Button_keluar: TButton;
    Button_bisnis: TButton;
    Button_next1: TButton;
    Button_next2: TButton;
    Button_personal: TButton;
    GroupBox_DAntrian: TGroupBox;
    GroupBox_MainMenu: TGroupBox;
    GroupBox_Antrian: TGroupBox;
    Label_daftarAn: TLabel;
    Label_antrian1: TLabel;
    Label_antrian2: TLabel;
    Label_jumlah: TLabel;
    Label_DAntrian: TLabel;
    Label_meja1: TLabel;
    Label_meja2: TLabel;
    Label_antrian: TLabel;
    ListBox_DAntrian: TListBox;
    procedure Button_bisnisClick(Sender: TObject);
    procedure Button_keluarClick(Sender: TObject);
    procedure Button_next1Click(Sender: TObject);
    procedure Button_next2Click(Sender: TObject);
    procedure Button_personalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);


  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  awal,akhir,awal2,akhir2:PointerQueue;
  Antrian_:NAntrian;
  counter,counterP,counterB:integer;


implementation
{$R *.lfm}
{$R 'SuaraAntrian.rc'}
{ TForm1 }

{prosedur create }
procedure createD;
begin
  awal:=nil;
  akhir:=nil;
  awal2:=nil;
  akhir2:=nil;
  counter:=0;
  counterP:=0;
  counterB:=0;

end;

{fungsi Queue-kosong}
function kosong(akhir:PointerQueue):boolean;
begin
kosong:=false;
if (akhir=nil) then
   kosong:=true;
end;

{fungsi Queue-satusimpul}
function SatuSimpul(awal,akhir:PointerQueue):boolean;
begin
SatuSimpul:=false;
if(awal=akhir) then
   SatuSimpul:=true;
end;

{prosedur Queue-Enqueue}
procedure Enqueue(var front,rear:PointerQueue;antrian:string);
var
  baru:PointerQueue;
begin
       new(baru);
       baru^.info:=antrian;
       baru^.next:=nil;
       if (kosong(rear)) then
         begin
            baru^.prev:=nil;
            front:=baru;
         end
       else
         begin
            rear^.next:=baru;
            baru^.prev:=rear;
         end;
         rear:=baru;
  end;

{posedur Queue-Dequeue}
procedure Dequeue(var front,rear:PointerQueue;var elemen:string);
var
  phapus:PointerQueue;
begin
     if (not kosong(rear))then
     begin
          phapus:=awal;
          elemen:=phapus^.info;
             if(not SatuSimpul(front,rear))then
              begin
                front:=front^.next;
                front^.prev:=nil;
              end
             else
              begin
                  front:=nil;
                  rear:=nil;
              end;
          dispose(phapus);
     end;
end;

{prosedur Heap-swap}
procedure swap ( var a, b: string );
var
  temp: string;
begin
     temp := a;
     a := b;
     b := temp;
end;

{prosedur Heap-siftdown}
procedure siftDown ( var A: NAntrian; start, end_: integer );
var
  root, child: integer;
begin
root := start;
   while ( root * 2 + 1 <= end_ ) do
   begin
      child := root * 2 + 1;
            if ( child < end_ ) and ( A[child] < A[child + 1] ) then
               child := child + 1;
                 if ( A[root] < A[child] ) then
                  begin
                    swap ( A[root], A[child] );
                    root := child;
                  end
            else
            break;
   end;
end;

{prosedur Heap-pembentukan heap}
procedure heapify ( var A: NAntrian; count: integer );
var
  start: integer;
begin
start := (count - 1) div 2;
  while ( start >= 0 ) do
  begin
       siftDown (A, start, count-1);
       start := start - 1;
  end;
end;

{prosedur Heap-pengurutan heap}
procedure heapSort( var A: NAntrian; n: integer );
var
  end_: integer;
begin
heapify ( A, n );
end_ := n - 1;
   while ( end_ > 0 ) do
   begin
        swap( A[end_], A[0]);
        end_ := end_ - 1;
        siftDown (A, 0, end_);
   end;
end;

{fungsi Input Antrian}
function InputAntri(KDantrian:string;akhir:PointerQueue;var n,nB,nP:integer):string;
var
  str_i:string;
  antriankode:integer;
begin
if(kosong(akhir))then
   n:=1
else
   n:=n+1;

if(KDantrian[1]='P')then
  begin
    nP:=nP+1;
    antriankode:=nP;
  end
else
if(KDantrian[1]='B')then
  begin
    nB:=nB+1;
    antriankode:=nB;
  end;

{pemberian digit pada i}
str_i:=IntToStr(antriankode);
if(Length(str_i)=1)then
  str_i:='00'+str_i
else
if(Length(str_i)=2)then
  str_i:='0'+str_i;
{end}

{menggabungkan input}
inputAntri:=KDantrian+str_i;
{end}
end;

{prosedur tampil data di layar}
procedure TampilDiListBox(Antrian_:NAntrian;n:integer);
var
  str:string;
  i:integer;
begin
     Form1.ListBox_DAntrian.Clear;
     for i:=0 to (n-1) do
     begin
          str:=IntToStr(i+1)+'.'+Antrian_[i];
          Form1.ListBox_DAntrian.Items.add(str);
     end;
end;
{end}

{fungsi merubah nomor ke kata}
function numToWord(str:string):string;
begin
  case str of
  '0' : numToWord:='kosong';
  '1' : numToWord:='satu';
  '2' : numToWord:='dua';
  '3' : numToWord:='tiga';
  '4' : numToWord:='empat';
  '5' : numToWord:='lima';
  '6' : numToWord:='enam';
  '7' : numToWord:='tujuh';
  '8' : numToWord:='delapan';
  '9' : numToWord:='sembilan';
  end;
end;
{end}

{prosedur memunculkan suara}
procedure suara(str:string);
var
kode,digit1,digit2,digit3: String;
begin
 kode := str[1];
 digit1 := numToWord(str[3]);
 digit2 := numToWord(str[4]);
 digit3 := numToWord(str[5]);

 sndPlaySound(PChar('ANTRIAN'),SND_RESOURCE);
 sndPlaySound(PChar(kode),SND_RESOURCE);
 sndPlaySound(PChar(digit1),SND_RESOURCE);
 sndPlaySound(PChar(digit2),SND_RESOURCE);
 sndPlaySound(PChar(digit3),SND_RESOURCE);
end;
{end}

{fungsi Next Queue}
function NextQueue(var front,rear:PointerQueue;var n:integer):string;
var
  elemen:string;
  i:integer;
begin
elemen:='';
  if(not kosong(rear))then
     begin
       Dequeue(front,rear,elemen);
       for i:=0 to n-1 do
       begin
            Antrian_[i]:=Antrian_[i+1];
       end;

     n:=n-1;
     Form1.Label_jumlah.Caption:=IntToStr(n);
     TampilDiListBox(Antrian_,n);
     NextQueue:=elemen;
     suara(elemen);

     end
  else
  NextQueue:='Kosong';
end;

{program utama}
procedure TForm1.FormCreate(Sender: TObject);
begin
  {penyiapan Antrian}
  createD;
  {End}
end;
{end}

{button_loket1-Click}
procedure TForm1.Button_next1Click(Sender: TObject);
begin
  Label_antrian1.Caption:=NextQueue(awal,akhir,counter);
  if(Label_antrian1.Caption<>'Kosong')then
  begin
     sndPlaySound(PChar('loket'),SND_RESOURCE);
     sndPlaySound(PChar('satu'),SND_RESOURCE);
  end;
end;
{end}

{button_loket2-Click}
procedure TForm1.Button_next2Click(Sender: TObject);
begin
  Label_antrian2.Caption:=NextQueue(awal,akhir,counter);
  if(Label_antrian2.Caption<>'Kosong')then
  begin
    sndPlaySound(PChar('loket'),SND_RESOURCE);
    sndPlaySound(PChar('dua'),SND_RESOURCE);
  end;
end;
{end}

{button exit-Click}
procedure TForm1.Button_keluarClick(Sender: TObject);
begin
 close;
end;
{end}


{button_AntrianP-Click}
procedure TForm1.Button_personalClick(Sender: TObject);
var
  bantu,bantu2:PointerQueue;
  i,j:integer;
  str_kode,str_antrian:string;
begin
  Form1.ListBox_DAntrian.clear;
  str_kode:='P-';
  str_antrian:=InputAntri(str_kode,akhir,counter,counterB,counterP);

  Enqueue(awal,akhir,str_antrian);

  {ubah Linked list ke Array}
  bantu:=awal;
  i:=0;
    while(bantu<>nil)do
    begin
           Antrian_[i]:=bantu^.info;
           i:=i+1;
           bantu:=bantu^.next;
      end;
    {end}

    {pengurutan}
    heapSort(Antrian_,counter);
    {end}

    TampilDiListBox(Antrian_,counter);

    {ubah array ke linked list}
    bantu2:=awal;
    j:=0;
    while(bantu2<>nil)do
      begin
           bantu2^.info:=Antrian_[j];
           j:=j+1;
           bantu2:=bantu2^.next;
      end;
    {end}

    Label_jumlah.Caption:=IntToStr(counter);

end;

{button_AntrianB-Click}
procedure TForm1.Button_bisnisClick(Sender: TObject);
var
  bantu,bantu2:PointerQueue;
  i,j:integer;
  str_kode,str_antrian:string;
begin
  Form1.ListBox_DAntrian.clear;
  str_kode:='B-';
  str_antrian:=InputAntri(str_kode,akhir,counter,counterB,counterP);

  Enqueue(awal,akhir,str_antrian);

  {ubah Linked list ke Array}
  bantu:=awal;
  i:=0;
    while(bantu<>nil)do
      begin
           Antrian_[i]:=bantu^.info;
           i:=i+1;
           bantu:=bantu^.next;
      end;
    {end}

    {pengurutan}
    heapSort(Antrian_,counter);
    {end}

    TampilDiListBox(Antrian_,counter);

    {ubah array ke linked list}
    bantu2:=awal;
    j:=0;
    while(bantu2<>nil)do
      begin
           bantu2^.info:=Antrian_[j];
           j:=j+1;
           bantu2:=bantu2^.next;
      end;
    {end}

    Label_jumlah.Caption:=IntToStr(counter);

end;
end.




