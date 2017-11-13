//
//  zhendongViewController.m
//  braceletC
//
//  Created by 张亚峰 on 2017/4/5.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "zhendongViewController.h"
#import "firstCell.h"
#import "dianhuaViewController.h"
#import "timeroneViewController.h"
#import "otherViewController.h"
#import "AppDelegate.h"
#import "FangdiuViewController.h"
#import "ShowClockViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "ClockDetailInfo.h"
#import "thirdCell.h"

#define SOUNDID  1012
@interface zhendongViewController ()<UITableViewDelegate,UITableViewDataSource>{
    CTCallCenter *center_;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) AppDelegate * appDelegate;
@property (nonatomic, copy)NSString *firstopen;
@property (nonatomic, copy)NSString *secondopen;
@property (nonatomic, copy)NSString *thirdopen;
@end

@implementation zhendongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _appDelegate.lan = _langestr;
    [self.tableview registerNib:[UINib nibWithNibName:@"firstCell" bundle:nil] forCellReuseIdentifier:@"first"];
    [self.tableview registerNib:[UINib nibWithNibName:@"thirdCell" bundle:nil] forCellReuseIdentifier:@"third"];
    self.firstopen = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstopen"];
    self.secondopen = [[NSUserDefaults standardUserDefaults] objectForKey:@"secondopen"];
    self.thirdopen = [[NSUserDefaults standardUserDefaults] objectForKey:@"thirdopen"];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) {
        thirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"third" forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *str2 = CustomStr(@"zhendongceshiText");
        cell.thirdlab.text = str2;
        return cell;
    } else if (indexPath.row == 4){
        thirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"third" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        NSString *str2 = CustomStr(@"jishiText");
        cell.thirdlab.text = str2;
        return cell;
    } else if (indexPath.row == 3){
        thirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"third" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *str2 = CustomStr(@"naozhong");
        cell.thirdlab.text = str2;
        return cell;
    }else {
        firstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"first" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            NSString *str2 = CustomStr(@"dianhualaidianText");
            cell.firstLab.text = str2;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            //此时是关闭的
            if ([self.firstopen isEqualToString:@"0"]) {
                [cell.switchbtn setOn:NO];
            }  else {
                [cell.switchbtn setOn:YES];
            }
            
        } else if (indexPath.row == 1){
            NSString *str2 = CustomStr(@"fangdiuText");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.firstLab.text = str2;
            cell.rightstraint.constant  = 48;
            if ([self.secondopen isEqualToString:@"0"]) {
                [cell.switchbtn setOn:NO];
            }  else {
                [cell.switchbtn setOn:YES];
            }
        } else {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            NSString *str2 = CustomStr(@"qitaText");
            cell.firstLab.text = str2;
            
            if ([self.thirdopen isEqualToString:@"0"]) {
                [cell.switchbtn setOn:NO];
            }  else {
                [cell.switchbtn setOn:YES];
            }
        }
        cell.switchbtn.tag = 150 + indexPath.row;
        [cell.switchbtn addTarget:self action:@selector(swithcaction:) forControlEvents:(UIControlEventValueChanged)];
        
        return cell;
    }
}
//switch点击事件
- (void)swithcaction:(UISwitch *)sender
{
    if (sender.tag == 150) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstopen"];
        if (sender.on == NO) {
           [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"firstopen"];
        }
    } else if (sender.tag == 151){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"secondopen"];
        if (sender.on == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"secondopen"];
        }
        
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"thirdopen"];
        if (sender.on == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"thirdopen"];
        }
    }
    
    BOOL isbtnon = [sender isOn];
    NSInteger i;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"number"]) {
        i = [[[NSUserDefaults standardUserDefaults] objectForKey:@"number"] integerValue];
    } else {
        i = 4;
    }
    if (isbtnon) {
        //(设置震动3次)
        Byte zd[1] = {i};
        NSData *theData = [NSData dataWithBytes:zd length:1];
        [self.thePerphernew writeValue:theData forCharacteristic:self.theSakeCCnew type:CBCharacteristicWriteWithResponse];
    } else {
        
        return;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str2 = CustomStr(@"zhendongText");
    return str2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        dianhuaViewController *dianhua = [dianhuaViewController new];
        dianhua.langestr = _appDelegate.lan;
        dianhua.theSakeFirst2 = self.theSakeFirst;
        dianhua.thePerphernew2 = self.thePerphernew;
        [self.navigationController pushViewController:dianhua animated:YES];
    } else if (indexPath.row == 1){

        
    } else if(indexPath.row == 2){
       
            otherViewController *other = [otherViewController new];
            if (_theSakeFirst) {
                other.theSakeCCnum = self.theSakeFirst;
                other.thePerphernum = self.thePerphernew;
             }
            other.langestr = _appDelegate.lan;
            [self.navigationController pushViewController:other animated:YES];
       
        
    } else if (indexPath.row == 4){
        
            timeroneViewController *timerone = [timeroneViewController new];
            timerone.langestr = _appDelegate.lan;
            if (self.theSakeCCnew) {
                timerone.theSakeCCnew1 = self.theSakeCCnew;
                timerone.thePerphernew1 = self.thePerphernew;
            }
            [self.navigationController pushViewController:timerone animated:YES];
        
        
    } else if(indexPath.row == 5){
        //震动1次
        [self zhengodongmethod];
        
    } else if (indexPath.row == 3){
        ShowClockViewController *show = [ShowClockViewController new];
        show.langestr = _appDelegate.lan;
        show.thePerphernew1 = self.thePerphernew;
        show.theSakeCCnew1 = self.theSakeCCnew;
        show.theSakeFirst1 = self.theSakeFirst;
        [self.navigationController pushViewController:show animated:YES];
    }
}
//进行震动
- (void)zhengodongmethod
{
    NSInteger i;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"number"]) {
        i = [[[NSUserDefaults standardUserDefaults] objectForKey:@"number"] integerValue];
    } else {
        i = 4;
    }
    if (self.thePerphernew && self.theSakeFirst) {
        Byte zd[1] = {1};
        NSData *theData = [NSData dataWithBytes:zd length:1];
        [self.thePerphernew writeValue:theData forCharacteristic:self.theSakeFirst type:CBCharacteristicWriteWithResponse];
    }
    
    if (self.thePerphernew && self.theSakeCCnew) {
        //0不震动123震动
        Byte zd[1] = {i};
        NSData *theData = [NSData dataWithBytes:zd length:1];
        [self.thePerphernew writeValue:theData forCharacteristic:self.theSakeCCnew type:CBCharacteristicWriteWithResponse];
        
    }
}

@end
