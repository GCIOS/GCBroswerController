//
//  ViewController.m
//  仿今日头条浏览器
//
//  Created by 高崇 on 17/2/9.
//  Copyright © 2017年 LieLvWang. All rights reserved.
//



#import "ViewController.h"
#import "ViewController1.h"
#import "GCTransitionManager.h"


@interface ViewController ()

@property (nonatomic, strong) GCTransitionManager *manager;
@end

@implementation ViewController


- (IBAction)click:(id)sender {
    
    ViewController1 *vc = [ViewController1 new];
    
    [self.manager addPanGestureForViewController:vc];
    vc.transitioningDelegate = self.manager;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (GCTransitionManager *)manager
{
    if (!_manager) {
        _manager = [[GCTransitionManager alloc] init];
    }
    return _manager;
}
@end
