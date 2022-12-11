(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.
*)

unit ClientMainIndy10;

interface

uses
  SysUtils;

function Read(AHost: string; APort: Integer; ALength: Integer): TBytes;

implementation

uses
  IdTcpClient, IdGlobal, Classes;

function Read(AHost: string; APort: Integer; ALength: Integer): TBytes;
var
   Client: TIdTCPClient;
begin
   SetLength(Result, ALength);
   Client := TIdTCPClient.Create;
   try
     Client.Host := AHost;
     Client.Port := APort;
     Client.Connect;
     Client.IOHandler.ReadBytes(Result, Length(Result), False);
   finally
     Client.Free;
   end;
end;

end.

