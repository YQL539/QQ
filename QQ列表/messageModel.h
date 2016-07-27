//
//  messageModel.h
//  QQ列表
//
//  Created by yangqinglong on 16/3/1.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    kMessageTypeText,
    kMessageTypePicture,
    kMessageTypeVoice,
    kMessageTypeVideo
}kMessageType;
@interface messageModel : NSObject
@property (nonatomic,strong) NSString *content;//聊天的内容
//消息类型
@property (nonatomic,assign) kMessageType messageType;
//谁发的
@property (nonatomic,assign) BOOL isSender;

@end
