//
//  ViewController.m
//  customTransition
//
//  Created by Jamz Tang on 31/12/13.
//  Copyright (c) 2013 Jamz Tang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic) UINavigationControllerOperation operation;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        self.operation = operation;
        return self;
    }
    self.operation = 0;
    return nil;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *containerView                       = [transitionContext containerView];
    UIViewController *fromController            = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController              = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UINavigationControllerOperation operation   = self.operation;
    CGRect toFinalFrame                         = [transitionContext finalFrameForViewController:toController];
    CGRect fromFinalFrame                       = [transitionContext finalFrameForViewController:fromController];

    if (operation == UINavigationControllerOperationPush) {
        
        [containerView addSubview:toController.view];

        toController.view.frame = toFinalFrame;

        UIView *topView = [self snapshotViewFromView:self.view
                                                rect:CGRectMake(0, 0, 320, CGRectGetMaxY(self.headerView.frame))];
        
        UIView *content = [self snapshotViewFromView:self.view
                                                rect:self.contentView.frame];


//        NSLog(@"%@", @{
//                       @"contentView":NSStringFromCGRect(self.contentView.frame),
//                       @"bottomRect":NSStringFromCGRect(bottomRect),
//                       @"maxY":@(CGRectGetMaxY(self.contentView.frame)),
//                       });
        
        CGRect bottomRect = CGRectMake(0, CGRectGetMaxY(self.contentView.frame), 320, CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.contentView.frame));
        UIView *bottomView = [self snapshotViewFromView:self.view
                                                   rect:bottomRect];
        [containerView addSubview:topView];
        [containerView addSubview:content];
        [containerView addSubview:bottomView];

        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             topView.transform = CGAffineTransformMakeTranslation(0, -topView.frame.size.height + 64);
                             
                             CGRect targetFrame = [toController.view viewWithTag:1000].frame;
                             
                             content.frame = targetFrame;
                             bottomView.transform = CGAffineTransformMakeTranslation(0, bottomView.frame.size.height);
                         } completion:^(BOOL finished) {
                             [transitionContext completeTransition:finished];
                             
                             [topView removeFromSuperview];
                             [content removeFromSuperview];
                             [bottomView removeFromSuperview];

                             NSLog(@"containerView %@", containerView);
                         }];
    }
}

- (UIView *)snapShotTopView {
    UIView *view = [self.view snapshotViewAfterScreenUpdates:YES];
    view.frame = CGRectMake(0, 0, 320, CGRectGetMaxY(self.headerView.frame));
    return view;
}

- (UIView *)snapshotViewFromView:(UIView *)view rect:(CGRect)rect {

    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
    
    CGRect drawRect = CGRectOffset(view.bounds, 0, -rect.origin.y);
    [view drawViewHierarchyInRect:drawRect afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectOffset(imageView.bounds, 0, rect.origin.y);
    return imageView;
}

@end
