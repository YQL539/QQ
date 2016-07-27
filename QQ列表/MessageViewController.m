//
//  MessageViewController.m
//  QQ列表
//
//  Created by yangqinglong on 16/2/26.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "MessageViewController.h"
#import "FaceKeyboardView.h"
#import "EmotionModel.h"
#import "messageModel.h"
#import "MessageCell.h"
typedef enum {
    kMassageStatusNormal,
    kMassageStatusShowKeyboard
}kMassageStatus;
@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageButtonLayoutConstraint;
//表情视图
@property (nonatomic,strong) FaceKeyboardView *faceKeyboardView;
@property (nonatomic,assign) kMassageStatus barStatus;
@property (nonatomic,strong) NSMutableArray *selectedModelsArray;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
//消息模型数组
@property (nonatomic,strong) NSMutableArray *messageModelsArray;

@property (nonatomic,assign) CGFloat offsetY;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _messageTextField.returnKeyType = UIReturnKeySend;
    //监听键盘弹出和隐藏的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    _barStatus = kMassageStatusNormal;
}
#pragma mark-----lazyload----
-(NSMutableArray *)selectedModelsArray{
    if (_selectedModelsArray ==nil) {
        self.selectedModelsArray = [NSMutableArray array];
    }
    return _selectedModelsArray;
}

-(FaceKeyboardView *)faceKeyboardView{
    if (_faceKeyboardView == nil) {
        self.faceKeyboardView = [[FaceKeyboardView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 224)];
        //表情选中的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(emotionDidSelected:) name:kEmotionClickedNotificationName object:nil];
        //删除按钮的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteEmotion) name:kEmotionDeleteButtonClickedNotificationName object:nil];
        
    }
    return _faceKeyboardView;
}

-(NSMutableArray *)messageModelsArray{
    if (_messageModelsArray ==nil) {
        self.messageModelsArray = [NSMutableArray array];
    }
    return _messageModelsArray;
}

-(void)emotionDidSelected:(NSNotification *)notifi{
    EmotionModel *model = notifi.object;
    //添加到数组里面，保存当前的这个表情
    if (![_selectedModelsArray containsObject:model]) {
        [self.selectedModelsArray addObject:model];
    }
    _messageTextField.text = [_messageTextField.text stringByAppendingString:model.name];
}
-(void)deleteEmotion{
    //如果有表情删除，没有就删除文字
    NSInteger length = _messageTextField.text.length;
    BOOL isExists = NO;
    if (length != 0) {
        if ([[_messageTextField.text substringWithRange:NSMakeRange(length-1, 1)] isEqualToString:@"]"]) {
            //只有文字[笑脸]!!![憋屈]
            //只有文字
            //笑脸]!!!
            //憋屈]
            //从后面开始搜索
            NSRange range = [_messageTextField.text rangeOfString:@"[" options:NSBackwardsSearch];
            NSString *faceString = [_messageTextField.text substringFromIndex:range.location];
            
            //判断是否合法
            for (EmotionModel *model in _selectedModelsArray) {
                if ([faceString isEqualToString:model.name]) {
                    isExists = YES;
                    _messageTextField.text = [_messageTextField.text stringByReplacingOccurrencesOfString:faceString withString:@""];
                    break;
                }
            }
            if (isExists == NO) {
                _messageTextField.text = [_messageTextField.text stringByReplacingCharactersInRange:NSMakeRange(_messageTextField.text.length-1, 1) withString:@""];
            }
        }else{
            //普通字符删除一个字即可
            _messageTextField.text = [_messageTextField.text stringByReplacingCharactersInRange:NSMakeRange(_messageTextField.text.length -1, 1) withString:@""];
        }
    }
}

#pragma mark----键盘消息
//键盘弹出隐藏
-(void)keyboardChanged:(NSNotification *)notifi{
    
    //最终的frame
    CGRect endRect = [[notifi.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //判断messageBar 是否需要移动
    if (_barStatus == kMassageStatusNormal||(_barStatus == kMassageStatusShowKeyboard&&_messageButtonLayoutConstraint.constant ==0)) {
        //先改变约束条件的值
        self.messageButtonLayoutConstraint.constant = self.view.frame.size.height - endRect.origin.y;
        
        //让当前这个视图重新刷新一下
        [self.view layoutIfNeeded];
    }
    _barStatus = kMassageStatusNormal;
}

#pragma mark messageBar-------------------------
- (IBAction)VoiceButtondidClicked:(UIButton *)sender {
}
- (IBAction)smileButtonDidClicked:(UIButton *)sender {
    _barStatus = kMassageStatusShowKeyboard;
    
    if (sender.tag ==0){
        //切换到表情视图
        [sender setImage:[UIImage imageNamed:@"keyboard"]forState:UIControlStateNormal];
        sender.tag = 1;
            //当textfiled 作为第一响应者，系统会去查找这个textfield的inputView 将这个inputView作为键盘弹出，如果inputView为nil 那么弹出系统键盘，否则弹出inputViews 的视图
        self.messageTextField.inputView = self.faceKeyboardView;
        
    }else{
        //从表情视图切换为键盘
        [sender setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
        sender.tag = 0;
        self.messageTextField.inputView = nil;
    }
    [self.messageTextField resignFirstResponder];
    //先让键盘消失，使用定时器隔几秒让键盘出现
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showKeyboard) userInfo:nil repeats:NO];
}
-(void)showKeyboard{
     [self.messageTextField becomeFirstResponder];
}
- (IBAction)addButtonDidClicked:(UIButton *)sender {
    
}


#pragma mark--------UITextFieldDelegate-----
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //创建即将发送的这个消息的模型
    messageModel *model = [[messageModel alloc]init];
    model.content = textField.text;
    model.messageType = kMessageTypeText;
    if (self.messageModelsArray.count%2 ==0) {
        model.isSender = YES;
    }else{
        model.isSender  = NO;
    }
    //将model添加到数据源里面去
    [self.messageModelsArray addObject:model];
    //刷新tabView
    [self.myTableView reloadData];
    
    //滚动到最后一行
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:_messageModelsArray.count - 1 inSection:0];
    [self.myTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return YES;
}
#pragma mark----------UITableViewDelegate-------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _messageModelsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取这一行对应的消息模型
    messageModel *model = [_messageModelsArray objectAtIndex:indexPath.row];

    return [MessageCell cellHeightWithMessage:model];
}
-(MessageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [MessageCell cellWithTableView:tableView];
    cell.message = [_messageModelsArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<_offsetY) {
        if ([_messageTextField isFirstResponder]) {
            [_messageTextField resignFirstResponder];
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _offsetY = scrollView.contentOffset.y;
}


@end




















