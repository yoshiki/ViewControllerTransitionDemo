#import "CustomNavigationTransition.h"

@interface CustomNavigationTransition ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CustomNavigationTransition

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
    
    if (self.isPushing) {
        frontView = toVC.view;
        backView = fromVC.view;
        frontView.frame = CGRectOffset(frontView.frame, frontView.bounds.size.width, 0);
        snapToPoint = containerView.center;
    } else {
        frontView = fromVC.view;
        backView  = toVC.view;
        snapToPoint = (CGPoint){
            containerView.center.x + frontView.bounds.size.width,
            containerView.center.y,
        };
    }
    
    [containerView addSubview:backView];
    [containerView addSubview:frontView];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:containerView];
    self.animator.delegate = self;
    
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:frontView snapToPoint:snapToPoint];
    snapBehavior.damping = 0.3f;
    [self.animator addBehavior:snapBehavior];
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self.transitionContext completeTransition:YES];
}

@end
