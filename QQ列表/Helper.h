//
//  Helper.h
//  QQ列表
//
//  Created by yangqinglong on 16/2/25.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+(NSArray *)loadDataFromPlistWithName:(NSString *)fileName;
+(NSArray *)loadEmotionDataFromPlistWithName:(NSString *)plistName;
//将图片进行拉伸
+(UIImage *)resizeWithImage:(UIImage *)image;
//将消息里的表情符号替换为有对应图片的字符串
+(NSMutableAttributedString *)emotionAttrbutedStringWithText:(NSString *)text faceFileName:(NSString *)fileName;


@end




