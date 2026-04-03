//
//  Car.m
//  LMProject
//
//  Created by zhanglimin on 2023/9/12.
//

#import "Car.h"

@implementation Car

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.year = 1;
//        self.kilometres = 2.0;
        self.name = @"My name is Car";
    }
    return self;
}

- (void)run {
    [super run];
//    NSLog(@"%s  %@, name = %@",__FUNCTION__, self, self.name);
}

-(void)go {
    
}

@end
