//
//  QQCell.m
//  QQ列表
//
//  Created by yangqinglong on 16/2/25.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "QQCell.h"
@interface QQCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@end
@implementation QQCell

+(QQCell *)cellWithTabView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    QQCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    
    
    return cell;
}
-(void)setModel:(Person *)model{
    _model = model;
    _iconImageView.image = [UIImage imageNamed:model.iconName];
    _nameLabel.text = model.name;
    _introLabel.text = model.introduction;
    
}
@end











