//
//  SetRepeatViewController.h
//  AlarmClockHomeWork
//
//  Created by huhu on 15/9/2.
//  Copyright (c) 2015年 GemInno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddClockViewController.h"

@interface SetRepeatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, weak) id<ModifyClockRepeatType> delegate;
@property (nonatomic, copy)NSString *langestr2;
@end
