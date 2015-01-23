//
//  DeviceInfo.h
//  NewTvuoo
//
//  Created by xubo on 11/21 Friday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfo : NSObject

@property (retain, nonatomic) NSString* version;
@property (retain, nonatomic) NSString* cid;

-(NSString*) toString;
@end
