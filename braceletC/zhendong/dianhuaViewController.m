//
//  dianhuaViewController.m
//  braceletC
//
//  Created by 张亚峰 on 2017/4/6.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "dianhuaViewController.h"
#import "firstCell.h"
#import "AppDelegate.h"
@interface dianhuaViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) AppDelegate * appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, copy)NSString *isopenstr;
@end

@implementation dianhuaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.isopenstr = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneisopen"];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _appDelegate.lan = _langestr;
    [self.tableview registerNib:[UINib nibWithNibName:@"firstCell" bundle:nil] forCellReuseIdentifier:@"first"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    firstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"first" forIndexPath:indexPath];
    NSString *str2 = CustomStr(@"phonecomeText");
    cell.firstLab.text = str2;
    
    if ([self.isopenstr isEqualToString:@"0"]) {
        [cell.switchbtn setOn:NO];
    } else {
        [cell.switchbtn setOn:YES];
    }
    
    [cell.switchbtn addTarget:self action:@selector(swithcaction:) forControlEvents:(UIControlEventValueChanged)];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
     NSString *str2 = CustomStr(@"comcomText");
    return str2;
}
//switch点击事件
- (void)swithcaction:(UISwitch *)sender
{
    BOOL isbtnon = [sender isOn];
    
    if (!isbtnon) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phoneisopen"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"phoneisopen"];
        
        if (self.thePerphernew2 && self.theSakeFirst2) {
            //更改震动次数
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"number"];
            [[NSUserDefaults standardUserDefaults] setValue:@(5) forKey:@"number"];
            Byte zd[1] = {5};
            NSData *theData = [NSData dataWithBytes:zd length:1];
            [self.thePerphernew2 writeValue:theData forCharacteristic:self.theSakeFirst2 type:CBCharacteristicWriteWithResponse];
        }
    }
}
@end
