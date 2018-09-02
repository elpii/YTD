object FormOptions: TFormOptions
  Left = 284
  Top = 158
  Width = 551
  Height = 465
  Caption = 'Options'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object BtnOK: TButton
    Left = 375
    Top = 402
    Width = 75
    Height = 25
    Action = actOK
    Anchors = [akRight, akBottom]
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 455
    Top = 402
    Width = 75
    Height = 25
    Action = actCancel
    Anchors = [akRight, akBottom]
    Cancel = True
    ModalResult = 2
    TabOrder = 1
  end
  object PageOptions: TPageControl
    Left = 0
    Top = 0
    Width = 543
    Height = 389
    ActivePage = TabDownloadOptions
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 2
    object TabMain: TTabSheet
      Caption = 'Main settings'
      object LabelLanguage: TLabel
        Left = 8
        Top = 92
        Width = 51
        Height = 13
        Caption = '&Language:'
        FocusControl = EditLanguage
      end
      object CheckPortableMode: TCheckBox
        Left = 8
        Top = 8
        Width = 520
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Portable mode'
        TabOrder = 0
      end
      object CheckCheckNewVersions: TCheckBox
        Left = 8
        Top = 32
        Width = 520
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Check for new versions on startup'
        TabOrder = 1
      end
      object EditLanguage: TEdit
        Left = 112
        Top = 88
        Width = 177
        Height = 21
        TabOrder = 3
      end
      object BtnDesktopShortcut: TButton
        Left = 8
        Top = 294
        Width = 512
        Height = 25
        Action = actDesktopShortcut
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 4
      end
      object BtnStartMenuShortcut: TButton
        Left = 8
        Top = 326
        Width = 512
        Height = 25
        Action = actStartMenuShortcut
        Anchors = [akLeft, akRight, akBottom]
        TabOrder = 5
      end
      object CheckMonitorClipboard: TCheckBox
        Left = 7
        Top = 56
        Width = 520
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Monitor clipboard for downloadable URLs'
        TabOrder = 2
      end
    end
    object TabDownloadOptions: TTabSheet
      Caption = 'Download settings'
      ImageIndex = 1
      object LabelOverwriteMode: TLabel
        Left = 8
        Top = 116
        Width = 60
        Height = 13
        Caption = '&Existing files:'
        FocusControl = ComboOverwriteMode
      end
      object LabelDownloadDir: TLabel
        Left = 8
        Top = 92
        Width = 94
        Height = 13
        Caption = '&Download directory:'
        FocusControl = EditDownloadDir
      end
      object LabelConverter: TLabel
        Left = 8
        Top = 148
        Width = 49
        Height = 13
        Caption = '&Converter:'
        FocusControl = ComboConverter
      end
      object CheckAutoDownload: TCheckBox
        Left = 8
        Top = 8
        Width = 520
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Automatically start downloads'
        TabOrder = 0
      end
      object ComboOverwriteMode: TComboBox
        Left = 112
        Top = 112
        Width = 416
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 4
        Items.Strings = (
          'Ask user'
          'Overwrite'
          'Skip'
          'Rename automatically')
      end
      object EditDownloadDir: TEdit
        Left = 112
        Top = 88
        Width = 400
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 2
      end
      object BtnDownloadDir: TButton
        Left = 511
        Top = 88
        Width = 17
        Height = 21
        Action = actDownloadDir
        Anchors = [akTop, akRight]
        TabOrder = 3
      end
      object ComboConverter: TComboBox
        Left = 112
        Top = 144
        Width = 416
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 5
        OnChange = ComboConverterChange
      end
      object CheckSubtitlesEnabled: TCheckBox
        Left = 8
        Top = 56
        Width = 520
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Download &subtitles if available'
        TabOrder = 1
      end
      object CheckAutoTryHtmlParser: TCheckBox
        Left = 7
        Top = 32
        Width = 520
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Automatically try &HTML parser'
        TabOrder = 6
      end
    end
    object TabNetworkOptions: TTabSheet
      Caption = 'Network settings'
      ImageIndex = 2
      object LabelProxyHost: TLabel
        Left = 8
        Top = 40
        Width = 52
        Height = 13
        Caption = 'Proxy &host:'
        FocusControl = EditProxyHost
      end
      object LabelProxyPort: TLabel
        Left = 8
        Top = 64
        Width = 50
        Height = 13
        Caption = 'Proxy &port:'
        FocusControl = EditProxyPort
      end
      object LabelProxyUser: TLabel
        Left = 8
        Top = 88
        Width = 78
        Height = 13
        Caption = 'Proxy &username:'
        FocusControl = EditProxyUser
      end
      object LabelProxyPass: TLabel
        Left = 8
        Top = 112
        Width = 77
        Height = 13
        Caption = 'Proxy pass&word:'
        FocusControl = EditProxyPass
      end
      object CheckUseProxy: TCheckBox
        Left = 8
        Top = 8
        Width = 520
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'U&se proxy server'
        TabOrder = 0
      end
      object EditProxyHost: TEdit
        Left = 112
        Top = 36
        Width = 177
        Height = 21
        TabOrder = 1
      end
      object EditProxyPort: TEdit
        Left = 112
        Top = 60
        Width = 177
        Height = 21
        TabOrder = 2
      end
      object EditProxyUser: TEdit
        Left = 112
        Top = 84
        Width = 177
        Height = 21
        TabOrder = 3
      end
      object EditProxyPass: TEdit
        Left = 112
        Top = 108
        Width = 177
        Height = 21
        TabOrder = 4
      end
    end
    object TabDownloaderOptions: TTabSheet
      Caption = 'Downloader settings'
      ImageIndex = 3
      object ListDownloaderOptions: TListBox
        Left = 0
        Top = 0
        Width = 169
        Height = 361
        Align = alLeft
        ItemHeight = 13
        Sorted = True
        TabOrder = 0
        OnClick = ListDownloaderOptionsClick
      end
      object PanelDownloaderOptions: TPanel
        Left = 169
        Top = 0
        Width = 366
        Height = 361
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
      end
    end
  end
  object ActionList: TActionList
    Left = 16
    Top = 240
    object actOK: TAction
      Caption = '&OK'
      ShortCut = 16397
      OnExecute = actOKExecute
    end
    object actCancel: TAction
      Caption = '&Cancel'
      ShortCut = 27
    end
    object actDownloadDir: TAction
      Caption = '...'
      ShortCut = 32836
      OnExecute = actDownloadDirExecute
    end
    object actDesktopShortcut: TAction
      Caption = 'Create shortcut on &desktop'
      OnExecute = actDesktopShortcutExecute
    end
    object actStartMenuShortcut: TAction
      Caption = 'Create shortcut in &Start menu'
      OnExecute = actStartMenuShortcutExecute
    end
  end
end
