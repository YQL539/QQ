//
//  SectionHeaderView.h
//  QQ列表
//
//  Created by yangqinglong on 16/2/25.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    kArrowDirectionRight,
    kArrowDirectionDown
}kArrowDirection;

typedef void(^SectionHeaderBlock)(NSInteger section);

@interface SectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (nonatomic,copy) SectionHeaderBlock block;
@property (nonatomic,assign) NSInteger section;
@property (nonatomic,assign) kArrowDirection direction;

@end










