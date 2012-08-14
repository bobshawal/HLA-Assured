//
//  ChangePwdViewController.m
//  HLA
//
//  Created by shawal sapuan on 7/19/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "ViewController.h"

@interface ChangePwdViewController ()

@end

@implementation ChangePwdViewController
@synthesize userID;
@synthesize oldPwdField;
@synthesize pwdNewField;
@synthesize retypeNewPwdField;
@synthesize passwordDB;
@synthesize msgLabel;


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Receive userID:%d",self.userID);
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    [self validateExistingPwd];
}

- (void)viewDidUnload
{
    [self setOldPwdField:nil];
    [self setRetypeNewPwdField:nil];
    [self setPasswordDB:nil];
    [self setMsgLabel:nil];
    [self setPwdNewField:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)doCancelChange:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)changePwdBtnPressed:(id)sender 
{
    NSLog(@"Your existing:%@",passwordDB);
    
    if (oldPwdField.text.length <= 0 || pwdNewField.text.length <= 0 || retypeNewPwdField.text.length <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill up all field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    } else if ([pwdNewField.text isEqualToString:retypeNewPwdField.text]){
        
        [self validatePassword];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password did not match!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        oldPwdField.text = @"";
        pwdNewField.text = @"";
        retypeNewPwdField.text = @"";
    }
}

-(void)validateExistingPwd
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT AgentPassword FROM tbl_User_Profile WHERE IndexNO=\"%d\"",self.userID];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                passwordDB = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Come back later" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)validatePassword
{
    if ([oldPwdField.text isEqualToString:passwordDB]){
        
        NSLog(@"Password enter match!");
        [self saveChanges];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password did not match!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        oldPwdField.text = @"";
        pwdNewField.text = @"";
        retypeNewPwdField.text = @"";
    }
}

-(void)saveChanges
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE tbl_User_Profile SET AgentPassword= \"%@\" WHERE IndexNo=\"%d\"",pwdNewField.text,self.userID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                oldPwdField.text = @"";
                pwdNewField.text = @"";
                retypeNewPwdField.text = @"";
                NSLog(@"Pwd Updated!");
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Password save!\n You need to re-login." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert setTag:01];
                [alert show];
                [alert release];
                
            } else {
                msgLabel.text = @"Failed to update!";
                msgLabel.textColor = [UIColor redColor];
                NSLog(@"Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 01) {     
        if (buttonIndex == 0) {
            
            ViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
            [self presentViewController:loginView animated:YES completion:nil];
        }
    }
}

- (void)dealloc {
    [oldPwdField release];
    [retypeNewPwdField release];
    [passwordDB release];
    [msgLabel release];
    [pwdNewField release];
    [super dealloc];
}
@end
