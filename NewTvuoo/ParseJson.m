//
//  ParseJson.m
//  NewTvuoo
//
//  Created by xubo on 9/25 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//



/****
 ios解析json的兼容性问题：
 如果服务端json数据不规范，比如出现非标准的空格，换行符等。
 必须先将其作适当转换，否则将出现json解析失败的情况
 ***/

#import "ParseJson.h"
#import "EGOCache.h"
@implementation ParseJson

+(TvInfo*) createTvInfoFromJson:(NSString *)tvString
{
    TvInfo* tv = [[TvInfo alloc] init];
    NSData* jsonData = [tvString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    if(jsonDic == nil)
    {
        NSLog(@"tvinfo json 解析失败");
        [tv release];
        return nil;
    }
    tv.tvName = [jsonDic objectForKey:@"name"];
    tv.tvServerport = [[jsonDic objectForKey:@"serverport"] intValue];
    tv.tvTag = [jsonDic objectForKey:@"tag"];
    tv.tvType = [[jsonDic objectForKey:@"type"] intValue];
    tv.tvUdpPort = [[jsonDic objectForKey:@"udpport"] intValue];
    tv.pkgName = [jsonDic objectForKey:@"pkgname"];
    return [tv autorelease];
//    return tv;
}

+(TvInfoDetail*) createTvInfoDetailFromJson: (NSString*) tvString
{
    TvInfoDetail* tv = [[TvInfoDetail alloc] init];
    NSData* jsonData = [tvString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    if(jsonDic == nil)
    {
        NSLog(@"tvinfoDetail json 解析失败:%@", tvString);
    }
    tv.deviceId = [[jsonDic objectForKey:@"deviceid"] intValue];
    tv.name = [jsonDic objectForKey:@"name"];
    tv.mac = [jsonDic objectForKey:@"mac"];
    tv.tag = [[jsonDic objectForKey:@"tag"] intValue];
    tv.isroot = [[jsonDic objectForKey:@"isroot"] intValue];
    tv.canadb = [[jsonDic objectForKey:@"canadb"] intValue];
    tv.capa = [[jsonDic objectForKey:@"capa"] intValue];
    tv.width = [[jsonDic objectForKey:@"width"] intValue];
    tv.height = [[jsonDic objectForKey:@"height"] intValue];
    return [tv autorelease];
//    return tv;
}

+(NSMutableArray*) createGameInfoArrayFromJson:(NSString *)jsonUrl
{
//    jsonUrl = [jsonUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL* url = [NSURL URLWithString:jsonUrl];
    
    //加载一个NSURL对象
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSError* error = [[NSError alloc] init];
    
    //将请求的url数据放到NSData对象中
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
  
        if(data == nil)
        {
            NSLog(@"没有解析， 返回NIL");
            NSLog(@"errorrrrr: %@", [error description]);
            return nil;
        }
        
        NSString* jsonString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    //开始解析json
    //json 数据最外层是数组  则返回数组
    NSDictionary* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if(jsonArray == nil)
    {
        NSLog(@"GameInfo Json--------- 解析失败   %@", [error description]);
    }
    NSArray* dataArray = [jsonArray objectForKey:@"data"];
//    NSMutableArray* gameInfoArray = [NSMutableArray arrayWithCapacity:3];  要返回的指针， 不能使用便利初始化
    NSMutableArray* gameInfoArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[dataArray count]; ++i)
    {
        NSDictionary* dic = (NSDictionary*)[dataArray objectAtIndex:i];
        GameInfo* gameInfo = [[GameInfo alloc] init];
        gameInfo.action = [[dic objectForKey:@"action"] intValue];
        gameInfo.appid = [[dic objectForKey:@"appid"] intValue];
        gameInfo.game_id = [[dic objectForKey:@"game_id"] intValue];
        gameInfo.name = [dic objectForKey:@"name"];
        gameInfo.appType = [[dic objectForKey:@"apptype"] intValue];
        gameInfo.gameType = [dic objectForKey:@"game_type"];
        gameInfo.tvPkgName = [dic objectForKey:@"tv_pkgname"];
        gameInfo.gameParam = [[dic objectForKey:@"gameparam"] intValue];
        gameInfo.gameRoot = [[dic objectForKey:@"gameroot"] intValue];
        gameInfo.level = [[dic objectForKey:@"level"] intValue];
        gameInfo.text = [dic objectForKey:@"text"];
        gameInfo.allText = [dic objectForKey:@"allText"];
        gameInfo.faceImg = [dic objectForKey:@"faceimg"];
        gameInfo.androidPhoneUseTvApk = [[dic objectForKey:@"androidphoneusetvapk"] intValue];
        gameInfo.androidPkgPath = [dic objectForKey:@"android_pkg_path"];
        gameInfo.androidPkgSize = [[dic objectForKey:@"android_pkg_size"] longValue];
        gameInfo.androidPkgName = [dic objectForKey:@"android_pkg_name"];
        gameInfo.itunesPath = [dic objectForKey:@"itunes_path"];
        gameInfo.iosPkgPath = [dic objectForKey:@"ios_pkg_path"];
        gameInfo.iosPkgSize = [[dic objectForKey:@"ios_package_size"] longValue];
        gameInfo.iconUrl = [dic objectForKey:@"icon_url"];
        gameInfo.bigIcon = [dic objectForKey:@"big_icon"];
        gameInfo.howToPlay = [dic objectForKey:@"howtoplay"];
        gameInfo.gameCapability = [[dic objectForKey:@"game_capability"] intValue];
        gameInfo.gamePlays = [[dic objectForKey:@"game_plays"] intValue];
        gameInfo.loadingUrl = [dic objectForKey:@"loading_url"];
        gameInfo.mouseImg = [dic objectForKey:@"mouse_img"];
        gameInfo.mouseImgDown = [dic objectForKey:@"mouse_img_down"];
        gameInfo.gameTypeName = [dic objectForKey:@"gametypename"];
        gameInfo.bgTouch = [[dic objectForKey:@"bgtouch"] intValue];
        gameInfo.vCode = [[dic objectForKey:@"vcode"] intValue];
        gameInfo.tvTarget = [dic objectForKey:@"tv_target"];
        gameInfo.tvApkPkg = [dic objectForKey:@"tvapkname"];
        gameInfo.tvSize = [[dic objectForKey:@"tv_sizes"] longValue];
        gameInfo.tvuSupport = [[dic objectForKey:@"tvusupport"] intValue];
        gameInfo.imgZipUrl = [dic objectForKey:@"img_zip_url"];
        gameInfo.supportDpad = [[dic objectForKey:@"suppportdpad"] intValue];
        gameInfo.largeAppIcon = [dic objectForKey:@"largeiconurl"];
        gameInfo.appIcon = [dic objectForKey:@"iconurl"];
        gameInfo.summary = [dic objectForKey:@"summary"];
        gameInfo.tvFileSize = [[dic objectForKey:@"tvfilesize"] intValue];
        //keyBeans 是一个数组
        NSArray* keyBeanArray = [dic objectForKey:@"keybeans"];
        gameInfo.keyBeans = [[self class] createGameKeyBeanArrayFromArray:keyBeanArray];
        //rockers 是一个数组
        gameInfo.rockers = [dic objectForKey:@"rockers"];
        
        //gameScrShoot是一个数组  继续解析
        NSArray* gameScrShoot = [dic objectForKey:@"gamescrshoot"];
        gameInfo.gameScrShoot = [[self class] createGameScrShootArrayFromArray:gameScrShoot];
        [gameInfoArray addObject:gameInfo];
        [gameInfo release];
    }
    return [gameInfoArray autorelease];
//    return gameInfoArray;
}

+(NSMutableArray*) createGameScrShootArrayFromArray: (NSArray*)shootArray
{
    NSMutableArray* gssArray = [[NSMutableArray alloc] init];
    for(int i=0; i<[shootArray count]; ++i)
    {
        GameScrShoot* gss = [[GameScrShoot alloc] init];
        NSDictionary* dic = [shootArray objectAtIndex:i];
        gss.imgId = [[dic objectForKey:@"imgid"] intValue];
        gss.imgSeq = [[dic objectForKey:@"imgseq"] intValue];
        gss.imgUrl = [dic objectForKey:@"img_url"];
        [gssArray addObject:gss];
        [gss release];
    }
    return [gssArray autorelease];
}


+(NSMutableArray*) createGameKeyBeanArrayFromArray: (NSArray*)array
{
    NSMutableArray* keyBeanArray = [[NSMutableArray alloc] init];
    for(int i=0; i<[array count]; ++i)
    {
        KeyBean* keyBean = [[KeyBean alloc] init];
        NSDictionary* dic = [array objectAtIndex:i];
        keyBean.mobX = [[dic objectForKey:@"mobx"] intValue];
        keyBean.mobY = [[dic objectForKey:@"moby"] intValue];
        keyBean.idd = [[dic objectForKey:@"id"] intValue];
        keyBean.type = [[dic objectForKey:@"type"] intValue];
        keyBean.gameId = [[dic objectForKey:@"gameid"] intValue];
        keyBean.shake = [[dic objectForKey:@"shake"] intValue];
        keyBean.tvX = [[dic objectForKey:@"tvx"] intValue];
        keyBean.tvY = [[dic objectForKey:@"tvy"] intValue];
        keyBean.memo = [dic objectForKey:@"memo"];
        keyBean.keyValue = [[dic objectForKey:@"keyvalue"] intValue];
        keyBean.targetKey = [[dic objectForKey:@"targetkey"] intValue];
        keyBean.upImgUrl = [dic objectForKey:@"upimgur"];
        keyBean.downImgUrl = [dic objectForKey:@"soundurl"];
        keyBean.soundUrl = [dic objectForKey:@"soundurl"];
        [keyBeanArray addObject:keyBean];
        [keyBean release];
    }
    return [keyBeanArray autorelease];
}

+(NSMutableArray*) createCategoryArrayFromJson:(NSString *)jsonUrl
{
    NSURL* url = [NSURL URLWithString:jsonUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if(data == nil)
    {
        NSLog(@"category 获取数据失败: %@", [error description]);
        return nil;
    }
    NSArray* dicArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if(dicArray == nil)
    {
        NSLog(@"category json解析失败");
        return nil;
    }
    NSMutableArray* retArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[dicArray count]; ++i)
    {
        CategoryGameInfo* cate = [[CategoryGameInfo alloc] init];
        NSDictionary* dic = [dicArray objectAtIndex:i];
        cate.gameType = [[dic objectForKey:@"gametype"] intValue];
        cate.typeMemo = [dic objectForKey:@"typememo"];
        cate.typeName = [dic objectForKey:@"typememo"];
        cate.imgUrl = [dic objectForKey:@"imgurl"];
        cate.bigImgUrl = [dic objectForKey:@"bigimgurl"];
        [retArray addObject:cate];
        [cate release];
    }
    return [retArray autorelease];
}

+(NSMutableArray*) createGameInfoArrayFromCategory:(NSString *)jsonUrl
{
    NSURL* url = [NSURL URLWithString:jsonUrl];
    
    //加载一个NSURL对象
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSError* error = [[NSError alloc] init];
    
    //将请求的url数据放到NSData对象中
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
    if(data == nil)
    {
        NSLog(@"没有解析， 返回NIL");
        NSLog(@"errorrrrr: %@", [error description]);
        return nil;
    }
    
    
    NSString* jsonString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //开始解析json
//    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(json == nil)
    {
        NSLog(@"GameInfo Json--------- 解析失败   %@", [error description]);
    }
    
    NSArray* jsonArray = [json objectForKey:@"data"];
    

//    NSArray* dataArray = [jsonArray objectForKey:@"data"];
    //    NSMutableArray* gameInfoArray = [NSMutableArray arrayWithCapacity:3];  要返回的指针， 不能使用便利初始化
    NSMutableArray* gameInfoArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[jsonArray count]; ++i)
    {
        NSDictionary* dic = (NSDictionary*)[jsonArray objectAtIndex:i];
        GameInfo* gameInfo = [[GameInfo alloc] init];
        gameInfo.action = [[dic objectForKey:@"action"] intValue];
        gameInfo.game_id = [[dic objectForKey:@"game_id"] intValue];
        gameInfo.name = [dic objectForKey:@"name"];
        gameInfo.appType = [[dic objectForKey:@"apptype"] intValue];
        gameInfo.gameType = [dic objectForKey:@"game_type"];
        gameInfo.tvPkgName = [dic objectForKey:@"tv_pkgname"];
        gameInfo.gameParam = [[dic objectForKey:@"gameparam"] intValue];
        gameInfo.level = [[dic objectForKey:@"level"] intValue];
        gameInfo.text = [dic objectForKey:@"text"];
        gameInfo.allText = [dic objectForKey:@"allText"];
        gameInfo.faceImg = [dic objectForKey:@"faceimg"];
        gameInfo.androidPhoneUseTvApk = [[dic objectForKey:@"androidphoneusetvapk"] intValue];
        gameInfo.androidPkgPath = [dic objectForKey:@"android_pkg_path"];
        gameInfo.androidPkgSize = [[dic objectForKey:@"android_pkg_size"] longValue];
        gameInfo.androidPkgName = [dic objectForKey:@"android_pkg_name"];
        gameInfo.itunesPath = [dic objectForKey:@"itunes_path"];
        gameInfo.iosPkgPath = [dic objectForKey:@"ios_pkg_path"];
        gameInfo.iosPkgSize = [[dic objectForKey:@"ios_package_size"] longValue];
        gameInfo.iconUrl = [dic objectForKey:@"icon_url"];
        gameInfo.bigIcon = [dic objectForKey:@"big_icon"];
        gameInfo.howToPlay = [dic objectForKey:@"howtoplay"];
        gameInfo.gameCapability = [[dic objectForKey:@"game_capability"] intValue];
        gameInfo.gamePlays = [[dic objectForKey:@"game_plays"] intValue];
        gameInfo.loadingUrl = [dic objectForKey:@"loading_url"];
        gameInfo.mouseImg = [dic objectForKey:@"mouse_img"];
        gameInfo.mouseImgDown = [dic objectForKey:@"mouse_img_down"];
        gameInfo.gameTypeName = [dic objectForKey:@"gametypename"];
        gameInfo.bgTouch = [[dic objectForKey:@"bgtouch"] intValue];
        gameInfo.vCode = [[dic objectForKey:@"vcode"] intValue];
        gameInfo.tvTarget = [dic objectForKey:@"tv_target"];
        gameInfo.tvSize = [[dic objectForKey:@"tv_sizes"] longValue];
        gameInfo.tvuSupport = [[dic objectForKey:@"tvusupport"] intValue];
        gameInfo.imgZipUrl = [dic objectForKey:@"img_zip_url"];
        gameInfo.supportDpad = [[dic objectForKey:@"suppportdpad"] intValue];
        gameInfo.gravity = [[dic objectForKey:@"gravity"] intValue];
        //keyBeans 是一个数组
        NSArray* keyBeanArray = [dic objectForKey:@"keybeans"];
        gameInfo.keyBeans = [[self class] createGameKeyBeanArrayFromArray:keyBeanArray];
        
        //rockers 是一个数组
        gameInfo.rockers = [dic objectForKey:@"rockers"];
        
        //gameScrShoot是一个数组  继续解析
        NSArray* gameScrShoot = [dic objectForKey:@"gamescrshoot"];
        gameInfo.gameScrShoot = [[self class] createGameScrShootArrayFromArray:gameScrShoot];
        [gameInfoArray addObject:gameInfo];
        [gameInfo release];
    }
    return [gameInfoArray autorelease];
    //    return gameInfoArray;
}

+(GameInfo*) createGameInfoFromJson:(NSString*)jsonUrl
{
    NSURL* url = [NSURL URLWithString:jsonUrl];
    NSData* data = [NSData dataWithContentsOfURL:url];
    if (data == nil) {
        NSLog(@"获取单个gameinfo失败");
        return nil;
    }
    
    NSString* jsonString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if(dic == nil)
    {
        NSLog(@"获取单个gameinfo的json 失败");
        return nil;
    }
    
    GameInfo* gameInfo = [[GameInfo alloc] init];
    gameInfo.gameRoot = [[dic objectForKey:@"gameroot"] intValue];
    gameInfo.action = [[dic objectForKey:@"action"] intValue];
    gameInfo.game_id = [[dic objectForKey:@"game_id"] intValue];
    gameInfo.name = [dic objectForKey:@"name"];
    gameInfo.appType = [[dic objectForKey:@"apptype"] intValue];
    gameInfo.gameType = [dic objectForKey:@"game_type"];
    gameInfo.tvPkgName = [dic objectForKey:@"tv_pkgname"];
    gameInfo.gameParam = [[dic objectForKey:@"gameparam"] intValue];
    gameInfo.level = [[dic objectForKey:@"level"] intValue];
    gameInfo.text = [dic objectForKey:@"text"];
    gameInfo.allText = [dic objectForKey:@"allText"];
    gameInfo.faceImg = [dic objectForKey:@"faceimg"];
    gameInfo.androidPhoneUseTvApk = [[dic objectForKey:@"androidphoneusetvapk"] intValue];
    gameInfo.androidPkgPath = [dic objectForKey:@"android_pkg_path"];
    gameInfo.androidPkgSize = [[dic objectForKey:@"android_pkg_size"] longValue];
    gameInfo.androidPkgName = [dic objectForKey:@"android_pkg_name"];
    gameInfo.itunesPath = [dic objectForKey:@"itunes_path"];
    gameInfo.iosPkgPath = [dic objectForKey:@"ios_pkg_path"];
    gameInfo.iosPkgSize = [[dic objectForKey:@"ios_package_size"] longValue];
    gameInfo.iconUrl = [dic objectForKey:@"icon_url"];
    gameInfo.bigIcon = [dic objectForKey:@"big_icon"];
    gameInfo.howToPlay = [dic objectForKey:@"howtoplay"];
    gameInfo.gameCapability = [[dic objectForKey:@"game_capability"] intValue];
    gameInfo.gamePlays = [[dic objectForKey:@"game_plays"] intValue];
    gameInfo.loadingUrl = [dic objectForKey:@"loading_url"];
    gameInfo.mouseImg = [dic objectForKey:@"mouse_img"];
    gameInfo.mouseImgDown = [dic objectForKey:@"mouse_img_down"];
    gameInfo.gameTypeName = [dic objectForKey:@"gametypename"];
    gameInfo.bgTouch = [[dic objectForKey:@"bgtouch"] intValue];
    gameInfo.vCode = [[dic objectForKey:@"vcode"] intValue];
    gameInfo.tvTarget = [dic objectForKey:@"tv_target"];
    gameInfo.tvSize = [[dic objectForKey:@"tv_sizes"] longValue];
    gameInfo.tvuSupport = [[dic objectForKey:@"tvusupport"] intValue];
    gameInfo.imgZipUrl = [dic objectForKey:@"img_zip_url"];
    gameInfo.supportDpad = [[dic objectForKey:@"suppportdpad"] intValue];
    gameInfo.gravity = [[dic objectForKey:@"gravity"] intValue];
    //keyBeans 是一个数组
    NSArray* keyBeanArray = [dic objectForKey:@"keybeans"];
    gameInfo.keyBeans = [[self class] createGameKeyBeanArrayFromArray:keyBeanArray];
    
    //rockers 是一个数组
    NSArray* rockersArray = [dic objectForKey:@"rockers"];
    NSLog(@"解析后rockersArray的个数是：%d", [rockersArray count]);
    gameInfo.rockers = [[self class] createRockerArrayFromArray:rockersArray];
    
    //gameScrShoot是一个数组  继续解析
    NSArray* gameScrShoot = [dic objectForKey:@"gamescrshoot"];
    gameInfo.gameScrShoot = [[self class] createGameScrShootArrayFromArray:gameScrShoot];
    return [gameInfo autorelease];
}

+ (NSMutableArray*) createRockerArrayFromArray:(NSArray*)array
{
    NSMutableArray* rockerArray = [[NSMutableArray alloc] init];
    for(int i=0; i<[array count]; ++i)
    {
        Rocker* rocker = [[Rocker alloc] init];
        NSDictionary* dic = [array objectAtIndex:i];
        rocker.centerX = [[dic objectForKey:@"centerx"] intValue];
        rocker.centerY = [[dic objectForKey:@"centery"] intValue];
        NSLog(@"centX = %d", rocker.centerX);
        NSLog(@"centY = %d", rocker.centerY);
        [rockerArray addObject:rocker];
        [rocker release];
    }
    return [rockerArray autorelease];
}

/*
 @synthesize update_modal;
 @synthesize vcode;
 @synthesize vname;
 @synthesize update_size;
 @synthesize isNeedUpdate;
 @synthesize update_url;
 @synthesize update_memo;
 @synthesize update_title;
 */
+ (UpdateInfo*) createUpdateInfoFromJson:(NSString*)json
{
    NSError* error=nil;
    NSLog(@"jsonis: %@", json);
    NSURL* url = [NSURL URLWithString:json];
    NSData* data = [NSData dataWithContentsOfURL:url options:kNilOptions error:&error];
    if(error != nil)
    {
        NSLog(@"createUpdateInfo 失败, %@", error);
        return nil;
    }
    
    NSString* jsonString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error != nil)
    {
        NSLog(@"解析updateInfo失败");
        return nil;
    }
    UpdateInfo* updateInfo = [[UpdateInfo alloc] init];
    updateInfo.update_model = [[dic objectForKey:@"update_model"] intValue];
    updateInfo.update_size = [[dic objectForKey:@"update_size"] longValue];
    updateInfo.vname = [dic objectForKey:@"vname"];
    updateInfo.vcode = [[dic objectForKey:@"vcode"] intValue];
    updateInfo.isNeedUpdate = [[dic objectForKey:@"isNeedUpdate"] intValue];
    updateInfo.update_url = [dic objectForKey:@"update_url"];
    updateInfo.update_memo = [dic objectForKey:@"update_memo"];
    updateInfo.update_title = [dic objectForKey:@"update_title"];
    return [updateInfo autorelease];
}

/*
 tvu_ad_switch   //启动是否展示广告
 showtvuoo_switch  //打开是否显示大厅
 tvu_showgame_switch	//手机显示手游栏目
 tvu_showremote_switch	//手机显示超级遥控
 exitgame_switch		//退出游戏广告开关
 exitsdk_switch		//退出SDK显示游戏
 tvu_super_apk_url	//超级遥控包地址
 */
//+(Switcher*) createSwitcherFromJson:(NSString*)jsonUrl
//{
//    NSURL* url = [NSURL URLWithString:jsonUrl];
//    
//    NSData* data = [NSData dataWithContentsOfURL:url];
//    if (data == nil) {
//        NSLog(@"获取单个switcher失败");
//        return nil;
//    }
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    if(dic == nil)
//    {
//        NSLog(@"获取switcher的json 失败");
//        return nil;
//    }
//    Switcher* switcher = [[Switcher alloc] init];
//    switcher.tvu_ad_switch = [[dic objectForKey:@"tvu_ad_switch"] intValue];
//    switcher.showtvuoo_switch = [[dic objectForKey:@"showtvuoo_switch"] intValue];
//    switcher.tvu_showgame_switch = [[dic objectForKey:@"tvu_showgame_switch"] intValue];
//    switcher.tvu_showremote_switch = [[dic objectForKey:@"tvu_showremote_switch"] intValue];
//    NSLog(@"llll %d", switcher.tvu_showremote_switch);
//    switcher.exitgame_switch = [[dic objectForKey:@"exitgame_switch"] intValue];
//    switcher.exitsdk_switch = [[dic objectForKey:@"exitsdk_switch"] intValue];
//    switcher.tvu_super_apk_url = [dic objectForKey:@"tvu_super_apk_url"];
//    return  [switcher autorelease];
//}


@end
