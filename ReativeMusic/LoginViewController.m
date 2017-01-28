//
//  LoginViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/23/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "LoginViewController.h"
#import "AuthenticationService.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString * const kSegueSearchIdentifier = @"SegueSearchIdentifier";

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation LoginViewController

#pragma mark - View life cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self checkAuthenticationStatus];
    
    [[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self presentViewController:[AuthenticationService authenticationController]
                           animated:YES
                         completion:nil];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kAuthenticationNotificationStartSessionSuccess object:nil]
     takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
        [self performSegueWithIdentifier:kSegueSearchIdentifier sender:self];
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kAuthenticationNotificationRefreshTokenSuccess object:nil]
      takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
        [self performSegueWithIdentifier:kSegueSearchIdentifier sender:self];
    }];
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

@end
