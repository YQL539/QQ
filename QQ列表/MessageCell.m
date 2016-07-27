//
//  MessageCell.m
//  QQ列表
//
//  Created by yangqinglong on 16/3/1.
//  Copyright © 2016年 杨清龙. All rights reserved.
//

#import "MessageCell.h"
#import "Helper.h"
#define kHeaderWidth 40
#define kTextSize 16.0
#define kScreenWidth [UIScreen mainScreen].bounds.size.width  //屏幕宽度
#define kPadding 10
#define kInset 10
@interface MessageCell()
@property (nonatomic,strong) UIImageView *headerImageView;//头像
@property (nonatomic,strong) UILabel *contentLabel;//显示消息内容
@property (nonatomic,strong) UIButton *bgButton;//消息内容的底，添加长按事件预留

@end
@implementation MessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _headerImageView.layer.cornerRadius = kHeaderWidth/2.0;
        _headerImageView.clipsToBounds = YES;
        [self.contentView addSubview:_headerImageView];
        
        //底层按钮
        self.bgButton = [[UIButton alloc]initWithFrame:CGRectZero];
        
        [self.contentView addSubview:_bgButton];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:kTextSize];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.bgButton addSubview:_contentLabel];
        
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}
+(MessageCell *)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"cellID";
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
+(CGSize)sizeWithMessage:(messageModel *)message{
    //消息最大宽度
    CGFloat textMaxWidth = [UIScreen mainScreen].bounds.size.width-60-kPadding*2-kHeaderWidth;
    //获取替换后的文本
    NSMutableAttributedString *attSring = [Helper emotionAttrbutedStringWithText:message.content faceFileName:@"face"];
    //文本的属性font
    [attSring addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTextSize]} range:NSMakeRange(0, attSring.length)];
    CGSize textSize = [attSring boundingRectWithSize:CGSizeMake(textMaxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    return textSize;
}


+(CGFloat)cellHeightWithMessage:(messageModel *)message{
    CGSize textSize = [MessageCell sizeWithMessage:message];
    CGFloat height = textSize.height + kInset*2;
    if (height <60) {
        height = 60;
    }
    return height;
}
#pragma mark ------setter-----
-(void)setMessage:(messageModel *)message{
    _message = message;
    //头像，消息体
    [self setHeaderFrame];
    
    [self setTextBodyFrame];
}

-(void)setHeaderFrame{
    CGFloat x;
    if (_message.isSender) {
        //自己发的
        x = kScreenWidth - kPadding - kHeaderWidth;
        _headerImageView.image = [UIImage imageNamed:@"header1"];
    }else{
        //别人发的，在左边
        x = kPadding;
        _headerImageView.image = [UIImage imageNamed:@"header2"];
    }
    _headerImageView.frame = CGRectMake(x, kPadding, kHeaderWidth, kHeaderWidth);
}
-(void)setTextBodyFrame{
    //消息的高度 宽度
    CGSize textSize = [MessageCell sizeWithMessage:_message];
    //设置背景按钮
    CGFloat bgX;
    UIImage *normalImage;
    UIImage *selectedImage;
    if (_message.isSender) {
        //自己发的
        bgX = kScreenWidth - kPadding*2 - kHeaderWidth - textSize.width - kInset *2;
        normalImage = [UIImage imageNamed:@"chat_send_nor"];
        selectedImage = [UIImage imageNamed:@"chat_send_press_pic"];
    }else{
        bgX = kPadding*2 +kHeaderWidth;
        normalImage = [UIImage imageNamed:@"chat_recive_press_pic"];
        selectedImage = [UIImage imageNamed:@"chat_recive_press_pic"];
    }
    _bgButton.frame = CGRectMake(bgX-kInset, kPadding/10, textSize.width+kInset*4, textSize.height+kInset*2);
    [_bgButton setBackgroundImage:[Helper resizeWithImage:normalImage] forState:UIControlStateNormal];
    [_bgButton setBackgroundImage:[Helper resizeWithImage:selectedImage] forState:UIControlStateSelected];
    
    //文本，获取替换后的文本
    NSMutableAttributedString *attString = [Helper emotionAttrbutedStringWithText:_message.content faceFileName:@"face"];
    //文本的属性 font
    [attString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTextSize]} range:NSMakeRange(0, attString.length)];
    _contentLabel.attributedText = attString;
    _contentLabel.frame = CGRectMake(kInset*2, kInset, textSize.width, textSize.height);
    
}

@end








