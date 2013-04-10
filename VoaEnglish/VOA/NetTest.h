//
//  NetTest.h
//  AEHTS
//
//  Created by zhao song on 12-11-30.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


@interface NetTest : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic) BOOL isExisitNet;

+ (NetTest *)sharedNet;
- (void)netEnable;
- (void)netDisable;
- (void)catchNet;

@end
