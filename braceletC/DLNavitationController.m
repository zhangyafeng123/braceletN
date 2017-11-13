//
//  DLNavitationController.m
//  PractiseA
//
//  Created by mibo02 on 16/11/16.
//  Copyright © 2016年 mibo02. All rights reserved.
//

#import "DLNavitationController.h"

@interface DLNavitationController ()

@end

@implementation DLNavitationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// MARK:- 拦截导航控制器的push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [super pushViewController:viewController animated:animated];  // 重写系统的方法，一般都要进行还原
    
    // 给非根控制器左侧设置按钮
    if (self.viewControllers.count > 1) {  // 如果是非根控制器
        
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem CreateItemWithTarget:self ForAction:@selector(backClick) WithImage:@"返回-2"];
    }
}

// MARK:- 左侧返回按钮
- (void)backClick {
    
    // 导航控制器出站，实现返回
    [self popViewControllerAnimated:YES];
}


@end
