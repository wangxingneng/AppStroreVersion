//
//  AppStoreVersion.m
//  PIWindow
//
//  Created by xingneng.wang on 13-9-17.
//  Copyright (c) 2013年 xingneng.wang. All rights reserved.
//

#define kAppID @"869289425"
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#import "AppStoreVersion.h"

@implementation AppStoreVersion

+(void)checkVersion{
    NSString *storeString = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",kAppID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 && !error) {//success
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            //异步处理以下步骤
            dispatch_async(dispatch_get_main_queue(), ^{
                //如果由此App，resultCount = 1；
                if ([[appData objectForKey:@"resultCount"] intValue] == 1) {
                    NSString *appVersion = [[[appData objectForKey:@"results"] objectAtIndex:0] objectForKey:@"version"];
                    [AppStoreVersion showAlretWithAppStoreVersion:appVersion];
                }
            });
        }
    }];
}

+(void)showAlretWithAppStoreVersion:(NSString *)appStoreVersion{
    NSString *message = @"";
    //NSOrderedAscending :The left operand is smaller than the right operand
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    if ([version compare:appStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
        message = [NSString stringWithFormat:@"%@发布了新版本%@，请升级！",kAppName,appStoreVersion];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"版本升级" message:message delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"马上升级", nil];
        [alertView show];
    }
}

+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",kAppID]]];
    }
}

@end
