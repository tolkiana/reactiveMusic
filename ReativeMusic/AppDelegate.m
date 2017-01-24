//
//  AppDelegate.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/23/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "AppDelegate.h"
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SafariServices/SafariServices.h>


static NSString * const kClientID = @"9c2c7d32399747ff9c9c4a7cc5e73a0f";
static NSString * const kRedirectURL = @"reactive-music://callback";
static NSString * const kSessionKey = @"ReactiveMusicSession";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    SPTAuth *auth = [SPTAuth defaultInstance];
    auth.clientID = kClientID;
    auth.redirectURL = [NSURL URLWithString:kRedirectURL];
    auth.sessionUserDefaultsKey = kSessionKey;
    auth.requestedScopes = @[SPTAuthStreamingScope];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    SPTAuth *auth = [SPTAuth defaultInstance];
    if ([auth canHandleURL:url]) {
        [auth handleAuthCallbackWithTriggeredAuthURL:url callback:^(NSError *error, SPTSession *session) {
            if (error) {
                NSLog(@"*** Auth error: %@", error);
            } else {
                auth.session = session;
            }
        }];
        return YES;
    }
    return NO;
}

@end
