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
    
    // If you're not using CSNavigationController, you should specify
    // self as the UINavigationControllerDelegate

//    self.navigationController.delegate = self;
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
    self.operation = operation;
    return self;
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
    NSTimeInterval duration                     = [self transitionDuration:transitionContext];

    if (operation == UINavigationControllerOperationPush) {
        
        [containerView addSubview:toController.view];

        toController.view.frame = toFinalFrame;

        UIView *topView = [self snapshotViewFromView:self.view
                                                rect:CGRectMake(0, 0, 320, CGRectGetMaxY(self.headerView.frame))];
        
        UIView *content = [self snapshotViewFromView:self.view
                                                rect:self.contentView.frame];
        
        UIView *footerView = [self.view resizableSnapshotViewFromRect:self.footerView.frame
                                            afterScreenUpdates:NO
                                                 withCapInsets:UIEdgeInsetsMake(self.footerView.bounds.size.height - 1, 0, 1, 0)];
        footerView.frame = self.footerView.frame;

       
        CGRect bottomRect = CGRectIntersection
        (self.view.bounds,
         CGRectMake(
                    CGRectGetMinX(self.nextHeaderView.frame),
                    CGRectGetMinY(self.nextHeaderView.frame),
                    CGRectGetMaxX(self.nextHeaderView.frame),
                    CGFLOAT_MAX));

        UIView *bottomView = [self snapshotViewFromView:self.view
                                                   rect:bottomRect];
        
        
        [containerView addSubview:topView];
//        [containerView addSubview:content];
        [containerView addSubview:footerView];
        [containerView addSubview:bottomView];

        CGRect contentFrame = [toController.view viewWithTag:1000].frame;
        CGRect footerFrame  = [toController.view viewWithTag:self.footerView.tag].frame;

        toController.view.transform = CGAffineTransformMakeTranslation(0, self.contentView.frame.origin.y - 64);

        [UIView animateKeyframesWithDuration:duration
                                       delay:0
                                     options:0
                                  animations:^
         {

             [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.8
                                           animations:^
              {
                  topView.transform = CGAffineTransformMakeTranslation(0, -topView.frame.size.height + 64);

                  content.frame      = contentFrame;
                  footerView.frame   = footerFrame;
                  
                  bottomView.transform = CGAffineTransformMakeTranslation(0, bottomView.frame.size.height);
                  toController.view.transform = CGAffineTransformIdentity;
              }];

             [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2
                                           animations:^
              {
                  topView.alpha = 0;
                  content.alpha = 0;
                  footerView.alpha = 0;
              }];

         } completion:^(BOOL finished) {
             [transitionContext completeTransition:finished];

             [topView removeFromSuperview];
             [content removeFromSuperview];
             [footerView removeFromSuperview];
             [bottomView removeFromSuperview];
         }];

    } else if (operation == UINavigationControllerOperationPop) {

        [containerView addSubview:toController.view];
        toController.view.frame = toFinalFrame;

        [containerView addSubview:fromController.view];

        UIView *topView = [self snapshotViewFromView:self.view
                                                rect:CGRectMake(0, 0, 320, CGRectGetMaxY(self.headerView.frame))];
        
        UIView *content = [self snapshotViewFromView:self.view
                                                rect:self.contentView.frame];

        UIView *fromFooterView = [fromController.view viewWithTag:self.footerView.tag];
        UIView *footerView = [fromController.view resizableSnapshotViewFromRect:fromFooterView.frame
                                                   afterScreenUpdates:NO
                                                        withCapInsets:UIEdgeInsetsMake(self.footerView.bounds.size.height - 1, 0, 1, 0)];

        CGRect bottomRect = CGRectIntersection
        (self.view.bounds,
         CGRectMake(
                    CGRectGetMinX(self.nextHeaderView.frame),
                    CGRectGetMinY(self.nextHeaderView.frame),
                    CGRectGetMaxX(self.nextHeaderView.frame),
                    CGFLOAT_MAX));

        UIView *bottomView = [self snapshotViewFromView:self.view
                                                   rect:bottomRect];
        

        [containerView addSubview:topView];
        [containerView addSubview:content];
        [containerView addSubview:footerView];
        [containerView addSubview:bottomView];

        topView.transform = CGAffineTransformMakeTranslation(0, -topView.frame.size.height + 64);
        topView.alpha = 0;
        content.alpha = 0;
        footerView.frame = [toController.view viewWithTag:self.footerView.tag].frame;
        content.frame = [fromController.view viewWithTag:1000].frame;
        bottomView.transform = CGAffineTransformMakeTranslation(0, bottomView.frame.size.height);
        footerView.frame = fromFooterView.frame;

        [UIView animateKeyframesWithDuration:duration
                                       delay:0
                                     options:0
                                  animations:^
         {

             [UIView addKeyframeWithRelativeStartTime:0
                                     relativeDuration:0.2
                                           animations:^
              {
                  topView.alpha = 1;
                  content.alpha = 1;
              }];

             [UIView addKeyframeWithRelativeStartTime:0.2
                                     relativeDuration:0.8
                                           animations:^
              {
                  CGRect targetFrame = [toController.view viewWithTag:1000].frame;
                  topView.transform = CGAffineTransformIdentity;
                  content.frame = targetFrame;
                  footerView.frame = self.footerView.frame;
                  bottomView.transform = CGAffineTransformIdentity;
                  fromController.view.transform = CGAffineTransformMakeTranslation(0, self.contentView.frame.origin.y - 64);

              }];

         } completion:^(BOOL finished) {
             [topView removeFromSuperview];
             [content removeFromSuperview];
             [footerView removeFromSuperview];
             [bottomView removeFromSuperview];
             [transitionContext completeTransition:finished];
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


@implementation CSNavigationController (CustomTransitioning)

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
 
    if ([fromVC respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [(id <UINavigationControllerDelegate>)fromVC navigationController:navigationController
                                                 animationControllerForOperation:operation
                                                              fromViewController:fromVC
                                                                toViewController:toVC];
    } else if ([toVC respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
            return [(id <UINavigationControllerDelegate>)toVC navigationController:navigationController
                                                     animationControllerForOperation:operation
                                                                  fromViewController:fromVC
                                                                    toViewController:toVC];
    }

    return nil;
}

@end
