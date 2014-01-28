//
//  CDPageContentViewController.m
//  Coursera Due
//
//  Created by Yuri Karabatov on 27.01.14.
//  Copyright (c) 2014 Yuri Karabatov. All rights reserved.
//

#import "CDPageContentViewController.h"
#import "OLGhostAlertView.h"
#import "CDNetworkDataLoader.h"

@interface CDPageContentViewController ()

@end

@implementation CDPageContentViewController

- (IBAction)signInButtonClicked:(id)sender {
    NSLog(@"Sign in button clicked");
    if (![self NSStringIsValidEmail:self.emailTextField.text]) {
        NSLog(@"Email is invalid!");
        OLGhostAlertView *emailAlert = [[OLGhostAlertView alloc] initWithTitle:@"Invalid Email" message: @"Please enter a valid Email address."];
        emailAlert.position = OLGhostAlertViewPositionTop;
        emailAlert.style = OLGhostAlertViewStyleDark;
        [emailAlert setCompletionBlock:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.emailTextField setTextColor:[UIColor blackColor]];
                [self.emailTextField setTintColor:[UIColor blackColor]];
            });
        }];
        [emailAlert show];
        [self.emailTextField becomeFirstResponder];
        [self.emailTextField setTextColor:[UIColor redColor]];
        [self.emailTextField setTintColor:[UIColor redColor]];
    } else {
        // Try authenticating
        [[CDNetworkDataLoader sharedLoader] tryAuthenticatingWithEmail:self.emailTextField.text password:self.passwordTextField.text success:^(AFOAuthCredential *credential) {
            // If yes, remove UIPageViewController, show UITabViewController (post notification?)
            NSLog(@"signInButtonClicked - In success block");
        } failure:^(NSError *error) {
            // If no, say “Wrong password”
            NSLog(@"signInButtonClicked - In error block");
        }];
    }
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

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    if (textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
        return NO;
    }

    if (textField == self.passwordTextField) {
        // Check if email is not null (for now)
        if ([self NSStringIsValidEmail:self.emailTextField.text]) {
            [self.passwordTextField resignFirstResponder];
            [self.signInButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        } else {
            NSLog(@"Email is invalid!");
            [self.emailTextField becomeFirstResponder];
        }
    }

    return NO; // We do not want UITextField to insert line-breaks.
}

// Remove keyboard if any touches on self
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(![touch.view isMemberOfClass:[UITextField class]]) {
        [touch.view endEditing:YES];
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
