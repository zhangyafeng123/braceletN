//
//  otherViewController.m
//  braceletC
//
//  Created by mibo02 on 17/4/9.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "otherViewController.h"
#import "AppDelegate.h"
#import "numberView.h"
#import "yuyanCell.h"
@interface otherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)numberView *numberV;
@property (strong,nonatomic) AppDelegate * appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, copy)NSString *onetime;
@property (nonatomic, copy)NSString *twotime;
@property (nonatomic, copy)NSString *threetime;

@end

@implementation otherViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _appDelegate.lan = _langestr;
    [self.tableview registerNib:[UINib nibWithNibName:@"yuyanCell" bundle:nil] forCellReuseIdentifier:@"yuyancell"];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    yuyanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yuyancell" forIndexPath:indexPath];
    NSString *str2 = CustomStr(@"numerText");
    cell.leftlab.text = str2;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"titlestr"]) {
        
        [cell.yuyanbtn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"titlestr"] forState:(UIControlStateNormal)];
       
    } else {
        //如果是第一次进来默认设置为1
        NSString *newstr = CustomStr(@"fourtime");
         [cell.yuyanbtn setTitle:newstr forState:(UIControlStateNormal)];
    }
    
    [cell.yuyanbtn addTarget:self action:@selector(action:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (void)action:(UIButton *)sender
{
    //先进行删除
    [self.numberV removeFromSuperview];
    
    self.numberV = [[[NSBundle mainBundle] loadNibNamed:@"numberView" owner:nil options:nil] firstObject];
    self.numberV.layer.cornerRadius = 5;
    self.numberV.layer.masksToBounds = YES;
    self.numberV.frame = CGRectMake(self.view.frame.size.width - 120 - 10, 70, 120, 220);
    NSString *str1 = CustomStr(@"onetime");
    NSString *str2 = CustomStr(@"twotime");
    NSString *str3 = CustomStr(@"threetime");
    NSString *str4 = CustomStr(@"fourtime");
    NSString *str5 = CustomStr(@"fivetime");
    NSString *str6 = CustomStr(@"sixtime");
    [self.numberV.firstbtn setTitle:str1 forState:(UIControlStateNormal)];
    [self.numberV.secondbtn setTitle:str2 forState:(UIControlStateNormal)];
    [self.numberV.threebtn setTitle:str3 forState:(UIControlStateNormal)];
    [self.numberV.fourbtn setTitle:str4 forState:(UIControlStateNormal)];
    [self.numberV.fivebtn setTitle:str5 forState:(UIControlStateNormal)];
    [self.numberV.sixbtn setTitle:str6 forState:(UIControlStateNormal)];
    
    [self.numberV.firstbtn addTarget:self action:@selector(buttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.numberV.secondbtn addTarget:self action:@selector(buttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.numberV.threebtn addTarget:self action:@selector(buttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.numberV.fourbtn addTarget:self action:@selector(buttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.numberV.fivebtn addTarget:self action:@selector(buttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.numberV.sixbtn addTarget:self action:@selector(buttonaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.numberV];
}
- (void)buttonaction:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
    //保存次数
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"number"];
    [[NSUserDefaults standardUserDefaults] setValue:@(sender.tag - 100) forKey:@"number"];
    //保存标题
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"titlestr"];
    [[NSUserDefaults standardUserDefaults] setValue:sender.titleLabel.text forKey:@"titlestr"];
    NSInteger i = sender.tag - 100;
    Byte zd[1] = {i};
    NSData *theData = [NSData dataWithBytes:zd length:1];
    [self.thePerphernum writeValue:theData forCharacteristic:self.theSakeCCnum type:CBCharacteristicWriteWithResponse];
    
    [self.tableview reloadData];
    [self.numberV removeFromSuperview];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str2 = CustomStr(@"othersetText");
    return str2;
}
@end
