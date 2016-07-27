//
//  FaceKeyboardView.m
//  QQ列表
//
//  Created by yangqinglong on 16/2/29.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "FaceKeyboardView.h"
#import "Helper.h"
#import "EmotionView.h"
#import "EmotionBarView.h"
@interface FaceKeyboardView()<EmotionViewDataSouce>
@property (nonatomic,strong) NSArray *emotionModelsArray;
@property (nonatomic,strong) EmotionView *emotionView;
@property (nonatomic,strong) EmotionBarView *emotionBarView;

@end
@implementation FaceKeyboardView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //加载数据源
        [self loadDataSource];
        //操作的bar
        self.emotionBarView = [[EmotionBarView alloc]initWithFrame:CGRectMake(0, frame.size.height - 44, frame.size.width, 44)];
        _emotionBarView.backgroundColor = [UIColor redColor];
        [self addSubview:_emotionBarView];
        
        //创建表情视图
        self.emotionView = [[EmotionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-44)];
        _emotionView.dataSource = self;
        _emotionView.modelsArray = self.emotionModelsArray;
        [self addSubview:_emotionView];
        
    }
    return self;
}
-(void)loadDataSource{
    self.emotionModelsArray = [Helper loadEmotionDataFromPlistWithName:@"face"];
}


#pragma mark ----EmotionViewDataSource -----
-(NSInteger)numberOfRowsInEmotionView{
    return 3;
}
-(NSInteger)numberOfEmotionsOfRow{
    return 7;
}
@end













