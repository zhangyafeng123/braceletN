//
//  AddClockViewController.h
//  AlarmClockHomeWork
//
//  Created by huhu on 15/9/2.
//  Copyright (c) 2015年 GemInno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowClockViewController.h"

@protocol ModifyClockRepeatType <NSObject>

- (void)updateClockRepeatType:(NSString *)clockRepeatType;

@end

@interface AddClockViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, ModifyClockRepeatType>

@property (nonatomic, weak) id<AddClockInfoDelegate> delegate;
@property (nonatomic, copy)NSString *langestr1;
@end
