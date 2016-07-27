//
//  GlassImageView.m
//  QQ列表
//
//  Created by yangqinglong on 16/2/29.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "GlassImageView.h"
#define kSize 50
@interface GlassImageView()
@property (nonatomic,strong) UIImageView *faceImageView;

@end
@implementation GlassImageView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier"];
        self.faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2.0-kSize/2.0, 5, kSize, kSize)];
        [self addSubview:_faceImageView];
    }
    return self;
}
-(void)setModel:(EmotionModel *)model{
    _model = model;
    _faceImageView.image = [UIImage imageNamed:_model.imageName];
}

@end
