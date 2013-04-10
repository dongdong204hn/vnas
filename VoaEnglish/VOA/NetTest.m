//
//  NetTest.m
//  AEHTS
//
//  Created by zhao song on 12-11-30.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "NetTest.h"

@implementation NetTest
@synthesize isExisitNet = _isExisitNet;

#pragma mark - static method
+ (NetTest *)sharedNet
{
    static NetTest *sharedNet;
    
    @synchronized(self)
    {
        if (!sharedNet){
            sharedNet = [[NetTest alloc] init];
            sharedNet.isExisitNet = YES;
        }
        else{
        }
        return sharedNet;
    }
}

#pragma mark - Net Method
- (void)netEnable
{
    _isExisitNet = YES;
}

- (void)netDisable
{
    _isExisitNet = NO;
}

#pragma mark - ASI Delegate
- (void)catchNet
{
    NSString *url = @"http://www.apple.com";
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"catchnet"];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request.username isEqualToString:@"catchnet"]) {
        NSLog(@"专有网络");
        _isExisitNet = YES;
        return;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if ([request.username isEqualToString:@"catchnet"]) {
        NSLog(@"专无网络");
        _isExisitNet = NO;
        return;
    }
}

@end
