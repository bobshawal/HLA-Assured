//
//  ForgotPwdViewController.m
//  HLA
//
//  Created by shawal sapuan on 7/17/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ForgotPwdViewController.h"

@interface ForgotPwdViewController ()

@end

@implementation ForgotPwdViewController
@synthesize questLabel;
@synthesize ansField;
@synthesize statusLabelOne;
@synthesize statusLabelTwo;
@synthesize popOverConroller,questCode,questDesc,answer,password;

- (void)viewDidLoad
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    UITapGestureRecognizer *gestureQOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectQuestion:)];
    gestureQOne.numberOfTapsRequired = 1;
    [questLabel addGestureRecognizer:gestureQOne];
    [gestureQOne release];
    
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - handle action

- (void)selectQuestion:(id)sender
{
    if(![popOverConroller isPopoverVisible]){
        
		RetreivePwdTbViewController *popView = [[RetreivePwdTbViewController alloc] init];
		popOverConroller = [[[UIPopoverController alloc] initWithContentViewController:popView] retain];
        popView.delegate = self;
        [popView release];
		
		[popOverConroller setPopoverContentSize:CGSizeMake(530.0f, 400.0f)];
        [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popOverConroller dismissPopoverAnimated:YES];
	}
}

- (IBAction)doCancelForgot:(id)sender 
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)doRetrieve:(id)sender
{
    if (ansField.text.length <= 0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill answer field!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else {
        if ([ansField.text isEqualToString:answer]) {
           
            [self retrievePassword];
            statusLabelOne.text = @"Success!";
            statusLabelOne.textColor = [UIColor blueColor];
            
            statusLabelTwo.text = [[NSString alloc] initWithFormat:@"Your password is %@",password];
            statusLabelTwo.textColor = [UIColor blueColor];
        }
        else {
            statusLabelOne.text = @"Failed!";
            statusLabelOne.textColor = [UIColor redColor];
            
            statusLabelTwo.text = @"Please insert correct answer!";
            statusLabelTwo.textColor = [UIColor redColor];
        }
    }
}

#pragma mark - delegate

-(void)retrievePwd:(RetreivePwdTbViewController *)inController didSelectQuest:(NSString *)code desc:(NSString *)desc ans:(NSString *)ans
{
    questCode = [[NSString alloc] initWithFormat:@"%@",code];
    questDesc = [[NSString alloc] initWithFormat:@"%@",desc];
    answer = [[NSString alloc] initWithFormat:@"%@",ans];
    
    questLabel.text = [[NSString alloc] initWithFormat:@"%@",questDesc];
    [popOverConroller dismissPopoverAnimated:YES];
}

#pragma mark - handling db

-(void) retrievePassword
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT AgentPassword from tbl_User_Profile"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                password = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            } else {
                NSLog(@"Error retreive!");
            }
            sqlite3_finalize(statement);
        }

        NSString *sqlUpdate = [NSString stringWithFormat:@"UPDATE tbl_User_Profile SET ForgetPassword = 1"];
        const char *sqlUpdate_stmt = [sqlUpdate UTF8String];
        if (sqlite3_prepare_v2(contactDB, sqlUpdate_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"UserProfile Update!");
                
            } else {
                NSLog(@"UserProfile Failed!");
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}

#pragma mark - memory management

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverConroller = nil;
}

- (void)viewDidUnload
{
    [self setQuestCode:nil];
    [self setQuestDesc:nil];
    [self setAnswer:nil];
    [self setQuestLabel:nil];
    [self setAnsField:nil];
    [self setPassword:nil];
    [self setStatusLabelOne:nil];
    [self setStatusLabelTwo:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [questLabel release];
    [ansField release];
    [questDesc release];
    [questCode release];
    [answer release];
    [password release];
    [statusLabelOne release];
    [statusLabelTwo release];
    [super dealloc];
}
@end
