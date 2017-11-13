//
//  ClockDetailInfo.m
//  AlarmClockHomeWork
//
//  Created by huhu on 15/9/2.
//  Copyright (c) 2015年 GemInno. All rights reserved.
//

#import "ClockDetailInfo.h"

@implementation ClockDetailInfo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.repeatType forKey:@"repeat"];
    [aCoder encodeBool:self.isUsable forKey:@"usable"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.repeatType = [aDecoder decodeObjectForKey:@"repeat"];
        self.isUsable = [aDecoder decodeBoolForKey:@"usable"];
    }
    
    return self;
}
@end
