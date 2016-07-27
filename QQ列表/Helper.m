//
//  Helper.m
//  QQ列表
//
//  Created by yangqinglong on 16/2/25.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "Helper.h"
#import "Person.h"
#import "EmotionModel.h"
@implementation Helper

+(NSArray *)loadDataFromPlistWithName:(NSString *)fileName{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (int i = 0; i<array.count; i++) {
        NSDictionary *dic = [array objectAtIndex:i];
        //读取分组名，把分组的key value读取出来
        NSString *groupName = [dic objectForKey:@"groupName"];
        
        //读取这组好友信息
        NSArray *friendArray = [dic objectForKey:@"friends"];
        
        NSMutableArray *modelsArray = [NSMutableArray array];
        //封装每个好友为friendModel类型
        for (NSDictionary *dic in friendArray) {
            NSString *name = [dic objectForKey:@"name"];
            NSString *iconName = [dic objectForKey:@"icon"];
            NSString *introduction = [dic objectForKey:@"intro"];
            Person *friend = [[Person alloc]initWithName:name iconName:iconName introduction:introduction];
            [modelsArray addObject:friend];
        }
        NSDictionary *friendDic = @{@"friend":modelsArray, @"groupName":groupName};
        
        [dataArray addObject:friendDic];
        
    }
    return dataArray;
}

+(NSArray *)loadEmotionDataFromPlistWithName:(NSString *)plistName{
    //获取路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:plistName ofType:@"plist"];
    NSArray *facesArray = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *emotionModelsArray = [NSMutableArray array];
    //解析数组里面的内容
    for (NSDictionary *dic in facesArray) {
        EmotionModel *model = [[EmotionModel alloc]init];
        model.name = [dic objectForKey:@"chs"];
        model.imageName = [dic objectForKey:@"png"];
        
        [emotionModelsArray addObject:model];
    }
    return emotionModelsArray;
}

+(UIImage *)resizeWithImage:(UIImage *)image{
    CGFloat top = image.size.height/2.0;
    CGFloat left = image.size.width/2.0;
    CGFloat bottom = image.size.height/2.0;
    CGFloat right = image.size.width/2.0;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(top, left, bottom, right) resizingMode:UIImageResizingModeStretch];
}

//将消息里面的 表情符号替换为对应图片的字符串
+(NSMutableAttributedString *)emotionAttrbutedStringWithText:(NSString *)text faceFileName:(NSString *)fileName{
    //读取plist文件所有表情的Model
    NSArray *faceModelsArray = [Helper loadEmotionDataFromPlistWithName:fileName];
    //将传递过来的文本转化为属性文本
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc]initWithString:text];
    //创建正则表达式 匹配中文
    NSString *pattern = @"\\[[\u4E00-\u9FA5]+\\]";
    NSError *errMsg = nil;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&errMsg];
    if (errMsg != nil) {
        NSLog(@"Error:%@",[errMsg description]);
        return attString;
    }
    //从text里面解析所有：【中文】类型的数据
    //数组里面保存的是NSTextCheckingResult
    NSArray *restultsArray = [regular matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //遍历数组，找到每个表情符号对应的图片 用这个图片替换表情符号
    for (NSInteger i = restultsArray.count -1; i>=0; i--) {
        //获取删选的 结果
        NSTextCheckingResult *checkResult = [restultsArray objectAtIndex:i];
        //获取这个表情符号在text里面的位置
        NSRange range = checkResult.range;
        //获取这个表情的字符串【微笑】
        NSString *faceString = [text substringWithRange:range];
        //从数据源里面去查找这个表情对应的图片
        for (EmotionModel *model in faceModelsArray) {
            if ([model.name isEqualToString:faceString]) {
                //这个表情存在，创建一个附件
                UIImage *image = [UIImage imageNamed:model.imageName];
                NSTextAttachment *attach = [[NSTextAttachment alloc]init];
                attach.image = image;
                attach.bounds = CGRectMake(0, -10, image.size.width, image.size.height);
                //将这个附件转化为属性字符串
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attach];
                //用imageStr 替换属性文本里面的符号
                [attString replaceCharactersInRange:range withAttributedString:imageStr];
                break;
            }
        }
    }
    return attString;
}


@end










