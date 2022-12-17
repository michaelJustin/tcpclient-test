(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.
*)

unit ClientSynapse266;

interface

uses
  SysUtils;

function Read(AHost: string; APort: Integer; ALength: Integer): TBytes;

function ReadDelimited(AHost: string; APort: Integer; ATerminator: string): string;

implementation

uses
  blcksock, Classes;

function Read(AHost: string; APort: Integer; ALength: Integer): TBytes;
var
  FSock: TTCPBlockSocket;
begin
  SetLength(Result, ALength);
  FSock := TTCPBlockSocket.Create;
  try
    FSock.RaiseExcept := True;
    FSock.Connect(AHost, IntToStr(APort));
    // note:
    // FSock.RecvBuffer(Result, ALength); seems to return "any" invalid length
    FSock.RecvBufferEx(Result, ALength, 1000);
   finally
     FSock.Free;
   end;
end;

function ReadDelimited(AHost: string; APort: Integer; ATerminator: string): string;
var
  FSock: TTCPBlockSocket;
begin
  FSock := TTCPBlockSocket.Create;
  try
    FSock.RaiseExcept := True;
    FSock.Connect(AHost, IntToStr(APort));
    Result := Utf8Decode(FSock.RecvTerminated(1000, Utf8Encode(ATerminator)));
   finally
     FSock.Free;
   end;
end;

end.

