//
//  ForgetPWController.m
//  muniao
//
//  Created by 赵中良 on 15/1/22.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "ForgetPWController.h"

@interface ForgetPWController ()

@end

@implementation ForgetPWController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)backToLogin:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
