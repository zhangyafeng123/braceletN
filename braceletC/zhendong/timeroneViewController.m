//
//  timeroneViewController.m
//  braceletC
//
//  Created by mibo02 on 17/4/9.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "timeroneViewController.h"
#import "ShowClockViewController.h"
#import "AppDelegate.h"
#import "NSObject+NSLocalNotification.h"
@interface timeroneViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,MZTimerLabelDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cancelbtn;
@property(assign, nonatomic)CGFloat mCount;
@property (nonatomic, strong)MZTimerLabel *timerLab;
@property (weak, nonatomic) IBOutlet UILabel *leftlab;
@property (weak, nonatomic) IBOutlet UIPickerView *pickView;
@property (nonatomic, strong)NSMutableArray *leftArr;
@property (nonatomic, strong)NSMutableArray *centerArr;
@property (weak, nonatomic) IBOutlet UILabel *timelab;

@property (weak, nonatomic) IBOutlet UIButton *jishibtn;
@property (strong,nonatomic) AppDelegate * appDelegate;

@property (nonatomic, copy)NSString *onestr;
@property (nonatomic, copy)NSString *twostr;

@property (nonatomic, copy)NSString *stopstring;
@property (nonatomic, copy)NSString *jishistring;
@property (nonatomic, copy)NSString *goonstring;
@property (nonatomic, strong)NSTimer *newtimer;

@end

@implementation timeroneViewController


- (NSMutableArray *)leftArr
{
    if (!_leftArr) {
        
        self.leftArr = [NSMutableArray new];
        
    }
    return _leftArr;
}
- (NSMutableArray *)centerArr
{
    if (!_centerArr) {
        self.centerArr = [NSMutableArray new];
        
    }
    return _centerArr;
}
- (IBAction)cancelBtnaction:(UIButton *)sender {
    
    [_timerLab reset];
    [self.jishibtn setTitle:self.jishistring forState:(UIControlStateNormal)];
    self.pickView.hidden = NO;
    self.timelab.hidden = YES;
}

- (IBAction)timerbtnaction:(UIButton *)sender
{
    self.timelab.hidden = NO;
    self.pickView.hidden = YES;
    if ([sender.titleLabel.text isEqualToString:self.jishistring]) {
       
        [_timerLab start];
        [sender setTitle:self.stopstring forState:(UIControlStateNormal)];
    } else if([sender.titleLabel.text isEqualToString:self.stopstring]){
        [_timerLab pause];
       
        [sender setTitle:self.goonstring forState:(UIControlStateNormal)];
    } else if ([sender.titleLabel.text isEqualToString:self.goonstring]){
        [_timerLab start];
        [sender setTitle:self.stopstring forState:(UIControlStateNormal)];
    }

}


//进行震动
- (void)zhengodongmethod
{
    if (self.thePerphernew1 && self.theSakeFirst1) {
        Byte zd[1] = {1};
        NSData *theData = [NSData dataWithBytes:zd length:1];
        [self.thePerphernew1 writeValue:theData forCharacteristic:self.theSakeFirst1 type:CBCharacteristicWriteWithResponse];
    }
    
    if (self.thePerphernew1 && self.theSakeCCnew1) {
        //
        Byte zd[1] = {1};
        NSData *theData = [NSData dataWithBytes:zd length:1];
        [self.thePerphernew1 writeValue:theData forCharacteristic:self.theSakeCCnew1 type:CBCharacteristicWriteWithResponse];
    }
}
-(void)countTime{
    _mCount+=1;
    NSLog(@"%f",_mCount);
    //结束之后进行震动
    __block typeof(self) bself = self;
    self.timerLab.endedBlock=^(NSTimeInterval nstime){
        NSString *strnew = CustomStr(@"timeison");
        [AppDelegate registerLocalNotification:1 content:strnew key:@"fengfeng"];
        //震动
        [bself.timerLab reset];
        [bself.jishibtn setTitle:bself.jishistring forState:(UIControlStateNormal)];
        bself.pickView.hidden = NO;
        bself.timelab.hidden = YES;
        
        [bself timers];
    };
    
    if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 60.) {//当剩余时间小于60时，开如播放音乐，并用这个假前台状态再次申请后台
        NSLog(@"播放%@",[NSThread currentThread]);
        //申请后台
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            NSLog(@"我要挂起了");
        }];
    }
}
- (void)timers
{
    self.newtimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(zhidongtimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.newtimer forMode:NSRunLoopCommonModes];
}
- (void)zhidongtimer
{
    [self zhengodongmethod];
}
//停止震动
- (void)actionforzhendong
{
    [_newtimer invalidate];
    _newtimer = nil;
    return;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionforzhendong) name:@"stopzhendong" object:nil];
    _mCount = 0;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    for (int i = 0; i < 13; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [self.leftArr addObject:str];
    }
    for (int i = 0; i < 61; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        [self.centerArr addObject:str];
    }
    self.timelab.hidden = YES;
    self.pickView.hidden = NO;
    
   
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _appDelegate.lan = _langestr;
    
    NSString *str1 = CustomStr(@"beginText");
    NSString *str2 = CustomStr(@"timerText");
    NSString *cancel = CustomStr(@"stopText");
    NSString *zanting = CustomStr(@"begintime");
    self.stopstring = cancel;
    self.jishistring = str1;
    self.goonstring = zanting;
    
    self.leftlab.text =  str2;
    [self.cancelbtn setTitle:cancel forState:(UIControlStateNormal)];
    [self.jishibtn setTitle:str1 forState:(UIControlStateNormal)];
    
    _timerLab = [[MZTimerLabel alloc] initWithLabel:self.timelab andTimerType:(MZTimerLabelTypeTimer)];
    _timerLab.delegate = self;
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.leftArr.count;
    } else {
        return self.centerArr.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *hourstr = CustomStr(@"hourText");
    NSString *minutestr = CustomStr(@"minuteText");
    NSString *str;
    if (component == 0) {
        
        str = [NSString stringWithFormat:@"%@%@",self.leftArr[row],hourstr];
        self.onestr = self.leftArr[row];
      
    } else {
        
        str = [NSString stringWithFormat:@"%@%@",self.centerArr[row],minutestr];
        self.twostr = self.centerArr[row];
        
    }
   
    NSInteger i = self.onestr.integerValue * 3600 + self.twostr.integerValue * 60;
    
    
    [_timerLab setCountDownTime:i];
    return str;
}




@end
