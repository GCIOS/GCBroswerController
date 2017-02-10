//
//  ViewController.m
//  仿今日头条浏览器
//
//  Created by 高崇 on 17/2/9.
//  Copyright © 2017年 LieLvWang. All rights reserved.
//



#import "ViewController.h"
#import "ViewController1.h"
#import "XWPresentOneTransition.h"



@interface ViewController ()

@property (nonatomic, strong) XWPresentOneTransition *interactiveDismiss;
@end

CGFloat const gestureMinimumTranslation1 = 20.0;


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)click:(id)sender {
    
    ViewController1 *vc = [ViewController1 new];
    
    self.interactiveDismiss = [XWPresentOneTransition new];
    [self.interactiveDismiss addPanGestureForViewController:vc];
    vc.transitioningDelegate = self.interactiveDismiss;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
}


@end
