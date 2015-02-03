//
//  SwitcherInfo.m
//  NewTvuoo
//
//  Created by xubo on 11/21 Friday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "AllUrl.h"
#import "DEFINE.h"
#import "DeviceInfo.h"

//
@implementation AllUrl
@synthesize switchUrl;
@synthesize gameListUrl;
@synthesize recommendUrl;
@synthesize updatedUrl;
@synthesize topicUrl;
@synthesize tvlogUrl;
@synthesize superApkName;
@synthesize logUrl;
@synthesize jumpUrl;
@synthesize tvuApkName;
@synthesize tvuApkUrl;
@synthesize handshangkBuyUrl;
@synthesize getGamesUrl;
@synthesize qRecode;
@synthesize findGameUrl;
@synthesize gameTypeUrl;
@synthesize superApkUrl;
@synthesize allTopicUrl;
@synthesize gameInfoUrl;
@synthesize gameGroupUrl;
@synthesize gameLayoutUrl;
@synthesize gamePadUrl;
@synthesize soUrl;
@synthesize sdkLogUrl;
//开关
@synthesize tvu_ad_switch;
@synthesize showtvuoo_switch;
@synthesize tvu_showgame_switch;
@synthesize tvu_showremote_switch;
@synthesize exitgame_switch;
@synthesize exitsdk_switch;

- (id) init
{
    if(self = [super init])
    {
        self.gameListUrl = [LocalData getUrl:@"gamelist_url"];
        self.recommendUrl = [LocalData getUrl:@"recommend_url"];
        self.updatedUrl = [LocalData getUrl:@"update_url"];
        self.topicUrl = [LocalData getUrl:@"topic_url"];
        self.tvlogUrl = [LocalData getUrl:@"tvlog_url"];
        self.superApkName = [LocalData getUrl:@"superapk_name"];
        self.logUrl = [LocalData getUrl:@"log_url"];
        self.jumpUrl = [LocalData getUrl:@"jump_url"];
        self.tvuApkName = [LocalData getUrl:@"tvuapk_name"];
        self.tvuApkUrl = [LocalData getUrl:@"tvuapk_url"];
        self.handshangkBuyUrl = [LocalData getUrl:@"handshankbuy_url"];
        self.getGamesUrl = [LocalData getUrl:@"getgames_url"];
        self.qRecode = [LocalData getUrl:@"qrecode"];
        self.findGameUrl = [LocalData getUrl:@"findgame_url"];
        self.gameTypeUrl = [LocalData getUrl:@"gametype_url"];
        self.superApkUrl = [LocalData getUrl:@"superapk_url"];
        self.allTopicUrl = [LocalData getUrl:@"alltopic_url"];
        self.switchUrl = [LocalData getUrl:@"switch_url"];
        self.gameInfoUrl = [LocalData getUrl:@"gameinfo_url"];
        self.gameGroupUrl = [LocalData getUrl:@"gamegroup_url"];
        self.gameLayoutUrl = [LocalData getUrl:@"gamelayout_url"];
        self.gamePadUrl = [LocalData getUrl:@"gamepad_url"];
        self.soUrl = [LocalData getUrl:@"so_url"];
        self.sdkLogUrl = [LocalData getUrl:@"sdklog_url"];
        
        self.tvu_ad_switch = 0;
        self.showtvuoo_switch = 0;
        self.tvu_showgame_switch = 0;
        self.tvu_showremote_switch = 0;
        self.exitgame_switch = 0;
        self.exitsdk_switch = 0;
    }
    return self;
}

+ (id)getInstance
{
    static AllUrl* allUrl = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        allUrl = [[[self class] alloc] init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString* switcherUrl = [LocalData getUrl:@"switch_url"];
            NSMutableString* url = [[NSMutableString alloc] initWithString:switcherUrl];
            [url appendString:[[[DeviceInfo alloc] init] toString]];
            [allUrl createSwitcherFromJson:url];
            [url release];      //add
        });
        
    });
    return  allUrl;
}

-(void) createSwitcherFromJson:(NSString*)jsonUrl
{
    NSURL* url = [NSURL URLWithString:jsonUrl];
    
    NSData* data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return ;
    }
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if(dic == nil)
    {
        return ;
    }
    self.tvu_ad_switch = [[dic objectForKey:@"tvu_ad_switch"] intValue];
    self.showtvuoo_switch = [[dic objectForKey:@"showtvuoo_switch"] intValue];
    self.tvu_showgame_switch = [[dic objectForKey:@"tvu_showgame_switch"] intValue];
    self.tvu_showremote_switch = [[dic objectForKey:@"tvu_showremote_switch"] intValue];
    self.exitgame_switch = [[dic objectForKey:@"exitgame_switch"] intValue];
    self.exitsdk_switch = [[dic objectForKey:@"exitsdk_switch"] intValue];
    
    self.gameListUrl = [dic objectForKey:@"new_gamelist_url"];
    [LocalData setUrl:@"gamelist_url" withValue:self.gameListUrl];
    
    self.recommendUrl = [dic objectForKey:@"new_recommend_url"];
    [LocalData setUrl:@"recommend_url" withValue:self.recommendUrl];
    
    self.updatedUrl = [dic objectForKey:@"new_update_url"];
    [LocalData setUrl:@"update_url" withValue:self.updatedUrl];
    
    self.topicUrl = [dic objectForKey:@"new_topic_url"];
    [LocalData setUrl:@"topic_url" withValue:self.topicUrl];
    
    self.tvlogUrl = [dic objectForKey:@"new_tvlog_url"];
    [LocalData setUrl:@"tvlog_url" withValue:self.tvlogUrl];
    
    self.superApkName = [dic objectForKey:@"tvu_super_apk_name"];
    [LocalData setUrl:@"superapk_name" withValue:self.superApkName];
    
    self.logUrl = [dic objectForKey:@"new_log_url"];
    [LocalData setUrl:@"log_url" withValue:self.logUrl];
    
    self.jumpUrl = [dic objectForKey:@"new_jump_url"];
    [LocalData setUrl:@"jump_url" withValue:self.jumpUrl];
    
    self.tvuApkName = [dic objectForKey:@"tvu_apk_name"];
    [LocalData setUrl:@"tvuapk_name" withValue:self.tvuApkName];
    
    self.tvuApkUrl = [dic objectForKey:@"tvu_apk_url"];
    [LocalData setUrl:@"tvuapk_url" withValue:self.tvuApkUrl];
    
    self.handshangkBuyUrl = [dic objectForKey:@"handshankbuy"];
    [LocalData setUrl:@"handshankbuy_url" withValue:self.handshangkBuyUrl];
    
    self.getGamesUrl = [dic objectForKey:@"new_getgames_url"];
    [LocalData setUrl:@"getgames_url" withValue:self.getGamesUrl];
    
    self.qRecode = [dic objectForKey:@"QRcode"];
    [LocalData setUrl:@"qrecode" withValue:self.qRecode];
    
    self.findGameUrl = [dic objectForKey:@"new_findgame_url"];
    [LocalData setUrl:@"findgame_url" withValue:self.findGameUrl];
    
    self.gameTypeUrl = [dic objectForKey:@"new_gametype_url"];
    [LocalData setUrl:@"gametype_url" withValue:self.gameTypeUrl];
    
    self.superApkUrl = [dic objectForKey:@"tvu_super_apk_url"];
    [LocalData setUrl:@"superapk_url" withValue:self.superApkUrl];
    
    self.allTopicUrl = [dic objectForKey:@"new_alltopic_url"];
    [LocalData setUrl:@"alltopic_url" withValue:self.allTopicUrl];
    
    self.switchUrl = [dic objectForKey:@"new_switch_url"];
    [LocalData setUrl:@"switch_url" withValue:self.switchUrl];
    
    self.gameInfoUrl = [dic objectForKey:@"new_gameinfo_url"];
    [LocalData setUrl:@"gameinfo_url" withValue:self.gameInfoUrl];
    
    self.gameGroupUrl = [dic objectForKey:@"new_gamegroup_url"];
    [LocalData setUrl:@"gamegroup_url" withValue:self.gameGroupUrl];
    
    self.gameLayoutUrl = [dic objectForKey:@"new_gamelayout_url"];
    [LocalData setUrl:@"gamelayout_url" withValue:self.gameLayoutUrl];
    
    self.gamePadUrl = [dic objectForKey:@"new_gamepad_url"];
    [LocalData setUrl:@"gamepad_url" withValue:self.gamePadUrl];
    
    self.soUrl = [dic objectForKey:@"new_so_url"];
    [LocalData setUrl:@"so_url" withValue:self.soUrl];
    
    self.sdkLogUrl = [dic objectForKey:@"new_sdklog_url"];
    [LocalData setUrl:@"sdklog_url" withValue:self.sdkLogUrl];
}
-(NSString*) description
{
    return [NSString stringWithFormat:@"gameListUrl:%@  recommendUrl:%@ updatedUrl:%@ topicUrl:%@ tvlogUrl:%@ superApkName:%@ getGamesUrl:%@ findGameUr:%@ gameTypeUrl:%@", self.gameListUrl, self.recommendUrl, self.updatedUrl, self.topicUrl, self.tvlogUrl, self.superApkName, self.getGamesUrl, self.findGameUrl, self.gameTypeUrl];
}

@end

@implementation LocalData

+(NSString*) getUrl:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* value = [defaults objectForKey:key];
    if(value)
    {
        return value;
    }
    else
    {
        if([key isEqualToString:@"gamelist_url"])
        {
            return GAMELIST_URL;
        }
        else if([key isEqualToString:@"recommend_url"])
        {
            return @"recommend_url";//--------
        }
        else if([key isEqualToString:@"update_url"])
        {
            return UPDATE_URL;
        }
        else if([key isEqualToString:@"topic_url"])
        {
            return TOPIC_URL;
        }
        else if([key isEqualToString:@"tvlog_url"])
        {
            return TVLOG_URL;
        }
        else if([key isEqualToString:@"superapk_name"])
        {
            return @"superapk_name";//---------
        }
        else if([key isEqualToString:@"log_url"])
        {
            return LOG_URL;
        }
        else if([key isEqualToString:@"jump_url"])
        {
            return JUMP_URL;
        }
        else if([key isEqualToString:@"tvuapk_name"])
        {
            return @"tvuapk_name";//-----------
        }
        else if([key isEqualToString:@"tvuapk_url"])
        {
            return @"tvuapk_url";//-------------
        }
        else if([key isEqualToString:@"handshankbuy_url"])
        {
            return HANDBUY_URL;
        }
        else if([key isEqualToString:@"getgames_url"])
        {
            return GETGAMES_BYIDS;
        }
        else if([key isEqualToString:@"qrecode"])
        {
            return @"qrecode";//------------------
        }
        else if([key isEqualToString:@"findgame_url"])
        {
            return FIND_URL;
        }
        else if([key isEqualToString:@"gametype_url"])
        {
            return GAMETYPE_URL;
        }
        else if([key isEqualToString:@"superapk_url"])
        {
            return @"superapk_url"; //------------
        }
        else if([key isEqualToString:@"alltopic_url"])
        {
            return @"alltopic_url"; //------------
        }
        else if([key isEqualToString:@"switch_url"])
        {
            return SWITCH_URL;
        }
        else if([key isEqualToString:@"gameinfo_url"])
        {
            return GAMEINFO_URL;
        }
        else if([key isEqualToString:@"gamegroup_url"])
        {
            return @"gamegroup_url"; //------------
        }
        else if([key isEqualToString:@"gamelayout_url"])
        {
            return LAYOUT_URL;
        }
        else if([key isEqualToString:@"gamepad_url"])
        {
            return @"gamepad_url"; //-------------
        }
        else if([key isEqualToString:@"so_url"])
        {
            return  SO_URL;
        }
        else if([key isEqualToString:@"sdklog_url"])
        {
            return @"sdklog_url"; //-----------
        }
        else
        {
            return nil;
        }
    }
}

+(void) setUrl: (NSString*)key withValue:(NSString*)value
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

@end


@implementation Switcher
@synthesize tvu_ad_switch;
@synthesize showtvuoo_switch;
@synthesize tvu_showgame_switch;
@synthesize tvu_showremote_switch;
@synthesize exitgame_switch;
@synthesize exitsdk_switch;
- (id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.tvu_ad_switch = [aDecoder decodeIntForKey:@"tvu_ad_switch"];
        self.showtvuoo_switch = [aDecoder decodeIntForKey:@"showtvuoo_switch"];
        self.tvu_showgame_switch = [aDecoder decodeIntForKey:@"tvu_showgame_switch"];
        self.exitgame_switch = [aDecoder decodeIntForKey:@"exitgame_switch"];
        self.exitsdk_switch = [aDecoder decodeIntForKey:@"exitsdk_switch"];
        self.tvu_showremote_switch = [aDecoder decodeIntForKey:@"tvu_showremote_switch"];
        return  self;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.tvu_ad_switch forKey:@"tvu_ad_switch"];
    [aCoder encodeInt:self.showtvuoo_switch forKey:@"showtvuoo_switch"];
    [aCoder encodeInt:self.tvu_showgame_switch forKey:@"tvu_showgame_switch"];
    [aCoder encodeInt:self.exitgame_switch forKey:@"exitgame_switch"];
    [aCoder encodeInt:self.exitsdk_switch forKey:@"exitsdk_switch"];
    [aCoder encodeInt:self.tvu_showremote_switch forKey:@"tvu_showremote_switch"];
}


+(Switcher*) createSwitcherFromJson:(NSString*)jsonUrl
{
    NSURL* url = [NSURL URLWithString:jsonUrl];
    
    NSData* data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        return nil;
    }
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if(dic == nil)
    {
        return nil;
    }
    Switcher* switcher = [[Switcher alloc] init];
    switcher.tvu_ad_switch = [[dic objectForKey:@"tvu_ad_switch"] intValue];
    switcher.showtvuoo_switch = [[dic objectForKey:@"showtvuoo_switch"] intValue];
    switcher.tvu_showgame_switch = [[dic objectForKey:@"tvu_showgame_switch"] intValue];
    switcher.tvu_showremote_switch = [[dic objectForKey:@"tvu_showremote_switch"] intValue];
    switcher.exitgame_switch = [[dic objectForKey:@"exitgame_switch"] intValue];
    switcher.exitsdk_switch = [[dic objectForKey:@"exitsdk_switch"] intValue];
    return  [switcher autorelease];
}
@end

