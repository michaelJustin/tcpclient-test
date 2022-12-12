(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.
*)

unit ClientSynopseCrtSock;

interface

uses
  SysUtils;

function Read(AHost: string; APort: Integer; ALength: Integer): TBytes;

function ReadDelimited(AHost: string; APort: Integer; ATerminator: RawByteString): string;

implementation

uses
  SynCrtSock, Classes;

function Read(AHost: string; APort: Integer; ALength: Integer): TBytes;
var
  Client: TCrtSocket;
begin
  SetLength(Result, ALength); // required
  Client := TCrtSocket.Open(AHost, IntToStr(APort));
  try
    Client.SockRecv(Result, ALength);
  finally
    Client.Free;
  end;
end;

function ReadDelimited(AHost: string; APort: Integer; ATerminator: RawByteString): string;
var
  Client: TCrtSocket;
  B: byte;
  L: PtrInt;
  Pos: Integer;
begin
  Result := '';
  Pos := 1;

  Client := TCrtSocket.Open(AHost, IntToStr(APort));
  try
    repeat
      Client.SockRecv(@B,1); // this is slow but works
      if B = Ord(ATerminator[Pos]) then
      begin
        Inc(Pos);
        if Pos = Length(ATerminator) then
        begin
          Break;
        end;
      end else begin
        L := Length(Result);
        SetLength(Result, L+1);
        PByteArray(Result)[L] := B;
        Pos := 1;
      end;
    until False;
  finally
    Client.Free;
  end;
end;

end.

