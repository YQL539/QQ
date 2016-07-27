//
//  EmotionView.m
//  QQ列表
//
//  Created by yangqinglong on 16/2/26.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "EmotionView.h"
#import "EmotionModel.h"
#import "GlassImageView.h"
//表情的尺寸
#define kFaceSize 32
//横向间隙
#define hSpace (self.frame.size.width - (_colum * kFaceSize))/(_colum +1)
//纵向间隙
#define vSpace ((self.frame.size.height - 20-(_row *kFaceSize))/(_row +1))

@interface EmotionView()<UIScrollViewDelegate>
@property (nonatomic,assign) NSInteger row;
@property (nonatomic,assign) NSInteger colum;
@property (nonatomic,strong) UIScrollView *faceScrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) GlassImageView *glassImageView;
@property (nonatomic,assign) NSInteger lastEmotionIndex;
@end
@implementation EmotionView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"emoticon_keyboard_background"]];
        
        //pageControl
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        _pageControl.numberOfPages = 5;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        [_pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        //scrollView
        self.faceScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, self.frame.size.height - 20)];
        _faceScrollView.pagingEnabled = YES;
        _faceScrollView.showsHorizontalScrollIndicator = NO;
        _faceScrollView.delegate = self;
        [self addSubview:_faceScrollView];
        
        //给初值
        _row = 3;
        _colum = 7;
        
        //添加长按事件  放大镜查看表情
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        [self addGestureRecognizer:longPressGesture];
        
        //添加点击事件，选中表情
        UITapGestureRecognizer  *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tapGesture];
        self.faceScrollView.clipsToBounds = NO;
    }
    return self;
}
-(void)setModelsArray:(NSArray *)modelsArray{
    _modelsArray = modelsArray;
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInEmotionView)]) {
        self.row = [self.dataSource numberOfRowsInEmotionView];
    }
    if ([self.dataSource respondsToSelector:@selector(numberOfEmotionsOfRow)]) {
        self.colum = [self.dataSource numberOfEmotionsOfRow];
    }
    //显示内容
    for (int i = 0; i<_modelsArray.count; i++) {
        //获取这个表情的模型
        EmotionModel *model = [_modelsArray objectAtIndex:i];
        //获取图片
        UIImage *faceImage = [UIImage imageNamed:model.imageName];
        //计算表情的位置。第几行几列
        NSInteger page = i/(_row *_colum - 1);
        NSInteger tRow = (i - page *(_row *_colum - 1))/_colum;
        NSInteger tColum = (i - page*(_row * _colum -1))%_colum;
        //将这个图片滑到scrollView上
        CGRect frame = CGRectMake(page *self.frame.size.width + hSpace + tColum *(kFaceSize +hSpace), vSpace +tRow *(kFaceSize +vSpace),kFaceSize, kFaceSize);
        UIImageView *faceImageView = [[UIImageView alloc]initWithFrame:frame];
        faceImageView.image = faceImage;
        [_faceScrollView addSubview:faceImageView];
    }
    //获取总共的页数
    NSInteger totalPages = _modelsArray.count/(_row *_colum - 1)+1;
    _pageControl.numberOfPages = totalPages;
    _faceScrollView.contentSize = CGSizeMake(totalPages*self.frame.size.width, _faceScrollView.frame.size.height);
    //添加删除按钮
    for (int i = 0; i<totalPages; i++) {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(self.frame.size.width*(i+1)-hSpace-kFaceSize, self.frame.size.height-20-vSpace-kFaceSize, kFaceSize, kFaceSize);
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.faceScrollView addSubview:deleteButton];
    }
    
}

#pragma mark ------lazyload
-(GlassImageView *)glassImageView{
    if (_glassImageView == nil) {
        self.glassImageView = [[GlassImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 91.5)];
        [self.faceScrollView addSubview:_glassImageView];
    }
    return _glassImageView;
}


#pragma mark ----deleteBtn Action
-(void)deleteButtonDidClicked{
    [[NSNotificationCenter defaultCenter]postNotificationName:kEmotionDeleteButtonClickedNotificationName object:nil];
}
#pragma mark -----gesture
-(void)longPressGesture:(UILongPressGestureRecognizer *)gesture{
    //获取位置
    CGPoint location = [gesture locationInView:self.faceScrollView];
    if (location.y <= _pageControl.frame.origin.y) {
        _glassImageView.hidden = NO;
        if (gesture.state == UIGestureRecognizerStateEnded) {
            _glassImageView.hidden = YES;
        }
        self.glassImageView.frame = CGRectMake(location.x-64/2.0, location.y - 91.5, 64, 91.5);
        //识别location的位置是第几个表情
        //第几页
        NSInteger page = location.x/self.frame.size.width;
        NSInteger tRow = location.y/(kFaceSize +vSpace);
        NSInteger tColum = (location.x - page*self.frame.size.width)/(kFaceSize +hSpace);
        NSInteger index = page *(_colum*_row-1)+tRow*_colum+tColum;
        if (index != _lastEmotionIndex) {
            //获取index位置对应的这个表情的model
            EmotionModel *model = [_modelsArray objectAtIndex:index];
            //将这个表情显示到放大镜上
            _glassImageView.model = model;
            _lastEmotionIndex = index;
        }
    }
}
-(void)tapGesture:(UITapGestureRecognizer *)gesture{
    CGPoint location = [gesture locationInView:self.faceScrollView];
    if (location.y<=_pageControl.frame.origin.y) {
        NSInteger page = location.x / self.frame.size.width;
        NSInteger tRow = location.y / (kFaceSize + vSpace);
        NSInteger tColum = (location.x - page*self.frame.size.width) / (kFaceSize + hSpace);
        NSInteger index = page*(_colum*_row - 1) + tRow*_colum + tColum;
        EmotionModel *model = [_modelsArray objectAtIndex:index];
        //广播消息
        [[NSNotificationCenter defaultCenter]postNotificationName:kEmotionClickedNotificationName object:model] ;
    }
}

#pragma mark---ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / self.frame.size.width;
    if (page != _pageControl.currentPage) {
        _pageControl.currentPage = page;
    }
}
-(void)pageChanged{
    [self.faceScrollView setContentOffset:CGPointMake(_pageControl.currentPage *self.frame.size.width, 0) animated:YES];
}
@end


















