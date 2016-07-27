//
//  Person.m
//  QQ列表
//
//  Created by yangqinglong on 16/2/25.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "Person.h"

@implementation Person

-(Person *)initWithName:(NSString *)name iconName:(NSString *)iconName introduction:(NSString *)introduction{
    if (self = [super init]) {
        _name = name;
        _iconName = iconName;
        _introduction = introduction;
        
        
        
    }
    return self;
}

@end














