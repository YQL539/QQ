//
//  SectionHeaderView.m
//  QQ列表
//
//  Created by yangqinglong on 16/2/25.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "SectionHeaderView.h"

@implementation SectionHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didViewClicked)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
}

-(void)setDirection:(kArrowDirection)direction{
    _direction = direction;
    if (direction) {
        self.arrowImageView.transform = CGAffineTransformRotate(_arrowImageView.transform, M_PI_2);
    }
}

-(void)didViewClicked{
    self.block(_section);
}


@end





