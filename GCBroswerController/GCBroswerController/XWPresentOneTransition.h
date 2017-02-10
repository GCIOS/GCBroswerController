//
//  XWPresentOneTransition.h
//  XWTrasitionPractice
//
//  Created by YouLoft_MacMini on 15/11/24.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWPresentOneTransition : UIPercentDrivenInteractiveTransition
<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>


/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;
- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
