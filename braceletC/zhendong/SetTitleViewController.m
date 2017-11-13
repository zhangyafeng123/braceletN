//
//  SetTitleViewController.m
//  AlarmClockHomeWork
//
//  Created by huhu on 15/9/2.
//  Copyright (c) 2015年 GemInno. All rights reserved.
//

#import "SetTitleViewController.h"
#import "AppDelegate.h"
@interface SetTitleViewController ()
@property (strong,nonatomic) AppDelegate * appDelegate;
@end

@implementation SetTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _appDelegate.lan = _langestr2;
    self.title = CustomStr(@"biaoqian");
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 200, size.width, 40)];
    tf.backgroundColor = [UIColor whiteColor];
    tf.text = CustomStr(@"naozhong");
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.tag = 10;
    [self.view addSubview:tf];
}

- (void)dealloc {
    UITextField *tf = (UITextField *)[self.view viewWithTag:10];
    NSString *title = tf.text;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"NewTitle" object:title];
}

@end
