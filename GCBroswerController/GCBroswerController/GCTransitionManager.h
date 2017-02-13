//
//  GCTransitionManager.h
//  GCBroswerController
//
//  Created by 高崇 on 17/2/10.
//  Copyright © 2017年 LieLvWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCTransitionManagerDelegate <NSObject>

- (UIImageView *)imgView;

@end

@interface GCTransitionManager : UIPercentDrivenInteractiveTransition
<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL interation;
- (void)addPanGestureForViewController:(UIViewController <GCTransitionManagerDelegate>*)viewController;
@end
