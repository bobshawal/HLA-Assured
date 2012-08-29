//
//  RiderPTypeTbViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/29/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class RiderPTypeTbViewController;
@protocol RiderPTypeTbViewControllerDelegate
-(void)PTypeController:(RiderPTypeTbViewController *)inController didSelectCode:(NSString *)code seqNo:(NSString *)seq desc:(NSString *)desc;
@end

@interface RiderPTypeTbViewController : UITableViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
    NSUInteger selectedIndex;
    id <RiderPTypeTbViewControllerDelegate> delegate;
}

@property (nonatomic,assign) id <RiderPTypeTbViewControllerDelegate> delegate;
@property (readonly) NSString *selectedCode;
@property (readonly) NSString *selectedSeqNo;
@property (readonly) NSString *selectedDesc;
@property(nonatomic , retain) NSMutableArray *ptype;
@property(nonatomic , retain) NSMutableArray *seqNo;
@property(nonatomic , retain) NSMutableArray *desc;

@property (nonatomic,strong) id requestSINo;

@end
