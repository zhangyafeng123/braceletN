//
//  ClockDetailInfo.h
//  AlarmClockHomeWork
//
//  Created by huhu on 15/9/2.
//  Copyright (c) 2015年 GemInno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClockDetailInfo : NSObject<NSCoding>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *repeatType;
@property (nonatomic, assign) BOOL isUsable;
@end
