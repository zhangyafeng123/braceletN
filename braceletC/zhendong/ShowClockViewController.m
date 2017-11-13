//
//  ShowClockViewController.m
//  AlarmClockHomeWork
//
//  Created by huhu on 15/9/2.
//  Copyright (c) 2015年 GemInno. All rights reserved.
//

#import "ShowClockViewController.h"
#import "ClockDetailInfo.h"
#import "AddClockViewController.h"
#import "AppDelegate.h"
@interface ShowClockViewController ()

@property (nonatomic, assign) BOOL isUpdate;
@property (nonatomic, strong) NSMutableArray *clockInfo;
@property (strong,nonatomic) AppDelegate * appDelegate;

@end

@implementation ShowClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _appDelegate.lan = _langestr;
    
    [self readClockInfo];
  
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClockInfo:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    //添加表视图
    CGSize size = [UIScreen mainScreen].bounds.size;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tag = 10;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.allowsSelection = NO;
    
    //隐藏表视图下面的白色线条
    UIView *footerView = [[UIView alloc]init];
    [footerView setBackgroundColor:[UIColor clearColor]];
    tableView.tableFooterView = footerView;
    
    [self.view addSubview:tableView];
}

//添加功能
- (void)addClockInfo:(UIBarButtonItem *)sender {
    AddClockViewController *avc = [[AddClockViewController alloc]init];
    avc.delegate = self;
    avc.langestr1 = self.langestr;
    [self.navigationController pushViewController:avc animated:YES];
}

//程序启动时读取沙盒里面的文件内容
- (void)readClockInfo {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@/clock.arc", path];
    
    self.clockInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
   
    //[NSMutableArray arrayWithContentsOfFile:filePath];
    if (self.clockInfo == nil) {
        self.clockInfo = [NSMutableArray new];
    }
}

//
- (void)writeClockInfo {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@/clock.arc", path];
    //[self.clockInfo writeToFile:filePath atomically:YES];
    [NSKeyedArchiver archiveRootObject:self.clockInfo toFile:filePath];
    
}

- (void)giveMeAClock:(ClockDetailInfo *)clockInfo {
    [self.clockInfo addObject:clockInfo];
    
    [self writeClockInfo];
    
    UITableView *tableView = (UITableView *)[self.view viewWithTag:10];
    [tableView reloadData];
}

#pragma mark - 表视图数据源代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clockInfo.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.clockInfo removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        
        [self writeClockInfo];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, self.view.frame.size.width * 0.5, 24)];
        timeLabel.font = [UIFont systemFontOfSize:20];
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.tag = 10;
        [cell.contentView addSubview:timeLabel];
        
        UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 36, self.view.frame.size.width * 0.8, 20)];
        infoLabel.font = [UIFont systemFontOfSize:14];
        infoLabel.textColor = [UIColor blackColor];
        infoLabel.tag = 11;
        [cell.contentView addSubview:infoLabel];
        
        UISwitch *openClose = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60, 18, 30, 24)];
        openClose.on = NO;
        openClose.tag = 12;
        [openClose addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:openClose];
    }
    
    ClockDetailInfo *cdi = [self.clockInfo objectAtIndex:indexPath.row];
    
    UILabel *timeLable = (UILabel *)[cell viewWithTag:10];
    timeLable.text = cdi.time;
    
    UILabel *infoLabel = (UILabel *)[cell viewWithTag:11];
    infoLabel.text = [self showWeekDay:cdi.repeatType andTitle:cdi.title];;
    
    UISwitch *sw = (UISwitch *)[cell viewWithTag:12];
    sw.on = cdi.isUsable;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSString *)showWeekDay:(NSString *)weekInfo andTitle:(NSString *)title {
    NSMutableString *result = [NSMutableString stringWithFormat:@"%@", title];
    if (weekInfo == nil || weekInfo.length == 0) {
        return result;
    }
    NSString *strnew = CustomStr(@"endstr");
    NSString *endstr = [NSString stringWithFormat:@", %@",strnew];
    NSString *every = CustomStr(@"everyday");
    NSString *everyday = [NSString stringWithFormat:@", %@",every];
    NSString *str1 = CustomStr(@"ristr");
    NSString *str11 = [NSString stringWithFormat:@" %@",str1];
    NSString *str2 = CustomStr(@"firstday");
    NSString *str22 = [NSString stringWithFormat:@" %@",str2];
    NSString *str3 = CustomStr(@"secondday");
    NSString *str33  = [NSString stringWithFormat:@" %@",str3];
    NSString *str4 = CustomStr(@"thirdday");
    NSString *str44 = [NSString stringWithFormat:@" %@",str4];
    NSString *str5 = CustomStr(@"fourday");
    NSString *str55 = [NSString stringWithFormat:@" %@",str5];
    NSString *str6 = CustomStr(@"fiveday");
    NSString *str66 = [NSString stringWithFormat:@" %@",str6];
    NSString *str7 = CustomStr(@"sixday");
    NSString *str77 = [NSString stringWithFormat:@" %@",str7];
    NSString *work = CustomStr(@"gongzuostr");
    NSString *workday = [NSString stringWithFormat:@", %@",work];
    
    NSArray *week = [weekInfo componentsSeparatedByString:@"|"];
    
    if (week.count == 7) {
        [result appendString:everyday];
    } else if (week.count == 2 && [[week objectAtIndex:0]intValue] == 0 && [[week objectAtIndex:1]intValue] == 6) {
        [result appendString:endstr];
    } else if (week.count == 5 && !([[week objectAtIndex:0]intValue] == 0 || [[week objectAtIndex:4]intValue] == 6)) {
        [result appendString:workday];
    } else {
        [result appendString:@","];
        for (NSNumber *num in week) {
            switch ([num intValue]) {
                case 1:
                    [result appendString:str22];
                    break;
                case 2:
                    [result appendString:str33];
                    break;
                case 3:
                    [result appendString:str44];
                    break;
                case 4:
                    [result appendString:str55];
                    break;
                case 5:
                    [result appendString:str66];
                    break;
                case 6:
                    [result appendString:str77];
                    break;
                case 0:
                    [result appendString:str11];
                    break;
                default:
                    break;
            }
        }
    }
    
    return result;
}

//选择开关后保存文件
- (void)open:(UISwitch *)sender {
    UITableViewCell *cell = (UITableViewCell *)[[sender superview]superview];
    UITableView *tableView = (UITableView *)[self.view viewWithTag:10];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    
    ClockDetailInfo *di = [self.clockInfo objectAtIndex:indexPath.row];
    di.isUsable = sender.isOn;
    
    [self writeClockInfo];
}

@end
