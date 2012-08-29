//
//  RiderListTbViewController.m
//  HLA
//
//  Created by shawal sapuan on 8/29/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "RiderListTbViewController.h"

@interface RiderListTbViewController ()

@end

@implementation RiderListTbViewController
@synthesize delegate,requestPlanCode,requestPtype,requestSeq,ridCode,ridDesc,selectedCode,selectedDesc;

-(id)init
{
    self = [super init];
	if (self != nil) {
		NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
        
        [self getRiderListing];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)getRiderListing
{
    ridCode = [[NSMutableArray alloc] init];
    ridDesc = [[NSMutableArray alloc] init];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        /*
        NSString *querySQL = [NSString stringWithFormat: @"SELECT a.RiderCode,b.RiderDesc FROM tbl_SI_Trad_RiderComb a LEFT JOIN tbl_SI_Trad_Rider_Profile b ON a.RiderCode=b.RiderCode WHERE a.PlanCode=\"%@\" AND a.PTypeCode=\"%@\" AND a.SeqNo=\"%d\"",[self.requestPlanCode description],[self.requestPtype description],self.requestSeq];
         */
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT a.RiderCode,b.RiderDesc FROM tbl_SI_Trad_RiderComb a LEFT JOIN tbl_SI_Trad_Rider_Profile b ON a.RiderCode=b.RiderCode WHERE a.PlanCode=\"HLAIB\" AND a.PTypeCode=\"LA\" AND a.SeqNo=1"];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [ridCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                [ridDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
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
    return [ridDesc count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *itemDesc = [ridDesc objectAtIndex:indexPath.row];
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
    [delegate RiderListController:self didSelectCode:self.selectedCode desc:self.selectedDesc];
    [tableView reloadData];
}

-(NSString *)selectedCode
{
    return [ridCode objectAtIndex:selectedIndex];
}

-(NSString *)selectedDesc
{
    return [ridDesc objectAtIndex:selectedIndex];
}

#pragma mark - Memory management

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setRequestPlanCode:nil];
    [self setRequestPtype:nil];
    [self setRidCode:nil];
    [self setRidDesc:nil];
    [super viewDidUnload];
}

-(void)dealloc
{
    [requestPlanCode release];
    [requestPtype release];
    [ridCode release];
    [ridDesc release];
    [super dealloc];
}

@end
