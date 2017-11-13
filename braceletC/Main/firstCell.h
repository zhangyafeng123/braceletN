//
//  firstCell.h
//  braceletC
//
//  Created by 张亚峰 on 2017/4/5.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface firstCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstLab;

@property (weak, nonatomic) IBOutlet UISwitch *switchbtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightstraint;

@end
