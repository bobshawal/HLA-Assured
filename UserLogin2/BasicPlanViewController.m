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
@synthesize HLField;
@synthesize indexNo,agenID,ageClient,requestSINo,termCover,planChoose,maxSA,minSA;
@synthesize basicPlanBtn;
@synthesize MOP,yearlyIncome,advanceYearlyIncome,basicRate,LSDRate;

#pragma mark - Cycle View

- (void)viewDidLoad
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    NSLog(@"indexNo:%d , agenID:%@, age:%d,SINo:%@",self.indexNo,[self.agenID description],self.ageClient,[self.requestSINo description]);
    
    [basicPlanBtn setBackgroundImage:[UIImage imageNamed:@"button_hover"] forState:UIControlStateNormal];
    
    healthLoadingView.alpha = 0;
    showHL = NO;
    planChoose = @"HLAIB";
    
    [super viewDidLoad];
    
    //for testing - should delete after this
    [self getTermRule];
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
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            minSALabel.text = @"";
            maxSALabel.text = @"";
            break;
        
        case 1:
            minSALabel.text = [[NSString alloc] initWithFormat:@"Min: %d",minSA];
            maxSALabel.text = [[NSString alloc] initWithFormat:@"Max: %d",maxSA];
            break;
            
        default:
            minSALabel.text = @"";
            maxSALabel.text = @"";
            break;
    }
    return YES;
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

#pragma mark - Action

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
        yearlyIncome = @"Accumulation";
    }
    else if (incomeSegment.selectedSegmentIndex == 1) {
        yearlyIncome = @"Pay Out";
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

- (IBAction)calculatePressed:(id)sender
{
    [self calculatePremium];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"basicGoRider"]) {
        
        RiderViewController *riderPlan = [segue destinationViewController];
        riderPlan.indexNo = self.indexNo;
        riderPlan.agenID = [self.agenID description];
        riderPlan.requestSINo = [self.requestSINo description];
        riderPlan.requestAge = self.ageClient;
        riderPlan.requestCoverTerm = self.termCover;
    }
    else if ([[segue identifier] isEqualToString:@"basicGoLA"]) {
        
        NewLAViewController *laView = [segue destinationViewController];
        laView.indexNo = self.indexNo;
        laView.agenID = [self.agenID description];
    }
}

#pragma mark - Calculation

-(void)calculatePremium
{
//    NSLog(@"term:%d, MOP:%d, Income:%@, advanceIncome:%d",termCover,MOP,yearlyIncome,advanceYearlyIncome);
    
    [self getBasicRate];
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

#pragma mark - Memory Management

- (void)viewDidUnload
{
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
    [super viewDidUnload];
}

- (void)dealloc {
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
    [super dealloc];
}
@end
