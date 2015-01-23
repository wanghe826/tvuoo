//
//  MyCell.h
//  NewTvuoo
//
//  Created by xubo on 10/20 Monday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfo.h"
#import "HJObjManager.h"
#import "HJManagedImageV.h"
//@class EGOImageView;

@interface MyCell : UITableViewCell
{
    @private
//    EGOImageView* imageView;
    HJManagedImageV* imageView;
    HJObjManager* hjObj;
}
@property (retain, nonatomic) HJManagedImageV* imageView;
//@property (retain, nonatomic) GameInfo* gameInfo;
- (void) setImage: (NSString*)image;
- (HJManagedImageV*) image;
- (void) clear;

@property (retain, nonatomic) UILabel* nameLabel;
@property (retain, nonatomic) UILabel* typeName;
@property (retain, nonatomic) UILabel* capa;
@property (retain, nonatomic) UILabel* typeLabel;
@property (retain, nonatomic) UILabel* capaLabel;

@end
