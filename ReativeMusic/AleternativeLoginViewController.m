//
//  AleternativeLoginViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/29/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "AleternativeLoginViewController.h"
#import "AuthenticationService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

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
    
    RACSignal *validUsernameSignal = [self.userTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUsername:text]);
     }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];
    
    RAC(self.passwordTextField, backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
         return [passwordValid boolValue] ? [UIColor whiteColor] : [UIColor lightGrayColor];
    }];
    
    RAC(self.userTextField, backgroundColor) = [validUsernameSignal map:^id(NSNumber *passwordValid) {
         return [passwordValid boolValue] ? [UIColor whiteColor] : [UIColor lightGrayColor];
    }];
    
    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                                                      reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid) {
                                                          return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.signInButton.enabled = [signupActive boolValue];
    }];
    
    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
        self.signInButton.enabled = NO;
        self.failureLabel.hidden = YES;
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        
    }] flattenMap:^id(id x) {
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *signedIn) {
        BOOL success = [signedIn boolValue];
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

#pragma mark - Sugnals

-(RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [AuthenticationService signInWithUsername:self.userTextField.text
                                         password:self.passwordTextField.text
                                       completion:^(BOOL success) {
                                           [subscriber sendNext:@(success)];
                                           [subscriber sendCompleted];
                                       }];
        return nil;
    }];
}



@end
