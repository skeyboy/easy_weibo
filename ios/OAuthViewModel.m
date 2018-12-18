//
//  OAuthViewModel.m
//  Runner
//
//  Created by sk on 2018/12/18.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "OAuthViewModel.h"
#import <WebKit/WebKit.h>
@interface OAuthViewModel()<WKNavigationDelegate, WKUIDelegate>
{
    NSString * _redirect_uri;
    NSString * _url ;
    NSURL* _original_url;
    void (^Token)(NSDictionary * _Nonnull);
}
@property (weak, nonatomic) IBOutlet WKWebView *oauthWebView;

@end
@implementation OAuthViewModel
-(instancetype)init{
    if (self = [super init]) {
        _redirect_uri = [@"https://api.weibo.com/oauth2/default.html" stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        _url = [[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=4049546345&redirect_uri=%@&response_type=code",_redirect_uri] stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
     
      
    }
    return self;
}
- (void)fetchOauth:(void (^)(NSDictionary * _Nonnull))token{
    Token = token;

    self.oauthWebView.UIDelegate = self;
    self.oauthWebView.navigationDelegate = self;
    _original_url = [NSURL URLWithString:_url];
    NSURLRequest * request = [NSURLRequest requestWithURL:_original_url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [self.oauthWebView loadRequest:request];
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%@", navigationResponse.response.URL);
    NSString * url = navigationResponse.response.URL.absoluteString;
    if ([url hasPrefix:_redirect_uri]) {
        NSString * code = [url stringByReplacingCharactersInRange:NSMakeRange(0, _redirect_uri.length+6) withString:@""];
        NSLog(@"code = %@", code);
        
        
        NSDictionary * params = @{@"client_id":@"4049546345",@"client_secret":@"f2b030d13ec05f460b74e62f46144f40",@"grant_type":@"authorization_code",@"redirect_uri":_redirect_uri,@"code":code};
        NSMutableArray * ps = [NSMutableArray array];
        for (NSString *item in params.allKeys) {
            [ps addObject:[NSString stringWithFormat:@"%@=%@", item, params[item]]];
        }
        NSMutableURLRequest * request = [NSMutableURLRequest
                                         requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/access_token"]
                                         cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [[ps componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
      NSURLSessionDataTask * task =  [[NSURLSession sharedSession] dataTaskWithRequest:request
                                        completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                            if (error == nil ) {
                                                NSError * jsonError;
                                             NSDictionary * tokenInfo =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
                                                if (jsonError) {
                                                    NSLog(@"%@", jsonError);
                                                }else{
                                                    NSLog(@"%@", tokenInfo);
                                                    Token(tokenInfo);
                                                }
                                            }
                                        }];
        
        [task resume];
        
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}
@end
