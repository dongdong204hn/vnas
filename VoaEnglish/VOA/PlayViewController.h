//
//  PlayViewControl.h
//  VOA
//
//  Created by song zhao on 12-2-6.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "VOAView.h"
#import "VOAFav.h"
#import "VOADetail.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "timeSwitchClass.h"
#import "DataBaseClass.h"
#import "LyricSynClass.h"
#import "MP3PlayerClass.h"
#import "VOAContent.h"
#import "ASIFormDataRequest.h"
#import "TextScrollView.h"
#import "MyLabel.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "VOAWord.h"
#import "MBProgressHUD.h"
//#import "AudioStreamer.h"
#import "Reachability.h"//isExistenceNetwork
#import "LogController.h"
#import "MyPageControl.h"
#import "GADBannerView.h"
#import "SevenProgressBar.h"
#import "ShareToCNBox.h"
#import "SVShareTool.h"
#include <AudioToolbox/AudioToolbox.h>
//#import "CommentViewController.h"
#import "HPGrowingTextView.h"//评论的自动放大的输入框
#import "NSString+URLEncoding.h"
#import "CL_AudioRecorder.h"
#import "LocalWord.h"
#import "VOASentence.h"

//#include <sys/xattr.h>

@class timeSwitchClass;
//@class SpeakHereController;
@class CL_AudioRecorder;

#define kHourComponent 0
#define kMinComponent 1
#define kSecComponent 2
#define kCommTableHeightPh 60.0
#define kRecorderDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Recorders"]
#define kFiveAdd (isFive?88:0)
#define kFiveAddHalf (isFive?44:0)

@interface PlayViewController : UIViewController <UIAlertViewDelegate, AVAudioPlayerDelegate,ASIHTTPRequestDelegate,MyLabelDelegate,MBProgressHUDDelegate,UIScrollViewDelegate,AVAudioSessionDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,MBProgressHUDDelegate,HPGrowingTextViewDelegate>
{
    CL_AudioRecorder* audioRecoder;
    BOOL              m_isRecording;
    AVAsset *avSet;
    CMTime nowTime;
    
    VOAView *voa;
    
    UIImageView     *myImageView;
    UIImageView     *lyricImage;
    UIImageView     *wordFrame;
    
    UITableView *commTableView;
    
    HPGrowingTextView *textView;
    
    UIPickerView *myPick;
    
    UIView     *viewOne;
    UIView     *viewTwo;
    UIView     *myView;
    UIView *containerView;
    UIView *fixTimeView;
    UIView *bottomView;
    UIImageView *senImage;
    UIImageView *starImage;
    
    UIImage     *playImage;
    UIImage     *pauseImage;
    UIImage     *loadingImage;
    
    UIButton		*collectButton;
    UIButton        *switchBtn;
    UIButton		*playButton;
    UIButton        *preButton;
    UIButton        *nextButton;
    UIButton        *fixButton;
    UIButton        *clockButton;
    UIButton		*btn_record;
    UIButton		*btn_play;
    UIButton		*downloadFlg;
    UIButton        *downloadingFlg;
    UIButton        *modeBtn;
    UIButton        *displayModeBtn;
    UIButton        *shareSenBtn;
    UIButton        *colSenBtn;
    
//    UILabel      *downloadFlg;
//    UILabel      *downloadingFlg;
    UILabel			*totalTimeLabel;//总时间
	UILabel			*currentTimeLabel;//当前时间
    UILabel     *myHighLightWord;
    UILabel *recordLabel;
    MyLabel *explainView;
    MyLabel *lyricLabel;
    UILabel *lyricCnLabel; 
    
    TextScrollView	*textScroll;
    TextScrollView	*myScroll;
    
    timeSwitchClass *timeSwitch;
    
	UISlider		*timeSlider;//时间滑块
    SevenProgressBar  *loadProgress;//缓冲进度
    
    NSTimer			*sliderTimer;
	NSTimer			*lyricSynTimer;
    NSTimer         *fixTimer;
    NSTimer         *recordTimer;
    NSTimer         *playRecordTimer;
    
//    NSTimer         *loadTimer;
    
    NSMutableArray	*lyricArray;
    NSMutableArray	*lyricCnArray;
	NSMutableArray	*timeArray;
	NSMutableArray	*indexArray;
	NSMutableArray	*lyricLabelArray;
    NSMutableArray	*lyricCnLabelArray;
    NSMutableArray    *listArray;
    NSMutableArray *commArray;
    NSMutableData* mp3Data;
    NSArray         *hoursArray;
    NSArray         *minsArray;
    NSArray         *secsArray;
    
	int				engLines;
    int				cnLines;
    int             playerFlag;
    int             fixSeconds;
    int             recordSeconds;
    int             nowRecordSeconds;
    int             recordTime;
    
    NSInteger nowPage;
    NSInteger nowUserId;
    NSInteger totalPage;
    NSInteger commNumber;
    
    AVPlayer	*player;
//    AVPlayer	*localPlayer;
    AVPlayer	*wordPlayer;
    
	NSURL			*mp3Url;
    
    BOOL localFileExist;
    BOOL downloaded;
    BOOL newFile;
    BOOL switchFlg;
    BOOL needFlush;
    BOOL needFlushAdv;
//    BOOL isExisitNet;
    BOOL noBuffering;
    BOOL isiPhone;
    BOOL readRecord;
    BOOL isNewComm;
//    BOOL afterRecord;
    BOOL isFixing;
    BOOL flushList;
    BOOL isFree;
    BOOL notValid;
    BOOL isShareSen;
    
    NSString *userPath;
    
    VOAWord *myWord;
    
    MBProgressHUD *HUD;
    
    UITextView *imgWords;
    UITextView *titleWords;
    
    double myStop;
    double seekTo;
    
    UIAlertView *alert;
    
    NSNotificationCenter *myCenter;
    
    MyPageControl *pageControl;
    
    GADBannerView *bannerView_;
    
//    SpeakHereController *controller;
    
    NSInteger sen_num;
    NSInteger contentMode;
    NSInteger playMode;
    NSInteger playIndex;
    NSInteger category;
    
    NSString *lyEn;
    NSString *lyCn;
//    NSString *category;
    NSString *shareStr;
    
    UIFont *CourierOne;
    UIFont *CourierTwo;
    
    VOASentence *mySentence;
//    CFURLRef		soundFileURLRef;
//	SystemSoundID	soundFileObject;
//    
//    float time_total;
}
//@property (nonatomic, retain) IBOutlet SpeakHereController *controller;
@property (nonatomic, retain) UIButton		*collectButton;
@property (nonatomic, retain) IBOutlet UIButton        *preButton;
@property (nonatomic, retain) IBOutlet UIButton        *nextButton;

@property (nonatomic, retain) IBOutlet UIButton        *btnOne;
@property (nonatomic, retain) IBOutlet UIButton        *btnTwo;
@property (nonatomic, retain) IBOutlet UIButton        *btnThree;
@property (nonatomic, retain) IBOutlet UIButton        *btnFour;

@property (nonatomic, retain) IBOutlet UIButton		*btn_record;
@property (nonatomic, retain) IBOutlet UIButton		*btn_play;
@property (nonatomic, retain) IBOutlet TextScrollView	*myScroll;
@property (nonatomic, retain) IBOutlet MyPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UILabel			*totalTimeLabel;//总时间
@property (nonatomic, retain) IBOutlet UILabel			*currentTimeLabel;//当前时间
@property (nonatomic, retain) IBOutlet UILabel *recordLabel;
@property (nonatomic, retain) IBOutlet UISlider		*timeSlider;//时间滑块

@property (nonatomic, retain) IBOutlet UIButton		*playButton;
//@property (nonatomic, retain) IBOutlet UILabel      *downloadFlg;
//@property (nonatomic, retain) IBOutlet UILabel      *downloadingFlg;
@property (nonatomic, retain) IBOutlet UITextView *titleWords;
@property (nonatomic, retain) IBOutlet UIImageView *RoundBack;
@property (nonatomic, retain) IBOutlet UIView *fixTimeView;
@property (nonatomic, retain) IBOutlet UIView *bottomView;
@property (nonatomic, retain) IBOutlet UIPickerView *myPick;
@property (nonatomic, retain) IBOutlet UIButton  *fixButton;
@property (nonatomic, retain) IBOutlet UIButton    *modeBtn;
@property (nonatomic, retain) IBOutlet UIButton  *displayModeBtn;

@property (nonatomic, retain) TextScrollView	*lyricScroll;
@property (nonatomic, retain) TextScrollView	*lyricCnScroll;

@property (nonatomic, retain) CL_AudioRecorder* audioRecoder;
@property (nonatomic) BOOL              m_isRecording;
@property (nonatomic) CMTime nowTime;
@property (nonatomic, retain) AVAsset *avSet;
@property (nonatomic, retain) NSURL			*mp3Url;
//@property (readwrite)	CFURLRef		soundFileURLRef;
//@property (readonly)	SystemSoundID	soundFileObject;
@property (nonatomic, retain) SevenProgressBar  *loadProgress;//缓冲进度
@property (nonatomic, retain) GADBannerView *bannerView_;
@property (nonatomic, retain) VOAView *voa;
@property (nonatomic, retain) UIImageView     *myImageView;
@property (nonatomic, retain) UIImageView     *lyricImage;
@property (nonatomic, retain) UIImageView *senImage;
@property (nonatomic, retain) UIImageView *starImage;
@property (nonatomic, retain) UIImageView     *wordFrame;
@property (nonatomic, retain) UIButton        *switchBtn;
@property (nonatomic, retain) UIButton        *shareSenBtn;
@property (nonatomic, retain) UIButton        *colSenBtn;
@property (nonatomic, retain) UIButton        *sendBtn;
@property (nonatomic, retain) timeSwitchClass *timeSwitch;
@property (nonatomic, retain) NSTimer			*sliderTimer;
@property (nonatomic, retain) NSTimer			*lyricSynTimer;
@property (nonatomic, retain) NSTimer         *fixTimer;
@property (nonatomic, retain) NSTimer         *recordTimer;
//@property (nonatomic, retain) NSTimer			*updateTimer;
@property (nonatomic, retain) NSMutableArray	*lyricArray;
@property (nonatomic, retain) NSMutableArray	*lyricCnArray;
@property (nonatomic, retain) NSMutableArray	*timeArray;
@property (nonatomic, retain) NSMutableArray	*indexArray;
@property (nonatomic, retain) NSMutableArray	*lyricLabelArray;
@property (nonatomic, retain) NSMutableArray	*lyricCnLabelArray;
@property (nonatomic, retain) NSMutableArray    *listArray;
@property (nonatomic, retain) NSArray         *hoursArray;
@property (nonatomic, retain) NSArray         *minsArray;
@property (nonatomic, retain) NSArray         *secsArray;
@property int				engLines;
@property int				cnLines;
@property int				playerFlag;//0:local 1:net
@property (nonatomic) int             recordSeconds;
@property (nonatomic) int             nowRecordSeconds;
@property (nonatomic) int             recordTime;
@property (nonatomic) int             fixSeconds;
//@property (nonatomic, retain) NSString *category;
@property (nonatomic) NSInteger category;
@property (nonatomic) NSInteger nowPage;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger commNumber;
@property (nonatomic) NSInteger contentMode;
@property (nonatomic) NSInteger playMode;
@property (nonatomic) NSInteger playIndex;
//@property (nonatomic, retain) AVPlayer	*localPlayer;
@property (nonatomic, retain) AVPlayer	*player;
@property (nonatomic, retain) AVPlayer	*wordPlayer;
@property (nonatomic, retain) UILabel     *myHighLightWord;
@property (nonatomic, retain) UIView      *myView;
@property (nonatomic, retain) NSMutableData* mp3Data;
@property (nonatomic, retain) NSString *userPath;
@property (nonatomic, retain) UIButton        *clockButton;
@property (nonatomic, retain) UIButton      *downloadFlg;
@property (nonatomic, retain) UIButton      *downloadingFlg;
@property BOOL localFileExist;
@property BOOL downloaded;
@property BOOL newFile;
@property BOOL switchFlg;
@property (nonatomic) BOOL isNewComm;
//@property (nonatomic) BOOL afterRecord;
@property (nonatomic) BOOL isFixing;
@property (nonatomic) BOOL flushList;
@property (nonatomic) BOOL isFree;
@property (nonatomic) BOOL isFive;
@property (nonatomic, retain) MyLabel *explainView;
@property (nonatomic, retain) VOAWord *myWord;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) UIView *viewOne;
@property (nonatomic, retain) UIView *viewTwo;
@property (nonatomic, retain) TextScrollView	*textScroll;
@property (nonatomic, retain) UITextView *imgWords;
@property double myStop;
@property (nonatomic, retain) UIImage *playImage;
@property (nonatomic, retain) UIImage *pauseImage;
@property (nonatomic, retain) UIImage *loadingImage;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) NSNotificationCenter *myCenter;
@property (nonatomic, retain) NSString *lyEn;
@property (nonatomic, retain) NSString *lyCn;
@property (nonatomic, retain) UITableView *commTableView;
@property (nonatomic, retain) NSMutableArray *commArray;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) HPGrowingTextView *textView;
@property NSInteger nowUserId;
//@property BOOL isExisitNet;
@property (nonatomic, retain) VOASentence *mySentence;

void RouteChangeListener(	void *                  inClientData,
                         AudioSessionPropertyID	inID,
                         UInt32                  inDataSize,
                         const void *            inData);
- (IBAction) playButtonPressed:(UIButton *)sender;
- (void) collectButtonPressed:(UIButton *)sender;
- (IBAction) sliderChanged:(UISlider *)sender;
- (IBAction) goBack:(UIButton *)sender;
- (IBAction) prePlay:(id)sender;
- (IBAction) aftPlay:(id)sender;
- (void) shareTo;
- (IBAction)shareNew:(id)sender;
- (IBAction)shareSen:(id)sender;
- (IBAction)changeView:(id)sender;
- (IBAction)collectSentence:(id)sender;

//- (IBAction) shareText;
//- (void) shareAll;
//- (IBAction) showComments:(id)sender;
- (void) QueueDownloadVoa;
- (void)catchWords:(NSString *) word;
+ (PlayViewController *)sharedPlayer;
+ (NSOperationQueue *)sharedQueue;
-(BOOL) isExistenceNetwork:(NSInteger)choose;
//-(void)updateCurrentTimeForPlayer:(AVPlayer *)p;
- (void)setButtonImage:(UIImage *)image;
- (void)spinButton;
- (IBAction)changePage:(UIPageControl *)sender;
- (CMTime)playerItemDuration;
- (void) stopRecord;

//- (void) stopRecordPlay;
//- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
//- (IBAction) recordButtonPressed:(UIButton *)sender;
@end
