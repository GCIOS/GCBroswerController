//
//  ViewController.m
//  仿今日头条浏览器
//
//  Created by 高崇 on 17/2/9.
//  Copyright © 2017年 LieLvWang. All rights reserved.
//



#import "ViewController.h"
#import "ViewController1.h"

#import "GCPercentDrivenInteractiveTransition.h"


@interface ViewController ()

@property (nonatomic, strong) GCPercentDrivenInteractiveTransition *interactiveDismiss;
@end

@implementation ViewController


- (IBAction)click:(id)sender {
    
    ViewController1 *vc = [ViewController1 new];
    
    self.interactiveDismiss = [GCPercentDrivenInteractiveTransition new];
    [self.interactiveDismiss addPanGestureForViewController:vc];
    vc.transitioningDelegate = self.interactiveDismiss;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
}


@end
