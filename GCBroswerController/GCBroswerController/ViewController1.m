//
//  ViewController1.m
//  仿今日头条浏览器
//
//  Created by 高崇 on 17/2/9.
//  Copyright © 2017年 LieLvWang. All rights reserved.
//

#import "ViewController1.h"

@implementation ViewController1


- (void)dealloc{
    NSLog(@"销毁了!!!!!");
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
}


- (IBAction)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
