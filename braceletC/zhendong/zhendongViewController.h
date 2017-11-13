//
//  zhendongViewController.h
//  braceletC
//
//  Created by 张亚峰 on 2017/4/5.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "BaseViewController.h"

@interface zhendongViewController : BaseViewController

@property (nonatomic, copy)NSString *langestr;
//
@property (nonatomic, strong)CBPeripheral *thePerphernew;
//防丢功能
@property (nonatomic, strong)CBCharacteristic *theSakeCCnew;
//震动是否打开
@property (nonatomic, assign)BOOL isopening;
//震动测试
@property (nonatomic, strong)CBCharacteristic *theSakeFirst;

@end
