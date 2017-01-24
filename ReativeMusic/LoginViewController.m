//
//  LoginViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/23/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthenticationService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkAuthenticationStatus];
}

#pragma mark - Authentication methods

- (IBAction)login:(id)sender {
    [self openLoginPage];
}

#pragma mark - Authentication methods

- (void)checkAuthenticationStatus {
    switch ([AuthenticationService authenticationStatus]) {
        case AuthenticationStatusNoSession:
            break;
        case AuthenticationStatusTokenExpired:
            [AuthenticationService renewTokenWithCompletion:^(NSError *error) {}];
            break;
        case AuthenticationStatusValidSession:
            break;
        default:
            break;
    }
}


- (void)openLoginPage {
    [self presentViewController:[AuthenticationService authenticationController]
                       animated:YES
                     completion:nil];
}

@end
