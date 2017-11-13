//
//  ShowClockViewController.h
//  AlarmClockHomeWork
//
//  Created by huhu on 15/9/2.
//  Copyright (c) 2015年 GemInno. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClockDetailInfo;

@protocol AddClockInfoDelegate <NSObject>

- (void)giveMeAClock:(ClockDetailInfo *)clockInfo;

@end

@interface ShowClockViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, AddClockInfoDelegate>
@property (nonatomic, strong)CBPeripheral *thePerphernew1;

@property (nonatomic, strong)CBCharacteristic *theSakeCCnew1;

@property (nonatomic, strong)CBCharacteristic *theSakeFirst1;
@property (nonatomic, copy)NSString *langestr;
@end
