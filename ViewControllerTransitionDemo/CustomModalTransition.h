#import <Foundation/Foundation.h>

@interface CustomModalTransition : NSObject <UIViewControllerAnimatedTransitioning, UIDynamicAnimatorDelegate>

@property (nonatomic, assign) BOOL isPresenting;

@end
