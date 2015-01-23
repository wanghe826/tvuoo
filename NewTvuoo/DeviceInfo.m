//
//  DeviceInfo.m
//  NewTvuoo
//
//  Created by xubo on 11/21 Friday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import "DeviceInfo.h"

@implementation DeviceInfo
@synthesize cid;
@synthesize version;
- (id) init
{
    if(self = [super init])
    {
        self.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return self;
}


-(NSString*) toString
{
    NSMutableString* params = [[NSMutableString alloc] init];
    [params appendString:@"?&cid=9527"];
    [params appendString:@"&version="];
    [params appendString:self.version];
    [params appendString:@"&pkg="];
    [params appendString:[[NSBundle mainBundle] bundleIdentifier]];
    return [params autorelease];
}

@end
