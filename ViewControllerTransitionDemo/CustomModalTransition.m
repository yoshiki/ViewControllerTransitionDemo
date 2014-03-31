#import "CustomModalTransition.h"

@interface CustomModalTransition ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CustomModalTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.transitionContext = transitionContext;
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *frontView = nil;
    UIView *backView  = nil;
    CGPoint snapToPoint = CGPointZero;
    
    if (self.isPresenting) {
        frontView = toVC.view;
        backView = fromVC.view;
        frontView.frame = CGRectOffset(frontView.frame, 0, frontView.bounds.size.height);
        snapToPoint = containerView.center;
    } else {
        frontView = fromVC.view;
        backView  = toVC.view;
        snapToPoint = (CGPoint){
            containerView.center.x,
            containerView.center.y + frontView.bounds.size.height,
        };
    }
    
    [containerView addSubview:backView];
    [containerView addSubview:frontView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:containerView];
    self.animator.delegate = self;
    
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:frontView snapToPoint:snapToPoint];
    [self.animator addBehavior:snapBehavior];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.transitionContext completeTransition:YES];
}

@end
