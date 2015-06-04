#import "PopAnimatedTransition.h"

static const CGFloat kPopAnimatedTransitionToViewOffset = 100.0f;
static const CGFloat kPopAnimatedTransitionToViewAlphaStart = 0.3f;
static const CGFloat kPopAnimatedTransitionToViewAlphaEnd = 1.0f;

@implementation PopAnimatedTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] insertSubview:toViewController.view atIndex:0];
    
    CGRect fromOrigFrame = fromViewController.view.frame;
    CGRect fromEndFrame = fromOrigFrame;
    fromEndFrame.origin.x = fromEndFrame.size.width;
    fromViewController.view.frame = fromOrigFrame;

    CGRect toOrigFrame = toViewController.view.frame;
    CGRect toStartFrame = toOrigFrame;
    toStartFrame.origin.x = toStartFrame.origin.x - kPopAnimatedTransitionToViewOffset;
    toViewController.view.frame = toStartFrame;

    toViewController.view.alpha = kPopAnimatedTransitionToViewAlphaStart;

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.frame = toOrigFrame;
        fromViewController.view.frame = fromEndFrame;
        toViewController.view.alpha = kPopAnimatedTransitionToViewAlphaEnd;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            fromViewController.view.frame = fromOrigFrame;
            toViewController.view.frame = toOrigFrame;
        }
        toViewController.view.alpha = kPopAnimatedTransitionToViewAlphaEnd;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
