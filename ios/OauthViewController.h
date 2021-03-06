//
//  OauthViewController.h
//  Runner
//
//  Created by sk on 2018/12/18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OauthViewController : UIViewController
@property(copy, nonatomic) void(^OAuthResult)(id info, OauthViewController * oAuthVc);
@end

NS_ASSUME_NONNULL_END
