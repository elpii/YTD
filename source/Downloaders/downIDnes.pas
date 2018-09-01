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

unit downIDnes;
{$INCLUDE 'ytd.inc'}

interface

uses
  SysUtils, Classes,
  uPCRE, uXml, HttpSend,
  uDownloader, uCommonDownloader, uRtmpDownloader;

type
  TDownloader_IDnes = class(TRtmpDownloader)
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

// http://video.idnes.cz/?c=A110315_160842_zajimavosti_nh&idVideo=V110315_150332_tv_zpravy_kbe
const
  URLREGEXP_BEFORE_ID = '^https?://(?:[a-z0-9-]+\.)*video\.idnes\.cz/[^?]*\?';
  URLREGEXP_ID =        '.+';
  URLREGEXP_AFTER_ID =  '';

{ TDownloader_IDnes }

class function TDownloader_IDnes.Provider: string;
begin
  Result := 'iDnes.cz';
end;

class function TDownloader_IDnes.UrlRegExp: string;
begin
  Result := Format(URLREGEXP_BEFORE_ID + '(?P<%s>' + URLREGEXP_ID + ')' + URLREGEXP_AFTER_ID, [MovieIDParamName]);;
end;

constructor TDownloader_IDnes.Create(const AMovieID: string);
begin
  inherited;
  InfoPageEncoding := peXml;
  InfoPageIsXml := True;
end;

destructor TDownloader_IDnes.Destroy;
begin
  inherited;
end;

function TDownloader_IDnes.GetMovieInfoUrl: string;
begin
  Result := 'http://servis.idnes.cz/stream/flv/data.asp?' + MovieID;
end;

function TDownloader_IDnes.GetFileNameExt: string;
begin
  Result := '.mp4';
end;

function TDownloader_IDnes.AfterPrepareFromPage(var Page: string; PageXml: TXmlDoc; Http: THttpSend): boolean;
var ItemType, Server, Path, VideoFile, Title, Stream: string;
    Items: TXmlNode;
    i: integer;
begin
  inherited AfterPrepareFromPage(Page, PageXml, Http);
  Result := False;
  if not XmlNodeByPath(PageXml, 'items', Items) then
    SetLastErrorMsg(ERR_INVALID_MEDIA_INFO_PAGE)
  else
    begin
    for i := 0 to Pred(Items.NodeCount) do
      if string(Items.Nodes[i].Name) = 'item' then
        if GetXmlVar(Items.Nodes[i], 'type', ItemType) then
          if ItemType = 'video' then
            begin
            {$IFNDEF DIRTYHACKS}
            if not GetXmlVar(Items.Nodes[i], 'linkvideo/server', Server) then
              SetLastErrorMsg(Format(ERR_VARIABLE_NOT_FOUND , ['server']))
            else
            {$ENDIF}
            if not GetXmlVar(Items.Nodes[i], 'linkvideo/path', Path) then
              SetLastErrorMsg(Format(ERR_VARIABLE_NOT_FOUND , ['path']))
            else if not GetXmlVar(Items.Nodes[i], 'linkvideo/file', VideoFile) then
              SetLastErrorMsg(Format(ERR_VARIABLE_NOT_FOUND , ['file']))
            else if not GetXmlVar(Items.Nodes[i], 'title', Title) then
              SetLastErrorMsg(ERR_FAILED_TO_LOCATE_MEDIA_TITLE)
            else
              begin
              SetName(Title);
              Stream := 'mp4:' + Path + VideoFile;
              {$IFDEF DIRTYHACKS}
              Server := 'stream7.idnes.cz/vod/'; // For some reason the "real" server does not work!
              {$ENDIF}
              MovieUrl := 'rtmpt://' + Server + Stream;
              AddRtmpDumpOption('r', 'rtmpt://' + Server);
              AddRtmpDumpOption('y', Stream);
              AddRtmpDumpOption('f', 'WIN 10,1,82,76');
              AddRtmpDumpOption('s', 'http://g.idnes.cz/swf/flv/player.swf?v=20101103');
              AddRtmpDumpOption('t', 'rtmpt://' + Server);
              AddRtmpDumpOption('p', 'http://video.idnes.cz/?' + MovieID);
              Result := True;
              SetPrepared(True);
              end;
            Exit;
            end;
    SetLastErrorMsg(ERR_INVALID_MEDIA_INFO_PAGE)
    end;
end;

initialization
  RegisterDownloader(TDownloader_IDnes);

end.
