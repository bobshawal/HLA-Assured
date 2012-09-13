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
#import "PremiumViewController.h"

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
@synthesize MOP,yearlyIncome,advanceYearlyIncome,basicRate,cashDividend;
@synthesize getSINo,getSumAssured,getPolicyTerm,getHL,getHLTerm,getTempHL,getTempHLTerm;
@synthesize planCode;

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
            [self getExistingBasic];
            [self toogleExistingField];
        } else {
            NSLog(@"create new");
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
        riderPlan.requestCoverTerm = termCover;
        riderPlan.requestPlanCode = planCode;
        riderPlan.requestBasicSA = [yearlyIncomeField.text intValue];
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
            NSLog(@"will save");
            [self saveBasicPlan];
        } else {
            NSLog(@"will update");
            [self updateBasicPlan];
        }
        [self getPlanCodePenta];
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
        HLTermField.text = [NSString stringWithFormat:@"%d",getHLTerm];
    }
    
    if (getTempHL.length != 0) {
        tempHLField.text = getTempHL;
    }
    
    if (getTempHLTerm != 0) {
        tempHLTermField.text = [NSString stringWithFormat:@"%d",getTempHLTerm];
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
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SINo FROM Trad_Details WHERE SINo=\"%@\"",SINoPlan];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                getSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            } else {
                NSLog(@"error access Trad_Details");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getExistingBasic
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
                cashDividend = [[NSString alloc ] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
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
                
                PremiumViewController *premView = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
                premView.modalPresentationStyle = UIModalPresentationFormSheet;
                premView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                premView.requestPlanCode = planCode;
                premView.requestSINo = SINoPlan;
                premView.requestMOP = MOP;
                premView.requestAge = self.ageClient;
                premView.requestTerm = termCover;
                premView.requestBasicSA = yearlyIncomeField.text;
                premView.requestBasicHL = HLField.text;
                [self presentModalViewController:premView animated:YES];
                premView.view.superview.bounds = CGRectMake(0, 0, 650, 550);
                
            } else {
                NSLog(@"error access PentaPlanCode");
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

#pragma mark - Memory Management

- (void)viewDidUnload
{
    [self setSINoPlan:nil];
    [self setGetSINo:nil];
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
    [self setPlanCode:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [planCode release];
    [getHL release];
    [getTempHL release];
    [SINoPlan release];
    [getSINo release];
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
