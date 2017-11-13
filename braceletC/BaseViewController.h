//
//  BaseViewController.h
//  braceletC
//
//  Created by 张亚峰 on 2017/4/5.
//  Copyright © 2017年 张亚峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/**
 *  显示loading动画
 */
- (void)showProgressHUD;
/**
 *  隐藏loading动画
 */
- (void)hideProgressHUD;

//显示带有文字的loading
- (void)showProgressHUDWithThitle:(NSString *)title;
@end
