//
//  Vichile.m
//  LMProject
//
//  Created by zhanglimin on 2023/10/10.
//

#import "Vichile.h"

@implementation Vichile

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)run {
    NSLog(@"%s  %@, name = %@, superClass = %@    %@",__FUNCTION__, self, self.name,[self superclass], [[self class] superclass]);
//    NSLog(@"%s ",__FUNCTION__);
}

// 构造器，beforeMainFunction 方法会在 main 函数之前调用
__attribute__((constructor))
void beforeMainFunction() {
//    NSLog(@"%s", __FUNCTION__);
}

// 析构器，beforeExitFunction 会在 exit 函数之前调用
__attribute__((destructor))
void beforeExitFunction() {
    NSLog(@"%s", __FUNCTION__);
}



@end
