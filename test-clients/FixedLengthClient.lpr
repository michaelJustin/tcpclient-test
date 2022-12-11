(*
  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.
*)

program FixedLengthClient;

uses
  ClientMainIndy10,
  SysUtils;

const
  CONTENT_LENGTH = 8192;
  SERVER_HOST = '127.0.0.1';
  SERVER_PORT = 30000;

  procedure Test(AExpectedLength: Integer);
  var
    Response: TBytes;
  begin
    WriteLn(Format('try to read %d bytes from %s:%d',
      [AExpectedLength, SERVER_HOST, SERVER_PORT]));
    Response := Read(SERVER_HOST, SERVER_PORT, AExpectedLength);
    WriteLn(Format('received %d bytes', [Length(Response)]));
  end;

begin
  try
    Test(CONTENT_LENGTH);
    Test(CONTENT_LENGTH - 1);
    Test(CONTENT_LENGTH + 1);
  except
    on E: Exception do
    begin
      WriteLn(E.Message);
    end;
  end;
  ReadLn;
end.
