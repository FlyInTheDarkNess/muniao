//
//  ViewController.m
//  muniao
//
//  Created by 赵中良 on 15/1/7.
//  Copyright (c) 2015年 com.iuiue. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"//接口文件
#import "Toast+UIView.h"
#import "ASIFormDataRequest.h"
#import "KVNProgress.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userMobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPassWordTextfield;
- (IBAction)loginButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPWButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加键盘变化时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [_userPassWordTextfield setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_userMobileTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [_userPassWordTextfield setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    
    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupBaseKVNProgressUI];
    
    if (MY_UID.length > 0) {
        [KVNProgress show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //跳转到主页
            [KVNProgress dismiss];
            [self performSegueWithIdentifier:@"muniao_Login" sender:self];
        });
    }
}

#pragma mark - UI

- (void)setupBaseKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor darkGrayColor];
    [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.9f alpha:0.9f];
    [KVNProgress appearance].backgroundTintColor = [UIColor whiteColor];
    [KVNProgress appearance].successColor = [UIColor darkGrayColor];
    [KVNProgress appearance].errorColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleSize = 75.0f;
    [KVNProgress appearance].lineWidth = 2.0f;
}

- (void)setupCustomKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor whiteColor];
    [KVNProgress appearance].statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.9f];
    [KVNProgress appearance].backgroundTintColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:1.0f];
    [KVNProgress appearance].successColor = [UIColor whiteColor];
    [KVNProgress appearance].errorColor = [UIColor whiteColor];
    [KVNProgress appearance].circleSize = 110.0f;
    [KVNProgress appearance].lineWidth = 1.0f;
}


/**********************************************************
 
 函数名称：- (IBAction)loginButton:(id)sender
 
 函数描述：登陆操作
 
 输入参数：N/A
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/

- (IBAction)loginButton:(id)sender {
    
    [_userMobileTextField resignFirstResponder];
    [_userPassWordTextfield resignFirstResponder];

    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:URL_NEW_LOGIN]];
    
    [request addPostValue:_userMobileTextField.text forKey:@"mobile"];
    [request addPostValue:_userPassWordTextfield.text forKey:@"password"];
    
    request.requestMethod = @"POST";
  
    [request setCompletionBlock:^{
        NSLog(@"%@",request.responseString);
        NSError *error;

        NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:&error];
        [KVNProgress dismiss];
        if (!error) {
            
            if([resultDict[@"status"]intValue] == 0){
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //跳转到主页
                    [self performSegueWithIdentifier:@"muniao_Login" sender:self];
                });
                [[UIApplication sharedApplication].keyWindow makeToast:@"登陆成功"];
                //房东uid存储
                [[NSUserDefaults standardUserDefaults] setValue:resultDict[@"uid"] forKey:UDKEY_UID];
                //房东zend存储
                [[NSUserDefaults standardUserDefaults] setValue:resultDict[@"zend"] forKey:UDKEY_ZEND];
                //房东手机号存储
                [[NSUserDefaults standardUserDefaults] setValue:resultDict[@"mobile"] forKey:UDKEY_MOBILE];
                //房东店铺名称存储
                [[NSUserDefaults standardUserDefaults] setValue:resultDict[@"username"] forKey:UDKEY_OWNERNAME];
                //房东聊天Urnd存储
                [[NSUserDefaults standardUserDefaults] setValue:resultDict[@"urnd"] forKey:UDKEY_URND];
                //房东聊天Uzend存储
                [[NSUserDefaults standardUserDefaults] setValue:resultDict[@"uzend"] forKey:UDKEY_UZEND];
    
            }else{
                NSString *srr = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
                [[UIApplication sharedApplication].keyWindow makeToast:srr];
            }
            
        }else{
            NSString *srr = [NSString stringWithFormat:@"%@",resultDict[@"message"]];
            [[UIApplication sharedApplication].keyWindow makeToast:srr];
        }
    }
     ];
    [request setFailedBlock:^{
        [KVNProgress showErrorWithStatus:@"Error"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });
        [[UIApplication sharedApplication].keyWindow makeToast:@"网络连接失败，请检查网络设置"];
    }];
    [request startAsynchronous];
    
    [KVNProgress show];
}

/**********************************************************
 
 函数名称：-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
 
 函数描述：点击空白处收起键盘
 
 输入参数：N/A
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_userMobileTextField resignFirstResponder];
    [_userPassWordTextfield resignFirstResponder];
}

/**********************************************************
 
 函数名称：- (void)keyboardWillChange:(NSNotification *)note
 
 函数描述：键盘发生改变执行
 
 输入参数：note 键盘通知传递的参数
 
 输出参数：N/A
 
 返回值：N/A
 
 **********************************************************/

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_userMobileTextField resignFirstResponder];
    [_userPassWordTextfield resignFirstResponder];
    return YES;
}


- (void)keyboardWillChange:(NSNotification *)note
{
    NSLog(@"%@", note.userInfo);
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - self.view.frame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
    }];
}

@end
