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

function ReadDelimited(AHost: string; APort: Integer; ATerminator: string): string;

implementation

uses
  SynCrtSock, Classes;

function Read(AHost: string; APort: Integer; ALength: Integer): TBytes;
var
  Client: TCrtSocket;
begin
  SetLength(Result, ALength); // required
  Client := TCrtSocket.Open(SockString(AHost), SockString(IntToStr(APort)));
  try
    Client.SockRecv(Result, ALength);
  finally
    Client.Free;
  end;
end;

function ReadDelimited(AHost: string; APort: Integer; ATerminator: string): string;
var
  TmpResult: RawByteString;
  RawTerminator: RawByteString;
  Client: TCrtSocket;
  B: Byte;
  L: PtrInt;
  Pos: Integer;
begin
  TmpResult := '';
  RawTerminator := Utf8Encode(ATerminator);
  Pos := 1;

  // expected response with 0xE2 0x9D 0x84 = 226 157 132
  Client := TCrtSocket.Open(SockString(AHost), SockString(IntToStr(APort)));
  try
    repeat
      Client.SockRecv(@B, 1); // this is slow but works
      if B = Ord(RawTerminator[Pos]) then
      begin
        Inc(Pos)
      end else begin
        Pos := 1;
      end;
      L := Length(TmpResult);
      SetLength(TmpResult, L + 1);
      PByteArray(TmpResult)[L] := B;
//    TmpResult := TmpResult + AnsiChar(B);
    until Pos > Length(RawTerminator);
  finally
    Client.Free;
  end;
  Result := Utf8ToString(TmpResult);
  SetLength(Result, Length(Result) - Length(ATerminator));
end;

end.

