//
//  AppFlutterViewController.m
//  Runner
//
//  Created by sk on 2018/12/27.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "AppFlutterViewController.h"
#import "OauthViewController.h"
@interface AppFlutterViewController ()<FlutterStreamHandler>
@property(copy, nonatomic) __block NSDictionary * tokenInfo;

@end

@implementation AppFlutterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   OauthViewController * oAuthVc =  [self.storyboard instantiateViewControllerWithIdentifier:@"OauthViewController"];
    
    
    oAuthVc.OAuthResult = ^(id  _Nonnull info, OauthViewController * _Nonnull oAuthVc) {
        self.tokenInfo  = info;
        FlutterEventChannel * tokenEventChannel = [FlutterEventChannel eventChannelWithName:@"App/Event/token" binaryMessenger:self];
        [tokenEventChannel setStreamHandler:self];
        [oAuthVc dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:oAuthVc animated:YES completion:nil];
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events{
    if (events) {
        events(self.tokenInfo);
    }
    return nil;
}
-(FlutterError *)onCancelWithArguments:(id)arguments{
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
