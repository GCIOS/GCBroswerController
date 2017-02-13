//
//  GCPercentDrivenInteractiveTransition.h
//  GCBroswerController
//
//  Created by 高崇 on 17/2/10.
//  Copyright © 2017年 LieLvWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GCPercentDrivenInteractiveTransitionDelegate <NSObject>

- (UIImageView *)imgView;

@end

@interface GCPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition
<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL interation;
- (void)addPanGestureForViewController:(UIViewController <GCPercentDrivenInteractiveTransitionDelegate>*)viewController;
@end
