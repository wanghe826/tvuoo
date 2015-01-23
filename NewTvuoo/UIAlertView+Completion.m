//
//  UIAlertView+Completion.m
//  NewTvuoo
//
//  Created by xubo on 12/24 星期三.
//  Copyright (c) 2014年 wap3. All rights reserved.
//

#import "UIAlertView+Completion.h"
#import <objc/runtime.h>

@implementation UIAlertView (Completion)


static char key;
static char tvInfoKey = 't';

- (void) alertViewWithBlock:(Completion)block
{
    if(block)
    {
        objc_removeAssociatedObjects(self);
        /**
         1 创建关联（源对象，关键字，关联的对象和一个关联策略。)
         2 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
         3 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。
         */
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        ////设置delegate
        self.delegate = self;
    }
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ///获取关联的对象，通过关键字。
    Completion block = objc_getAssociatedObject(self, &key);
    if (block) {
        ///block传值
//        block(objc_getAssociatedObject(self, &tvInfoKey));
        block([self tvInfo]);
    }
}

- (void) setTvInfo:(TvInfo *)_tvInfo
{
    objc_removeAssociatedObjects(self);
    objc_setAssociatedObject(self, &tvInfoKey, _tvInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (TvInfo*) tvInfo
{
    return objc_getAssociatedObject(self, &tvInfoKey);
}

@end
