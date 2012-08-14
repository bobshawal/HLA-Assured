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
@synthesize premiumTermSegment;
@synthesize yearlyIncomeSegment;
@synthesize advanceIncomeSegment;
@synthesize minSALabel;
@synthesize maxSALabel;
@synthesize btnHealthLoading;
@synthesize healthLoadingView;
@synthesize indexNo,agenID,ageClient,requestSINo;
@synthesize basicPlanBtn;

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
    
    [super viewDidLoad];
    
    //for testing - should delete after this
    [self getTermRule];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Handle DB

-(void) getTermRule
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT MinTerm,MaxTerm,MinSA,MaxSA FROM tbl_SI_Trad_Mtn WHERE PlanCode=\"HLAIB\""];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
//                int minTerm =  sqlite3_column_int(statement, 0);
                int maxTerm  =  sqlite3_column_int(statement, 1);
                int minSA = sqlite3_column_int(statement, 2);
                int maxSA = sqlite3_column_int(statement, 3);
                
                int term;
                term = maxTerm - self.ageClient;
                
                planField.text = @"HLA Income Builder";
                termField.text = [[NSString alloc] initWithFormat:@"%d",term];
                termField.enabled = NO;
                yearlyIncomeField.text = [[NSString alloc] initWithFormat:@"%d",minSA];
                minSALabel.text = [[NSString alloc] initWithFormat:@"Min: %d",minSA];
                maxSALabel.text = [[NSString alloc] initWithFormat:@"Max: %d",maxSA];
                
            } else {
                NSLog(@"error access Trad_Mtn");
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"basicGoRider"]) {
        
        RiderViewController *riderPlan = [segue destinationViewController];
        riderPlan.indexNo = self.indexNo;
        riderPlan.agenID = [self.agenID description];
        riderPlan.requestSINo = [self.requestSINo description];
        riderPlan.requestAge = self.ageClient;
    }
    else if ([[segue identifier] isEqualToString:@"basicGoLA"]) {
        
        NewLAViewController *laView = [segue destinationViewController];
        laView.indexNo = self.indexNo;
        laView.agenID = [self.agenID description];
    }
}

#pragma mark - Memory Management

- (void)viewDidUnload
{
    [self setBasicPlanBtn:nil];
    [self setPlanField:nil];
    [self setTermField:nil];
    [self setYearlyIncomeField:nil];
    [self setPremiumTermSegment:nil];
    [self setYearlyIncomeSegment:nil];
    [self setAdvanceIncomeSegment:nil];
    [self setMinSALabel:nil];
    [self setMaxSALabel:nil];
    [self setBtnHealthLoading:nil];
    [self setHealthLoadingView:nil];
    [self setRequestSINo:nil];
    [self setAgenID:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [basicPlanBtn release];
    [planField release];
    [termField release];
    [yearlyIncomeField release];
    [premiumTermSegment release];
    [yearlyIncomeSegment release];
    [advanceIncomeSegment release];
    [minSALabel release];
    [maxSALabel release];
    [btnHealthLoading release];
    [healthLoadingView release];
    [requestSINo release];
    [agenID release];
    [super dealloc];
}
@end
