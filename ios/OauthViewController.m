//
//  OauthViewController.m
//  Runner
//
//  Created by sk on 2018/12/18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "OauthViewController.h"
#import "OAuthViewModel.h"
#import <Flutter/Flutter.h>
@interface OauthViewController ()<FlutterStreamHandler>
@property (strong, nonatomic) IBOutlet OAuthViewModel *OauthViewModel;
@property(copy, nonatomic) __block NSDictionary * tokenInfo;
@end

@implementation OauthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary * token = [userDefault dictionaryForKey:Key];
    if ([token isKindOfClass:[NSDictionary class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.OAuthResult) {
                self.OAuthResult(token, self);
            }
//            [self performSegueWithIdentifier:@"show_flutter" sender:token];
        });
        return;
    }
    [self.OauthViewModel fetchOauth:^(NSDictionary * _Nonnull tokenInfo) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"show_flutter" sender:tokenInfo];
        });
    }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    self.tokenInfo = sender;
    FlutterViewController * flutterVc = segue.destinationViewController;
    FlutterEventChannel * tokenEventChannel = [FlutterEventChannel eventChannelWithName:@"App/Event/token" binaryMessenger:flutterVc];
    [tokenEventChannel setStreamHandler:self];
    
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
