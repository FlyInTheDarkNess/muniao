//
//  BegForRentViewController.m
//  muniao
//
//  Created by 赵中良 on 15/1/15.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "BegForRentViewController.h"
#import "Constants.h"

@interface BegForRentViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation BegForRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"muniao_BegForRent_One";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    UIButton *_contentBtn = (UIButton *)[cell viewWithTag:6];
    [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _contentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _contentBtn.titleLabel.numberOfLines = 0;
    
    [_contentBtn setTitle:@"sdjfkalsjdflas" forState:UIControlStateNormal];
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    [_contentBtn setTitle:@"天使的翅膀教室里的开发将阿里上空间大发了卡接收到了罚天使的翅膀教室里的开发将阿里上空间大发了卡接收到了罚款" forState:UIControlStateNormal];
    UIImage *normal = [UIImage imageNamed:@"chatto_bg_normal"];
    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];

    
//    else{
//        //    UIImage* img=[UIImage imageNamed:@"2.png"];//原图
//        UIEdgeInsets edge=UIEdgeInsetsMake(0, 10, 0,10);
//        //UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
//        //UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图
//        normal= [normal resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
//    }

    
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];

    
//    [cell.contentView addSubview:_contentBtn];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
