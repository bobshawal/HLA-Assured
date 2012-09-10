//
//  NewLAViewController.m
//  HLA
//
//  Created by shawal sapuan on 7/30/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "NewLAViewController.h"
#import "PayorViewController.h"
#import "SecondLAViewController.h"
#import "BasicPlanViewController.h"
#import "RiderViewController.h"
#import "MainMenuViewController.h"

@interface NewLAViewController ()

@end

@implementation NewLAViewController
@synthesize occPickerView;
@synthesize datePickerView;
@synthesize pickerToolbar;
@synthesize lifeAssuredBtn;
@synthesize myScrollView;
@synthesize indexNo;
@synthesize LANameField;
@synthesize sexSegment;
@synthesize smokerSegment;
@synthesize LAAgeField;
@synthesize LACommencementDateField;
@synthesize LAOccSearchField;
@synthesize LAOccLoadingField;
@synthesize LACPAField;
@synthesize LAPAField;
@synthesize btnDOB;
@synthesize btnOccp;
@synthesize sex,smoker,age,SINo,SIDate,SILastNo,CustCode,ANB,CustDate,CustLastNo,DOB,jobDesc;
@synthesize occDesc,occCode,occLoading,occCPA,occPA;
@synthesize agenID,popoverController,requestSINo,clientName,occuCode,commencementDate,occuDesc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    NSLog(@"indexNo:%d , agenID:%@",self.indexNo,[self.agenID description]);
    
    occPickerView.hidden = YES;
    datePickerView.hidden = YES;
    pickerToolbar.hidden = YES;
    
    [lifeAssuredBtn setBackgroundImage:[UIImage imageNamed:@"button_hover"] forState:UIControlStateNormal];
    
    [self toogleView];
    [self getOccDesc];
    
    if (self.requestSINo) {
        [self checkingExisting];
        if (SINo.length != 0) {
            [self getSavedField];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
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

#pragma mark - Handle KeyboardShow

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 748-352);
    self.myScrollView.contentSize = CGSizeMake(1024, 748);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 748);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeField = textField;
    return YES;
}

#pragma mark - ToogleView

-(void)toogleView
{
    NSLog(@"sex:%@",sex);
    NSLog(@"smoker:%@",smoker);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *commencementDateStr = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    LACommencementDateField.text = [[NSString alloc]initWithFormat:@"%@",commencementDateStr];
}

-(void)getSavedField
{
    LANameField.text = clientName;
    [self.btnDOB setTitle:DOB forState:UIControlStateNormal];
    LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
    LACommencementDateField.text = commencementDate;

    if ([sex isEqualToString:@"M"]) {
        sexSegment.selectedSegmentIndex = 0;
    } else if ([sex isEqualToString:@"F"]) {
        sexSegment.selectedSegmentIndex = 1;
    }
    
    if ([smoker isEqualToString:@"Y"]) {
        smokerSegment.selectedSegmentIndex = 0;
    } else if ([smoker isEqualToString:@"N"]) {
        smokerSegment.selectedSegmentIndex = 1;
    }
    
    [self getOccCodeLoading];
    [self.btnOccp setTitle:occuDesc forState:UIControlStateNormal];
    LAOccLoadingField.text = occLoading;
    LACPAField.text = occCPA;
    LAPAField.text = occPA;
}

#pragma mark - Action

- (IBAction)sexSegmentPressed:(id)sender 
{
    if ([sexSegment selectedSegmentIndex]==0) {
        sex = @"M";
    } 
    else if (sexSegment.selectedSegmentIndex == 1){
        sex = @"F";
    }
    [self toogleView];
}

- (IBAction)smokerSegmentPressed:(id)sender 
{
    if ([smokerSegment selectedSegmentIndex]==0) {
        smoker = @"Y";
    }
    else if (smokerSegment.selectedSegmentIndex == 1){
        smoker = @"N";
    }
    [self toogleView];
}

- (IBAction)goHome:(id)sender 
{
    MainMenuViewController *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
    mainMenu.modalPresentationStyle = UIModalPresentationFullScreen;
    mainMenu.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    mainMenu.indexNo = self.indexNo;
    mainMenu.userRequest = [self.agenID description];
    [self presentModalViewController:mainMenu animated:YES];
}

- (IBAction)payorBtnPressed:(id)sender 
{
    if (age >= 18) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"You are not allowed to add payor!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        NSLog(@"above %d",age);
    }
    else if (age < 16) {
        
        PayorViewController *payorView = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
        payorView.modalPresentationStyle = UIModalPresentationFormSheet;
        payorView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:payorView animated:YES];
        payorView.view.superview.bounds = CGRectMake(0, 0, 800, 400);
        NSLog(@"below %d",age);
    }
    else {
        
        PayorViewController *payorView = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
        payorView.modalPresentationStyle = UIModalPresentationFormSheet;
        payorView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:payorView animated:YES];
        payorView.view.superview.bounds = CGRectMake(0, 0, 800, 400);
        NSLog(@"age 16-17");
    }

}

- (IBAction)secondLAPressed:(id)sender 
{
    if (age >= 18) {
        
        SecondLAViewController *secondLA = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
        secondLA.modalPresentationStyle = UIModalPresentationFormSheet;
        secondLA.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:secondLA animated:YES];
        secondLA.view.superview.bounds = CGRectMake(0, 0, 800, 400);
        NSLog(@"above %d",age);
        
    }
    else if(age < 16) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"You are not allowed to\n add Secondary Life Assured!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        NSLog(@"below %d",age);
    }
    else {
        
        SecondLAViewController *secondLA = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
        secondLA.modalPresentationStyle = UIModalPresentationFormSheet;
        secondLA.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:secondLA animated:YES];
        secondLA.view.superview.bounds = CGRectMake(0, 0, 800, 400);
        NSLog(@"age 16-17");
    }
}

- (IBAction)btnDOBPressed:(id)sender
{
    if (!((occPickerView.hidden = YES) && (pickerToolbar.hidden = YES))) {
        occPickerView.hidden = YES;
        pickerToolbar.hidden = YES;
    }
    datePickerView.hidden = NO;
}

- (IBAction)btnOccPressed:(id)sender 
{
    if ( !(datePickerView.hidden = YES)) {
        datePickerView.hidden = YES;
    }
    occPickerView.hidden = NO;
    pickerToolbar.hidden = NO;
}

- (IBAction)btnOccDone:(id)sender 
{
    NSInteger row = [occPickerView selectedRowInComponent:0];
    NSString *occD = [occDesc objectAtIndex:row];
    [self.btnOccp setTitle:occD forState:UIControlStateNormal];
    jobDesc = occD;
    
    
    [self getOccLoading];
    
    if (!((occPickerView.hidden = YES) && (pickerToolbar.hidden = YES))) {
        occPickerView.hidden = YES;
        pickerToolbar.hidden = YES;
    }
}

- (IBAction)datePickerValueChanged:(id)sender 
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *pickerDate = [dateFormatter stringFromDate:[datePickerView date]];
    [dateFormatter release];
   
    NSString *msg = [NSString stringWithFormat:@"%@",pickerDate];
    [self.btnDOB setTitle:msg forState:UIControlStateNormal];
//    [self.btnDOB.titleLabel setTextAlignment:UITextAlignmentLeft];
    DOB = msg;
    [self calculateAge];
}

- (IBAction)doSaveLA:(id)sender
{
    [self insertData];
}

- (IBAction)selectProspect:(id)sender
{
    if(![popoverController isPopoverVisible]) {
        
		ListingTbViewController *listingMenu = [[ListingTbViewController alloc] init];
		popoverController = [[[UIPopoverController alloc] initWithContentViewController:listingMenu] retain];
		
		[popoverController setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];
        [popoverController presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        popoverController.delegate = self;
	}
    else {
		[popoverController dismissPopoverAnimated:YES];
	}
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"goBasicPlan"]) {
        
        BasicPlanViewController *basicPlan = [segue destinationViewController];
        basicPlan.indexNo = self.indexNo;
        basicPlan.agenID = [self.agenID description];
        basicPlan.ageClient = age;
        basicPlan.requestSINo = SINo;
    }
    else if ([[segue identifier] isEqualToString:@"goRiderView"]) {
            
        RiderViewController *rider = [segue destinationViewController];
        rider.indexNo = self.indexNo;
        rider.agenID = [self.agenID description];
        rider.requestSINo = SINo;
        rider.requestAge = age;
    }
}

#pragma mark - Handle Data

-(void)getRunningSI
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LastNo,LastUpdated FROM tbl_Adm_TrnTypeNo WHERE TrnTypeCode=\"SI\""];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                SILastNo = sqlite3_column_int(statement, 0);
                
                const char *lastDate = (const char *)sqlite3_column_text(statement, 1);
                SIDate = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];
                
                NSLog(@"LastSINo:%d SIDate:%@",SILastNo,SIDate);
                
            } else {
                NSLog(@"error check logout");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (SILastNo == 0 && SIDate == NULL) {
        [self updateFirstRunSI];
    } else {
        [self updateFirstRunSI];
    }
}

-(void)updateFirstRunSI
{
    int newLastNo;
    newLastNo = SILastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE tbl_Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"SI\"",newLastNo,dateString];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Run SI update!");
                
            } else {
                NSLog(@"Run SI update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getRunningCustCode
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LastNo,LastUpdated FROM tbl_Adm_TrnTypeNo WHERE TrnTypeCode=\"CL\""];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CustLastNo = sqlite3_column_int(statement, 0);
                
                const char *lastDate = (const char *)sqlite3_column_text(statement, 1);
                CustDate = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];
                
                NSLog(@"LastCustNo:%d CustDate:%@",CustLastNo,CustDate);
                
            } else {
                NSLog(@"error check logout");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    if (CustLastNo == 0 && CustDate == NULL) {
        [self updateFirstRunCust];
    } else {
        [self updateFirstRunCust];
    }
}

-(void)updateFirstRunCust
{
    int newLastNo;
    newLastNo = CustLastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE tbl_Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",newLastNo,dateString];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Run Cust update!");
                
            } else {
                NSLog(@"Run Cust update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getOccDesc
{
    occCode = [[NSMutableArray alloc] init];
    occDesc = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT OccpCode,OccpDesc from tbl_Adm_Occp"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [occCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                [occDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getOccLoading
{
    NSInteger row = [occPickerView selectedRowInComponent:0];
    NSString *code = [occCode objectAtIndex:row];
    NSLog(@"code:%@",code);
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT OccpLoading,CPA,PA from tbl_Adm_Occp_Loading where OccpCode = \"%@\"",code];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occLoading = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                occCPA  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                occPA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                LAOccLoadingField.text = occLoading;
                LACPAField.text = occCPA;
                LAPAField.text = occPA;
            }
            else {
                NSLog(@"Error retrieve loading!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getOccCodeLoading
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT a.OccpCode,b.OccpDesc,a.OccpLoading,a.CPA,a.PA from tbl_Adm_Occp_Loading a LEFT JOIN tbl_Adm_Occp b ON a.OccpCode=b.OccpCode where a.OccpCode = \"%@\"",occuCode];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occuDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                occLoading = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                occCPA  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                occPA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
            }
            else {
                NSLog(@"Error retrieve loading!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)insertData
{
    [self getRunningSI];
    [self getRunningCustCode];
    
    //generate SINo || CustCode
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    int runningNoSI = SILastNo + 1;
    int runningNoCust = CustLastNo + 1;
    SINo = [[NSString alloc] initWithFormat:@"SI%@-000%d",currentdate,runningNoSI];
    CustCode = [[NSString alloc] initWithFormat:@"CL%@-000%d",currentdate,runningNoCust];
    
    NSInteger row = [occPickerView selectedRowInComponent:0];
    NSString *code = [occCode objectAtIndex:row];
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO tbl_SI_Trad_LAPayor (SINo, CustCode,PTypeCode,Sequence,DateCreated,CreatedBy) VALUES (\"%@\",\"%@\",\"LA\",\"1\",\"%@\",\"%@\")",SINo, CustCode,LACommencementDateField.text,[self.agenID description]];
        
        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA");
            } else {
                NSLog(@"Failed LA");
            }
            sqlite3_finalize(statement);
        }
        
        NSString *insertSQL2 = [NSString stringWithFormat:
                    @"INSERT INTO tbl_Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, CreatedBy) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"%@\")", CustCode, LANameField.text, smoker, sex, DOB, age, ANB, code, LACommencementDateField.text, [self.agenID description]];
        
        const char *insert_stmt2 = [insertSQL2 UTF8String];
        if(sqlite3_prepare_v2(contactDB, insert_stmt2, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA2");
            } else {
                NSLog(@"Failed LA2");
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
                @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated FROM tbl_SI_Trad_LAPayor a LEFT JOIN tbl_Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=1",[self.requestSINo description]];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                SINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                CustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                clientName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                smoker = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                sex = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                DOB = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                age = sqlite3_column_int(statement, 6);
                occuCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                commencementDate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
            } else {
                NSLog(@"error access tbl_SI_Trad_LAPayor");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - calculation

-(void)calculateAge
{
    //format in year
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc] init];
    [yearFormatter setDateFormat:@"yyyy"];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"MM"];
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"dd"];
    
    NSString *currentYear = [yearFormatter stringFromDate:[NSDate date]];
    NSString *birthYear = [yearFormatter stringFromDate:[datePickerView date]];
    [yearFormatter release];
    
    NSString *currentMonth = [monthFormatter stringFromDate:[NSDate date]];
    NSString *birthMonth = [monthFormatter stringFromDate:[datePickerView date]];
    [monthFormatter release];
    
    NSString *currentDay = [dayFormatter stringFromDate:[NSDate date]];
    NSString *birthDay = [dayFormatter stringFromDate:[datePickerView date]];
    [dayFormatter release];
    
    int yearN = [currentYear intValue];
    int yearB = [birthYear intValue];
    int monthN = [currentMonth intValue];
    int monthB = [birthMonth intValue];
    int dayN = [currentDay intValue];
    int dayB = [birthDay intValue];
    
    int ALB = yearN - yearB;
    int newALB;
    int newANB;
    
    if (ALB <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Date not valid!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    if (monthN < monthB) {
        newALB = ALB - 1;
    }
    else if (monthN == monthB && dayN < dayB) {
        newALB = ALB - 1;
    }
    else {
        newALB = ALB;
    }
    
    if (monthN > monthB) {
        newANB = ALB + 1;
    }
    else if (monthN == monthB && dayN >= dayB) {
        newANB = ALB + 1;
    }
    else {
        newANB = ALB;
    }
    
    age = newALB;
    LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
    ANB = newANB;
    NSLog(@"ANB:%d",ANB);
}

#pragma mark - Picker Management

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [occDesc count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [occDesc objectAtIndex:row];
}

#pragma mark - Memory management
- (void)viewDidUnload
{
    [self setLANameField:nil];
    [self setSexSegment:nil];
    [self setSmokerSegment:nil];
    [self setLAAgeField:nil];
    [self setLACommencementDateField:nil];
    [self setLAOccSearchField:nil];
    [self setLAOccLoadingField:nil];
    [self setLACPAField:nil];
    [self setLAPAField:nil];
    [self setMyScrollView:nil];
    [self setOccPickerView:nil];
    [self setDatePickerView:nil];
    [self setLifeAssuredBtn:nil];
    [self setSmoker:nil];
    [self setSex:nil];
    [self setPickerToolbar:nil];
    [self setOccDesc:nil];
    [self setOccLoading:nil];
    [self setOccCode:nil];
    [self setOccCPA:nil];
    [self setOccPA:nil];
    [self setAgenID:nil];
    [self setSINo:nil];
    [self setCustCode:nil];
    [self setSIDate:nil];
    [self setCustDate:nil];
    [self setBtnDOB:nil];
    [self setBtnOccp:nil];
    [self setDOB:nil];
    [self setJobDesc:nil];
    [self setRequestSINo:nil];
    [self setClientName:nil];
    [self setOccuCode:nil];
    [self setCommencementDate:nil];
    [self setOccuDesc:nil];
    [super viewDidUnload];
}

- (void)dealloc 
{
    [occuDesc release];
    [commencementDate release];
    [occuCode release];
    [clientName release];
    [requestSINo release];
    [LANameField release];
    [sexSegment release];
    [smokerSegment release];
    [LAAgeField release];
    [LACommencementDateField release];
    [LAOccSearchField release];
    [LAOccLoadingField release];
    [LACPAField release];
    [LAPAField release];
    [myScrollView release];
    [occPickerView release];
    [datePickerView release];
    [lifeAssuredBtn release];
    [smoker release];
    [sex release];
    [pickerToolbar release];
    [occDesc release];
    [occCode release];
    [occLoading release];
    [occCPA release];
    [occPA release];
    [agenID release];
    [SINo release];
    [CustCode release];
    [SIDate release];
    [CustDate release];
    [btnDOB release];
    [btnOccp release];
    [DOB release];
    [jobDesc release];
    [super dealloc];
}

@end
