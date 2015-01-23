//
//  GameInfo.h
//  NewTvuoo
//
//  Created by xubo on 9/28 Sunday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameInfo : NSObject
@property (retain, nonatomic) NSString* summary;
@property (retain, nonatomic) NSString* largeAppIcon;
@property (retain, nonatomic) NSString* appIcon;
@property (assign, nonatomic) int gameRoot;
@property int action;
@property int game_id;
@property int gravity;
@property (retain, nonatomic) NSString* name;
@property int appType;
@property (retain, nonatomic) NSString* gameType;
@property (retain, nonatomic) NSString* tvPkgName;
@property int gameParam;
@property int level;
@property (retain, nonatomic) NSString* text;
@property (retain, nonatomic) NSString* allText;
@property (retain, nonatomic) NSString* faceImg;
@property int androidPhoneUseTvApk;
@property (retain, nonatomic) NSString* androidPkgPath;
@property long androidPkgSize;
@property (retain, nonatomic) NSString* androidPkgName;
@property (retain, nonatomic) NSString* itunesPath;
@property (retain, nonatomic) NSString* iosPkgPath;
@property long iosPkgSize;
@property (retain, nonatomic) NSString* iconUrl;
@property (retain, nonatomic) NSString* bigIcon;
@property (retain, nonatomic) NSString* howToPlay;
@property int gameCapability;
@property int gamePlays;
@property (retain, nonatomic) NSString* loadingUrl;
@property (retain, nonatomic) NSString* mouseImg;
@property (retain, nonatomic) NSString* mouseImgDown;
@property (retain, nonatomic) NSString* gameTypeName;
@property int bgTouch;
@property int vCode;
@property (retain, nonatomic) NSString* tvTarget;
@property long tvSize;
@property int tvuSupport;
@property (retain, nonatomic) NSString* imgZipUrl;
@property int supportDpad;
@property (retain, nonatomic) NSArray* keyBeans;
@property (retain, nonatomic) NSArray* rockers;
@property (retain, nonatomic) NSArray* gameScrShoot;
@property (assign, nonatomic) int tvFileSize;
@property (retain, nonatomic) NSString* tvApkPkg;
@property (nonatomic, assign) int appid;

@end

@interface KeyBean : NSObject
@property int idd;
@property int type;
@property int gameId;
@property int shake;
@property int mobX;
@property int mobY;
@property int tvX;
@property int tvY;
@property int keyValue;
@property int targetKey;
@property (retain, nonatomic) NSString* upImgUrl;
@property (retain, nonatomic) NSString* downImgUrl;
@property (retain, nonatomic) NSString* soundUrl;
@property (retain, nonatomic) NSString* memo;
@end

@interface Rocker : NSObject
@property (nonatomic, assign) int centerX;
@property (nonatomic, assign) int centerY;
@end

@interface GameScrShoot : NSObject
@property int imgId;
@property int imgSeq;
@property (retain, nonatomic) NSString* imgUrl;
@end

@interface CategoryGameInfo : NSObject

@property int gameType;
@property (retain, nonatomic) NSString* typeName;
@property (retain, nonatomic) NSString* typeMemo;
@property (retain, nonatomic) NSString* imgUrl;
@property (retain, nonatomic) NSString* bigImgUrl;

@end


@interface UpdateInfo : NSObject
@property (assign, nonatomic) int update_model;
@property (assign, nonatomic) int vcode;
@property (retain, nonatomic) NSString* vname;
@property (assign, nonatomic) long update_size;
@property (assign, nonatomic) int isNeedUpdate;
@property (retain, nonatomic) NSString* update_url;
@property (retain, nonatomic) NSString* update_memo;
@property (retain, nonatomic) NSString* update_title;
@end





