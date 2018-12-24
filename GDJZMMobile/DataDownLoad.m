//
//  DataDownLoad.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-22.
//
//

#import "DataDownLoad.h"
#import "AGAlertViewWithProgressbar.h"



@interface DataDownLoad()
@property (nonatomic,retain) AGAlertViewWithProgressbar *progressView;
@property (nonatomic,assign) NSInteger parserCount;
@property (nonatomic,assign) NSInteger currentParserCount;
@property (nonatomic,assign) BOOL stillParsing;

- (void)parserFinished:(NSNotification *)noti;
@end

@implementation DataDownLoad
@synthesize progressView = _progressView;
@synthesize parserCount = _parserCount;
@synthesize currentParserCount = _currentParserCount;
@synthesize stillParsing = _stillParsing;

- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(parserFinished:) name:@"ParserFinished" object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setProgressView:nil];
}

- (void)startDownLoad{
    if ([WebServiceHandler isServerReachable]) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        self.progressView=[[AGAlertViewWithProgressbar alloc] initWithTitle:@"同步基础数据" message:@"正在下载，请稍候……" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        MAINDISPATCH(^(void){
            [self.progressView show];
        });
        self.parserCount=DOWNLOADCOUNT;
        self.currentParserCount=self.parserCount;
        @autoreleasepool {
            InitUser *initUser = [[InitUser alloc] init];
            [initUser downLoadUserInfo];
            WAITFORPARSER
            
           
            InitSystype *iiSystype = [[InitSystype alloc] init];
            [iiSystype downloadSysType];
            WAITFORPARSER
            
            
            InitIconModel *initIcon = [[InitIconModel alloc] init];
            [initIcon downLoadIconModels];
            WAITFORPARSER
            InitProvince *initProvice = [[InitProvince alloc] init];
            [initProvice downloadProvince];
            WAITFORPARSER
            InitCities *initCities = [[InitCities alloc] init];
            [initCities downloadCityCode];
            WAITFORPARSER
            InitRoadSegment *initRoad = [[InitRoadSegment alloc] init];
            [initRoad downloadRoadSegment];
            WAITFORPARSER
            InitRoadAssetPrice *initRoadAssetPrice = [[InitRoadAssetPrice alloc] init];
            [initRoadAssetPrice downloadRoadAssetPrice];
            WAITFORPARSER
            InitInquireAnswerSentence *iias = [[InitInquireAnswerSentence alloc] init];
            [iias downloadInquireAnswerSentence];
            WAITFORPARSER
            InitInquireAskSentence *iiask = [[InitInquireAskSentence alloc] init];
            [iiask downloadInquireAskSentence];
            WAITFORPARSER
            InitCheckItemDetails *icid = [[InitCheckItemDetails alloc] init];
            [icid downloadCheckItemDetails];
            WAITFORPARSER
            InitCheckItems *icheckItems = [[InitCheckItems alloc] init];
            [icheckItems downloadCheckItems];
            WAITFORPARSER
            InitCheckType *iCheckType = [[InitCheckType alloc] init];
            [iCheckType downLoadCheckType];
            WAITFORPARSER
            InitCheckHandle *iCheckHandle = [[InitCheckHandle alloc] init];
            [iCheckHandle downLoadCheckHandle];
            WAITFORPARSER
            InitCheckReason *iCheckReason = [[InitCheckReason alloc] init];
            [iCheckReason downLoadCheckReason];
            WAITFORPARSER
            InitCheckStatus *iCheckStatus = [[InitCheckStatus alloc] init];
            [iCheckStatus downLoadCheckStatus];
            WAITFORPARSER
            InitSystype *iSystype = [[InitSystype alloc] init];
            [iSystype downloadSysType];
            WAITFORPARSER
            InitLaws *iLaws = [[InitLaws alloc] init];
            [iLaws downLoadLaws];
            WAITFORPARSER
            InitLawItems *iLawItems = [[InitLawItems alloc] init];
            [iLawItems downloadLawItems];
            WAITFORPARSER
            InitMatchLaw *iMatchLaw = [[InitMatchLaw alloc] init];
            [iMatchLaw downloadMatchLaw];
            WAITFORPARSER
            InitMatchLawDetails *iMatchLawDetails = [[InitMatchLawDetails alloc] init];
            [iMatchLawDetails downloadMatchLawDetails];
            WAITFORPARSER
            InitLawBreakingAction *iLawBreakingAction = [[InitLawBreakingAction alloc] init];
            [iLawBreakingAction downloadLawBreakingAction];
            WAITFORPARSER
            InitOrgInfo *iOrgInfo = [[InitOrgInfo alloc] init];
            [iOrgInfo downLoadOrgInfo];
            WAITFORPARSER
            InitFileCode *iFileCode = [[InitFileCode alloc] init];
            [iFileCode downLoadFileCode];
            
            WAITFORPARSER
//             下载历史案件数据
            InitCase *initCase = [[InitCase alloc] init];
            [initCase downLoadCase];
            WAITFORPARSER
            
            
            getProject *iProject = [[getProject alloc] init];
            [iProject  downLoadProject];
            WAITFORPARSER
            
            getCaseInquire *iCaseInquire = [[getCaseInquire alloc] init];
            [iCaseInquire  downLoadCaseInquire];
            WAITFORPARSER
            
            getTask *iTask = [[getTask alloc] init];
            [iTask  downLoadTask];
            WAITFORPARSER
            getAtonementNotice *iAtonementNotice = [[getAtonementNotice alloc] init];
            [iAtonementNotice  downLoadAtonementNotice];
            WAITFORPARSER
            
            getCaseDeformation *iCaseDeformation= [[getCaseDeformation alloc] init];
            [iCaseDeformation  downLoadCaseDeformation];
            WAITFORPARSER
            
            getCaseProveInfo *iCaseProveInfo = [[getCaseProveInfo alloc] init];
            [iCaseProveInfo  downLoadCaseProveInfo];
            
            WAITFORPARSER
            getCaseServiceFiles *iCaseServiceFiles = [[getCaseServiceFiles alloc] init];
            [iCaseServiceFiles  downLoadCaseServiceFiles];
            WAITFORPARSER
            
            getCaseServiceReceipt *iCaseServiceReceipt = [[getCaseServiceReceipt alloc] init];
            [iCaseServiceReceipt  downLoadCaseServiceReceipt];
            WAITFORPARSER
            
            getRoadWayClosed *iRoadWayClosed= [[getRoadWayClosed alloc] init];
             [iRoadWayClosed downLoadRoadWayClosed];
            WAITFORPARSER
            
            getParkingNode *iParkingNode = [[getParkingNode alloc] init];
            [iParkingNode  downLoadParkingNode];
            WAITFORPARSER
            
            
            getCaseMap *iCaseMap = [[getCaseMap alloc] init];
            [iCaseMap  downLoadCaseMap];
            WAITFORPARSER
            
            getCaseInvestigate *iCaseInvestigate = [[getCaseInvestigate alloc] init];
            [iCaseInvestigate  downLoadCaseInvestigate];
            WAITFORPARSER
            
            getCaseEnd *iCaseEnd= [[getCaseEnd alloc] init];
            [iCaseEnd  downLoadCaseEnd];
            WAITFORPARSER
            
            getCitizen *iCitizen= [[getCitizen alloc] init];
            [iCitizen  downloadCitizen];
            //WAITFORPARSER
            /* 下载历史案件数据结束*/
            
            
            
        }
    }
}
 
- (void)parserFinished:(NSNotification *)noti{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.progressView isVisible]) {
            self.currentParserCount=self.currentParserCount-1;
            [self.progressView setProgress:(int)(((float)(-self.currentParserCount+self.parserCount)/(float)self.parserCount)*100.0)];
            
            self.stillParsing = NO;
            if (self.currentParserCount==0) {
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.progressView hide];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOADFINISHNOTI object:nil];
                    UIAlertView *finishAlert = [[UIAlertView alloc] initWithTitle:@"消息" message:@"下载完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [finishAlert show];
                });
            }
        }
    });
}

@end
