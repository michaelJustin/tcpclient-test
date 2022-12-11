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

end.

