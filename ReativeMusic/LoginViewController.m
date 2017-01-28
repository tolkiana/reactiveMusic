//
//  LoginViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/23/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthenticationService.h"

static NSString * const kSegueSearchIdentifier = @"SegueSearchIdentifier";

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation LoginViewController

#pragma mark - View life cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkAuthenticationStatus];
    [AuthenticationService subscribeObserverForStartSessionSucces:self andSelector:@selector(sessionStartedNotification:)];
    [AuthenticationService subscribeObserverForRefreshTokenSucces:self andSelector:@selector(tokenRefreshedNotification:)];
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
            [AuthenticationService refreshToken];
            break;
        case AuthenticationStatusValidSession:
            [self performSegueWithIdentifier:kSegueSearchIdentifier sender:self];
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

#pragma mark - Authentication notifications

- (void)sessionStartedNotification:(NSNotification *)notification {
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)tokenRefreshedNotification:(NSNotification *)notification {
    [self performSegueWithIdentifier:kSegueSearchIdentifier sender:self];
}


@end
