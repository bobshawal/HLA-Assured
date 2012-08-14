//
//  RiderViewController.m
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "RiderViewController.h"
#import "BasicPlanViewController.h"
#import "MainMenuViewController.h"
#import "NewLAViewController.h"

@interface RiderViewController ()

@end

@implementation RiderViewController
@synthesize indexNo,agenID,requestPlanCode,requestPtype,requestSeq,requestSINo,requestAge;
@synthesize riderBtn;

#pragma mark - Cycle View

- (void)viewDidLoad
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    NSLog(@"indexNo:%d , agenID:%@,propectAge:%d,SINo:%@",self.indexNo,[self.agenID description],self.requestAge,[self.requestSINo description]);
    
    [riderBtn setBackgroundImage:[UIImage imageNamed:@"button_hover"] forState:UIControlStateNormal];
    
    [super viewDidLoad];
    
    //for testing
    [self getPersonType];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Action

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"riderGoBasic"]) {
        
        BasicPlanViewController *basicPlan = [segue destinationViewController];
        basicPlan.indexNo = self.indexNo;
        basicPlan.agenID = [self.agenID description];
        basicPlan.ageClient = self.requestAge;
        basicPlan.requestSINo = [self.requestSINo description];
    }
    else if ([[segue identifier] isEqualToString:@"riderGoLA"]) {
        
        NewLAViewController *laView = [segue destinationViewController];
        laView.indexNo = self.indexNo;
        laView.agenID = [self.agenID description];
    }
}

- (IBAction)homePressed:(id)sender
{
    MainMenuViewController *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
    mainMenu.modalPresentationStyle = UIModalPresentationFullScreen;
    mainMenu.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    mainMenu.indexNo = self.indexNo;
    mainMenu.userRequest = [self.agenID description];
    [self presentModalViewController:mainMenu animated:YES];
}

#pragma mark - DB handling

-(void)getPersonType
{
    NSMutableArray *ptype = [[NSMutableArray alloc] init];
    NSMutableArray *seq = [[NSMutableArray alloc] init];
    NSMutableArray *desc = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.PTypeCode,a.Sequence,b.PTypeDesc FROM tbl_SI_Trad_LAPayor a LEFT JOIN tbl_Adm_PersonType b ON a.PTypeCode=b.PTypeCode AND a.Sequence=b.Seq WHERE SINo=\"%@\"",self.requestSINo];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [ptype addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [seq addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                [desc addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]];
                
                NSLog(@"ptype:%@, seq:%@, desc:%@",ptype,seq,desc);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRiderListing
{
    NSMutableArray *ridercode = [[NSMutableArray alloc] init];
    NSMutableArray *riderDesc = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode FROM tbl_SI_Trad_RiderComb WHERE PlanCode=\"%@\" AND PTypeCode=\"%@\" AND Seq=\"%@\"",self.requestPlanCode,self.requestPtype,self.requestSeq];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [ridercode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                [riderDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
                
                NSLog(@"ridercode:%@, desc:%@",ridercode,riderDesc);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - Memory Management

- (void)viewDidUnload
{
    [self setAgenID:nil];
    [self setRiderBtn:nil];
    [self setRequestPlanCode:nil];
    [self setRequestPtype:nil];
    [self setRequestSeq:nil];
    [self setRequestSINo:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [agenID release];
    [riderBtn release];
    [requestPlanCode release];
    [requestPtype release];
    [requestSeq release];
    [requestSINo release];
    [super dealloc];
}
@end
