//
//  timeroneViewController.h
//  braceletC
//
//  Created by mibo02 on 17/4/9.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "BaseViewController.h"

@interface timeroneViewController : BaseViewController

@property (nonatomic, copy)NSString *langestr;

@property (nonatomic, strong)CBPeripheral *thePerphernew1;

@property (nonatomic, strong)CBCharacteristic *theSakeCCnew1;

@property (nonatomic, strong)CBCharacteristic *theSakeFirst1;

@end
