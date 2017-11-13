//
//  mainfirstViewController.h
//  braceletC
//
//  Created by 张亚峰 on 2017/4/5.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import "BaseViewController.h"

@interface mainfirstViewController : BaseViewController<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBPeripheral *thePerpher;
    CBCharacteristic *theSakeCC;
    CBCharacteristic *theSakeCCnew;
    CBCharacteristic *theSakeCCfirst;
}
@property (nonatomic, strong)CBCentralManager *bluetoothManager;

@end
