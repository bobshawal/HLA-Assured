//
//  RetreivePwdTbViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/30/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class RetreivePwdTbViewController;
@protocol RetreivePwdTbViewControllerDelegate
-(void)retrievePwd:(RetreivePwdTbViewController *)inController didSelectQuest:(NSString *)code desc:(NSString *)desc ans:(NSString *)ans;
@end

@interface RetreivePwdTbViewController : UITableViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
    NSUInteger selectedIndex;
    id <RetreivePwdTbViewControllerDelegate> delegate;
}

@property (nonatomic,assign) id <RetreivePwdTbViewControllerDelegate> delegate;
@property (readonly) NSString *selectedQuestCode;
@property (readonly) NSString *selectedQuestDesc;
@property (readonly) NSString *selectedQuestAns;
@property(nonatomic , retain) NSMutableArray *quesCode;
@property(nonatomic , retain) NSMutableArray *quesDesc;
@property(nonatomic , retain) NSMutableArray *quesAns;

@end
