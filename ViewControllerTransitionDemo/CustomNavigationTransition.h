#import <Foundation/Foundation.h>

@interface CustomNavigationTransition : NSObject <UIViewControllerAnimatedTransitioning, UIDynamicAnimatorDelegate>

@property (nonatomic, assign) BOOL isPushing;

@end
