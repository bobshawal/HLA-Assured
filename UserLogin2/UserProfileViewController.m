//
//  UserProfileViewController.m
//  HLA
//
//  Created by shawal sapuan on 7/18/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "UserProfileViewController.h"
#import "ChangePwdViewController.h"

@interface UserProfileViewController ()
@end

@implementation UserProfileViewController
@synthesize statusLabel;
@synthesize loginIDLabel;
@synthesize idRequest;
@synthesize myScrollView;
@synthesize agentCodeField;
@synthesize agentNameField;
@synthesize agentTypeField;
@synthesize contactNoField;
@synthesize leaderCodeField;
@synthesize leaderNameField;
@synthesize registerNoField;
@synthesize emailField;
@synthesize indexNo,username,code,name,type,contactNo,leaderCode,leaderName,email,registerNo;

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
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    NSLog(@"receive User:%@",[self.idRequest description]);
    NSLog(@"receive Index:%d",self.indexNo);
    
    loginIDLabel.text = [NSString stringWithFormat:@"%@",[self.idRequest description]];
}

- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    [self setAgentCodeField:nil];
    [self setAgentNameField:nil];
    [self setAgentTypeField:nil];
    [self setContactNoField:nil];
    [self setLeaderCodeField:nil];
    [self setLeaderNameField:nil];
    [self setRegisterNoField:nil];
    [self setEmailField:nil];
    [self setUsername:nil];
    [self setCode:nil];
    [self setName:nil];
    [self setType:nil];
    [self setContactNo:nil];
    [self setLeaderCode:nil];
    [self setLeaderName:nil];
    [self setEmail:nil];
    [self setRegisterNo:nil];
    [self setStatusLabel:nil];
    [self setLoginIDLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewExisting];
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

- (IBAction)doCancel:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doSaveEdit:(id)sender 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Update profile?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
    [alert release];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissModalViewControllerAnimated:YES];
        
    } else {
        [self updateUserData];
    }
}

- (void)dealloc 
{
    [myScrollView release];
    [agentCodeField release];
    [agentNameField release];
    [agentTypeField release];
    [contactNoField release];
    [leaderCodeField release];
    [leaderNameField release];
    [registerNoField release];
    [emailField release];
    [username release];
    [code release];
    [name release];
    [type release];
    [contactNo release];
    [leaderCode release];
    [leaderName release];
    [email release];
    [registerNo release];
    [statusLabel release];
    [loginIDLabel release];
    [super dealloc];
}

-(void)viewExisting
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT IndexNo,AgentLoginID,AgentCode,AgentName,AgentType,AgentContactNo,ImmediateLeaderCode,ImmediateLeaderName,BusinessRegNumber,AgentEmail FROM tbl_Agent_Profile WHERE IndexNo=\"%d\"",self.indexNo];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                username = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                const char *code2 = (const char*)sqlite3_column_text(statement, 2);
                code = code2 == NULL ? nil : [[NSString alloc] initWithUTF8String:code2];
                
                const char *name2 = (const char*)sqlite3_column_text(statement, 3);
                name = name2 == NULL ? nil : [[NSString alloc] initWithUTF8String:name2];
                
                const char *type2 = (const char*)sqlite3_column_text(statement, 4);
                type = type2 == NULL ? nil : [[NSString alloc] initWithUTF8String:type2];
                
                const char *contactNo2 = (const char*)sqlite3_column_text(statement, 5);
                contactNo = contactNo2 == NULL ? nil : [[NSString alloc] initWithUTF8String:contactNo2];
                
                const char *leaderCode2 = (const char*)sqlite3_column_text(statement, 6);
                leaderCode = leaderCode2 == NULL ? nil : [[NSString alloc] initWithUTF8String:leaderCode2];
                
                const char *leaderName2 = (const char*)sqlite3_column_text(statement, 7);
                leaderName = leaderName2 == NULL ? nil : [[NSString alloc] initWithUTF8String:leaderName2];
                
                const char *register2 = (const char*)sqlite3_column_text(statement, 8);
                registerNo = register2 == NULL ? nil : [[NSString alloc] initWithUTF8String:register2];
                
                const char *email2 = (const char*)sqlite3_column_text(statement, 9);
                email = email2 == NULL ? nil : [[NSString alloc] initWithUTF8String:email2];
                
                agentCodeField.text = code;
                agentNameField.text = name;
                agentTypeField.text = type;
                contactNoField.text = contactNo;
                leaderCodeField.text = leaderCode;
                leaderNameField.text = leaderName;
                registerNoField.text = registerNo;
                emailField.text = email;
                
//                NSLog(@"%@",querySQL);
                
            } else {
                NSLog(@"Failed!");
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

-(void)updateUserData
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE tbl_Agent_Profile SET AgentCode= \"%@\",AgentName= \"%@\",AgentType= \"%@\",AgentContactNo= \"%@\",ImmediateLeaderCode= \"%@\",ImmediateLeaderName= \"%@\",BusinessRegNumber = \"%@\",AgentEmail= \"%@\" WHERE IndexNo=\"%d\"",agentCodeField.text,agentNameField.text,agentTypeField.text,contactNoField.text,leaderCodeField.text,leaderNameField.text,registerNoField.text,emailField.text,self.indexNo];
        
//        NSLog(@"%@",querySQL);
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                statusLabel.text = @"Data successfully update!";
                statusLabel.textColor = [UIColor blueColor];
                NSLog(@"Done update!");
                
            } else {
                statusLabel.text = @"Failed to update!";
                statusLabel.textColor = [UIColor redColor];
                NSLog(@"Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

@end
