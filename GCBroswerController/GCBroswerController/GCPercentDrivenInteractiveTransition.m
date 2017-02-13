//
//  GCPercentDrivenInteractiveTransition.m
//  GCBroswerController
//
//  Created by 高崇 on 17/2/10.
//  Copyright © 2017年 LieLvWang. All rights reserved.
//

#import "GCPercentDrivenInteractiveTransition.h"
#import "UIView+FrameChange.h"

#define MaxPercent 0.35
@interface GCPercentDrivenInteractiveTransition ()

@property (nonatomic, weak) UIViewController <GCPercentDrivenInteractiveTransitionDelegate>*presentingVC;

@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isPresent;
@end

@implementation GCPercentDrivenInteractiveTransition

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
    
    UIImageView *imageView = self.presentingVC.imgView;
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:imageView.frame];
    tempImgView.image = imageView.image;
//    NSLog(@"hello = %@  %@", imageView, tempImgView);
    
    UIView *containerView = [transitionContext containerView];
    UIView *coverView = [[UIView alloc] initWithFrame:containerView.bounds];
    coverView.backgroundColor = [UIColor blackColor];
    if (!self.isDown && !self.isUp) {
        
    }else{
        
        [containerView addSubview:coverView];
        [containerView addSubview:tempImgView];
        fromVC.view.hidden = YES;
    }
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (self.isUp) {
            
            tempImgView.transform = CGAffineTransformMakeTranslation(0, -kScreenH*0.5 - tempImgView.height);
        }
        if (self.isDown) {
            
            tempImgView.transform = CGAffineTransformMakeTranslation(0, kScreenH*0.5 + tempImgView.height);
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
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [tempImgView removeFromSuperview];
                [coverView removeFromSuperview];
            });
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            [transitionContext completeTransition:YES];
            [tempImgView removeFromSuperview];
            [coverView removeFromSuperview];
        }
        
    }];
    
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)addPanGestureForViewController:(UIViewController <GCPercentDrivenInteractiveTransitionDelegate>*)viewController;
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [viewController.view addGestureRecognizer:pan];
    self.presentingVC = viewController;
}

- (CGFloat)completionSpeed
{
    if (self.percentComplete > MaxPercent) {// dismiss
        return 0.70;
    }else{
        return  self.percentComplete;
    }
}

/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    
    //位移
    CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
    //手势百分比
    CGFloat percent =   transitionY / (kScreenH*0.5 + self.presentingVC.imgView.height);
    
    //Limit it between -1.0 and 1.0
    if (percent > 1.0 ) {
        percent = 1.0;
    }
    if (percent < -1.0) {
        percent = -1.0;
    }
    
//    NSLog(@"------   %f   %f ", transitionY, percent);
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.interation = YES;
            break;
        case UIGestureRecognizerStateChanged:{
            
            if (percent > 0) {
                
                [self updateInteractiveTransition:percent];
                if (self.isDown) {
                    return;
                }
                self.isDown = YES;
                self.isUp = NO;
                NSLog(@"下");
                [self cancelInteractiveTransition];
                [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
            }else{
                [self updateInteractiveTransition:-percent];
                if (self.isUp) {
                    return;
                }
                self.isUp = YES;
                self.isDown = NO;
                NSLog(@"---- 上");
                [self cancelInteractiveTransition];
                [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:{
            self.interation = NO;
            if (self.isDown) {
                if (percent > MaxPercent) {
                    [self finishInteractiveTransition];
                }else{
                    [self cancelInteractiveTransition];
                }
            }
            if (self.isUp){
                if (-percent > MaxPercent) {
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
