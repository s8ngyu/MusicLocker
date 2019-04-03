#import <Nepeta/NEPColorUtils.h>
#import "MediaRemote.h"

static bool locked = false;
UISwitch *musicLockerSwitch;

@interface MediaControlsTimeControl : UIControl
-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2;
@end

@interface MPVolumeSlider : UISlider
-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2;
@end

@interface MPButton : UIButton
-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2;
@end

@interface MediaControlsPanelViewController : UIViewController
-(void)viewDidLayoutSubviews;
-(void)_updateHeaderUI;
-(void)viewDidLoad;
-(void)touched;
@end

%hook MediaControlsTimeControl
-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2 {
	if (!locked) {
		return %orig;
	} else {
		return nil;
	}
	return %orig;
}
%end

%hook MPVolumeSlider
-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2 {
	if (!locked) {
		return %orig;
	} else {
		return nil;
	}
	return %orig;
}
%end

%hook MPButton
-(BOOL)beginTrackingWithTouch:(id)arg1 withEvent:(id)arg2 {
	if (!locked) {
		return %orig;
	} else {
		return nil;
	}
	return %orig;
}
%end

%hook MediaControlsPanelViewController
-(void)viewDidLoad {
	%orig;
	if (!musicLockerSwitch) {
		musicLockerSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 77, 3, 0, 0)];
		[musicLockerSwitch addTarget: self action:@selector(touched:) forControlEvents:UIControlEventValueChanged];
		musicLockerSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);

		[self.view addSubview:musicLockerSwitch];
	}
}

-(void)_updateHeaderUI {
	%orig;
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        NSDictionary *dict=(__bridge NSDictionary *)(information);
		if ([dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData] != nil) {
			NSData *artworkData = [dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData];
			UIImage *finalImage = [UIImage imageWithData:artworkData];
			musicLockerSwitch.onTintColor = [NEPColorUtils averageColor:finalImage withAlpha:1.0];
		}
	});
}

%new
-(void)touched:(id)sender {
	NSLog(@"MusicLocker");
	UISwitch *mlSwitch = (UISwitch *)sender;
	if ([mlSwitch isOn]) {
		NSLog(@"MusicLocker On");
		locked = true;
	} else {
		NSLog(@"MusicLocker Off");
		locked = false;
	}
}
%end