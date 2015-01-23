//
//  GameInfo.m
//  NewTvuoo
//
//  Created by xubo on 9/28 Sunday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "GameInfo.h"

@implementation GameInfo
@synthesize tvApkPkg;
@synthesize appid;
@synthesize gameRoot;
@synthesize tvFileSize;
@synthesize summary;
@synthesize appIcon;
@synthesize largeAppIcon;
@synthesize action;
@synthesize game_id;
@synthesize name;
@synthesize appType;
@synthesize gameType;
@synthesize tvPkgName;
@synthesize gameParam;
@synthesize level;
@synthesize text;
@synthesize allText;
@synthesize faceImg;
@synthesize androidPhoneUseTvApk;
@synthesize androidPkgPath;
@synthesize androidPkgSize;
@synthesize androidPkgName;
@synthesize itunesPath;
@synthesize iosPkgPath;
@synthesize iosPkgSize;
@synthesize iconUrl;
@synthesize bigIcon;
@synthesize howToPlay;
@synthesize gameCapability;
@synthesize gamePlays;
@synthesize loadingUrl;
@synthesize mouseImg;
@synthesize mouseImgDown;
@synthesize gameTypeName;
@synthesize gameScrShoot;
@synthesize bgTouch;
@synthesize vCode;
@synthesize tvTarget;
@synthesize tvSize;
@synthesize tvuSupport;
@synthesize imgZipUrl;
@synthesize keyBeans;
@synthesize rockers;
@synthesize supportDpad;
@synthesize gravity;

- (id) init
{
    if(self = [super init])
    {
        
    }
    return self;
}

- (NSString*) description
{
    NSString* str1 = [NSString stringWithFormat:@"游戏名字是: %@ 游戏介绍是: %@", self.name, self.text];
    return str1;
}
- (void) dealloc
{
    self.name = nil;
    self.tvPkgName = nil;
    self.text = nil;
    self.allText = nil;
    self.faceImg = nil;
    self.androidPkgName = nil;
    self.itunesPath = nil;
    self.iosPkgPath = nil;
    self.iconUrl = nil;
    self.bigIcon = nil;
    self.howToPlay = nil;
    self.loadingUrl = nil;
    self.mouseImg = nil;
    self.mouseImgDown = nil;
    self.gameTypeName = nil;
    self.tvTarget = nil;
    self.imgZipUrl = nil;
    self.keyBeans = nil;
    self.rockers = nil;
    self.gameScrShoot = nil;
    self.gameType = nil;
    self.appIcon = nil;
    self.largeAppIcon = nil;
    self.tvApkPkg = nil;
    [super dealloc];
}
@end

@implementation Rocker
@synthesize centerX;
@synthesize centerY;
- (id) init
{
    if(self = [super init])
    {
        
    }
    return self;
}
@end


@implementation KeyBean
@synthesize idd;
@synthesize type;
@synthesize gameId;
@synthesize shake;
@synthesize mobX;
@synthesize mobY;
@synthesize tvX;
@synthesize tvY;
@synthesize memo;
@synthesize keyValue;
@synthesize upImgUrl;
@synthesize downImgUrl;
@synthesize soundUrl;
@synthesize targetKey;
- (id) init
{
    if(self = [super init])
    {
        
    }
    return self;
}

- (void) dealloc
{
    self.memo = nil;
    self.upImgUrl = nil;
    self.downImgUrl = nil;
    self.soundUrl = nil;
    [super dealloc];
    
}
@end

@implementation GameScrShoot
@synthesize imgId;
@synthesize imgSeq;
@synthesize imgUrl;

- (id) init
{
    self = [super init];
    if(self)
    {
    }
    return self;
}

- (void) dealloc
{
    
    [imgUrl release];
    [super dealloc];
}
@end

@implementation CategoryGameInfo
@synthesize  gameType;
@synthesize  typeName;
@synthesize typeMemo;
@synthesize imgUrl;
@synthesize bigImgUrl;
- (id) init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}

- (void) dealloc
{
    self.typeName = nil;
    self.typeMemo = nil;
    self.imgUrl = nil;
    self.bigImgUrl = nil;
    [super dealloc];
}

@end


@implementation UpdateInfo
@synthesize update_model;
@synthesize vcode;
@synthesize vname;
@synthesize update_size;
@synthesize isNeedUpdate;
@synthesize update_url;
@synthesize update_memo;
@synthesize update_title;
-(id) init
{
    if(self = [super init])
    {
        
    }
    return self;
}

-(void) dealloc
{
    self.vname = nil;
    self.update_url = nil;
    self.update_memo = nil;
    self.update_title = nil;
    [super dealloc];
}
@end








