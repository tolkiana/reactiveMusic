//
//  AuthenticationService.h
//  ReativeMusic
//
//  Created by Nelida Velazquez on 1/24/17.
//  Copyright © 2017 tolkiana. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AuthenticationStatus) {
    AuthenticationStatusUnknown,
    AuthenticationStatusNoSession,
    AuthenticationStatusValidSession,
    AuthenticationStatusTokenExpired
};


@interface AuthenticationService : NSObject

+ (void)configure;
+ (AuthenticationStatus)authenticationStatus;
+ (UIViewController *)authenticationController;
+ (void)startAuthenticationWithUrl:(NSURL *)url andCompletion:(void (^)(NSError *))completion;
+ (void)renewTokenWithCompletion:(void (^)(NSError *))completion;

@end
