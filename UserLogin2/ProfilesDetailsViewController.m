//
//  ProfilesDetailsViewController.m
//  UserLogin2
//
//  Created by Md. Nazmus Saadat on 7/13/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

// this is sample syntaxing and procedural presentation of the coding structure, must modify and ensure correct implementation always; preferably checking through output using commandline


#import "ProfilesDetailsViewController.h"

@interface ProfilesDetailsViewController ()

@end

@implementation ProfilesDetailsViewController
@synthesize myScrollView;
@synthesize oldPwdField;
@synthesize changePwdField;
@synthesize retypePwdField;
@synthesize agentCodeField;
@synthesize agentNameField;
@synthesize agentTypeField;
@synthesize cntcNoField;
@synthesize leaderCodeField;
@synthesize leaderNameField;
@synthesize registrationNoField;
@synthesize emailField;
@synthesize statusLabel;
@synthesize userID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Receive user:%d",self.userID);
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
}

- (void)viewDidUnload
{
    [self setAgentNameField:nil];
    [self setAgentCodeField:nil];
    [self setAgentTypeField:nil];
    [self setCntcNoField:nil];
    [self setLeaderCodeField:nil];
    [self setLeaderNameField:nil];
    [self setEmailField:nil];
    [self setMyScrollView:nil];
    [self setRegistrationNoField:nil];
    [self setOldPwdField:nil];
    [self setRetypePwdField:nil];
    [self setStatusLabel:nil];
    [self setChangePwdField:nil];
    [super viewDidUnload];
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

- (IBAction)cancelBtnPressed:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doSave:(id)sender 
{
    if (oldPwdField.text.length <= 0 || changePwdField.text.length <= 0 || retypePwdField.text.length <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill password field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    } else if ([changePwdField.text isEqualToString:retypePwdField.text]){
        
        NSLog(@"Password match!");
        [self saveData];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password did not match!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void)dealloc {
    [agentNameField release];
    [agentCodeField release];
    [agentTypeField release];
    [cntcNoField release];
    [leaderCodeField release];
    [leaderNameField release];
    [myScrollView release];
    [registrationNoField release];
    [oldPwdField release];
    [retypePwdField release];
    [emailField release];
    [statusLabel release];
    [changePwdField release];
    [super dealloc];
}

- (void) saveData
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE tbl_User_Profile SET AgentPassword= \"%@\" ,FirstLogin = 0 WHERE IndexNo=\"%d\"",changePwdField.text,self.userID];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"UserProfile Update!");
                
            } else {
                NSLog(@"UserProfile Failed!");
            }
            sqlite3_finalize(statement);
        }
        
        NSString *query2 = [NSString stringWithFormat:@"UPDATE tbl_Agent_Profile SET AgentCode= \"%@\", AgentName= \"%@\" ,AgentType= \"%@\",AgentContactNo= \"%@\",ImmediateLeaderCode= \"%@\",ImmediateLeaderName= \"%@\",BusinessRegNumber= \"%@\",AgentEmail= \"%@\" WHERE IndexNo = \"%d\"",agentCodeField.text,agentNameField.text,agentTypeField.text,cntcNoField.text,leaderCodeField.text,leaderNameField.text,registrationNoField.text,emailField.text,self.userID];
        
        const char *result = [query2 UTF8String];
        if (sqlite3_prepare_v2(contactDB, result, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"AgentProfile Update!");
                statusLabel.text = @"Data updated! Please relogin.";
                
            } else {
                NSLog(@"AgentProfile Failed!");
                statusLabel.text = @"Update failed!.";
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}

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

@end
