(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.
*)

unit ClientIndySockets10;

interface

uses
  SysUtils;

function Read(AHost: string; APort: Integer; ALength: Integer): TBytes;

function ReadDelimited(AHost: string; APort: Integer; ATerminator: string): string;

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
     Client.IOHandler.ReadBytes(TIdBytes(Result), Length(Result), False);
   finally
     Client.Free;
   end;
end;

function ReadDelimited(AHost: string; APort: Integer; ATerminator: string): string;
var
   Client: TIdTCPClient;
begin
   Result := '';
   Client := TIdTCPClient.Create;
   try
     Client.Host := AHost;
     Client.Port := APort;
     Client.Connect;
     Client.IOHandler.DefStringEncoding := IndyTextEncoding_UTF8;
     Client.IOHandler.CheckForDataOnSource(50);
     if not Client.IOHandler.InputBufferIsEmpty then
     begin
       Result := Client.IOHandler.ReadLn(ATerminator);
     end;
   finally
     Client.Free;
   end;
end;

end.

