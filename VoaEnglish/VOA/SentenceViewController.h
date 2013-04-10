//
//  SentenceViewController.h
//  VOAAdvanced
//
//  Created by iyuba on 12-11-21.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayViewController.h"

@interface SentenceViewController : UIViewController{
    NSInteger row;
    NSInteger nowUserId;
    UITextView *SenEn;
    UITextView *SenCn;
//    UILabel *NowSen;
//    UIButton *OriText;
    MBProgressHUD *HUD;
    NSArray * sentences;
    UIImageView *myImageView;
    
}
@property (nonatomic, retain) IBOutlet UITextView *SenEn;
@property (nonatomic, retain) IBOutlet UITextView *SenCn;
//@property (nonatomic, retain) IBOutlet UILabel *NowSen;
@property (nonatomic, retain) IBOutlet UIImageView *myImageView;
//@property (nonatomic, retain) IBOutlet UIButton *OriText;
@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger nowUserId;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) NSArray *sentences;

//-(IBAction)goOriText:(id)sender;
-(IBAction)preSen:(id)sender;
-(IBAction)nextSen:(id)sender;
@end
