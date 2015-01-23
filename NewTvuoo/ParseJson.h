//
//  ParseJson.h
//  NewTvuoo
//
//  Created by xubo on 9/25 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TvInfo.h"
#import "GameInfo.h"
//#import "Switcher.h"

@interface ParseJson : NSObject

+(TvInfo*) createTvInfoFromJson: (NSString*) tvString;
+(TvInfoDetail*) createTvInfoDetailFromJson: (NSString*) tvString;
+(NSMutableArray*) createGameInfoArrayFromJson: (NSString*)jsonUrl;
+(NSMutableArray*) createCategoryArrayFromJson: (NSString*)jsonUrl;

+(NSMutableArray*) createGameScrShootArrayFromArray: (NSArray*)array;
+(NSMutableArray*) createGameKeyBeanArrayFromArray: (NSArray*)array;

+(NSMutableArray*) createGameInfoArrayFromCategory:(NSString *)jsonUrl;

+(GameInfo*) createGameInfoFromJson:(NSString*)jsonUrl;

+(UpdateInfo*) createUpdateInfoFromJson:(NSString*)json;

//+(Switcher*) createSwitcherFromJson:(NSString*)jsonUrl;
@end
