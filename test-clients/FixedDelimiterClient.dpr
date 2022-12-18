(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.
*)

program FixedDelimiterClient;

uses
  ClientIndySockets10,
//  ClientSynapse266,
//  ClientSynopseCrtSock,
  SysUtils;

const
  FIXED_DELIMITER = '' + #$2603;  // '☃';
  SERVER_HOST = '127.0.0.1';
  SERVER_PORT = 30000;

  procedure Test(ADelimiter: string);
  var
    Response: string;
  begin
    WriteLn(Format('try to read from %s:%d delimited with %s',
      [SERVER_HOST, SERVER_PORT, ADelimiter]));
    Response := ReadDelimited(SERVER_HOST, SERVER_PORT, ADelimiter);
    WriteLn(Format('received response "%s" - %d bytes',
      [Response, Length(Response)]));
  end;

begin
  try
    Test(FIXED_DELIMITER);
    Test(FIXED_DELIMITER);
    Test(FIXED_DELIMITER);
  except
    on E: Exception do
    begin
      WriteLn(E.Message);
    end;
  end;
  ReadLn;
end.
