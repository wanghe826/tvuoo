//
//  NoConnViewController.h
//  NewTvuoo
//
//  Created by xubo on 10/17 Friday.
//  Copyright (c) 2014 wap3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickConnViewController.h"
@interface NoConnViewController : UIViewController<UIAccelerometerDelegate>
@property (retain, nonatomic) QuickConnViewController* quickConnVc;
@end


@interface GetTvStateViewController : UIViewController<CallBack>
{
    UIImageView* _activityView;
    NSTimer* _timer;
}
@end

@interface GetModuleViewController : UIViewController

@end

@interface HintViewController : UIViewController

@end

@interface GetRootViewController : UIViewController
@end