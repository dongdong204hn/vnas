//
//  NewViewController.h
//  VOA
//
//  Created by song zhao on 12-2-2.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "PlayViewController.h"
#import "VOAView.h"
#import <PlausibleDatabase/PlausibleDatabase.h>
#import "VoaViewCell.h"
#import "UIImageView+WebCache.h"
#import "SearchViewController.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "Reachability.h"//isExistenceNetwork
#import "EGORefreshTableHeaderView.h" 

@interface NewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate> 
{
    UITableView *voasTableView;
    UITableView *classTableView;
    NSMutableArray *voasArray;
    NSMutableArray *datesArray;
    NSMutableArray *localArray;
    NSArray *classArray;
    NSInteger nowSection;
    UISearchBar *search;
    NSString *catchData;
    MBProgressHUD *HUD;
    NSInteger lastId;
    NSInteger nowId;
    NSTimer *myTimer;
    NSInteger addNum;
    NSInteger addNumTwo;
    NSInteger addTimes;
    NSInteger pageNum;
    NSInteger category;
    UIButton *titleBtn;
//    BOOL isExisitNet;
    BOOL rightCharacter;
    BOOL _reloading; 
    BOOL isiPhone;
    EGORefreshTableHeaderView *_refreshHeaderView; 
    
}

@property (nonatomic, retain) NSTimer *myTimer;
@property (nonatomic, retain) NSMutableArray *voasArray;
@property (nonatomic, retain) NSMutableArray *datesArray;
@property (nonatomic, retain) NSMutableArray *localArray;
@property (nonatomic, retain) NSArray *classArray;
@property (nonatomic, retain) UIButton *titleBtn;
@property (nonatomic) NSInteger nowSection;
@property (nonatomic) NSInteger				lastId;
@property (nonatomic) NSInteger               nowId;
@property (nonatomic) NSInteger addNum;
@property (nonatomic) NSInteger addNumTwo;
@property (nonatomic) NSInteger addTimes;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger category;
//@property (nonatomic) BOOL isExisitNet;
@property (nonatomic) BOOL rightCharacter;
@property (nonatomic) BOOL reloading; 
@property (nonatomic) BOOL isiPhone;
@property (nonatomic) BOOL notSelect;
@property (nonatomic, retain) UISearchBar *search;
@property (nonatomic, retain) IBOutlet UITableView *voasTableView;
@property (nonatomic, retain) UITableView *classTableView;
@property (nonatomic, retain) NSString *catchData;
@property (nonatomic, retain) NSString *nowTitle;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView; 
@property (nonatomic, retain) ASIHTTPRequest *asiIntro;
@property (nonatomic, retain) NSOperationQueue *sharedSingleQueue;

//- (IBAction)doReturn:(id)sender;
- (void)catchIntroduction:(NSInteger)maxid pages:(NSInteger)pages pageNum:(NSInteger)pageNumOne;
- (void)catchDetails:(VOAView *)voaid;
-(BOOL) isExistenceNetwork:(NSInteger)choose;
- (void)reloadTableViewDataSource; 
- (void)doneLoadingTableViewData; 
//- (void)catchNetA;

@end
