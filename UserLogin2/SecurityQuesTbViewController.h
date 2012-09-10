//
//  SecurityQuesTbViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/29/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class SecurityQuesTbViewController;
@protocol SecurityQuesTbViewControllerDelegate
-(void)securityQuest:(SecurityQuesTbViewController *)inController didSelectQuest:(NSString *)code desc:(NSString *)desc;
@end

@interface SecurityQuesTbViewController : UITableViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
    NSUInteger selectedIndex;
    id <SecurityQuesTbViewControllerDelegate> delegate;
}

@property (nonatomic,assign) id <SecurityQuesTbViewControllerDelegate> delegate;
@property (readonly) NSString *selectedQuestCode;
@property (readonly) NSString *selectedQuestDesc;
@property(nonatomic , retain) NSMutableArray *quesCode;
@property(nonatomic , retain) NSMutableArray *quesDesc;
@end
