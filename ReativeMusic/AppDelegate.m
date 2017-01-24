//
//  AppDelegate.m
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/23/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthenticationService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [AuthenticationService configure];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [AuthenticationService startAuthenticationWithUrl:url andCompletion:^(NSError *error) {}];
    return NO;
}

@end
