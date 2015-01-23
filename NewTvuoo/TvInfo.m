//
//  TvInfo.m
//  NewTvuoo
//
//  Created by xubo on 9/25 Thursday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "TvInfo.h"

@implementation TvInfo

@synthesize tvName = _tvName;
@synthesize tvServerport = _tvServerport;
@synthesize tvTag = _tvTag;
@synthesize tvType = _tvType;
@synthesize tvUdpPort = _tvUdpPort;
@synthesize tvIp = _tvIp;
@synthesize cell_btn_statue = _cell_btn_statue;
@synthesize pkgName;
@synthesize date;

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
    self.tvName = nil;
    self.tvTag = nil;
    self.pkgName = nil;
    [super dealloc];
}
@end


@implementation TvInfoDetail

@synthesize name = _name;
@synthesize mac = _mac;
@synthesize width = _width;
@synthesize height = _height;
@synthesize tag = _tag;
@synthesize isroot = _isroot;
@synthesize canadb = _canadb;
@synthesize capa = _capa;
@synthesize deviceId = _deviceId;

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
    [super dealloc];
    [_name release];
    [_mac release];
}
@end
