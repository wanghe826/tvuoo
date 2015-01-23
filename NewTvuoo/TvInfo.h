//
//  TvInfo.h
//  NewTvuoo
//
//  Created by xubo on 9/25 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TvInfo : NSObject
{
    NSString* _tvName;
    int __tvServerport;
    int _tvUdpPort;
    NSString* _tvTag;
    int _tvType;
    int _tvIp;
    BOOL _cell_btn_statue;
}
@property (retain, nonatomic) NSDate* date;
@property (assign, nonatomic) BOOL cell_btn_statue;
@property (assign, nonatomic) int tvIp;
@property (retain, nonatomic) NSString* tvName;
@property (assign, nonatomic) int tvServerport;
@property (assign, nonatomic) int tvUdpPort;
@property (assign, nonatomic) NSString* tvTag;
@property (assign, nonatomic) int tvType;
@property (retain, nonatomic) NSString* pkgName;

@end

@interface TvInfoDetail : NSObject
{
    int _canadb;
    int _capa;
    int _height;
    int _width;
    int _isroot;
    int _deviceId;
    NSString* _mac;
    NSString* _name;
    int _tag;
}

@property (assign, nonatomic) int canadb;
@property (assign, nonatomic) int capa;
@property (assign, nonatomic) int height;
@property (assign, nonatomic) int width;
@property (assign, nonatomic) int isroot;
@property (assign, nonatomic) int tag;
@property (retain, nonatomic) NSString* mac;
@property (retain, nonatomic) NSString* name;
@property (assign, nonatomic) int deviceId;

@end