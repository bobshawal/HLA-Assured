//
//  RiderFormTbViewController.h
//  HLA
//
//  Created by shawal sapuan on 9/4/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class RiderFormTbViewController;
@protocol RiderFormTbViewControllerDelegate
-(void)RiderFormController:(RiderFormTbViewController *)inController didSelectItem:(NSString *)item desc:(NSString *)itemdesc;
@end

@interface RiderFormTbViewController : UITableViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
    NSUInteger selectedIndex;
    id <RiderFormTbViewControllerDelegate> delegate;
}

@property (nonatomic,assign) id <RiderFormTbViewControllerDelegate> delegate;
@property (readonly) NSString *selectedItem;
@property (readonly) NSString *selectedItemDesc;
@property(nonatomic , retain) NSMutableArray *itemValue;
@property(nonatomic , retain) NSMutableArray *itemDesc;

@property (nonatomic,strong) id requestCondition;


@end
