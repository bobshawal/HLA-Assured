//
//  RiderViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface RiderViewController : UIViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
}

@property (retain, nonatomic) IBOutlet UIButton *riderBtn;

@property (nonatomic, assign,readwrite) int indexNo;
@property (nonatomic,strong) id agenID;
@property (nonatomic, assign,readwrite) int requestAge;
@property (nonatomic,strong) id requestPlanCode;
@property (nonatomic,strong) id requestPtype;
@property (nonatomic,strong) id requestSeq;
@property (nonatomic,strong) id requestSINo;



- (IBAction)homePressed:(id)sender;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
