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

unit downIPrima;
{$INCLUDE 'ytd.inc'}

interface

uses
  SysUtils, Classes, Windows,
  uPCRE, uXml, HttpSend,
  uDownloader, uCommonDownloader, uHttpDownloader, downStream;

type
  TDownloader_iPrima = class(TDownloader_Stream)
    private
    protected
      StreamIDRegExp: TRegExp;
      StreamCDNIDRegExp: TRegExp;
    protected
      function GetMovieInfoUrl: string; override;
      function AfterPrepareFromPage(var Page: string; PageXml: TXmlDoc; Http: THttpSend): boolean; override;
    public
      class function Provider: string; override;
      class function UrlRegExp: string; override;
      constructor Create(const AMovieID: string); override;
      destructor Destroy; override;
    end;

implementation

uses
  uDownloadClassifier,
  uMessages;

// http://www.iprima.cz/videoarchiv/44524/all/all
const
  URLREGEXP_BEFORE_ID = '^https?://(?:[a-z0-9-]+\.)*iprima.cz/(?:videoarchiv|videoplayer)/';
  URLREGEXP_ID =        '[0-9]+';
  URLREGEXP_AFTER_ID =  '';

const
  REGEXP_MOVIE_TITLE = '<h3\s+id="videoTitle">(?P<TITLE>.*?)</h3>';
  REGEXP_STREAM_ID = '<param\s+name="flashvars"\s+value="[^"]*&id=(?P<STREAMID>[0-9]+)';
  REGEXP_STREAM_CDNID = '<param\s+name="flashvars"\s+value="[^"]*&cdnID=(?P<STREAMID>[0-9]+)';

{ TDownloader_iPrima }

class function TDownloader_iPrima.Provider: string;
begin
  Result := 'iPrima.cz';
end;

class function TDownloader_iPrima.UrlRegExp: string;
begin
  Result := URLREGEXP_BEFORE_ID + '(?P<' + MovieIDParamName + '>' + URLREGEXP_ID + ')' + URLREGEXP_AFTER_ID;
end;

constructor TDownloader_iPrima.Create(const AMovieID: string);
begin
  inherited Create(AMovieID);
  InfoPageEncoding := peUTF8;
  RegExFreeAndNil(MovieTitleRegExp);
  MovieTitleRegExp := RegExCreate(REGEXP_MOVIE_TITLE, [rcoIgnoreCase]);
  StreamIDRegExp := RegExCreate(REGEXP_STREAM_ID, [rcoIgnoreCase]);
  StreamCDNIDRegExp := RegExCreate(REGEXP_STREAM_CDNID, [rcoIgnoreCase]);
end;

destructor TDownloader_iPrima.Destroy;
begin
  RegExFreeAndNil(MovieTitleRegExp);
  RegExFreeAndNil(StreamIDRegExp);
  RegExFreeAndNil(StreamCDNIDRegExp);
  inherited;
end;

function TDownloader_iPrima.GetMovieInfoUrl: string;
begin
  Result := 'http://www.iprima.cz/videoarchiv/' + MovieID + '/all/all';
end;

function TDownloader_iPrima.AfterPrepareFromPage(var Page: string; PageXml: TXmlDoc; Http: THttpSend): boolean;
var Url, ID: string;
begin
  Result := False;
  if GetRegExpVar(StreamCDNIDRegExp, Page, 'STREAMID', ID) then
    begin
    ExternalCDNID := ID;
    Result := inherited AfterPrepareFromPage(Page, PageXml, Http);
    end
  else if GetRegExpVar(StreamIDRegExp, Page, 'STREAMID', ID) then
    begin
    Url := GetMovieInfoUrlForID(ID);
    FreeAndNil(PageXml);
    if not GetMovieInfoContent(Http, Url, Page, PageXml) then
      SetLastErrorMsg(_(ERR_FAILED_TO_DOWNLOAD_MEDIA_INFO_PAGE))
    else
      Result := inherited AfterPrepareFromPage(Page, PageXml, Http);
    end;
end;

initialization
  RegisterDownloader(TDownloader_iPrima);

end.
