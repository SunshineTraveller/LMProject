//
//  BBA_BWM.m
//  LMProject
//
//  Created by zhanglimin on 2023/9/12.
//
//  self VS super 方法调用时，都是用的当前类的实例对象，区别是：调用父类还是当前类里调的方法
//  receiver current_cls, receiver 是当前实例对象，current_cls 代表从哪个类找方法并实现

#import "BBA_BWM.h"

@implementation BBA_BWM

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"My name is Audi A6L";
    }
    return self;
}

-(void)run {
    [super run];
}

-(void)go {
    [super go];
}

@end
