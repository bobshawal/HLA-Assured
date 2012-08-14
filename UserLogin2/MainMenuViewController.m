//
//  MainMenuViewController.m
//  HLA
//
//  Created by shawal sapuan on 7/17/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "MainMenuViewController.h"
#import "UserProfileViewController.h"
#import "ChangePwdViewController.h"
#import "NewLAViewController.h"
#import "ViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize userRequest;
@synthesize welcomeLabel;
@synthesize indexNo;

- (void)viewDidLoad
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    [super viewDidLoad];
    welcomeLabel.text = [NSString stringWithFormat:@"User : %@",[self.userRequest description]];
}

- (void)viewDidUnload
{
    [self setWelcomeLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Handle Action

- (IBAction)changePwdBtnPressed:(id)sender 
{
    ChangePwdViewController *changePwdView = [self.storyboard instantiateViewControllerWithIdentifier:@"changePasswordView"];
    changePwdView.modalPresentationStyle = UIModalPresentationFormSheet;
    changePwdView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    changePwdView.userID = self.indexNo;
    [self presentModalViewController:changePwdView animated:YES];
    changePwdView.view.superview.bounds = CGRectMake(0, 0, 550, 600);
}

- (IBAction)doLogout:(id)sender 
{
    ViewController *mainLogin = [self.storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
    mainLogin.modalPresentationStyle = UIModalPresentationFullScreen;
    mainLogin.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:mainLogin animated:YES];
    
    [self updateDateLogout];
}

-(void)updateDateLogout
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE tbl_User_Profile SET LastLogoutDate= \"%@\" WHERE IndexNo=\"%d\"",dateString,indexNo];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"date update!");
                
            } else {
                NSLog(@"date update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"goUserProfile"]) {
        
        UserProfileViewController *userProfile = [segue destinationViewController];
        userProfile.idRequest = [self.userRequest description];
        userProfile.indexNo = self.indexNo;
        
    }
    else if ([[segue identifier] isEqualToString:@"goLAScreen"]) {
        
        NewLAViewController *viewLA = [segue destinationViewController];
        viewLA.indexNo = self.indexNo;
        viewLA.agenID = [self.userRequest description];
    }
    
}

#pragma mark - Memory management

- (void)dealloc {
    [welcomeLabel release];
    [super dealloc];
}

@end
