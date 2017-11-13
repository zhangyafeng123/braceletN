//
//  otherViewController.h
//  braceletC
//
//  Created by mibo02 on 17/4/9.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "BaseViewController.h"

@interface otherViewController : BaseViewController
@property (nonatomic, copy)NSString *langestr;

//设置震动次数
@property (nonatomic, strong)CBPeripheral *thePerphernum;

@property (nonatomic, strong)CBCharacteristic *theSakeCCnum;

@end
