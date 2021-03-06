//
//  CDRootViewController.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 27.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

@import UIKit;

@interface CDRootViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSArray *pageTitles;

@end
