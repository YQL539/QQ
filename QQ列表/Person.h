//
//  Person.h
//  QQ列表
//
//  Created by yangqinglong on 16/2/25.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *iconName;
@property (nonatomic,strong) NSString *introduction;
//为避免写代码时过于冗长，将属性变量卸载init方法中进行赋值
-(Person *)initWithName:(NSString *)name iconName:(NSString *)iconName introduction:(NSString *)introduction;

@end





