//
//  MessageCell.h
//  QQ列表
//
//  Created by yangqinglong on 16/3/1.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageModel.h"
@interface MessageCell : UITableViewCell
@property (nonatomic,strong) messageModel *message;
//获取cell
+(MessageCell *)cellWithTableView:(UITableView *)tableView;

//获取cell高度
+(CGFloat)cellHeightWithMessage:(messageModel *)message;

@end
