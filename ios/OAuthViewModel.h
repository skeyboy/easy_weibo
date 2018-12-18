//
//  OAuthViewModel.h
//  Runner
//
//  Created by sk on 2018/12/18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OAuthViewModel : NSObject
-(void)fetchOauth:(void(^)(NSDictionary *)) token ;
@end

NS_ASSUME_NONNULL_END
