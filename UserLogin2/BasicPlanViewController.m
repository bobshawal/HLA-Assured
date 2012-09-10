//
//  BasicPlanViewController.m
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "BasicPlanViewController.h"
#import "RiderViewController.h"
#import "MainMenuViewController.h"
#import "NewLAViewController.h"

@interface BasicPlanViewController ()

@end

@implementation BasicPlanViewController
@synthesize planField;
@synthesize termField;
@synthesize yearlyIncomeField;
@synthesize minSALabel;
@synthesize maxSALabel;
@synthesize btnHealthLoading;
@synthesize healthLoadingView;
@synthesize MOPSegment;
@synthesize incomeSegment;
@synthesize advanceIncomeSegment;
@synthesize cashDividendSegment;
@synthesize HLField;
@synthesize HLTermField;
@synthesize tempHLField;
@synthesize tempHLTermField;
@synthesize indexNo,agenID,ageClient,requestSINo,termCover,planChoose,maxSA,minSA,SINoPlan;
@synthesize basicPlanBtn;
@synthesize MOP,yearlyIncome,advanceYearlyIncome,basicRate,LSDRate,planCode,cashDividend,riderRate;
@synthesize getSINo,getSumAssured,getPolicyTerm,getHL,getHLTerm,getTempHL,getTempHLTerm;
@synthesize riderHL1K,riderHL100,riderHLP,riderCode,riderSA;

#pragma mark - Cycle View

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    NSLog(@"indexNo:%d , agenID:%@, age:%d,SINo:%@",self.indexNo,[self.agenID description],self.ageClient,[self.requestSINo description]);
    
    [basicPlanBtn setBackgroundImage:[UIImage imageNamed:@"button_hover"] forState:UIControlStateNormal];
    
    healthLoadingView.alpha = 0;
    showHL = NO;
    planChoose = @"HLAIB";
    SINoPlan = [[NSString alloc] initWithFormat:@"%@",[self.requestSINo description]];
    [self getTermRule];
    
    if (self.requestSINo) {
        [self checkingExisting];
        if (getSINo.length != 0) {
            NSLog(@"view selected field");
            [self toogleExistingField];
        }
    } else {
        NSLog(@"SINo not exist!");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    minSALabel.text = @"";
    maxSALabel.text = @"";
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            minSALabel.text = @"";
            maxSALabel.text = @"";
            break;
        
        case 1:
            minSALabel.text = [NSString stringWithFormat:@"Min: %d",minSA];
            maxSALabel.text = [NSString stringWithFormat:@"Max: %d",maxSA];
            break;
            
        default:
            minSALabel.text = @"";
            maxSALabel.text = @"";
            break;
    }
    return YES;
}

#pragma mark - Action

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"basicGoRider"]) {
        
        RiderViewController *riderPlan = [segue destinationViewController];
        riderPlan.indexNo = self.indexNo;
        riderPlan.agenID = [self.agenID description];
        riderPlan.requestSINo = SINoPlan;
        riderPlan.requestAge = self.ageClient;
        riderPlan.requestCoverTerm = self.termCover;
        riderPlan.requestPlanCode = planCode;
    }
    else if ([[segue identifier] isEqualToString:@"basicGoLA"]) {
        
        NewLAViewController *laView = [segue destinationViewController];
        laView.indexNo = self.indexNo;
        laView.agenID = [self.agenID description];
        laView.requestSINo = SINoPlan;
    }
}

- (IBAction)goHomePressed:(id)sender
{
    MainMenuViewController *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
    mainMenu.modalPresentationStyle = UIModalPresentationFullScreen;
    mainMenu.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    mainMenu.indexNo = self.indexNo;
    mainMenu.userRequest = [self.agenID description];
    [self presentModalViewController:mainMenu animated:YES];
}

- (IBAction)btnShowHealthLoadingPressed:(id)sender
{
    if (showHL) {
        
        [self.btnHealthLoading setTitle:@"SHOW" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            healthLoadingView.alpha = 0;
        }];
        
        showHL = NO;
    }
    else {
        
        [self.btnHealthLoading setTitle:@"HIDE" forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.5 animations:^{
            healthLoadingView.alpha = 1;
        }];
        
        showHL = YES;
    }
}

- (IBAction)MOPSegmentPressed:(id)sender
{
    if ([MOPSegment selectedSegmentIndex]==0) {
        MOP = 6;
    }
    else if (MOPSegment.selectedSegmentIndex == 1){
        MOP = 9;
    }
    else if (MOPSegment.selectedSegmentIndex == 2) {
        MOP = 12;
    }
}

- (IBAction)incomeSegmentPressed:(id)sender
{
    if (incomeSegment.selectedSegmentIndex == 0) {
        yearlyIncome = @"ACC";
    }
    else if (incomeSegment.selectedSegmentIndex == 1) {
        yearlyIncome = @"POF";
    }
}

- (IBAction)advanceIncomeSegmentPressed:(id)sender
{
    if (advanceIncomeSegment.selectedSegmentIndex == 0) {
        advanceYearlyIncome = 0;
    }
    else if (advanceIncomeSegment.selectedSegmentIndex == 1) {
        advanceYearlyIncome = 60;
    }
    else if (advanceIncomeSegment.selectedSegmentIndex == 2) {
        advanceYearlyIncome = 75;
    }
}

- (IBAction)cashDividendSegmentPressed:(id)sender
{
    if (cashDividendSegment.selectedSegmentIndex == 0) {
        cashDividend = @"ACC";
    } else if (cashDividendSegment.selectedSegmentIndex == 1) {
        cashDividend = @"POF";
    }
}

- (IBAction)calculatePressed:(id)sender
{
    if (!(MOP) || !(yearlyIncome) || !(cashDividend) || !(advanceYearlyIncome)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill up all field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    } else {
      
        //checking existing
        [self checkingExisting];
        if (!(getSINo)) {
            [self saveBasicPlan];
        } else {
            [self updateBasicPlan];
        }
        
        [self getPlanCodePenta];
        [self calculatePremium];
        
        [self checkExistRider];
        if ([riderCode count] != 0) {
            NSLog(@"rider exist!");
            [self calculateRiderPrem];
        }
    }
}

#pragma mark - Toogle view

-(void)toogleExistingField
{
    termField.text = [[NSString alloc] initWithFormat:@"%d",getPolicyTerm];
    yearlyIncomeField.text = [[NSString alloc] initWithFormat:@"%d",getSumAssured];
    if (MOP == 6) {
        MOPSegment.selectedSegmentIndex = 0;
    } else if (MOP == 9) {
        MOPSegment.selectedSegmentIndex = 1;
    } else if (MOP == 12) {
        MOPSegment.selectedSegmentIndex = 2;
    }
    
    if ([yearlyIncome isEqualToString:@"ACC"]) {
        incomeSegment.selectedSegmentIndex = 0;
    } else if ([yearlyIncome isEqualToString:@"POF"]) {
        incomeSegment.selectedSegmentIndex = 1;
    }
    
    if ([cashDividend isEqualToString:@"ACC"]) {
        cashDividendSegment.selectedSegmentIndex = 0;
    } else if ([cashDividend isEqualToString:@"POF"]) {
        cashDividendSegment.selectedSegmentIndex = 1;
    }
    
    if (advanceYearlyIncome == 0) {
        advanceIncomeSegment.selectedSegmentIndex = 0;
    } else if (advanceYearlyIncome == 60) {
        advanceIncomeSegment.selectedSegmentIndex = 1;
    } else if (advanceYearlyIncome == 75) {
        advanceIncomeSegment.selectedSegmentIndex = 2;
    }
    
    if (getHL.length != 0) {
        HLField.text = getHL;
    }
    
    if (getHLTerm != 0) {
        HLTermField.text = [[NSString alloc] initWithFormat:@"%d",getHLTerm];
    }
    
    if (getTempHL.length != 0) {
        tempHLField.text = getTempHL;
    }
    
    if (getTempHLTerm != 0) {
        tempHLTermField.text = [[NSString alloc] initWithFormat:@"%d",getTempHLTerm];
    }
}

#pragma mark - Handle DB

-(void) getTermRule
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT MinTerm,MaxTerm,MinSA,MaxSA FROM tbl_SI_Trad_Mtn WHERE PlanCode=\"%@\"",planChoose];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                //                int minTerm =  sqlite3_column_int(statement, 0);
                int maxTerm  =  sqlite3_column_int(statement, 1);
                minSA = sqlite3_column_int(statement, 2);
                maxSA = sqlite3_column_int(statement, 3);
                
                termCover = maxTerm - self.ageClient;
                planField.text = @"HLA Income Builder";
                termField.text = [[NSString alloc] initWithFormat:@"%d",termCover];
                termField.enabled = NO;
                
            } else {
                NSLog(@"error access Trad_Mtn");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingExisting
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
            @"SELECT SINo,PolicyTerm,BasicSA,PremiumPaymentOption,CashDividend,YearlyIncome,AdvanceYearlyIncome,HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm FROM Trad_Details WHERE SINo=\"%@\"",SINoPlan];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                getSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                getPolicyTerm = sqlite3_column_int(statement, 1);
                getSumAssured = sqlite3_column_int(statement, 2);
                MOP = sqlite3_column_int(statement, 3);
                cashDividend = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                yearlyIncome = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                advanceYearlyIncome = sqlite3_column_int(statement, 6);
                
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 7);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 8);
                
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 9);
                getTempHL = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getTempHLTerm = sqlite3_column_int(statement, 10);
                
            } else {
                NSLog(@"error access Trad_Details");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)saveBasicPlan
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
        @"INSERT INTO Trad_Details (SINo,  PlanCode, PTypeCode, Seq, PolicyTerm, BasicSA, PremiumPaymentOption, CashDividend, YearlyIncome, AdvanceYearlyIncome, HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm, CreatedAt) VALUES (\"%@\", \"HLAIB\", \"LA\", \"1\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\")", SINoPlan,  termField.text, yearlyIncomeField.text, MOP, cashDividend, yearlyIncome, advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text, [tempHLTermField.text intValue], dateString];

        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Saved BasicPlan!");
            } else {
                NSLog(@"Failed Save basicPlan!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateBasicPlan
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Trad_Details SET BasicSA=\"%@\", PremiumPaymentOption=\"%d\", CashDividend=\"%@\", YearlyIncome=\"%@\", AdvanceYearlyIncome=\"%d\", HL1KSA=\"%@\", HL1KSATerm=\"%d\", TempHL1KSA=\"%@\", TempHL1KSATerm=\"%d\", UpdatedAt=\"%@\" WHERE SINo=\"%@\"",yearlyIncomeField.text, MOP, cashDividend, yearlyIncome,advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text, [tempHLTermField.text intValue], dateString, SINoPlan];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"BasicPlan update!");
                
            } else {
                NSLog(@"BasicPlan update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getPlanCodePenta
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE SIPlanCode=\"HLAIB\" AND PremPayOpt=\"%d\"",MOP];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                planCode =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSLog(@"planCodePenta:%@",planCode);
            } else {
                NSLog(@"error access PentaPlanCode");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getBasicPentaRate
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Basic_Prem WHERE PlanCode=\"%@\" AND FromTerm=\"%d\" AND FromMortality=0",planCode,termCover];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicRate =  sqlite3_column_int(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Basic_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

//not use anymore replace with pentaRate
-(void)getBasicRate
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM tbl_SI_Trad_HLAIB WHERE PremPayOpt=\"%d\" AND Term=\"%d\"",MOP,termCover];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicRate =  sqlite3_column_int(statement, 0);
                
            } else {
                NSLog(@"error access Trad_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getLSDRate
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LSD FROM tbl_SI_Trad_LSD_HLAIB WHERE PremPayOpt=\"%d\" AND FromSA <=\"%@\" AND ToSA >= \"%@\"",MOP,yearlyIncomeField.text,yearlyIncomeField.text];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                LSDRate =  sqlite3_column_int(statement, 0);
                
            } else {
                NSLog(@"error access Trad_LSD_HLAIB");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

/*------RiderPart----*/

-(void)checkExistRider
{
    riderCode = [[NSMutableArray alloc] init];
    riderSA = [[NSMutableArray alloc] init];
    riderHL1K = [[NSMutableArray alloc] init];
    riderHL100 = [[NSMutableArray alloc] init];
    riderHLP = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT RiderCode,SumAssured, HL1KSA, HL100SA, HLPercentage from Trad_Rider_Details WHERE SINo=\"%@\"",SINoPlan];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [riderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [riderSA addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                
                const char *ridHL = (const char *)sqlite3_column_text(statement, 2);
                [riderHL1K addObject:ridHL == NULL ? nil : [[NSString alloc] initWithUTF8String:ridHL]];
                
                const char *ridHL100 = (const char *)sqlite3_column_text(statement, 3);
                [riderHL100 addObject:ridHL100 == NULL ? nil : [[NSString alloc] initWithUTF8String:ridHL100]];
                
                const char *ridHLP = (const char *)sqlite3_column_text(statement, 4);
                [riderHLP addObject:ridHLP == NULL ? nil : [[NSString alloc] initWithUTF8String:ridHLP]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderRate
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT Rate FROM Trad_Sys_Rider_Prem WHERE PlanCode=\"%@\" AND FromTerm=\"%d\" AND FromMortality=0",planCode,termCover];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                riderRate =  sqlite3_column_int(statement, 0);
            } else {
                NSLog(@"error access Trad_Sys_Basic_Prem");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - Calculation

-(void)calculatePremium
{
    //    NSLog(@"term:%d, MOP:%d, Income:%@, advanceIncome:%d",termCover,MOP,yearlyIncome,advanceYearlyIncome);
    
    [self getBasicPentaRate];
    [self getLSDRate];
    NSLog(@"basicrate:%d, lsdrate:%d",basicRate,LSDRate);
    
    //calculate basic
    double BasicSA = [yearlyIncomeField.text doubleValue];
    double Annually = basicRate * (BasicSA/1000) * 1;
    double HalfYear = basicRate * (BasicSA/1000) * 0.5125;
    double Quarterly = basicRate * (BasicSA/1000) * 0.2625;
    double Monthly = basicRate * (BasicSA/1000) * 0.0875;
    NSLog(@"Basic A:%.3f, S:%.3f, Q:%.3f, M:%.3f",Annually,HalfYear,Quarterly,Monthly);
    
    //calculate health loading
    double HLoad = [HLField.text doubleValue];
    double HLAnnually = HLoad * (BasicSA/1000) * 1;
    double HLHalfYear = HLoad * (BasicSA/1000) * 0.5125;
    double HLQuarterly = HLoad * (BasicSA/1000) * 0.2625;
    double HLMonthly = HLoad * (BasicSA/1000) * 0.0875;
    NSLog(@"Health Loading A:%.3f, S:%.3f, Q:%.3f, M:%.3f",HLAnnually,HLHalfYear,HLQuarterly,HLMonthly);
    
    //calculate LSD
    double LSDAnnually = LSDRate * (BasicSA/1000) * 1;
    double LSDHalfYear = LSDRate * (BasicSA/1000) * 0.5125;
    double LSDQuarterly = LSDRate * (BasicSA/1000) * 0.2625;
    double LSDMonthly = LSDRate * (BasicSA/1000) * 0.0875;
    NSLog(@"LSD A:%.3f, S:%.3f, Q:%.3f, M:%.3f",LSDAnnually,LSDHalfYear,LSDQuarterly,LSDMonthly);
    
    //calculate Total
    double totalA = Annually + HLAnnually - LSDAnnually;
    double totalS = HalfYear + HLHalfYear - LSDHalfYear;
    double totalQ = Quarterly + HLQuarterly - LSDQuarterly;
    double totalM = Monthly + HLMonthly - LSDMonthly;
    NSLog(@"total A:%.3f, S:%.3f, Q:%.3f, M:%.3f",totalA,totalS,totalQ,totalM);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    //    [formatter setRoundingMode:NSNumberFormatterRoundDown];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:22.368511]];
    NSString *numberString2 = [formatter stringFromNumber:[NSNumber numberWithFloat:22.364511]];
    NSLog(@"result 1:%@, result 2:%@",numberString,numberString2);
    [formatter release];
}

-(void)calculateRiderPrem
{
    [self getRiderRate];
    NSLog(@"riderrate:%d, lsdrate:%d",riderRate,LSDRate);
    
    NSUInteger i;
    for (i=0; i<[riderCode count]; i++) {
        //calculate rider
        double ridSA = [[riderSA objectAtIndex:i] doubleValue];
        double Annually = riderRate * (ridSA/1000) * 1;
        double HalfYear = riderRate * (ridSA/1000) * 0.5125;
        double Quarterly = riderRate * (ridSA/1000) * 0.2625;
        double Monthly = riderRate * (ridSA/1000) * 0.0875;
        NSLog(@"Rider A:%.3f, S:%.3f, Q:%.3f, M:%.3f",Annually,HalfYear,Quarterly,Monthly);
    
        //calculate health loading
        double HLoad;
        if ([riderHL1K count] != 0) {
            HLoad = [[riderHL1K objectAtIndex:i] doubleValue];
        } else if ([riderHL100 count] != 0) {
            HLoad = [[riderHL100 objectAtIndex:i] doubleValue];
        } else if ([riderHLP count] != 0) {
            HLoad = [[riderHLP objectAtIndex:i] doubleValue];
        }
        double HLAnnually = HLoad * (ridSA/1000) * 1;
        double HLHalfYear = HLoad * (ridSA/1000) * 0.5125;
        double HLQuarterly = HLoad * (ridSA/1000) * 0.2625;
        double HLMonthly = HLoad * (ridSA/1000) * 0.0875;
        NSLog(@"Health Loading A:%.3f, S:%.3f, Q:%.3f, M:%.3f",HLAnnually,HLHalfYear,HLQuarterly,HLMonthly);
    
        //calculate LSD
        double LSDAnnually = LSDRate * (ridSA/1000) * 1;
        double LSDHalfYear = LSDRate * (ridSA/1000) * 0.5125;
        double LSDQuarterly = LSDRate * (ridSA/1000) * 0.2625;
        double LSDMonthly = LSDRate * (ridSA/1000) * 0.0875;
        NSLog(@"LSD A:%.3f, S:%.3f, Q:%.3f, M:%.3f",LSDAnnually,LSDHalfYear,LSDQuarterly,LSDMonthly);
    
        //calculate Total
        double totalA = Annually + HLAnnually - LSDAnnually;
        double totalS = HalfYear + HLHalfYear - LSDHalfYear;
        double totalQ = Quarterly + HLQuarterly - LSDQuarterly;
        double totalM = Monthly + HLMonthly - LSDMonthly;
        NSLog(@"total A:%.3f, S:%.3f, Q:%.3f, M:%.3f",totalA,totalS,totalQ,totalM);
    }
}

#pragma mark - Memory Management

- (void)viewDidUnload
{
    [self setSINoPlan:nil];
    [self setGetSINo:nil];
    [self setRiderCode:nil];
    [self setRiderSA:nil];
    [self setBasicPlanBtn:nil];
    [self setPlanField:nil];
    [self setTermField:nil];
    [self setYearlyIncomeField:nil];
    [self setMinSALabel:nil];
    [self setMaxSALabel:nil];
    [self setBtnHealthLoading:nil];
    [self setHealthLoadingView:nil];
    [self setRequestSINo:nil];
    [self setAgenID:nil];
    [self setMOPSegment:nil];
    [self setIncomeSegment:nil];
    [self setAdvanceIncomeSegment:nil];
    [self setYearlyIncome:nil];
    [self setHLField:nil];
    [self setPlanChoose:nil];
    [self setCashDividendSegment:nil];
    [self setCashDividend:nil];
    [self setHLTermField:nil];
    [self setTempHLField:nil];
    [self setTempHLTermField:nil];
    [self setGetHL:nil];
    [self setGetTempHL:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [getHL release];
    [getTempHL release];
    [SINoPlan release];
    [getSINo release];
    [riderSA release];
    [riderCode release];
    [basicPlanBtn release];
    [planField release];
    [termField release];
    [yearlyIncomeField release];
    [minSALabel release];
    [maxSALabel release];
    [btnHealthLoading release];
    [healthLoadingView release];
    [requestSINo release];
    [agenID release];
    [MOPSegment release];
    [incomeSegment release];
    [advanceIncomeSegment release];
    [yearlyIncome release];
    [HLField release];
    [planChoose release];
    [cashDividendSegment release];
    [cashDividend release];
    [HLTermField release];
    [tempHLField release];
    [tempHLTermField release];
    [super dealloc];
}
@end
