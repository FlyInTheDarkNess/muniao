//
//  MessageCellone.m
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-19.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MessageCellone.h"
#import "CellFrameModel.h"
#import "MessageModel.h"
#import "UIImage+ResizeImage.h"
#import "UIImageView+WebCache.h"//引入加载图片的头文件

@interface MessageCellone()
{
    UILabel *_timeLabel;
    UIImageView *_iconView;
    UIButton *_textView;
}
@end

@implementation MessageCellone

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_timeLabel];
        
        _iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconView];
        
        _textView = [UIButton buttonWithType:UIButtonTypeCustom];
        _textView.titleLabel.numberOfLines = 0;
        _textView.titleLabel.font = [UIFont systemFontOfSize:13];
        _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
        [self.contentView addSubview:_textView];
    }
    return self;
}

- (void)setCellFrame:(CellFrameModel *)cellFrame
{
    _cellFrame = cellFrame;
    MessageModel *message = cellFrame.message;
    
    _timeLabel.frame = cellFrame.timeFrame;
    _timeLabel.text = message.time;
    
    _iconView.frame = cellFrame.iconFrame;
    NSString *iconStr = message.type ? message.FriendImageUrl : message.UserImageUrl;
    [_iconView setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"ChatBack"]];
    
    _textView.frame = cellFrame.textFrame;
    NSString *textBg = message.type ? @"chat_recive_nor" : @"chat_send_nor";
    UIColor *textColor = message.type ? [UIColor blackColor] : [UIColor whiteColor];
    [_textView setTitleColor:textColor forState:UIControlStateNormal];
    [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
    [_textView setTitle:message.text forState:UIControlStateNormal];
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action ==@selector(copy:)){
        
        return YES;
    }
    return [super canPerformAction:action withSender:sender];
}

-(void)copy:(id)sender
{
    [[UIPasteboard generalPasteboard]setString:_textView.titleLabel.text];
}

@end
