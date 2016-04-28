//
//  TodayViewController.h
//  WeatherOrNotExt
//
//  Created by Kevin Remigio on 4/26/16.
//  Copyright © 2016 Kevin Remigio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *weatherInfoFirstLine;
@property (weak, nonatomic) IBOutlet UILabel *weatherInfoSecondLine;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeLabel;
- (IBAction)searchWeather:(id)sender;

@end
