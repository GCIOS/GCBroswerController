//
//  XWPresentOneTransition.m
//  XWTrasitionPractice
//
//  Created by YouLoft_MacMini on 15/11/24.
//  Copyright © 2015年 YouLoft_MacMini. All rights reserved.
//

#import "XWPresentOneTransition.h"
#import "UIView+FrameChange.h"
#import "ViewController1.h"


@interface XWPresentOneTransition ()


@property (nonatomic, weak) ViewController1 *vc;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, assign) CGFloat persent;
@end

@implementation XWPresentOneTransition


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    _isPresent = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    _isPresent = NO;
    return self;
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    
    return self.interation ? self : nil;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    if (!self.isDown && !self.isUp) {
        return 0.25;
    }
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //为了将两种动画的逻辑分开，变得更加清晰，我们分开书写逻辑，
    if (_isPresent) {
        
        [self presentAnimation:transitionContext];
    }else{
        
        [self dismissAnimation:transitionContext];
    }
}

/**
 *  实现present动画
 */
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    toVC.view.alpha = 0.0;
    toVC.view.frame = containerView.bounds;
    [containerView addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

/**
 *  实现dimiss动画
 */
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    ViewController1 *fromVC = (ViewController1 *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:fromVC.imgView.frame];
    tempView.image = fromVC.imgView.image;
    
    UIView *containerView = [transitionContext containerView];
    UIView *coverView = [[UIView alloc] initWithFrame:containerView.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    if (!self.isDown && !self.isUp) {
        
    }else{
        
        [containerView addSubview:coverView];
        [containerView addSubview:tempView];
        fromVC.view.hidden = YES;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (self.isUp) {
            
            tempView.transform = CGAffineTransformMakeTranslation(0, -kScreenH*0.5 - tempView.height);
        }
        if (self.isDown) {
            
            tempView.transform = CGAffineTransformMakeTranslation(0, kScreenH*0.5 + tempView.height);
        }
        if (!self.isDown && !self.isUp) {
            
            fromVC.view.transform = CGAffineTransformMakeTranslation(kScreenW,0);
        }
        
        coverView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        if ([transitionContext transitionWasCancelled]) {
            //失败了接标记失败
            [transitionContext completeTransition:NO];
            fromVC.view.hidden = NO;
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            [transitionContext completeTransition:YES];
        }
        
        [tempView removeFromSuperview];
        [coverView removeFromSuperview];
    }];
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    self.vc = (ViewController1 *)viewController;
    [self.vc.view addGestureRecognizer:pan];
}

- (CGFloat)completionSpeed
{
    return  _persent;
}
/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    
    
    //手势百分比
    CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
    CGFloat persent =   transitionY / (kScreenH*0.5);
    self.persent = fabs(persent);
    
//    NSLog(@"------   %f   %f   %f", transitionY, persent, self.completionSpeed);
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.interation = YES;
            break;
        case UIGestureRecognizerStateChanged:{
            
            if (persent > 0) {
                
                [self updateInteractiveTransition:persent];
                if (self.isDown) {
                    return;
                }
                self.isDown = YES;
                self.isUp = NO;
                NSLog(@"下");
                [self cancelInteractiveTransition];
                [_vc dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self updateInteractiveTransition:-persent];
                if (self.isUp) {
                    return;
                }
                self.isUp = YES;
                self.isDown = NO;
                NSLog(@"---- 上");
                [self cancelInteractiveTransition];
                [_vc dismissViewControllerAnimated:YES completion:nil];
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:{
            self.interation = NO;
            if (self.isDown) {
                if (persent > 0.4) {
                    [self finishInteractiveTransition];
                }else{
                    [self cancelInteractiveTransition];
                }
            }
            if (self.isUp){
                if (-persent > 0.4) {
                    [self finishInteractiveTransition];
                }else{
                    [self cancelInteractiveTransition];
                }
                
            }
            self.isUp = NO;
            self.isDown = NO;
            
            
            NSLog(@"Stop");
            break;
        }
        default:
            break;
    }
}



@end











