(******************************************************************************

______________________________________________________________________________

YouTube Downloader                                           (c) 2009-11 Pepak
http://www.pepak.net/download/youtube-downloader/         http://www.pepak.net
______________________________________________________________________________


Copyright (c) 2011, Pepak (http://www.pepak.net)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Pepak nor the
      names of his contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL PEPAK BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

******************************************************************************)

unit downBarrandovTV;
{$INCLUDE 'ytd.inc'}

interface

uses
  SysUtils, Classes, {$IFDEF DELPHI2009_UP} Windows, {$ENDIF}
  uPCRE, uXml, HttpSend,
  uDownloader, uCommonDownloader, uRtmpDownloader;

type
  TDownloader_BarrandovTV = class(TRtmpDownloader)
    private
    protected
      function GetMovieInfoUrl: string; override;
      function GetFileNameExt: string; override;
      function AfterPrepareFromPage(var Page: string; PageXml: TXmlDoc; Http: THttpSend): boolean; override;
    public
      class function Provider: string; override;
      class function UrlRegExp: string; override;
      constructor Create(const AMovieID: string); override;
      destructor Destroy; override;
    end;

implementation

uses
  uStringConsts,
  uStringUtils,
  uMessages,
  uDownloadClassifier;

// http://www.barrandov.tv/54698-nikdy-nerikej-nikdy-upoutavka-epizoda-12
const
  URLREGEXP_BEFORE_ID = 'barrandov\.tv/';
  URLREGEXP_ID =        REGEXP_NUMBERS;
  URLREGEXP_AFTER_ID =  '';

{ TDownloader_BarrandovTV }

class function TDownloader_BarrandovTV.Provider: string;
begin
  Result := 'Barrandov.tv';
end;

class function TDownloader_BarrandovTV.UrlRegExp: string;
begin
  Result := Format(REGEXP_COMMON_URL, [URLREGEXP_BEFORE_ID, MovieIDParamName, URLREGEXP_ID, URLREGEXP_AFTER_ID]);
end;

constructor TDownloader_BarrandovTV.Create(const AMovieID: string);
begin
  inherited;
  InfoPageEncoding := peUTF8;
  InfoPageIsXml := True;
end;

destructor TDownloader_BarrandovTV.Destroy;
begin
  inherited;
end;

function TDownloader_BarrandovTV.GetMovieInfoUrl: string;
begin
  Result := 'http://www.barrandov.tv/special/videoplayerdata/' + MovieID;
end;

function TDownloader_BarrandovTV.GetFileNameExt: string;
begin
  Result := inherited GetFileNameExt;
  if AnsiCompareText(Result, '.f4v') = 0 then
    Result := '.flv';
end;

function TDownloader_BarrandovTV.AfterPrepareFromPage(var Page: string; PageXml: TXmlDoc; Http: THttpSend): boolean;
var Title, HostName, StreamName: string;
begin
  inherited AfterPrepareFromPage(Page, PageXml, Http);
  Result := False;
  if not GetXmlVar(PageXml, 'videotitle', Title) then
    SetLastErrorMsg(ERR_FAILED_TO_LOCATE_MEDIA_TITLE)
  else if not GetXmlVar(PageXml, 'hostname', HostName) then
    SetLastErrorMsg(Format(ERR_VARIABLE_NOT_FOUND , ['hostname']))
  else if not GetXmlVar(PageXml, 'streamname', StreamName) then
    SetLastErrorMsg(Format(ERR_VARIABLE_NOT_FOUND , ['streamname']))
  else
    begin
    SetName(Title);
    MovieUrl := 'rtmpe://' + HostName + '/' + StreamName;
    SetRtmpDumpOption('r', MovieURL);
    SetRtmpDumpOption('y', StreamName);
    //SetRtmpDumpOption('f', FLASH_DEFAULT_VERSION);
    //SetRtmpDumpOption('s', 'http://www.barrandov.tv/flash/unigramPlayer_v1.swf?itemid=' + MovieID);
    //SetRtmpDumpOption('t', MovieUrl);
    //SetRtmpDumpOption('p', 'http://www.barrandov.tv/' + MovieID);
    SetPrepared(True);
    Result := True;
    end;
end;

initialization
  RegisterDownloader(TDownloader_BarrandovTV);

end.
