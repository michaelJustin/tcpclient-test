(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.
*)

unit FixedLengthServer;

interface

const
  SERVER_PORT = 30000;
  CONTENT_LENGTH = 8192;

procedure Run;

implementation

uses
  IdCustomTCPServer, IdContext, IdGlobal, SysUtils, Classes;

type
  { TFixedLengthServer }

  TFixedLengthServer = class(TIdCustomTCPServer)
  protected
    function DoExecute(AContext: TIdContext): boolean; override;
  end;

{ TFixedLengthServer }

function TFixedLengthServer.DoExecute(AContext: TIdContext): boolean;
var
  Buffer: TBytes;
begin
  Result := inherited;

  SetLength(Buffer, CONTENT_LENGTH);
  WriteLn(Format('write %d bytes', [Length(Buffer)]));
  AContext.Connection.IOHandler.Write(Buffer, CONTENT_LENGTH);
  AContext.Connection.IOHandler.CloseGracefully;
end;

procedure Run;
var
  ExampleServer: TIdCustomTCPServer;
begin
  ExampleServer := TFixedLengthServer.Create;
  try
    ExampleServer.DefaultPort := SERVER_PORT;
    ExampleServer.Active := True;

    WriteLn(Format('server is listening on port %d', [30000]));
    WriteLn('hit any key to stop');
    ReadLn;

    ExampleServer.Active := False;
  finally
    ExampleServer.Free;
  end;
end;

end.
