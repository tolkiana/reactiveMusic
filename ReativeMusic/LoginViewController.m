//
//  LoginViewController.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/23/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "LoginViewController.h"
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SafariServices/SafariServices.h>


@interface LoginViewController () <SFSafariViewControllerDelegate>

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
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    // Check if we have a token at all
    if (auth.session == nil) {
        return;
    }
    // Check if it's still valid
    if ([auth.session isValid]) {
        // It's still valid, show the player.
        // Perform segue to SearchViewController
        return;
    }
    // Oh noes, the token has expired, if we have a token refresh service set up, we'll call tat one.
    if (auth.hasTokenRefreshService) {
        [self renewToken];
        return;
    }
}

- (void)renewToken {
    SPTAuth *auth = [SPTAuth defaultInstance];
    [auth renewSession:auth.session callback:^(NSError *error, SPTSession *session) {
        auth.session = session;
        if (error) {
            NSLog(@"*** Error renewing session: %@", error);
            return;
        }
    }];
}

- (void)openLoginPage {
    SPTAuth *auth = [SPTAuth defaultInstance];
    UIViewController *authViewController = [self authViewControllerWithURL:[auth spotifyWebAuthenticationURL]];
    self.definesPresentationContext = YES;
    [self presentViewController:authViewController animated:YES completion:nil];

}

- (UIViewController *)authViewControllerWithURL:(NSURL *)url {
    SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:url];
    safari.delegate = self;
    safari.modalPresentationStyle = UIModalPresentationPageSheet;
    return safari;
}

#pragma mark - SFSafariViewControllerDelegate

- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    // User tapped the close button. Treat as auth error
}

@end
