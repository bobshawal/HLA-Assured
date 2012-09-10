//
//  SecurityQuesTbViewController.m
//  HLA
//
//  Created by shawal sapuan on 8/29/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SecurityQuesTbViewController.h"

@interface SecurityQuesTbViewController ()

@end

@implementation SecurityQuesTbViewController
@synthesize delegate,quesCode,quesDesc,selectedQuestCode,selectedQuestDesc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];

    [self getSecurityQuestion];
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
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SecurityQuestionCode,SecurityQuestionDesc from tbl_SecurityQuestion"];
    
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [quesCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [quesDesc addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
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
    [delegate securityQuest:self didSelectQuest:self.selectedQuestCode desc:self.selectedQuestDesc];
    
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

#pragma mark - memory management

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setQuesCode:nil];
    [self setQuesDesc:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [quesCode release];
    [quesDesc release];
    [super dealloc];
}

@end
