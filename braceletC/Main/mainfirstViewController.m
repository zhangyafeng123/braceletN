//
//  mainfirstViewController.m
//  braceletC
//
//  Created by 张亚峰 on 2017/4/5.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "mainfirstViewController.h"
#import "firstCell.h"
#import "secondCell.h"
#import "zhendongViewController.h"
#import "yuyanViewController.h"
#import "AppDelegate.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "ClockDetailInfo.h"
//邮件相关和短信相关
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "NSObject+NSLocalNotification.h"
#import "thirdCell.h"
//4个字节Bytes 转 int
unsigned int  TCcbytesValueToInt(Byte *bytesValue) {
    unsigned int  intV;
    intV = (unsigned int ) ( ((bytesValue[3] & 0xff)<<24)
                            |((bytesValue[2] & 0xff)<<16)
                            |((bytesValue[1] & 0xff)<<8)
                            |(bytesValue[0] & 0xff));
    return intV;
}
#define ShowText(str) [self customLocalizableStr:(str)];
@interface mainfirstViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MFMessageComposeViewControllerDelegate>{
    CTCallCenter *center_;   //为了避免形成retain cycle而声明的一个变量，指向接收通话中心对象
}
@property(assign, nonatomic)CGFloat mCount;

@property (strong,nonatomic) AppDelegate * appDelegate;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
//电池电量
@property (nonatomic, copy)NSString *buttystr;

@property (nonatomic, assign)BOOL isopen;
@property (nonatomic, strong)NSTimer *newtimer;

@end

@implementation mainfirstViewController

//蓝牙代理方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:{
            
            NSString *str = CustomStr(@"showText");
            NSString *str1 = CustomStr(@"settingText");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str message:@"" delegate:self cancelButtonTitle:str1 otherButtonTitles: nil];
            alert.tag = 120;
            [alert show];
        }
            break;
        case CBCentralManagerStatePoweredOn:{
            
            [self showProgressHUD];
            //两个参数为nil,默认扫描所有的外设，可以设置一些服务，进行过滤搜索
            [self.bluetoothManager scanForPeripheralsWithServices:nil options:nil];
           
            
        }
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateUnsupported:
            [MBProgressHUD showSuccess:@"当前设备不支持蓝牙"];
            break;
        default:
            break;
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isfirst"]) {
        _appDelegate.lan = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfirst"];
    } else {
        _appDelegate.lan = @"ja";
    }
    [self.tableview reloadData];
    NSString *titlestr = CustomStr(@"titleText");
    self.title = titlestr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSLog(@"Country Code is %@", [currentLocale objectForKey:NSLocaleCountryCode]);
    _mCount = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    //是否打开震动设置
    self.isopen = YES;
    //禁用系统的弹窗
    NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey:@NO};
    _bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:options];
    
    self.navigationController.navigationBar.translucent = NO;
    [self.tableview registerNib:[UINib nibWithNibName:@"firstCell" bundle:nil] forCellReuseIdentifier:@"first"];
    [self.tableview registerNib:[UINib nibWithNibName:@"secondCell" bundle:nil] forCellReuseIdentifier:@"second"];
    [self.tableview registerNib:[UINib nibWithNibName:@"thirdCell" bundle:nil] forCellReuseIdentifier:@"third"];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isfirst"]) {
        _appDelegate.lan = [[NSUserDefaults standardUserDefaults] objectForKey:@"isfirst"];
    } else {
        _appDelegate.lan = @"ja";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tingzhizhendongaction) name:@"stopzhendong" object:nil];
}
- (void)tingzhizhendongaction
{
    [_newtimer invalidate];
    _newtimer = nil;
    return;
}

-(void)countTime{
    _mCount+=40;
    NSLog(@"%f",_mCount);
    [self readClockInfo];
   
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 60.) {//当剩余时间小于60时
       
        //申请后台
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"我要挂起了");
        }];
    }
}

//程序启动时读取沙盒里面的文件内容
- (void)readClockInfo {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [[NSString alloc] initWithFormat:@"%@/clock.arc", path];
    
    NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int hour = (int) [dateComponent hour];
    int minute = (int) [dateComponent minute];
    NSString *str = [self getTheTimeBucket];
    if (hour >= 12) {
       hour = hour - 12;
    }
    
    NSString *yearstr=[NSString stringWithFormat:@"%@%ld:%02ld",str,(long)hour,(long)minute];
    NSLog(@"shijian--%@",yearstr);
    for (ClockDetailInfo *info in arr) {
        
        NSLog(@"666%@-----%@",info.time,info.title);
        if ([yearstr isEqualToString:info.time]) {
            NSString *strnew = @"目覚まし時計が鳴りました";
            [AppDelegate registerLocalNotification:1 content:strnew key:@"fengfeng"];
            //进行震动(无限震动)
            _newtimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(zhidongtimer) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_newtimer forMode:NSRunLoopCommonModes];
        }
    }
    if (arr == nil) {
        arr = [NSMutableArray new];
    }
}
- (void)zhidongtimer
{
    if (thePerpher && theSakeCCfirst) {
        Byte zd[1] = {1};
        NSData *theData = [NSData dataWithBytes:zd length:1];
        [thePerpher writeValue:theData forCharacteristic:theSakeCCfirst type:CBCharacteristicWriteWithResponse];
    }
    
    if (thePerpher && theSakeCC) {
        //0不震动123震动
        Byte zd[1] = {1};
        NSData *theData = [NSData dataWithBytes:zd length:1];
        [thePerpher writeValue:theData forCharacteristic:theSakeCC type:CBCharacteristicWriteWithResponse];
        
    }
}
//将时间点转化成日历形式
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate * destinationDateNow = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    
    //设置当前的时间点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}
//获取时间段
-(NSString *)getTheTimeBucket
{
    NSDate * currentDate = [NSDate date];
    if ([currentDate compare:[self getCustomDateWithHour:0]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:12]] == NSOrderedAscending)
    {
        return @"上午";
    }
    else
    {
        return @"下午";
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
    if (thePerpher && theSakeCCfirst) {
        Byte zd[1] = {i};
        NSData *theData = [NSData dataWithBytes:zd length:1];
        [thePerpher writeValue:theData forCharacteristic:theSakeCCfirst type:CBCharacteristicWriteWithResponse];
    }
    
    if (thePerpher && theSakeCC) {
        //0不震动123震动
        Byte zd[1] = {i};
        NSData *theData = [NSData dataWithBytes:zd length:1];
        [thePerpher writeValue:theData forCharacteristic:theSakeCC type:CBCharacteristicWriteWithResponse];
        
    }
}


//这里默认扫到MI，主动连接，当然也可以手动触发连接
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"扫描连接外设：%@ %@",peripheral.name,RSSI);
    //保存外设，并停止扫描，达到节电效果
    if ([peripheral.name hasSuffix:@"Smartbb"]) {
        thePerpher = peripheral;
        [central stopScan];
        //进行连接
        [central connectPeripheral:peripheral options:nil];
        NSString *str1 = CustomStr(@"successstr");
        [MBProgressHUD showError:str1];
    } else {
        [self hideProgressHUD];
        NSString *newstr = CustomStr(@"nofind");
        [MBProgressHUD showError:newstr];
    }
    
}
//扫描外设中的服务和特征
//扫描到服务
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error)
    {
        NSLog(@"扫描外设服务出错：%@-> %@", peripheral.name, [error localizedDescription]);
        [self hideProgressHUD];
       
        return;
    }
    NSLog(@"扫描到外设服务：%@ -> %@",peripheral.name,peripheral.services);
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
//扫描到特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error)
    {
        NSLog(@"扫描外设的特征失败！%@->%@-> %@",peripheral.name,service.UUID, [error localizedDescription]);
        return;
    }
    
    NSLog(@"扫描到外设服务特征有：%@->%@->%@",peripheral.name,service.UUID,service.characteristics);
  
    //获取Characteristic的值
    for (CBCharacteristic *characteristic in service.characteristics){
        
        //这里外设需要订阅特征的通知，否则无法收到外设发送过来的数据
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        //震动
        if ([characteristic.UUID.UUIDString isEqualToString:@"2A06"]) {
            
            
            NSString *str = [NSString stringWithFormat:@"1111%@",service.UUID];
            
            
            if ([str isEqual:@"1803"]) {
                //断开设置震动次数
                theSakeCCnew = characteristic;
            } else if ([str isEqual:@"1802"]){
                
            }
            
        } else if ([characteristic.UUID.UUIDString isEqualToString:@"FFE4"]){
            
            NSString *str = [NSString stringWithFormat:@"%@",service.UUID];
            
            theSakeCCfirst = characteristic;
           
        } else if ([characteristic.UUID.UUIDString isEqualToString:@"FFE2"]){
            //震动测试
            theSakeCC = characteristic;
        }
        
    }
}


//扫描到具体的值->通讯主要的获取数据的方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error
{
    if (error) {
        NSLog(@"扫描外设的特征失败！%@-> %@",peripheral.name, [error localizedDescription]);
        [MBProgressHUD showError:@"error"];
        return;
    }
    NSLog(@"666%@ %@",characteristic.UUID.UUIDString,characteristic.value);
    
    
    //电池
    if ([characteristic.UUID.UUIDString isEqualToString:@"2A19"]) {
        Byte *bufferBytes = (Byte *)characteristic.value.bytes;
        int buterys = TCcbytesValueToInt(bufferBytes)&0xff;
        
        self.buttystr = [NSString stringWithFormat:@"%d%%\n",buterys];
    }
 
    [self.tableview reloadData];
    
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
       [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
       
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    NSLog(@"连接外设成功！%@",peripheral.name);
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
     NSLog(@"我现在的状态%ld",(long)thePerpher.state);
    [self hideProgressHUD];
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"连接到外设 失败！%@ %@",[peripheral name],[error localizedDescription]);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //
    if (alertView.tag == 120) {
        NSURL*right_url=[NSURL URLWithString:@"Prefs:root=Bluetooth"];
        Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
        
        [[LSApplicationWorkspace performSelector:@selector(defaultWorkspace)] performSelector:@selector(openSensitiveURL:withOptions:) withObject:right_url withObject:nil];
    } else if (alertView.tag == 130){
        
      
        NSFileManager *defauleManager = [NSFileManager defaultManager];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filePath = [[NSString alloc] initWithFormat:@"%@/clock.arc", path];
        
        [defauleManager removeItemAtPath:filePath error:nil];
        
        firstCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (!cell.switchbtn.on) {
            //重新搜索硬件设备
            [cell.switchbtn setOn:YES];
            [self.bluetoothManager scanForPeripheralsWithServices:nil options:nil];
        }
    }
   
}

-(CGFloat)getBatteryQuantity
{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return [[UIDevice currentDevice] batteryLevel];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            firstCell *cell = [tableView dequeueReusableCellWithIdentifier:@"first" forIndexPath:indexPath];
            NSString *str1 = CustomStr(@"lianjieText");
            cell.firstLab.text = str1;
            [cell.switchbtn addTarget:self action:@selector(swithcaction:) forControlEvents:(UIControlEventValueChanged)];
            
            return cell;
        }
            break;
            
        case 1:
        {
            secondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"second" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
             NSString *str1 = CustomStr(@"zhendongText");
            cell.leftlab.text = str1;
            cell.rightImg.image = [UIImage imageNamed:@"set_icon"];
            return cell;
        }
            break;
        case 2:
        {
            thirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"third" forIndexPath:indexPath];
            NSString *str1 = CustomStr(@"yuyanText");
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.thirdlab.text = str1;
            return cell;
        }
            break;
        case 3:
        {
            thirdCell   *cell = [tableView dequeueReusableCellWithIdentifier:@"third" forIndexPath:indexPath];
            NSString *str1 = CustomStr(@"dianchiText");
            cell.thirdlab.text = str1;
            cell.detaillab.text = self.buttystr;
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }
            break;
        case 4:
        {
            secondCell *cell = [tableView dequeueReusableCellWithIdentifier:@"second" forIndexPath:indexPath];
            NSString *str1 = CustomStr(@"huifuText");
            cell.leftlab.text = str1;
            cell.rightImg.image = [UIImage imageNamed:@"ccsz_icon"];
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str1 = CustomStr(@"settingsText");
    return str1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
        }
            break;
        case 1:
        {
            zhendongViewController *zhendong = [zhendongViewController new];
            zhendong.langestr = _appDelegate.lan;
            zhendong.theSakeCCnew = theSakeCC;
            zhendong.isopening = self.isopen;
            zhendong.thePerphernew = thePerpher;
            zhendong.theSakeFirst = theSakeCCfirst;
            [self.navigationController pushViewController:zhendong animated:YES];
        }
            break;
        case 2:
        {
            yuyanViewController *yuyan = [yuyanViewController new];
            [self.navigationController pushViewController:yuyan animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            NSString *str1 = CustomStr(@"oksettingText");
            NSString *str2 = CustomStr(@"okText");
            NSString *str3 = CustomStr(@"cancelText");
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:str1 message:@"" delegate:self cancelButtonTitle:str3 otherButtonTitles:str2, nil];
            alert.tag = 130;
            [alert show];
        }
            break;
            
        default:
            break;
    }
}
//switch点击事件
- (void)swithcaction:(UISwitch *)sender
{
    
    BOOL isbtnon = [sender isOn];
    if (isbtnon) {
        
       [self.bluetoothManager scanForPeripheralsWithServices:nil options:nil];
        
    } else {
        if(thePerpher){
            
        [self zhengodongmethod];
            
        [self.bluetoothManager cancelPeripheralConnection:thePerpher];
        thePerpher = nil;
        theSakeCCfirst = nil;
        theSakeCC = nil;
        theSakeCCnew = nil;
        
        self.buttystr = @"";
        [self.tableview reloadData];
        }
    }
    self.isopen = isbtnon;
}

@end
