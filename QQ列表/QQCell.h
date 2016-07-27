//
//  QQCell.h
//  QQ列表
//
//  Created by yangqinglong on 16/2/25.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@interface QQCell : UITableViewCell
@property (nonatomic,strong) Person *model;

+(QQCell *)cellWithTabView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


@end







