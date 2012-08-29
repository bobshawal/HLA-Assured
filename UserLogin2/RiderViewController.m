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
@synthesize btnPType;
@synthesize btnAddRider;
@synthesize riderBtn;
@synthesize indexNo,agenID,requestPlanCode,requestSINo,requestAge,requestCoverTerm;
@synthesize pTypeCode,PTypeSeq,pTypeDesc,riderCode,riderDesc;

#pragma mark - Cycle View

- (void)viewDidLoad
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    NSLog(@"indexNo:%d , agenID:%@,propectAge:%d,SINo:%@",self.indexNo,[self.agenID description],self.requestAge,[self.requestSINo description]);
    
    [riderBtn setBackgroundImage:[UIImage imageNamed:@"button_hover"] forState:UIControlStateNormal];
    
    [super viewDidLoad];
    [self displayLabel];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)displayLabel
{
    //first column
    
    UILabel *rTermLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 201, 120, 31)];
    rTermLabel.text = @"Rider Term";
    rTermLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:25];
    
    UILabel *pALabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 240, 120, 31)];
    pALabel.text = @"PA Class";
    pALabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:25];
    
    UILabel *unitsLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 279, 120, 31)];
    unitsLabel.text = @"Units";
    unitsLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:25];
    
    UILabel *HLLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 318, 300, 31)];
    HLLabel.text = @"Health Loading (%)";
    HLLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:25];
    
    UILabel *HLTLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 357, 300, 31)];
    HLTLabel.text = @"Health Loading (%) Term";
    HLTLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:25];
    
    UITextField *rTermField = [[UITextField alloc] initWithFrame:CGRectMake(212, 201, 140, 31)];
    rTermField.borderStyle = UITextBorderStyleRoundedRect;
    rTermField.textColor = [UIColor blackColor];
    rTermField.font = [UIFont systemFontOfSize:14.0];
    rTermField.backgroundColor = [UIColor whiteColor];
    rTermField.autocorrectionType = UITextAutocorrectionTypeNo;
    rTermField.backgroundColor = [UIColor clearColor];
    rTermField.keyboardType = UIKeyboardTypeDefault;
    rTermField.clearButtonMode = UITextFieldViewModeWhileEditing;
    rTermField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UITextField *pAField = [[UITextField alloc] initWithFrame:CGRectMake(212, 240, 140, 31)];
    pAField.borderStyle = UITextBorderStyleRoundedRect;
    pAField.textColor = [UIColor blackColor];
    pAField.font = [UIFont systemFontOfSize:14.0];
    pAField.backgroundColor = [UIColor whiteColor];
    pAField.autocorrectionType = UITextAutocorrectionTypeNo;
    pAField.backgroundColor = [UIColor clearColor];
    pAField.keyboardType = UIKeyboardTypeDefault;
    pAField.clearButtonMode = UITextFieldViewModeWhileEditing;
    pAField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UITextField *unitsField = [[UITextField alloc] initWithFrame:CGRectMake(212, 279, 140, 31)];
    unitsField.borderStyle = UITextBorderStyleRoundedRect;
    unitsField.textColor = [UIColor blackColor];
    unitsField.font = [UIFont systemFontOfSize:14.0];
    unitsField.backgroundColor = [UIColor whiteColor];
    unitsField.autocorrectionType = UITextAutocorrectionTypeNo;
    unitsField.backgroundColor = [UIColor clearColor];
    unitsField.keyboardType = UIKeyboardTypeDefault;
    unitsField.clearButtonMode = UITextFieldViewModeWhileEditing;
    unitsField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UITextField *HLField = [[UITextField alloc] initWithFrame:CGRectMake(441, 318, 140, 31)];
    HLField.borderStyle = UITextBorderStyleRoundedRect;
    HLField.textColor = [UIColor blackColor];
    HLField.font = [UIFont systemFontOfSize:14.0];
    HLField.backgroundColor = [UIColor whiteColor];
    HLField.autocorrectionType = UITextAutocorrectionTypeNo;
    HLField.backgroundColor = [UIColor clearColor];
    HLField.keyboardType = UIKeyboardTypeDefault;
    HLField.clearButtonMode = UITextFieldViewModeWhileEditing;
    HLField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UITextField *HLTField = [[UITextField alloc] initWithFrame:CGRectMake(441, 357, 140, 31)];
    HLTField.borderStyle = UITextBorderStyleRoundedRect;
    HLTField.textColor = [UIColor blackColor];
    HLTField.font = [UIFont systemFontOfSize:14.0];
    HLTField.backgroundColor = [UIColor whiteColor];
    HLTField.autocorrectionType = UITextAutocorrectionTypeNo;
    HLTField.backgroundColor = [UIColor clearColor];
    HLTField.keyboardType = UIKeyboardTypeDefault;
    HLTField.clearButtonMode = UITextFieldViewModeWhileEditing;
    HLTField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //second column
    
    UILabel *sALabel = [[UILabel alloc] initWithFrame:CGRectMake(444, 201, 140, 31)];
    sALabel.text = @"Sum Assured";
    sALabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:25];
    
    UILabel *cPALabel = [[UILabel alloc] initWithFrame:CGRectMake(444, 240, 140, 31)];
    cPALabel.text = @"CPA Class";
    cPALabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:25];
    
    UILabel *occLabel = [[UILabel alloc] initWithFrame:CGRectMake(444, 279, 140, 31)];
    occLabel.text = @"Occp Loading";
    occLabel.font = [UIFont fontWithName:@"Thonburi-Bold" size:25];
    
    UITextField *sAField = [[UITextField alloc] initWithFrame:CGRectMake(607, 201, 140, 31)];
    sAField.borderStyle = UITextBorderStyleRoundedRect;
    sAField.textColor = [UIColor blackColor];
    sAField.font = [UIFont systemFontOfSize:14.0];
    sAField.backgroundColor = [UIColor whiteColor];
    sAField.autocorrectionType = UITextAutocorrectionTypeNo;
    sAField.backgroundColor = [UIColor clearColor];
    sAField.keyboardType = UIKeyboardTypeDefault;
    sAField.clearButtonMode = UITextFieldViewModeWhileEditing;
    sAField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UITextField *cPAField = [[UITextField alloc] initWithFrame:CGRectMake(607, 240, 140, 31)];
    cPAField.borderStyle = UITextBorderStyleRoundedRect;
    cPAField.textColor = [UIColor blackColor];
    cPAField.font = [UIFont systemFontOfSize:14.0];
    cPAField.backgroundColor = [UIColor whiteColor];
    cPAField.autocorrectionType = UITextAutocorrectionTypeNo;
    cPAField.backgroundColor = [UIColor clearColor];
    cPAField.keyboardType = UIKeyboardTypeDefault;
    cPAField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cPAField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UITextField *occField = [[UITextField alloc] initWithFrame:CGRectMake(607, 279, 140, 31)];
    occField.borderStyle = UITextBorderStyleRoundedRect;
    occField.textColor = [UIColor blackColor];
    occField.font = [UIFont systemFontOfSize:14.0];
    occField.backgroundColor = [UIColor whiteColor];
    occField.autocorrectionType = UITextAutocorrectionTypeNo;
    occField.backgroundColor = [UIColor clearColor];
    occField.keyboardType = UIKeyboardTypeDefault;
    occField.clearButtonMode = UITextFieldViewModeWhileEditing;
    occField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.view addSubview:rTermLabel];
    [self.view addSubview:rTermField];
    [self.view addSubview:sALabel];
    [self.view addSubview:sAField];
    [self.view addSubview:pALabel];
    [self.view addSubview:pAField];
    [self.view addSubview:cPALabel];
    [self.view addSubview:cPAField];
    [self.view addSubview:unitsLabel];
    [self.view addSubview:unitsField];
    [self.view addSubview:occLabel];
    [self.view addSubview:occField];
    [self.view addSubview:HLLabel];
    [self.view addSubview:HLField];
    [self.view addSubview:HLTLabel];
    [self.view addSubview:HLTField];
    
    [rTermLabel release];
    [rTermField release];
    [sALabel release];
    [sAField release];
    [pALabel release];
    [pAField release];
    [cPALabel release];
    [cPAField release];
    [unitsLabel release];
    [unitsField release];
    [occLabel release];
    [occField release];
    [HLLabel release];
    [HLField release];
    [HLTLabel release];
    [HLTField release];
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

- (IBAction)btnPTypePressed:(id)sender
{
    if(![popOverConroller isPopoverVisible]){
        
		RiderPTypeTbViewController *popView = [[RiderPTypeTbViewController alloc] init];
		popOverConroller = [[[UIPopoverController alloc] initWithContentViewController:popView] retain];
        popView.delegate = self;
        popView.requestSINo = [self.requestSINo description];
        [popView release];
		
		[popOverConroller setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];
        [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popOverConroller dismissPopoverAnimated:YES];
	}
}

- (IBAction)btnAddRiderPressed:(id)sender
{
    if(![popOverConroller isPopoverVisible]){
        
		RiderListTbViewController *popView = [[RiderListTbViewController alloc] init];
		popOverConroller = [[[UIPopoverController alloc] initWithContentViewController:popView] retain];
        popView.requestPlanCode = [self.requestPlanCode description];
        popView.requestPtype = self.pTypeCode;
        popView.requestSeq = self.PTypeSeq;
        
        popView.delegate = self;
        [popView release];
		
		[popOverConroller setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];
        [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popOverConroller dismissPopoverAnimated:YES];
	}
}

#pragma mark - DB handling

-(void)getLabelForm
{
    NSMutableArray *labelCode = [[NSMutableArray alloc] init];
    NSMutableArray *labelDesc = [[NSMutableArray alloc] init];
    NSMutableArray *ridCode = [[NSMutableArray alloc] init];
    NSMutableArray *ridName = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                    @"SELECT LabelCode,LabelDesc,RiderCode,RiderName FROM tbl_SI_Trad_Rider_Label WHERE RiderCode=\"%@\"",riderCode];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                [labelCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                [labelDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
                [ridCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
                [ridName addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)]];
                
                NSLog(@"code:%@ desc:%@ ridercode:%@ ridername:%@",labelCode,labelDesc,ridCode,ridName);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getRiderTermRule
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT MinAge,MaxAge,ExpiryAge,MinTerm,MaxTerm,MinSA,MaxSA,MaxSAFactor FROM tbl_SI_Trad_Rider_Mtn WHERE RiderCode=\"%@\"",riderCode];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                int expAge =  sqlite3_column_int(statement, 2);
                int minT =  sqlite3_column_int(statement, 3);
                int minSA = sqlite3_column_int(statement, 5);
                int maxSA = sqlite3_column_int(statement, 6);
                
                int maxTerm;
                int maxCovered;
                maxTerm = expAge - self.requestAge;
                if (maxTerm < self.requestCoverTerm) {
                    maxCovered = maxTerm;
                }
                else {
                    maxCovered = self.requestCoverTerm;
                }
                
                NSLog(@"minTerm:%d minSA:%d maxSA:%d",minT,minSA,maxSA);
                
            } else {
                NSLog(@"error access Trad_Mtn");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - Delegate

-(void)PTypeController:(RiderPTypeTbViewController *)inController didSelectCode:(NSString *)code seqNo:(NSString *)seq desc:(NSString *)desc
{
    pTypeCode = [[NSString alloc] initWithFormat:@"%@",code];
    PTypeSeq = [seq intValue];
    pTypeDesc = [[NSString alloc] initWithFormat:@"%@",desc];
    [self.btnPType setTitle:pTypeDesc forState:UIControlStateNormal];
    [popOverConroller dismissPopoverAnimated:YES];
    
    NSLog(@"pType:%@, seq:%d, desc:%@",pTypeCode,PTypeSeq,pTypeDesc);
}

-(void)RiderListController:(RiderListTbViewController *)inController didSelectCode:(NSString *)code desc:(NSString *)desc
{
    riderCode = [[NSString alloc] initWithFormat:@"%@",code];
    riderDesc = [[NSString alloc] initWithFormat:@"%@",desc];
    [self.btnAddRider setTitle:riderDesc forState:UIControlStateNormal];
    [popOverConroller dismissPopoverAnimated:YES];
    
    NSLog(@"riderCode:%@, riderDesc:%@",riderCode,riderDesc);
}

#pragma mark - Memory Management

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverConroller = nil;
}

- (void)viewDidUnload
{
    [self setAgenID:nil];
    [self setRiderBtn:nil];
    [self setRequestPlanCode:nil];
    [self setRequestSINo:nil];
    [self setBtnPType:nil];
    [self setBtnAddRider:nil];
    [self setPTypeCode:nil];
    [self setPTypeDesc:nil];
    [self setRiderCode:nil];
    [self setRiderDesc:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [agenID release];
    [riderBtn release];
    [requestPlanCode release];
    [requestSINo release];
    [btnPType release];
    [btnAddRider release];
    [pTypeDesc release];
    [pTypeCode release];
    [riderCode release];
    [riderDesc release];
    [super dealloc];
}
@end
