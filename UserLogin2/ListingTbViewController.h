//
//  ListingTbViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/7/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingTbViewController : UITableViewController {
    NSArray *items;
    NSMutableArray *dateItems;
    NSUInteger selectedIndex;
}

@property (readonly) NSString *selectedItem;

@end
