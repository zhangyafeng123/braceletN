//
//  yuyanViewController.m
//  braceletC
//
//  Created by 张亚峰 on 2017/4/6.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "yuyanViewController.h"
#import "langeView.h"
#import "AppDelegate.h"
#import "yuyanCell.h"
@interface yuyanViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) AppDelegate * appDelegate;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong)langeView *langeV;
@property (nonatomic, copy)NSString *selectedlangue;
@property (nonatomic, copy)NSString *buttonlangue;
@end

@implementation yuyanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableview registerNib:[UINib nibWithNibName:@"yuyanCell" bundle:nil] forCellReuseIdentifier:@"yuyancell"];
    //ja日语 zh-Hans中文 en 英文
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isfirst"]) {
        _selectedlangue = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfirst"];
        _buttonlangue = [[NSUserDefaults standardUserDefaults] objectForKey:@"buttons"];
    } else {
        _selectedlangue = @"ja";
        _buttonlangue =@"日本語";
    }
    
    NSLog(@"%@--%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"isfirst"],[[NSUserDefaults standardUserDefaults] objectForKey:@"buttons"]);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    yuyanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yuyancell" forIndexPath:indexPath];
    _appDelegate.lan = _selectedlangue;
    cell.leftlab.text = CustomStr(@"showlanage");
    [cell.yuyanbtn setTitle:_buttonlangue forState:(UIControlStateNormal)];
    [cell.yuyanbtn addTarget:self action:@selector(settingbtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}

- (void)settingbtnaction:(UIButton *)sender
{
    _langeV = [[[NSBundle mainBundle] loadNibNamed:@"langeView" owner:nil options:nil] firstObject];
    _langeV.frame = CGRectMake(self.view.frame.size.width - 120 - 10, 40, 120, 105);
    _langeV.firstBtn.tag = 180;
    _langeV.secondbtn.tag = 181;
    _langeV.englishbtn.tag = 182;
    _langeV.layer.cornerRadius = 5;
    _langeV.layer.masksToBounds = YES;
    [_langeV.firstBtn addTarget:self action:@selector(firstBtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_langeV.secondbtn addTarget:self action:@selector(firstBtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_langeV.englishbtn addTarget:self action:@selector(firstBtnaction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_langeV];
}
- (void)firstBtnaction:(UIButton *)sender
{
    yuyanCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [_langeV removeFromSuperview];
    if (sender.tag == 180) {
       
        [cell.yuyanbtn setTitle:@"日本語" forState:(UIControlStateNormal)];
        _buttonlangue = @"日本語";
        _selectedlangue = @"ja";
    } else if (sender.tag == 181){
         [cell.yuyanbtn setTitle:@"中文" forState:(UIControlStateNormal)];
        _buttonlangue = @"中文";
        _selectedlangue = @"zh-Hans";
    } else {
         [cell.yuyanbtn setTitle:@"English" forState:(UIControlStateNormal)];
        _buttonlangue = @"English";
        _selectedlangue  = @"en";
    }
    _appDelegate.lan = _selectedlangue;
    cell.leftlab.text = CustomStr(@"showlanage");
    //将想要设置的语言保存到本地
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isfirst"];
    [[NSUserDefaults standardUserDefaults] setValue:_selectedlangue forKey:@"isfirst"];
    //改变按钮的语言
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"buttons"];
    [[NSUserDefaults standardUserDefaults] setValue:_buttonlangue forKey:@"buttons"];

    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



@end
