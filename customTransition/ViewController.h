//
//  ViewController.h
//  customTransition
//
//  Created by Jamz Tang on 31/12/13.
//  Copyright (c) 2013 Jamz Tang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSNavigationController.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *nextHeaderView;

@end


@interface CSNavigationController (CustomTransitioning)

@end