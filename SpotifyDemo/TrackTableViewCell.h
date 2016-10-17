//
//  TrackTableViewCell.h
//  SpotifyDemo
//
//  Created by CardSwapper on 10/17/16.
//
//

#import <UIKit/UIKit.h>

@interface TrackTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *explicitLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
