//
//  CDPageContentViewController.h
//  Coursera Due
//
//  Created by Yuri Karabatov on 27.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

@import UIKit;

@interface CDPageContentViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property BOOL hideControls;

@end
