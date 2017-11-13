//
//  SetRepeatViewController.m
//  AlarmClockHomeWork
//
//  Created by huhu on 15/9/2.
//  Copyright (c) 2015年 GemInno. All rights reserved.
//

#import "SetRepeatViewController.h"
#import "AppDelegate.h"
@interface SetRepeatViewController ()
@property (strong,nonatomic) AppDelegate * appDelegate;
@property (nonatomic, retain) NSMutableArray *selectArray;

@end

@implementation SetRepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _appDelegate.lan = _langestr2;
    NSString *str1 = CustomStr(@"morestr");
    self.title = str1;
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //添加表视图
    CGSize size = [UIScreen mainScreen].bounds.size;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsMultipleSelection = YES;
    tableView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *footerView = [[UIView alloc]init];
    [footerView setBackgroundColor:[UIColor clearColor]];
    tableView.tableFooterView = footerView;
    
    [self.view addSubview:tableView];
    
    self.selectArray = [NSMutableArray new];
}



- (void)dealloc {
    NSArray *array = [self.selectArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    [self.delegate updateClockRepeatType:[array componentsJoinedByString:@"|"]];
}

#pragma mark - 表视图数据源代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddCell"];
//        CGSize size = cell.bounds.size;
//        UIView *sView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height - 2)];
//        sView.backgroundColor = [UIColor whiteColor];
//        cell.selectedBackgroundView = sView;
    }
    NSString *str1 = CustomStr(@"ristr");
    NSString *str2 = CustomStr(@"firstday");
    NSString *str3 = CustomStr(@"secondday");
    NSString *str4 = CustomStr(@"thirdday");
    NSString *str5 = CustomStr(@"fourday");
    NSString *str6 = CustomStr(@"fiveday");
    NSString *str7 = CustomStr(@"sixday");
    
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = str1;
            break;
        case 1:
            cell.textLabel.text = str2;
            break;
        case 2:
            cell.textLabel.text = str3;
            break;
        case 3:
            cell.textLabel.text = str4;
            break;
        case 4:
            cell.textLabel.text = str5;
            break;
        case 5:
            cell.textLabel.text = str6;
            break;
        case 6:
            cell.textLabel.text = str7;
            break;
        default:
            break;
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectArray removeObject:[NSNumber numberWithInteger:indexPath.row]];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectArray addObject:[NSNumber numberWithInteger:indexPath.row]];
    }
}

@end
