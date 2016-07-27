//
//  EmotionView.h
//  QQ列表
//
//  Created by yangqinglong on 16/2/26.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import <UIKit/UIKit.h>
//定义代理用于数据源的配置
@protocol EmotionViewDataSouce <NSObject>
//有多少行
-(NSInteger)numberOfRowsInEmotionView;
//每行显示多少个
-(NSInteger)numberOfEmotionsOfRow;

@end

@interface EmotionView : UIView
@property (nonatomic,assign) id<EmotionViewDataSouce> dataSource;
@property (nonatomic,strong)NSArray *modelsArray;
@end
