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
@synthesize termLabel;
@synthesize sumLabel;
@synthesize planLabel;
@synthesize cpaLabel;
@synthesize unitLabel;
@synthesize occpLabel;
@synthesize HLLabel;
@synthesize HLTLabel;
@synthesize termField;
@synthesize sumField;
@synthesize cpaField;
@synthesize unitField;
@synthesize occpField;
@synthesize HLField;
@synthesize HLTField;
@synthesize planBtn;
@synthesize deducBtn;
@synthesize minDisplayLabel;
@synthesize maxDisplayLabel;
@synthesize btnPType;
@synthesize btnAddRider;
@synthesize riderBtn;
@synthesize indexNo,agenID,requestPlanCode,requestSINo,requestAge,requestCoverTerm,requestBasicSA;
@synthesize pTypeCode,PTypeSeq,pTypeDesc,riderCode,riderDesc,popOverConroller;
@synthesize FLabelCode,FLabelDesc,FRidName,FInputCode,FFieldName,FTbName,FCondition;
@synthesize expAge,minSATerm,maxSATerm,minTerm,maxTerm,maxRiderTerm,planCode,SINoPlan,planOption,deductible,maxRiderSA;
@synthesize inputHL1KSA,inputHL1KSATerm,inputHL100SA,inputHL100SATerm,inputHLPercentage,inputHLPercentageTerm;

#pragma mark - Cycle View

- (void)viewDidLoad
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    NSLog(@"indexNo:%d,agenID:%@,propectAge:%d,covered:%d,SINo:%@ planCode:%@",self.indexNo,[self.agenID description],self.requestAge,self.requestCoverTerm,[self.requestSINo description],[self.requestPlanCode description]);
    
    [riderBtn setBackgroundImage:[UIImage imageNamed:@"button_hover"] forState:UIControlStateNormal];
    deducBtn.hidden = YES;
    SINoPlan = [[NSString alloc] initWithFormat:@"%@",[self.requestSINo description]];
    planCode = [[NSString alloc] initWithFormat:@"%@",[self.requestPlanCode description]];
    
    [super viewDidLoad];
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

#pragma mark - keyboard display

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    minDisplayLabel.text = @"";
    maxDisplayLabel.text = @"";
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            minDisplayLabel.text = @"";
            maxDisplayLabel.text = @"";
            break;
            
        case 1:
            minDisplayLabel.text = [NSString stringWithFormat:@"Min: %d",minTerm];
            maxDisplayLabel.text = [NSString stringWithFormat:@"Max: %.f",maxRiderTerm];
            break;
            
        case 2:
            minDisplayLabel.text = [NSString stringWithFormat:@"Min: %d",minSATerm];
            maxDisplayLabel.text = [NSString stringWithFormat:@"Max: %.f",maxRiderSA];
            break;
            
        default:
            minDisplayLabel.text = @"";
            maxDisplayLabel.text = @"";
            break;
    }
    return YES;
}

#pragma mark - logic cycle/calculation

-(void)toggleForm
{
    NSUInteger i;
    for (i=0; i<[FLabelCode count]; i++) {
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"RITM"]]) {
            termLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            term = YES;
        }
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"SUMA"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"SUAS"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"GYIRM"]]) {
            sumLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            sumA = YES;
        }
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"PLOP"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"PLCH"]]) {
            planLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            plan = YES;
        }
        
        cpaLabel.textColor = [UIColor grayColor];
        cpaField.enabled = NO;
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"UNIT"]]) {
            unitLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            unit = YES;
        } else if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"DEDUC"]]) {
            unitLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            deduc = YES;
        }
        
        occpLabel.textColor = [UIColor grayColor];
        occpField.enabled = NO;
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL1K"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL10"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HLP"]]) {
            HLLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            hload = YES;
        }
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL1KT"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL10T"]] ||
            [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HLPT"]]) {
            HLTLabel.text = [NSString stringWithFormat:@"%@",[FLabelDesc objectAtIndex:i]];
            hloadterm = YES;
        }
    }
    [self replaceActive];
}

-(void)replaceActive
{
    if (term) {
        termLabel.textColor = [UIColor blackColor];
        termField.enabled = YES;
    } else {
        termLabel.textColor = [UIColor grayColor];
        termField.enabled = NO;
    }
    
    if (sumA) {
        sumLabel.textColor = [UIColor blackColor];
        sumField.enabled = YES;
    } else {
        sumLabel.textColor = [UIColor grayColor];
        sumField.enabled = NO;
    }
    
    if (plan) {
        planLabel.textColor = [UIColor blackColor];
        planBtn.enabled = YES;
    } else {
        planLabel.textColor = [UIColor grayColor];
        planBtn.enabled = NO;
        planLabel.text = @"PA Class";
    }
    
    if (unit) {
        unitLabel.textColor = [UIColor blackColor];
        unitField.enabled = YES;
        deducBtn.hidden = YES;
    } else {
        unitLabel.textColor = [UIColor grayColor];
        unitField.enabled = NO;
    }
    
    if (deduc) {
        unitLabel.textColor = [UIColor blackColor];
        unitField.hidden = YES;
        deducBtn.hidden = NO;
    } else {
        unitLabel.textColor = [UIColor grayColor];
        unitField.enabled = NO;
        unitField.hidden = NO;
        deducBtn.hidden = YES;
        unitLabel.text = @"Units";
    }
    
    if (hload) {
        HLLabel.textColor = [UIColor blackColor];
        HLField.enabled = YES;
    } else {
        HLLabel.textColor = [UIColor grayColor];
        HLField.enabled = NO;
    }
    
    if (hloadterm) {
        HLTLabel.textColor = [UIColor blackColor];
        HLTField.enabled = YES;
    } else {
        HLTLabel.textColor = [UIColor grayColor];
        HLTField.enabled = NO;
    }
}

-(void)calculateTerm
{
    int period = expAge - self.requestAge;
    int period2 = 80 - self.requestAge;
    double age1 = fmin(period2,60);
    
    if ([riderCode isEqualToString:@"LCWP"]||[riderCode isEqualToString:@"PR"]||[riderCode isEqualToString:@"PLCP"]||
        [riderCode isEqualToString:@"PTR"]||[riderCode isEqualToString:@"SP_STD"]||[riderCode isEqualToString:@"SP_PRE"]) {
        maxRiderTerm = fmin(self.requestCoverTerm,age1);
    } else {
        maxRiderTerm = fmin(period,self.requestCoverTerm);
    }
    NSLog(@"exp-alb:%d,covperiod:%d,maxRiderTerm:%.f",period,self.requestCoverTerm,maxRiderTerm);
}

-(void)calculateSA
{
    int dblPseudoBSA = self.requestBasicSA / 0.05;
    double dblPseudoBSA2 = dblPseudoBSA * 0.1;
    if ([riderCode isEqualToString:@"CCTR"]) {
        maxRiderSA = dblPseudoBSA * 5;
    } else if ([riderCode isEqualToString:@"ETPD"]) {
        maxRiderSA = fmin(dblPseudoBSA2,120000);
    }
    else {
        maxRiderSA = maxSATerm;
    }
}

#pragma mark - Action

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"riderGoBasic"]) {
        
        BasicPlanViewController *basicPlan = [segue destinationViewController];
        basicPlan.indexNo = self.indexNo;
        basicPlan.agenID = [self.agenID description];
        basicPlan.ageClient = self.requestAge;
        basicPlan.requestSINo = SINoPlan;
    }
    else if ([[segue identifier] isEqualToString:@"riderGoLA"]) {
        
        NewLAViewController *laView = [segue destinationViewController];
        laView.indexNo = self.indexNo;
        laView.agenID = [self.agenID description];
        laView.requestSINo = SINoPlan;
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
        popView.requestSINo = SINoPlan;
		popOverConroller = [[[UIPopoverController alloc] initWithContentViewController:popView] retain];
        popView.delegate = self;
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
        popView.requestPtype = self.pTypeCode;
        popView.requestSeq = self.PTypeSeq;
		popOverConroller = [[[UIPopoverController alloc] initWithContentViewController:popView] retain];
        popView.delegate = self;
        [popView release];
		
		[popOverConroller setPopoverContentSize:CGSizeMake(600.0f, 400.0f)];
        [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popOverConroller dismissPopoverAnimated:YES];
	}
}

- (IBAction)planBtnPressed:(id)sender
{
    NSUInteger i;
    for (i=0; i<[FLabelCode count]; i++) {
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"PLOP"]] ||
                [[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"PLCH"]]) {
            if(![popOverConroller isPopoverVisible]) {
                pressedPlan = YES;
                RiderFormTbViewController *popView = [[RiderFormTbViewController alloc] init];
                popView.requestCondition = [NSString stringWithFormat:@"%@",[FCondition objectAtIndex:i]];
                popOverConroller = [[[UIPopoverController alloc] initWithContentViewController:popView] retain];
                popView.delegate = self;
                [popView release];
                
                [popOverConroller setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];
                [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            } else {
                [popOverConroller dismissPopoverAnimated:YES];
                pressedPlan = NO;
            }
        }
    }
}

- (IBAction)deducBtnPressed:(id)sender
{
    NSUInteger i;
    for (i=0; i<[FLabelCode count]; i++) {
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"DEDUC"]]) {
            if(![popOverConroller isPopoverVisible]){
                pressedDeduc = YES;
                RiderFormTbViewController *popView = [[RiderFormTbViewController alloc] init];
                popView.requestCondition = [NSString stringWithFormat:@"%@",[FCondition objectAtIndex:i]];
                popOverConroller = [[[UIPopoverController alloc] initWithContentViewController:popView] retain];
                popView.delegate = self;
                [popView release];
                [popOverConroller setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];
                [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            } else {
                [popOverConroller dismissPopoverAnimated:YES];
                pressedDeduc = NO;
            }
        }
    }
}

- (IBAction)doSaveRider:(id)sender
{
    NSUInteger i;
    for (i=0; i<[FLabelCode count]; i++) {
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL1K"]]) {
            inputHL1KSA = [[NSString alloc]initWithFormat:@"%@",HLField.text];
        } else if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL10"]]) {
            inputHL100SA = [[NSString alloc]initWithFormat:@"%@",HLField.text];
        } else if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HLP"]]) {
            inputHLPercentage = [[NSString alloc]initWithFormat:@"%@",HLField.text];
        }
        
        if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL1KT"]]) {
            inputHL1KSATerm = [HLTField.text intValue];
        } else if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HL10T"]]) {
            inputHL100SATerm = [HLTField.text intValue];
        } else if ([[FLabelCode objectAtIndex:i] isEqualToString:[NSString stringWithFormat:@"HLPT"]]) {
            inputHLPercentageTerm = [HLTField.text intValue];
        }
    }
    if (term) {     //check term
        if (termField.text.length <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill up all field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else if (sumA) {    //check sum assured
            if (sumField.text.length <= 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill up all field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            } else {      //save
                NSLog(@"will save rider - 1");
//                NSLog(@"SINoPlan:%@, riderCode:%@, pTypeCode:%@, PTypeSeq:%d, term:%@, sumA:%@, planOption:%@, unit:%@, deduc:%@, HL1k:%@, HL1kTerm:%d, HL100:%@, HL100Term:%d, HLPerc:%@, HLPercTerm:%d",SINoPlan,riderCode, pTypeCode, PTypeSeq, termField.text, sumField.text, planOption, unitField.text, deductible, inputHL1KSA, inputHL1KSATerm, inputHL100SA, inputHL100SATerm, inputHLPercentage, inputHLPercentageTerm);
                [self saveRider];
            }
        } else {      //save
            NSLog(@"will save rider - 2");
            [self saveRider];
        }
    } else if (sumA) {        //check sum assured
        if (sumField.text.length <= 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill up all field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        } else {      //save
            NSLog(@"will save rider - 3");
            [self saveRider];
        }
    } else {        //save
        NSLog(@"will save rider - 4");
        [self saveRider];
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
//    NSLog(@"RIDERVC pType:%@, seq:%d, desc:%@",pTypeCode,PTypeSeq,pTypeDesc);
}

-(void)RiderListController:(RiderListTbViewController *)inController didSelectCode:(NSString *)code desc:(NSString *)desc
{
    //reset value existing
    if (riderCode != NULL) {
        term = NO;
        sumA = NO;
        plan = NO;
        unit = NO;
        deduc = NO;
        hload = NO;
        hloadterm = NO;
        planOption = nil;
        deductible = nil;
        inputHL100SA = nil;
        inputHL1KSA = nil;
        inputHLPercentage = nil;
        inputHL1KSATerm = 0;
        inputHL100SATerm = 0;
        inputHLPercentageTerm = 0;
        sumField.text = @"";
        termField.text = @"";
        HLField.text = @"";
        HLTField.text = @"";
        
        [self.planBtn setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
        [self.deducBtn setTitle:[NSString stringWithFormat:@""] forState:UIControlStateNormal];
    }
    riderCode = [[NSString alloc] initWithFormat:@"%@",code];
    riderDesc = [[NSString alloc] initWithFormat:@"%@",desc];
    [self.btnAddRider setTitle:riderDesc forState:UIControlStateNormal];
    [popOverConroller dismissPopoverAnimated:YES];
    
    [self getLabelForm];
    [self toggleForm];
    [self getRiderTermRule];
}

-(void) RiderFormController:(RiderFormTbViewController *)inController didSelectItem:(NSString *)item desc:(NSString *)itemdesc
{
    if (pressedPlan) {
        [self.planBtn setTitle:itemdesc forState:UIControlStateNormal];
        planOption = [[NSString alloc] initWithFormat:@"%@",item];
        NSLog(@"planoption:%@",planOption);
    } else if (pressedDeduc) {
        [self.deducBtn setTitle:itemdesc forState:UIControlStateNormal];
        deductible = [[NSString alloc] initWithFormat:@"%@",item];
    }

    [popOverConroller dismissPopoverAnimated:YES];
    pressedPlan = NO;
    pressedDeduc = NO;
}

#pragma mark - DB handling

-(void)getLabelForm
{
    FLabelCode = [[NSMutableArray alloc] init];
    FLabelDesc = [[NSMutableArray alloc] init];
    FRidName = [[NSMutableArray alloc] init];
    FInputCode = [[NSMutableArray alloc] init];
    FTbName = [[NSMutableArray alloc] init];
    FFieldName = [[NSMutableArray alloc] init];
    FCondition = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT LabelCode,LabelDesc,RiderName,InputCode,TableName,FieldName,Condition FROM Trad_Sys_Rider_Label WHERE RiderCode=\"%@\"",riderCode];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                [FLabelCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                [FLabelDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
                [FRidName addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
                [FInputCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)]];
                
                const char *tbname = (const char *)sqlite3_column_text(statement, 4);
                [FTbName addObject:tbname == NULL ? nil : [[NSString alloc] initWithUTF8String:tbname]];
                
                const char *fieldname = (const char *)sqlite3_column_text(statement, 5);
                [FFieldName addObject:fieldname == NULL ? nil :[[NSString alloc] initWithUTF8String:fieldname]];
                
                const char *condition = (const char *)sqlite3_column_text(statement, 6);
                [FCondition addObject:condition == NULL ? nil :[[NSString alloc] initWithUTF8String:condition]];
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
                expAge =  sqlite3_column_int(statement, 2);
                minTerm =  sqlite3_column_int(statement, 3);
                maxTerm =  sqlite3_column_int(statement, 4);
                minSATerm = sqlite3_column_int(statement, 5);
                maxSATerm = sqlite3_column_int(statement, 6);
                
                NSLog(@"expiryAge:%d,minTerm:%d,maxTerm:%d,minSA:%d,maxSA:%d",expAge,minTerm,maxTerm,minSATerm,maxSATerm);
                
                [self calculateTerm];
                [self calculateSA];
                
            } else {
                NSLog(@"error access Trad_Mtn");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)saveRider
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
        @"INSERT INTO Trad_Rider_Details (SINo,  RiderCode, PTypeCode, Seq, RiderTerm, SumAssured, PlanOption, Units, Deductible, HL1KSA, HL1KSATerm, HL100SA, HL100SATerm, HLPercentage, HLPercentageTerm, CreatedAt) VALUES"
        "(\"%@\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\")", SINoPlan,riderCode, pTypeCode, PTypeSeq, termField.text, sumField.text, planOption, unitField.text, deductible, inputHL1KSA, inputHL1KSATerm, inputHL100SA, inputHL100SATerm, inputHLPercentage, inputHL100SATerm, dateString];

        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Saved Rider!");
            } else {
                NSLog(@"Failed Save Rider!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - Memory Management

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverConroller = nil;
}

- (void)viewDidUnload
{
    [self setInputHL1KSA:nil];
    [self setInputHL100SA:nil];
    [self setInputHLPercentage:nil];
    [self setPlanOption:nil];
    [self setDeductible:nil];
    [self setPlanCode:nil];
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
    [self setFLabelCode:nil];
    [self setFLabelDesc:nil];
    [self setFRidName:nil];
    [self setFTbName:nil];
    [self setFInputCode:nil];
    [self setFFieldName:nil];
    [self setFCondition:nil];
    [self setTermLabel:nil];
    [self setSumLabel:nil];
    [self setPlanLabel:nil];
    [self setCpaLabel:nil];
    [self setUnitLabel:nil];
    [self setOccpLabel:nil];
    [self setHLLabel:nil];
    [self setHLTLabel:nil];
    [self setTermField:nil];
    [self setSumField:nil];
    [self setCpaField:nil];
    [self setUnitField:nil];
    [self setOccpField:nil];
    [self setHLField:nil];
    [self setHLTField:nil];
    [self setPlanBtn:nil];
    [self setDeducBtn:nil];
    [self setMinDisplayLabel:nil];
    [self setMaxDisplayLabel:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [inputHL1KSA release];
    [inputHL100SA release];
    [inputHLPercentage release];
    [deductible release];
    [planOption release];
    [planCode release];
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
    [FLabelCode release];
    [FLabelDesc release];
    [FInputCode release];
    [FRidName release];
    [FTbName release];
    [FFieldName release];
    [FCondition release];
    [termLabel release];
    [sumLabel release];
    [planLabel release];
    [cpaLabel release];
    [unitLabel release];
    [occpLabel release];
    [HLLabel release];
    [HLTLabel release];
    [termField release];
    [sumField release];
    [cpaField release];
    [unitField release];
    [occpField release];
    [HLField release];
    [HLTField release];
    [planBtn release];
    [deducBtn release];
    [minDisplayLabel release];
    [maxDisplayLabel release];
    [super dealloc];
}
@end
