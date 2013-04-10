//
//  CollectViewController.h
//  VOA
//
//  Created by song zhao on 12-2-2.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "VOAView.h"
#import <PlausibleDatabase/PlausibleDatabase.h>
#import "VoaViewCell.h"
#import "SearchViewController.h"
#import "VOAFav.h"
#import "VOASentence.h"
#import "PlayViewController.h"
#import "SentenceViewController.h"

@interface CollectViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> 
{
    UITableView *voasTableView;
    UISegmentedControl *segmentedControl;

//    NSMutableArray *voasArray;
    NSMutableArray *favArray;
    NSMutableArray *senArray;
    UISearchBar *search;
    MBProgressHUD *HUD;
    BOOL isiPhone;
    BOOL isSentence;
    NSInteger nowUserId;
}

@property (nonatomic, retain) IBOutlet UITableView *voasTableView;

@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic) BOOL isSentence ;
//@property (nonatomic, retain) NSMutableArray *voasArray;
@property (nonatomic, retain) NSMutableArray *favArray;
@property (nonatomic, retain) NSMutableArray *senArray;
@property (nonatomic, retain) UISearchBar *search;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic) BOOL isiPhone;
@property (nonatomic) NSInteger nowUserId;

@end
