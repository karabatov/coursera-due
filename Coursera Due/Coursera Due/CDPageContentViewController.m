//
//  CDPageContentViewController.m
//  Coursera Due
//
//  Created by Yuri Karabatov on 27.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import "CDPageContentViewController.h"

@interface CDPageContentViewController ()

@end

@implementation CDPageContentViewController
- (IBAction)signInButtonClicked:(id)sender {
    NSLog(@"Sign in button clicked");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.titleLabel.text = self.titleText;

    if (self.hideControls) {
        [self.signInButton setHidden:YES];
        [self.emailTextField setHidden:YES];
        [self.passwordTextField setHidden:YES];
    }

    // Set rounded border
    // Source: http://stackoverflow.com/questions/18295703/ios-7-and-button-and-border
    self.signInButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.signInButton.layer.borderWidth = 1.0;
    self.signInButton.layer.cornerRadius = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
