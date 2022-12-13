(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.
*)

unit FixedDelimiterServer;

interface

const
  SERVER_PORT = 30000;
  FIXED_DELIMITER = '☃';

procedure Run;

implementation

uses
  IdCustomTCPServer, IdContext, IdGlobal, SysUtils, Classes;

const
  RESPONSE = 'This is the server response.';
  RESPONSE_PART_2 = 'The client must not receive this.';

type
  { TFixedDelimiterServer }

  TFixedDelimiterServer = class(TIdCustomTCPServer)
  protected
    function DoExecute(AContext: TIdContext): boolean; override;
  end;

{ TFixedDelimiterServer }

function TFixedDelimiterServer.DoExecute(AContext: TIdContext): boolean;
begin
  Result := inherited;

  WriteLn(Format('write response "%s"', [RESPONSE]));
  AContext.Connection.IOHandler.Write(RESPONSE);

  WriteLn(Format('write delimiter "%s"', [FIXED_DELIMITER]));
  AContext.Connection.IOHandler.Write(Utf8Encode(FIXED_DELIMITER));

  WriteLn(Format('write text beyond delimiter "%s"', [RESPONSE_PART_2]));
  AContext.Connection.IOHandler.Write(RESPONSE_PART_2);

  AContext.Connection.IOHandler.CloseGracefully;
end;

procedure Run;
var
  ExampleServer: TIdCustomTCPServer;
begin
  ExampleServer := TFixedDelimiterServer.Create;
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
