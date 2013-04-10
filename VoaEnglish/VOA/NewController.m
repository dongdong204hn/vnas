//
//  NewViewController.m
//  VOA
//
//  Created by song zhao on 12-2-2.
//  Copyright (c) 2012年 buaa. All rights rese/Users/zhaosong/workplace/VOA/VOA/PlayViewController.xibrved.
//

#import "NewController.h"
#import "database.h"
#import "UIImageView+WebCache.h"

@implementation NewController

@synthesize localArray;
@synthesize category;
@synthesize nowTitle;
@synthesize classTableView;
@synthesize classArray;
@synthesize titleBtn;
@synthesize myTimer;
@synthesize voasArray;
@synthesize datesArray;
@synthesize nowSection;
@synthesize lastId;
@synthesize nowId;
@synthesize addNum;
@synthesize addNumTwo;
@synthesize addTimes;
@synthesize pageNum;
//@synthesize isExisitNet;
@synthesize rightCharacter;
@synthesize reloading = _reloading;
@synthesize isiPhone;
@synthesize search;
@synthesize voasTableView;
@synthesize catchData;
@synthesize HUD;
@synthesize refreshHeaderView;
@synthesize asiIntro;
@synthesize sharedSingleQueue;
@synthesize notSelect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        NSLog(@"%@",nibNameOrNil);

    }

    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - My Action
- (NSOperationQueue *)sharedQueue
{
//    static NSOperationQueue *sharedSingleQueue;
    
    @synchronized(self)
    {
        if (!sharedSingleQueue){
            sharedSingleQueue = [[NSOperationQueue alloc] init];
            [sharedSingleQueue setMaxConcurrentOperationCount:1];
        }
        return sharedSingleQueue;
    }
}

- (void)doReturn
{
    HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
    HUD.dimBackground = YES;
    HUD.labelText = @"connecting!";    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
        
        dispatch_async(dispatch_get_main_queue(), ^{  
            PlayViewController *play = [PlayViewController sharedPlayer];//新建新界面的controller实例
            if(play.voa._voaid > 0 )
            {
                play.newFile = NO;
            }else
            {
                play.newFile = YES;
                NSInteger voaid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastPlay"] integerValue];
                if (voaid > 0) {
                    play.voa = [VOAView find:voaid];
                    play.contentMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"contentMode"];
                    
                }else
                {
                    play.voa = [VOAView find:2];
                    play.voa._isRead = @"1";
                    play.contentMode =1;
                }
                play.category =0;
            }
            [play setHidesBottomBarWhenPushed:YES];//设置推到新界面时无bottomBar
            [self.navigationController pushViewController:play animated:NO]; 
            [HUD hide:YES];
        });  
    });
}

- (void)doSearch
{
    self.navigationController.navigationBarHidden = YES;
    if (classTableView.frame.size.height!=0.0) {
        [titleBtn setSelected:NO];
        
        [UIView beginAnimations:@"classAniOne" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseInOut];
        [self setMytitleUp];
        [titleBtn setBackgroundColor:[UIColor clearColor]];
        if (isiPhone) {
            [classTableView setFrame:CGRectMake(85, 0, 150, 0)];
        }else{
            [classTableView setFrame:CGRectMake(284, 0, 200, 0)];
        }
        [UIView commitAnimations];

    }
    if (isiPhone) {
        [search setFrame:CGRectMake(0, 0, 320, 44)];
        [voasTableView setFrame:CGRectMake(0, 44, 320, kViewHeight)];
    }else {
        [search setFrame:CGRectMake(0, 0, 768, 44)];
        [voasTableView setFrame:CGRectMake(0, 44, 768, kViewHeight)];
    }
    [search setHidden:NO];
}

//- (BOOL)isPad {
//	BOOL isPad = NO;
//#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
//	isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
//#endif
//	return isPad;
//}

- (void)doSwitch:(UIButton *) sender {
    if ([sender isSelected]) {
        [sender setSelected:NO];
        
        [UIView beginAnimations:@"classAniOne" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseInOut];
        [self setMytitleUp];
        [sender setBackgroundColor:[UIColor clearColor]];
        if (isiPhone) {
            [classTableView setFrame:CGRectMake(85, 0, 150, 0)];
        }else{
            [classTableView setFrame:CGRectMake(284, 0, 200, 0)];
        }
                [UIView commitAnimations];
    } else {
        [sender setSelected:YES];
        
        [UIView beginAnimations:@"classAniTwo" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve:UIViewAnimationOptionCurveEaseInOut];
        [self setMytitleDown];
        [sender setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44f]];
        if (isiPhone) {
            [classTableView setFrame:CGRectMake(85, 0, 150, 250)];

        } else {
            [classTableView setFrame:CGRectMake(284, 0, 200, 400)];

        }
                [UIView commitAnimations];
        
        //        [sender setBackgroundColor:[UIColor colorWithRed:0.44f green:0.44f blue:0.44f alpha:1.0f]];
    }
}
//↑
- (void)setMytitleUp{
    [titleBtn setTitle:[NSString stringWithFormat:@"%@ ∵", nowTitle] forState:UIControlStateNormal];
}

- (void)setMytitleDown{
    [titleBtn setTitle:[NSString stringWithFormat:@"%@ ∴", nowTitle] forState:UIControlStateNormal];
}


#pragma mark - View lifecycle

/*
 * 获取数据库中数据并存入voasArray，基于此数组数据建立tableView
 */
- (void) viewWillAppear:(BOOL)animated {
//    [self catchNetA];
    kNetTest;
    notSelect = YES;
//    [self setTitle:@"最新"];
//    isExisitNet = [self isExistenceNetwork:0];
    [self.voasTableView reloadData];//reloadData只能保证tableView重读数据，但是数据的改变要靠自己手动才行。
    [search setPlaceholder:kNewOne];
    self.navigationController.navigationBarHidden = NO;
    [voasTableView setUserInteractionEnabled:YES];
    if (isiPhone) {
        [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
        [search setFrame:CGRectMake(0, 0, 320, 44)];
    }else {
        [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
        [search setFrame:CGRectMake(0, 0, 768, 44)];
    }
    [search setBackgroundColor:[UIColor clearColor]];
	[search setHidden:YES];
    
    if (category == 10) {
        NSArray *favViews = [VOAFav findCollect];
        [localArray removeAllObjects];
        for (id fav in favViews) {
            [localArray addObject:fav];
        }
        [self.voasTableView reloadData];
        [favViews release], favViews = nil;
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    isExisitNet = NO;
    self.title = kNewThree;
    isiPhone = ![Constants isPad];
    
    voasArray = [[NSMutableArray alloc]init];
    localArray= [[NSMutableArray alloc]init];
    NSArray *favViews = [VOAFav findCollect];
    for (id fav in favViews) {
        [localArray addObject:fav];
    }
    [self.voasTableView reloadData];
    [favViews release], favViews = nil;
    
    search = [[UISearchBar alloc] init];
    search.delegate = self;
    [self.view addSubview:search];
    [search release];//$$
   
    classArray = [[NSArray alloc] initWithObjects:kClassAll,kClassTwo,kClassThree,kClassFour,kClassFive,kClassSix,kClassSeven,kClassEight,kClassNine,kClassTen,nil];
    if (isiPhone) {
        classTableView = [[UITableView alloc] initWithFrame:CGRectMake(85, 0, 150, 0)];

    } else {
        classTableView = [[UITableView alloc] initWithFrame:CGRectMake(284, 0, 200, 0)];

    }
    [classTableView setTag:2];
    classTableView.dataSource = self;
    [classTableView setDelegate:self];
    [classTableView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.44]];
    [classTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:classTableView];
    [classTableView release];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(doSearch)];
	self.navigationItem.leftBarButtonItem = editButton;
    [editButton release], editButton = nil;
    
    UIBarButtonItem *returnButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"playingBBC.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doReturn)];
    self.navigationItem.rightBarButtonItem = returnButton;
    [returnButton release], returnButton = nil;
   
    search.backgroundImage = [UIImage imageNamed:@"title.png"];
//    [search setKeyboardType:UIKeyboardAppearanceAlert];
//    search.backgroundColor = [UIColor clearColor];
//    self.title = kNewThree;
    if (isiPhone) {
        titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    } else {
        titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    }
    
    [titleBtn setBackgroundColor:[UIColor clearColor]];
    //    [[titleBtn layer] setCornerRadius:5.0f];
    //    [[titleBtn layer] setMasksToBounds:YES];
    //    [titleBtn setTitle:@"全部" forState:UIControlStateNormal];
    category = 0;
    nowTitle = kClassAll;
    [self setMytitleUp];
    [titleBtn addTarget:self action:@selector(doSwitch:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    [titleBtn release];

    
//    HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
//    HUD.dimBackground = YES;
//    HUD.labelText = kNewFour;
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
//        
//        dispatch_async(dispatch_get_main_queue(), ^{  
            self.lastId = [VOAView findLastId];
//            isExisitNet = [self isExistenceNetwork:0];
            pageNum = 1;
//            if (isExisitNet) {
//                [self catchIntroduction:0 pages:pageNum pageNum:10 ];
//            }
            self.voasArray = [VOAView findNew:10*(pageNum-1) newVoas:self.voasArray];
            pageNum++;
            addNum = 10;
//            NSLog(@"lastId:%d",lastId);
            [self.voasTableView reloadData];
//            [HUD hide:YES];
//        });  
//    }); 
    if(_refreshHeaderView == nil){
        EGORefreshTableHeaderView *view =[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.voasTableView.bounds.size.height, self.voasTableView.bounds.size.width, self.voasTableView.bounds.size.height)];
        view.delegate = self;
        [self.voasTableView addSubview:view];
        _refreshHeaderView = view;
        [view release];
    }
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];

}

- (void)viewDidUnload
{
    self.voasTableView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [self.voasTableView release], voasTableView = nil;
    [self.myTimer release], myTimer = nil;
    [self.voasArray release], voasArray = nil;
    [self.datesArray release], datesArray = nil;
    [self.catchData release], catchData = nil;
    [self.sharedSingleQueue release], sharedSingleQueue = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods
-(void)reloadTableViewDataSource{
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    
//    NSLog(@"isExisitNet:%d",isExisitNet);
    if (kNetIsExist) {
//        NSLog(@"开始刷新");
        
        [self catchIntroduction:0 pages:1 pageNum:10 ];
        
//        pageNum = 1;
//        NSArray *voas = [[NSArray alloc] init];
//        //    NSLog(@"获取生词到:%d",nowUserId);
//        voas = [VOAView findNew:10*(pageNum-1) newVoas:self.voasArray];;
//        [voasArray removeAllObjects];
//        for (id fav in voas) {
//            [voasArray addObject:fav];
//        }
//        pageNum++;
//        addNum = 10;
//        [voas release], voas = nil;
        
//        [self.voasArray removeAllObjects];
//        [self catchIntroduction:0 pages:1 pageNum:10 ];
//        pageNum = 1;
//        self.voasArray = [VOAView findNew:10*(pageNum-1) newVoas:self.voasArray];
//        pageNum++;
//        addNum = 10;
        
    }
    _reloading =YES;
//    [self doneLoadingTableViewData];
}
-(void)doneLoadingTableViewData{
    //  model should call this when its done loading
    if (_reloading) {
        _reloading =NO;
        
        if (kNetIsExist) {
            
            [self.voasArray removeAllObjects];
            self.lastId = [VOAView findLastId];
            pageNum = 1;
            addNum = 1;
            if (category == 0) {
                self.voasArray = [VOAView findNew:10*(pageNum-1) newVoas:self.voasArray];
            } else if (category<10) {
                self.voasArray = [VOAView findNewByCategory:10*(pageNum-1) category:category myArray:self.voasArray];
            } else {
                
            }
            pageNum++;
            addNum = 10;
            [self.voasTableView reloadData];
            
        }
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.voasTableView];    
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
//    NSThread * thread = [[NSThread alloc] initWithTarget:self selector:@selector(reloadTableViewDataSource) object:nil];
//    [thread start];
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:6.0];
}
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
}
-(NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return[NSDate date]; // should return date data source was last changed
}

#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView //明确cell数目
 numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"number：%i", (tableView.tag == 1? (category == 10? [localArray count]: [voasArray count]+2): [classArray count]));
//    NSLog(@"table:%d",tableView.tag);
    return (tableView.tag == 1? (category == 10? [localArray count]: [voasArray count]+2): [classArray count]);}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        if (category == 10) {
//            NSLog(@"本地");
            NSUInteger row = [indexPath row];
            static NSString *FirstLevelCell= @"CollectCell";
            
            VoaViewCell *cell = (VoaViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
            
            if (!cell) {
                
                if (isiPhone) {
                    cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell"
                                                                        owner:self
                                                                      options:nil] objectAtIndex:0];
                }else {
                    cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell-iPad"
                                                                        owner:self
                                                                      options:nil] objectAtIndex:0];
                }
            }
            //            NSUInteger row = [indexPath row];
            
//            NSLog(@"fav:%i", row);
            VOAFav *fav = [localArray objectAtIndex:row];
            
            VOAView *voa = [VOAView find:fav._voaid];
            
            cell.myTitle.text = voa._title;
            
            cell.myDate.text = voa._creatTime;
            
            cell.collectDate.text = fav._date;
            
            //--------->设置内容换行
            [cell.myTitle setLineBreakMode:UILineBreakModeClip];
            
            //--------->设置最大行数
            [cell.myTitle setNumberOfLines:3];
            
            NSURL *url = [NSURL URLWithString: voa._pic];
            
            [cell.myImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"acquiesceBBC.png"]];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //            if (voa._hotFlg.integerValue == 1) {
            //
            //                [cell.hotImg setHidden:NO];
            //
            //                //        NSLog(@"hot:1");
            //            }
            [voa release];
            return cell;
        } else {
//            NSLog(@"全部");
            NSUInteger row = [indexPath row];
            if ([indexPath row]<[voasArray count]) {
                static NSString *FirstLevelCell= @"NewCell";
                VOAView *voa = [self.voasArray objectAtIndex:row];
                
                //        NSLog(@"-----cell id:%d",voa._voaid);
                VoaViewCell *cell = (VoaViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
                
                if (!cell) {
                    if (isiPhone) {
                        cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell"
                                                                            owner:self
                                                                          options:nil] objectAtIndex:0];
                    }else {
                        cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell-iPad"
                                                                            owner:self
                                                                          options:nil] objectAtIndex:0];
                    }
                    
                }
                cell.myTitle.text = voa._title;
                cell.myDate.text = voa._creatTime;
                //--------->设置内容换行
                [cell.myTitle setLineBreakMode:UILineBreakModeClip];
                //--------->设置最大行数
                [cell.myTitle setNumberOfLines:3];
                NSURL *url = [NSURL URLWithString: voa._pic];
                [cell.myImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"acquiesce.png"]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                //        NSLog(@"readmy:%@",voa._isRead);
                if ([VOAView isRead:voa._voaid]) {
                    [cell.readImg setImage:[UIImage imageNamed:@"detailRead-ipad.png"]];
                }else
                {
                    //                    [cell.myTitle setTextColor:[UIColor redColor]];
                    //                    [cell.myDate setTextColor:[UIColor redColor]];
                    //                    [cell.readImg setImage:[UIImage imageNamed:@"detail-ipad.png"]];
                    [cell.hotImg setHidden:NO];
                    
                }
                if (voa._hotFlg.integerValue == 1) {
                    //            NSLog(@"hot:1");
                }
                
                return cell;
            }else
            {
                if ([indexPath row]==[voasArray count]) {
                    static NSString *SecondLevelCell= @"NewCellOne";
                    UITableViewCell *cellTwo = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:SecondLevelCell];
                    //            if (addNum > 0) {
                    //                if (!cellTwo) {
                    //                    //                cellTwo = [[UITableViewCell alloc]init];
                    //                    //                cellTwo = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondLevelCell] autorelease];
                    //                    if (isiPhone) {
                    //                        cellTwo = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondLevelCell] autorelease];
                    //                    }else {
                    //                        cellTwo = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaImageCell-iPad"
                    //                                                                               owner:self
                    //                                                                             options:nil] objectAtIndex:0];
                    //                    }
                    //                }
                    //                [cellTwo setSelectionStyle:UITableViewCellSelectionStyleNone];
                    //                //                cellTwo.imageView.contentMode = UIViewContentModeScaleToFill;
                    //                //                if (isiPhone) {
                    //                [cellTwo.imageView setImage:[UIImage imageNamed:@"load.png"]];
                    //                //                } else {
                    //                //                    [cellTwo.imageView setImage:[UIImage imageNamed:@"load-ipad.png"]];
                    //                //                }
                    //            } else {
                    //                [cellTwo setHidden:YES];
                    //            }
                    if (!cellTwo) {
                        //                cellTwo = [[UITableViewCell alloc]init];
                        //                cellTwo = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondLevelCell] autorelease];
                        if (isiPhone) {
                            cellTwo = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondLevelCell] autorelease];
                        }else {
                            cellTwo = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaImageCell-iPad"
                                                                                   owner:self
                                                                                 options:nil] objectAtIndex:0];
                        }
                    }
                    [cellTwo setSelectionStyle:UITableViewCellSelectionStyleNone];
                    //            NSLog(@"cell width:%f",cellTwo.frame.size.width);
                    //            if (isiPhone) {
                    //                [cellTwo setFrame:CGRectMake(0, 0, 320, 28)];
                    //                [cellTwo.imageView setFrame:CGRectMake(0, 0, 320, 28)];
                    //            } else {
                    //                [cellTwo setFrame:CGRectMake(0, 0, 768, 28)];
                    //                [cellTwo.imageView setFrame:CGRectMake(0, 0, 768, 28)];
                    //            }
                    //            NSLog(@"cell width after:%f",cellTwo.frame.size.width);
                    if (addNum > 0) {
                        //                cellTwo.imageView.contentMode = UIViewContentModeScaleToFill;
                        if (isiPhone) {
                            [cellTwo.imageView setImage:[UIImage imageNamed:@"load.png"]];
                        }
                    } else {
                        [cellTwo setHidden:YES];
                    }
                    //            NSLog(@"width:%f",cellTwo.imageView.frame.size.width);
                    return cellTwo;
                }else
                {
                    if ([indexPath row]==[voasArray count]+1) {
                        //                NSLog(@"enter");
                        static NSString *ThirdLevelCell= @"NewCellTwo";
                        UITableViewCell *cellThree = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ThirdLevelCell];
                        if (!cellThree) {
                            cellThree = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ThirdLevelCell] autorelease];
                            //                    cellThree = [[UITableViewCell alloc]init];
                        }
                        //                UITableViewCell *cellThree = [[UITableViewCell alloc]init];
                        [cellThree setSelectionStyle:UITableViewCellSelectionStyleNone];
                        [cellThree setHidden:YES];
                        if (row>lastId) {
                        } else
                        {
                            //                    NSLog(@"重新加载");
                            
                            if (kNetIsExist) {
                                //                        NSLog(@"lastId:%d",lastId);
                                if (addNum>0) {
                                    //                            NSLog(@"联网重新加载");
                                    [self catchIntroduction:(0) pages:pageNum pageNum:10];
                                }
                            }else {
                                NSMutableArray *addArray = [[NSMutableArray alloc]init];
                                if (category == 0) {
                                    addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
                                } else if (category<10) {
                                    addArray = [VOAView findNewByCategory:10*(pageNum-1) category:category myArray:addArray];
                                } else {
                                    
                                }
                                
                                //                            addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
                                pageNum ++;
                                addNum = 0;
                                for (VOAView *voaOne in addArray) {
                                    [self.voasArray addObject:voaOne];
                                    addNum++;
                                }
                                [addArray release],addArray = nil;
                                
                                [self.voasTableView reloadData];
                                
                            }
                            //                    NSLog(@"lastId2:%d",lastId);
                            
                            //                    NSMutableArray *addArray = [[NSMutableArray alloc]init];
                            //                    addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
                            //                    pageNum ++;
                            //                    addNum = 0;
                            //                    for (VOAView *voaOne in addArray) {
                            //                        [self.voasArray addObject:voaOne];
                            //                        addNum++;
                            //                    }
                            //                    [addArray release],addArray = nil;
                            //
                            //                    [self.voasTableView reloadData];
                        }
                        return cellThree;
                    }
                }
            }
        }
    } else {
        NSUInteger row = [indexPath row];
        UIFont *classFo;
        if (isiPhone) {
            classFo = [UIFont systemFontOfSize:16];
        } else {
            classFo = [UIFont systemFontOfSize:18];
        }
       
        //            UIFont *classFoPad = [UIFont systemFontOfSize:20];
        static NSString *ClsssCell= @"ClsssCell";
        UITableViewCell *cellThree = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ClsssCell];
        if (!cellThree) {
            cellThree = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ClsssCell] autorelease];
            UILabel *classLabel = [[UILabel alloc] init];
            if (isiPhone) {
                [classLabel setFrame:CGRectMake(50, 0, 50, 25)];
                [classLabel setFont:classFo];
            } else {
                [classLabel setFrame:CGRectMake(75, 0, 50, 40)];
                [classLabel setFont:classFo];
            }
            
            [classLabel setBackgroundColor:[UIColor clearColor]];
            [classLabel setTag:1];
            [classLabel setTextColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8f]];
            [classLabel setTextAlignment:NSTextAlignmentCenter];
            //            [wordLabel setTextColor:[UIColor colorWithRed:0.112f green:0.112f blue:0.112f alpha:1.0f]];
            //            [wordLabel  setLineBreakMode:UILineBreakModeClip];
            //            [wordLabel setNumberOfLines:1];
            [cellThree addSubview:classLabel];
            [classLabel release];
        }
        
        for (UIView *nLabel in [cellThree subviews]) {
            
            if (nLabel.tag == 1) {
                [(UILabel*)nLabel setText:[classArray objectAtIndex:row]];
            }
            
        }
        
        [cellThree setSelectionStyle:UITableViewCellSelectionStyleGray];
        cellThree.backgroundColor = [UIColor clearColor];
        //        [cellThree.textLabel setText:[classArray objectAtIndex:row]];
        //        [cellThree.textLabel setTextAlignment:NSTextAlignmentRight];
        //        [cellThree.textLabel setBackgroundColor:[UIColor clearColor]];
        //        [cellThree.textLabel setTextColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8f]];
        return cellThree;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((tableView.tag == 1)? ( category == 10? (isiPhone?80.0f:160.0f):(([indexPath row]<[voasArray count])?(isiPhone?80.0f:160.0f):(([indexPath row]==[voasArray count]+1)?1.0f:(isiPhone?28.0f:48.0f)))): (isiPhone?25.0f:40.0f));
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self catchNetA];
    kNetTest;
    NSInteger row = [indexPath row];
    if (tableView.tag == 1) {
        if (classTableView.frame.size.height < 200.f) {
            if (search.isFirstResponder) {
                [self.search resignFirstResponder];
                NSString *searchWords =  [self.search text];
                if (searchWords.length == 0) {
                }else
                {
                    self.navigationController.navigationBarHidden = NO;
                    
                    if (category == 10) {
                        NSMutableArray *allVoaArray = localArray;
                        NSMutableArray *contentsArray = nil;
                        contentsArray = [VOAView findFavSimilar:allVoaArray search:searchWords];
                        //                NSLog(@"count:%d", [contentsArray count]);
                        
                        if ([contentsArray count] == 0) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kColFour message:[NSString stringWithFormat:@"%@ %@ %@",kSearchThree,searchWords,kColThree] delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil, nil ];
                            [alert show];
                            [alert release];
                            [contentsArray release];
                        }else
                        {
                            search.text = @"";
                            SearchViewController *searchController = [SearchViewController alloc];
                            searchController.searchWords = searchWords;
                            searchController.contentsArray = contentsArray;
                            searchController.contentMode = 2;
                            [contentsArray release];
                            searchController.searchFlg = 11;
                            [self.navigationController pushViewController:searchController animated:YES];
                            [searchController release], searchController = nil;
                        }
                    } else {
                        if (isiPhone) {
                            [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                            
                            [search setFrame:CGRectMake(0, 0, 320, 44)];
                        }else {
                            [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                            [search setFrame:CGRectMake(0, 0, 768, 44)];
                        }
                        
                        [search setHidden:YES];
                        search.text = @"";
                        SearchViewController *searchController = [SearchViewController alloc];
                        searchController.searchWords = searchWords;
                        searchController.searchFlg = category;
                        searchController.contentMode = 1;
                        searchController.category = category;
                        [self.navigationController pushViewController:searchController animated:YES];
                        [searchController release], searchController = nil;
                    }
                    
                }
            }else{
                if (!search.isHidden) {
                    self.navigationController.navigationBarHidden = NO;
                    if (isiPhone) {
                        [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                        [search setFrame:CGRectMake(0, 0, 320, 44)];
                                            }else {
                        [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                        [search setFrame:CGRectMake(0, 0, 768, 44)];
                    }
                    [search setHidden:YES];
                    search.text = @"";
                }else{
                    if (category == 10) {
                        NSUInteger row = [indexPath row];
                        
                        VOAFav *fav = [localArray objectAtIndex:row];
                        
                        HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
                        
                        HUD.dimBackground = YES;
                        
                        HUD.labelText = @"connecting!";
                        
                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                VOAView *voa = [VOAView find:fav._voaid];
                                PlayViewController *play = [PlayViewController sharedPlayer];//新建新界面的controller实例
                                if(play.voa._voaid == voa._voaid)
                                {
                                    play.newFile = NO;
                                }else
                                {
                                    play.newFile = YES;
                                    play.voa = voa;
                                }
                                [voa release];
                                [play setHidesBottomBarWhenPushed:YES];//设置推到新界面时无bottomBar
                                if (play.contentMode != 2) {
                                    play.flushList = YES;
                                    play.contentMode = 2;
                                }
                                [self.navigationController pushViewController:play animated:NO];
                                [HUD hide:YES];
                            });
                        });
                    } else {
                        if ([indexPath row]<[voasArray count]) {
                            if (notSelect) {
                                notSelect = NO;
                                [voasTableView setUserInteractionEnabled:NO];
                                NSUInteger row = [indexPath row];
                                VOAView *voa = [self.voasArray objectAtIndex:row];
                                //                NSLog(@"PIC:%@,MP3:%@",voa._pic,voa._sound);
                                if ([voa._pic isEqualToString:@""] || [voa._pic isEqualToString:@"null"] || voa._pic == nil) {
                                    [VOAView deleteByVoaid:voa._voaid];
                                    [self.voasTableView reloadData];
                                } else {
                                    if ([VOADetail isExist:voa._voaid] || [self isExistenceNetwork:1]) {
                                        HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
                                        HUD.dimBackground = YES;
                                        HUD.labelText = @"connecting!";
                                        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                VOADetail *myDetail = [VOADetail find:voa._voaid];
                                                if (!myDetail) {
                                                    //                                    NSLog(@"内容不全-%d",voa._voaid);
                                                    if (kNetIsExist) {
                                                        [VOADetail deleteByVoaid: voa._voaid];
                                                        //                                        NSLog(@"voaid:%i",voa._voaid);
                                                        [self catchDetails:voa];
                                                    }else {
                                                        rightCharacter = NO;
                                                    }
                                                }else {
                                                    [myDetail release];
                                                    rightCharacter = YES;
                                                }//获取所选的cell的数据
                                                if (rightCharacter) {
                                                    //                                NSLog(@"内容完整-%d",voa._voaid);
                                                    //                                if ([VOADetail find:voa._voaid]) {
                                                    PlayViewController *play = [PlayViewController sharedPlayer];//新建新界面的controller实例
//                                                    play.isExisitNet = isExisitNet;
                                                    if(play.voa._voaid == voa._voaid)
                                                    {
                                                        play.newFile = NO;
                                                    }else
                                                    {
                                                        play.newFile = YES;
                                                        play.voa = voa;
                                                    }
                                                    voa._isRead = @"1";//保证界面上显示已读
                                                    if (!(play.contentMode == 1 && play.category == category)) {
                                                        play.flushList = YES;
                                                        play.contentMode = 1;
                                                        play.category = category;
                                                    }
                                                    
                                                    [play setHidesBottomBarWhenPushed:YES];//设置推到新界面时无bottomBar
                                                    [self.navigationController pushViewController:play animated:NO];
                                                    [HUD hide:YES];
                                                    //                                }
                                                }else {
                                                    notSelect = YES;
                                                    [HUD hide:YES];
                                                    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:kColFour message:kNewFive delegate:self cancelButtonTitle:kWordFour otherButtonTitles:nil ,nil];
                                                    [addAlert show];
                                                    [addAlert release];
                                                    [voasTableView setUserInteractionEnabled:YES];
                                                }
                                            });
                                        });
                                    }
                                    else
                                    {
                                        notSelect = YES;
                                        [voasTableView setUserInteractionEnabled:YES];
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        } else {
            [self doSwitch:titleBtn];
        }
        
    } else {
        //        [titleBtn setTitle:[classArray objectAtIndex:row] forState:UIControlStateNormal];
        category = row ;
        nowTitle = [classArray objectAtIndex:row];
        [self doSwitch:titleBtn];
        
        [self.voasArray removeAllObjects];
        self.lastId = [VOAView findLastId];
        pageNum = 1;
        //        addNum = 1;
        if (category == 0) {
            self.voasArray = [VOAView findNew:10*(pageNum-1) newVoas:self.voasArray];
        } else if (category<10) {
            self.voasArray = [VOAView findNewByCategory:10*(pageNum-1) category:category myArray:self.voasArray];
        } else {
            
        }
        pageNum++;
        addNum = 10;
        [self.voasTableView reloadData];
        [self.voasTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *searchWords =  [searchBar text];
    if (searchWords.length == 0) {
    }else
    {
        self.navigationController.navigationBarHidden = NO;
        
        if (category == 10) {
            NSMutableArray *allVoaArray = localArray;
            NSMutableArray *contentsArray = nil;
            contentsArray = [VOAView findFavSimilar:allVoaArray search:searchWords];
            //                NSLog(@"count:%d", [contentsArray count]);
            
            if ([contentsArray count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kColFour message:[NSString stringWithFormat:@"%@ %@ %@",kSearchThree,searchWords,kColThree] delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil, nil ];
                [alert show];
                [alert release];
                [contentsArray release];
            }else
            {
                search.text = @"";
                SearchViewController *searchController = [SearchViewController alloc];
                searchController.searchWords = searchWords;
                searchController.contentsArray = contentsArray;
                searchController.contentMode = 2;
                [contentsArray release];
                searchController.searchFlg = 11;
                [self.navigationController pushViewController:searchController animated:YES];
                [searchController release], searchController = nil;
            }
        } else {
            if (isiPhone) {
                [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                
                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }else {
                [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 768, 44)];
            }
            
            [search setHidden:YES];
            search.text = @"";
            SearchViewController *searchController = [SearchViewController alloc];
            searchController.searchWords = searchWords;
            searchController.searchFlg = category;
            searchController.contentMode = 1;
            searchController.category = category;
            [self.navigationController pushViewController:searchController animated:YES];
            [searchController release], searchController = nil;
        }
//        if (isiPhone) {
//            [voasTableView setFrame:CGRectMake(0, 0, 320, 372)];
//            [search setFrame:CGRectMake(0, 0, 320, 44)];
//        }else {
//            [voasTableView setFrame:CGRectMake(0, 0, 768, 372+544)];
//            [search setFrame:CGRectMake(0, 0, 768, 44)];
//        }
//        [search setHidden:YES];
//        HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
//        HUD.dimBackground = YES;
//        HUD.labelText = @"connecting!";
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
//            dispatch_async(dispatch_get_main_queue(), ^{  
//                searchBar.text = @"";
//                SearchViewController *searchController = [[SearchViewController alloc]init];
//                searchController.searchWords = searchWords;
//                searchController.searchFlg = 0;
//                searchController.contentMode = 1;
//                searchController.category  = [NSString stringWithFormat:@"0"];
//                [self.navigationController pushViewController:searchController animated:YES];
//                [searchController release], searchController = nil;
//                [HUD hide:YES];
//            });  
//        });
    }

}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.navigationController.navigationBarHidden = NO;
    if (isiPhone) {
        [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
        [search setFrame:CGRectMake(0, 0, 320, 44)];
    }else {
        [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
        [search setFrame:CGRectMake(0, 0, 768, 44)];
    }
    [search setHidden:YES];
    search.text = @"";
    
}

#pragma mark - Http connect
- (void)catchIntroduction:(NSInteger)maxid pages:(NSInteger)pages pageNum:(NSInteger)pageNumOne{
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/titleApi.jsp?maxid=%d&type=iOS&format=xml&pages=%d&pageNum=%d&parentID=%d",maxid,pages,pageNumOne,category];
//    NSLog(@"url:%@",url);
//    if (asiIntro ) {
//        [asiIntro release], asiIntro = nil;
//    }
//    asiIntro = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
////    [asiIntro setURL:[NSURL URLWithString:url]];
////        ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    asiIntro.delegate = self;
//    [asiIntro setUsername:@"new"];
//    [asiIntro startSynchronous];
    
//    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    request.delegate = self;
//    [request setUsername:@"new"];
//    [request startAsynchronous];
    
//    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//     [request setDelegate:self];
//    [request setUsername:@"new"];
//    [request startAsynchronous];
    
    NSOperationQueue *myQueue = [self sharedQueue];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setUsername:@"new"];
//    [request setDidStartSelector:@selector(requestMyStarted:)];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [myQueue addOperation:request];
}

//- (void)catchNetA
//{
//    NSString *url = @"http://www.baidu.com";
////    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    request.delegate = self;
//    [request setUsername:@"catchnet"];
//    [request startAsynchronous];
//}

- (void)catchDetails:(VOAView *) voaid
{
//    NSLog(@"获取内容-%d",voaid._voaid);
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/textApi.jsp?voaid=%d&format=xml",voaid._voaid];
//    NSLog(@"catch:%d",voaid._voaid);
//    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"detail"];
    [request setTag:voaid._voaid];
    [request startSynchronous];
//    [request release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
//    isExisitNet = NO;
    kNetDisable;
    if ([request.username isEqualToString:@"detail"])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:kColFour message:kNewSix delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
        [HUD hide:YES];
        [self.voasTableView setUserInteractionEnabled:YES];
    }
//    else {
////            if ([request.username isEqualToString:@"catchnet"]) {
//                //                NSLog(@"无网络");
//        
////            }
//    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    kNetDisable;
//        if ([request.username isEqualToString:@"new"]) {
    NSMutableArray *addArray = [[NSMutableArray alloc]init];
//    addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
    if (category == 0) {
        addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
    } else if (category<10) {
        addArray = [VOAView findNewByCategory:10*(pageNum-1) category:category myArray:addArray];
    } else {
        
    }

    
    pageNum ++; 
    addNum = 0;
    for (VOAView *voaOne in addArray) {
        [self.voasArray addObject:voaOne];
        addNum++;
    }
    [addArray release],addArray = nil;
    
    [self.voasTableView reloadData];
//        }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    kNetEnable;
    if ([request.username isEqualToString:@"catchnet"]) {
        //        NSLog(@"有网络");
//        isExisitNet = YES;
        notSelect = YES;
        [voasTableView setUserInteractionEnabled:YES];
        return;
    }
    rightCharacter = NO;
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"detail"]) {
        NSArray *items = [doc nodesForXPath:@"data/voatext" error:nil];
        if (items) {
            
            for (DDXMLElement *obj in items) {
                rightCharacter = YES;
                //                    NSLog(@"222");
                VOADetail *newVoaDetail = [[VOADetail alloc] init];
                newVoaDetail._voaid = request.tag ;
                //                    NSLog(@"id:%d",newVoaDetail._voaid);
                newVoaDetail._paraid = [[[obj elementForName:@"ParaId"] stringValue]integerValue];
                newVoaDetail._idIndex = [[[obj elementForName:@"IdIndex"] stringValue]integerValue];             
                newVoaDetail._timing = [[[obj elementForName:@"Timing"] stringValue]integerValue];
                newVoaDetail._sentence = [[[[obj elementForName:@"Sentence"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"]stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
                newVoaDetail._imgWords = [[[obj elementForName:@"ImgWords"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                newVoaDetail._imgPath = [[obj elementForName:@"ImgPath"] stringValue];
                newVoaDetail._sentence_cn = [[[[[obj elementForName:@"sentence_cn"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
                if ([newVoaDetail insert]) {
                    //                        NSLog(@"插入%d成功",newVoaDetail._voaid);
                }
                [newVoaDetail release],newVoaDetail = nil;
                
            }
            
        } 
    }
    [doc release],doc = nil;
//    [request release], request = nil;
}

- (void)requestDone:(ASIHTTPRequest *)request
{
    kNetEnable;
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"new" ]) {
        /////解析
        NSArray *items = [doc nodesForXPath:@"data" error:nil];
//        if (items) {
//            for (DDXMLElement *obj in items) {
//                NSInteger total = [[[obj elementForName:@"total"] stringValue] integerValue] ;
//                NSLog(@"total:%d",total);
//            }
//        }
        items = [doc nodesForXPath:@"data/voatitle" error:nil];
        if (items) {
            BOOL flushList = NO;
            for (DDXMLElement *obj in items) {
                VOAView *newVoa = [[VOAView alloc] init];
                newVoa._voaid = [[[obj elementForName:@"voaid"] stringValue] integerValue] ;
                if (lastId<newVoa._voaid) {
                    lastId = newVoa._voaid;
                }
                newVoa._title = [[obj elementForName:@"Title"] stringValue];
                newVoa._descCn = [[[obj elementForName:@"DescCn"] stringValue] stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                newVoa._title_Cn = [[[obj elementForName:@"Title_cn"] stringValue] isEqualToString: @" null"] ? nil :[[obj elementForName:@"Title_cn"] stringValue];
                newVoa._category = [[obj elementForName:@"Category"] stringValue];
                newVoa._sound = [[obj elementForName:@"Sound"] stringValue];
                newVoa._url = [[obj elementForName:@"Url"] stringValue];
                newVoa._pic = [[obj elementForName:@"Pic"] stringValue];
                newVoa._creatTime = [[obj elementForName:@"CreatTime"] stringValue];
                newVoa._publishTime = [[obj elementForName:@"PublishTime"] stringValue] == @" null" ? nil :[[obj elementForName:@"PublishTime"] stringValue];
                newVoa._readCount = [[obj elementForName:@"ReadCount"] stringValue];
                newVoa._hotFlg = [[obj elementForName:@"HotFlg"] stringValue];
                newVoa._isRead = @"0";
                if ([VOAView isExist:newVoa._voaid] == NO) {
                    [newVoa insert];
//                    [self catchDetails:newVoa];
                    flushList = YES;
//                    NSLog(@"插入%d成功",newVoa._voaid);
                }else {
//                    NSLog(@"已有");
                }
                [newVoa release],newVoa = nil;
            }
            if (flushList) {
                PlayViewController *player = [PlayViewController sharedPlayer];
                //                if (player.playMode == 3) {
                player.flushList = YES;  
                //                }
                flushList = NO;
            }
            NSMutableArray *addArray = [[NSMutableArray alloc]init];
            if (category == 0) {
                addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
            } else if (category<10) {
                addArray = [VOAView findNewByCategory:10*(pageNum-1) category:category myArray:addArray];
            } else {
                
            }
            //            addArray = [VOAView findNew:10*(pageNum-1) newVoas:addArray];
            pageNum ++;
            addNum = 0;
            for (VOAView *voaOne in addArray) {
                [self.voasArray addObject:voaOne];
                addNum++;
            }
            [addArray release],addArray = nil;
            [self.voasTableView reloadData];
        }
        else{
        }
        [self doneLoadingTableViewData];//下拉刷新获取数据后立即结束刷新
    }
    [doc release],doc = nil;
//    [request release], request = nil;
}

-(BOOL) isExistenceNetwork:(NSInteger)choose
{
    UIAlertView *myalert = nil;
    switch (choose) {
        case 0:
            
            break;
        case 1:
            if (kNetIsExist) {
                
            }else {
                myalert = [[UIAlertView alloc] initWithTitle:kInfoTwo message:kRegNine delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil,nil];
                [myalert show];
                [myalert release];
            }
            break;
        default:
            break;
    }    
	return kNetIsExist;
}

//-(BOOL) isExistenceNetwork:(NSInteger)choose
//{
//	BOOL isExistenceNetwork;
//	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//			isExistenceNetwork=FALSE;
//            break;
//        case ReachableViaWWAN:
//			isExistenceNetwork=TRUE;
//            break;
//        case ReachableViaWiFi:
//			isExistenceNetwork=TRUE;     
//            break;
//    }
//	if (!isExistenceNetwork) {
//        UIAlertView *myalert = nil;
//        switch (choose) {
//            case 0:
//                
//                break;
//            case 1:
//                myalert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"您还没有网络连接,请收听本地中新闻" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//                [myalert show];
//                [myalert release];
//                break;
//            default:
//                break;
//        }
//	}
//	return isExistenceNetwork;
//}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!search.isHidden) {
        self.navigationController.navigationBarHidden = NO;
        if (isiPhone) {
            [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 320, 44)];
        }else {
            [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 768, 44)];
        }
        [search setHidden:YES];
        search.text = @"";
    }
}

@end
