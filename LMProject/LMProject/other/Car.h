//
//  Car.h
//  LMProject
//
//  Created by zhanglimin on 2023/9/12.
//

#import <Foundation/Foundation.h>
#import "Vichile.h"

NS_ASSUME_NONNULL_BEGIN

@interface Car : Vichile
//{
//    @public
//    int _year;  // 4字节
//    double _kilometres;    // 8字节
//}
//
//@property (nonatomic,copy) NSString *name;

//@property (nonatomic,assign) int year; // 4字节
//@property (nonatomic,assign) double kilometres; // 8字节
// isa 指针 8字节

- (void)run;

@end

NS_ASSUME_NONNULL_END
