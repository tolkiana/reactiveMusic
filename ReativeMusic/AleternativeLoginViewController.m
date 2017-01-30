//
//  AleternativeLoginViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/29/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "AleternativeLoginViewController.h"
#import "AuthenticationService.h"

static NSString * const kSegueSearchIdentifier = @"SegueSearchIdentifier";

@interface AleternativeLoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *userTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *signInButton;
@property (strong, nonatomic) IBOutlet UILabel *failureLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic) BOOL passwordIsValid;
@property (nonatomic) BOOL usernameIsValid;


@end

@implementation AleternativeLoginViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;
    self.failureLabel.hidden = YES;

    // handle text changes for both text fields
    [self.userTextField addTarget:self action:@selector(usernameTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(passwordTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - IBActions

- (IBAction)signIn:(id)sender {
    // disable all UI controls
    self.signInButton.enabled = NO;
    self.failureLabel.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    [AuthenticationService signInWithUsername:self.userTextField.text
                                     password:self.passwordTextField.text
                                   completion:^(BOOL success) {
                                       self.signInButton.enabled = YES;
                                       self.failureLabel.hidden = success;
                                       self.activityIndicator.hidden = YES;
                                       [self.activityIndicator stopAnimating];
                                       if (success) {
                                           [self performSegueWithIdentifier:kSegueSearchIdentifier sender:self];
                                       }
    }];
}


#pragma mark - Validation methods

- (BOOL)isValidUsername:(NSString *)username {
    return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
    return password.length > 3;
}

- (void)updateUIState {
    self.userTextField.backgroundColor = self.usernameIsValid ? [UIColor whiteColor] : [UIColor lightGrayColor];
    self.passwordTextField.backgroundColor = self.passwordIsValid ? [UIColor whiteColor] : [UIColor lightGrayColor];
    self.signInButton.enabled = self.usernameIsValid && self.passwordIsValid;
}

- (void)usernameTextFieldChanged {
    self.usernameIsValid = [self isValidUsername:self.userTextField.text];
    [self updateUIState];
}

- (void)passwordTextFieldChanged {
    self.passwordIsValid = [self isValidPassword:self.passwordTextField.text];
    [self updateUIState];
}

@end
