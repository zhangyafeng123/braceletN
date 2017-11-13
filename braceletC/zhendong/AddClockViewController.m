//
//  AddClockViewController.m
//  AlarmClockHomeWork
//
//  Created by huhu on 15/9/2.
//  Copyright (c) 2015年 GemInno. All rights reserved.
//

#import "AddClockViewController.h"
#import "SetRepeatViewController.h"
#import "SetTitleViewController.h"
#import "ClockDetailInfo.h"
#import "AppDelegate.h"
@interface AddClockViewController ()
@property (strong,nonatomic) AppDelegate * appDelegate;
@property (nonatomic, retain) ClockDetailInfo *ClockInfoItem;

@end

@implementation AddClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",self.langestr1);
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _appDelegate.lan = _langestr1;
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    NSString *str1 = CustomStr(@"savestr");
    NSString *str2 = CustomStr(@"cancelText");
    //导航栏上添加按钮
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithTitle:str2 style:UIBarButtonItemStylePlain target:self action:@selector(popClockInfo:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:str1 style:UIBarButtonItemStylePlain target:self action:@selector(saveClockInfo:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    //添加时间选择器
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIDatePicker *dp = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 76, size.width, 162)];
    dp.backgroundColor = [UIColor whiteColor];
   // ja日语 zh-Hans中文 en 英文
    if ([self.langestr1 isEqualToString:@"ja"]) {
        dp.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"CN"];
    } else if ([self.langestr1 isEqualToString:@"zh-Hans"]){
        dp.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    } else {
        dp.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
    }
    dp.datePickerMode = UIDatePickerModeTime;
    dp.tag = 10;
    [self.view addSubview:dp];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300, size.width, 44) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.bounces = NO;
    
    [self.view addSubview:tableView];
    
    NSString *str=CustomStr(@"naozhong");
    self.ClockInfoItem = [[ClockDetailInfo alloc]init];
    self.ClockInfoItem.title = str;
}

#pragma mark - 按钮功能
- (void)popClockInfo:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveClockInfo:(UIBarButtonItem *)sender {
    UIDatePicker *dp = (UIDatePicker *)[self.view viewWithTag:10];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.dateStyle = NSDateIntervalFormatterNoStyle;
    df.timeStyle = NSDateFormatterShortStyle;
    
    self.ClockInfoItem.time = [df stringFromDate:dp.date];
    
    [self.delegate giveMeAClock:self.ClockInfoItem];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 表视图数据源代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    NSString *str11 = CustomStr(@"morestr");
    if (indexPath.row == 0) {
        cell.textLabel.text =str11;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
  
        SetRepeatViewController *svc = [[SetRepeatViewController alloc]init];
        svc.delegate = self;
        svc.langestr2 = self.langestr1;
        [self.navigationController pushViewController:svc animated:YES];
    
}

#pragma mark - ModifyClockRepeatType 方法
- (void)updateClockRepeatType:(NSString *)clockRepeatType {
   
    self.ClockInfoItem.repeatType = clockRepeatType;
    if (clockRepeatType.length != 0) {
        self.ClockInfoItem.isUsable = YES;
    }
}

@end
