//
//  RetreivePwdTbViewController.m
//  HLA
//
//  Created by shawal sapuan on 8/30/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "RetreivePwdTbViewController.h"

@interface RetreivePwdTbViewController ()

@end

@implementation RetreivePwdTbViewController
@synthesize selectedQuestCode,selectedQuestDesc,quesCode,quesDesc,selectedQuestAns,quesAns,delegate;

- (void)viewDidLoad
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    [self getSecurityQuestion];
    
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - handling db

-(void)getSecurityQuestion
{
    quesCode = [[NSMutableArray alloc] init];
    quesDesc = [[NSMutableArray alloc] init];
    quesAns = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
            @"SELECT a.SecurityQuestionCode,a.SecurityQuestionAns,b.SecurityQuestionDesc from tbl_SecurityQuestion_Input a LEFT JOIN tbl_SecurityQuestion b ON a.SecurityQuestionCode=b.SecurityQuestionCode"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [quesCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [quesAns addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                [quesDesc addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [quesCode count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *itemDesc = [quesDesc objectAtIndex:indexPath.row];
	cell.textLabel.text = itemDesc;
    
	if (indexPath.row == selectedIndex) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [delegate retrievePwd:self didSelectQuest:self.selectedQuestCode desc:self.selectedQuestDesc ans:self.selectedQuestAns];
    [tableView reloadData];

}

-(NSString *)selectedQuestCode
{
    return [quesCode objectAtIndex:selectedIndex];
}

-(NSString *)selectedQuestDesc
{
    return [quesDesc objectAtIndex:selectedIndex];
}

-(NSString *)selectedQuestAns   
{
    return [quesAns objectAtIndex:selectedIndex];
}

#pragma mark - memory management

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setQuesCode:nil];
    [self setQuesAns:nil];
    [self setQuesDesc:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [quesAns release];
    [quesCode release];
    [quesDesc release];
    [super dealloc];
}

@end
