//
//  RiderPTypeTbViewController.m
//  HLA
//
//  Created by shawal sapuan on 8/29/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "RiderPTypeTbViewController.h"

@interface RiderPTypeTbViewController ()

@end

@implementation RiderPTypeTbViewController
@synthesize delegate,ptype,seqNo,desc,requestSINo,selectedCode,selectedDesc,selectedSeqNo;

-(id)init
{
    self = [super init];
	if (self != nil) {
		NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"RIDERPTYPE SINo:%@",[self.requestSINo description]);
    
    [self getPersonType];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)getPersonType
{
    ptype = [[NSMutableArray alloc] init];
    seqNo = [[NSMutableArray alloc] init];
    desc = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.PTypeCode,a.Sequence,b.PTypeDesc FROM tbl_SI_Trad_LAPayor a LEFT JOIN tbl_Adm_PersonType b ON a.PTypeCode=b.PTypeCode AND a.Sequence=b.Seq WHERE a.SINo=\"%@\"",[self.requestSINo description]];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [ptype addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [seqNo addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                [desc addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]];
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
    return [ptype count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *itemDesc = [desc objectAtIndex:indexPath.row];
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
    [delegate PTypeController:self didSelectCode:self.selectedCode seqNo:self.selectedSeqNo desc:self.selectedDesc];
    [tableView reloadData];
}

-(NSString *)selectedCode
{
    return [ptype objectAtIndex:selectedIndex];
}

-(NSString *)selectedSeqNo
{
    return [seqNo objectAtIndex:selectedIndex];
}

-(NSString *)selectedDesc
{
    return [desc objectAtIndex:selectedIndex];
}

#pragma mark - Memory Management

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setPtype:nil];
    [self setSeqNo:nil];
    [self setDesc:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [ptype release];
    [seqNo release];
    [desc release];
    [super dealloc];
}

@end
