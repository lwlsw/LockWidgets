#import "LockWidgetsView.h"

@implementation LockWidgetsView
@synthesize collectionView;
@synthesize widgetIdentifiers;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	// Setup the widgetIdentifiers with some default values if it's not set
	if (!widgetIdentifiers) {
		widgetIdentifiers = [@[ @"com.apple.BatteryCenter.BatteryWidget", @"com.apple.UpNextWidget.extension" ] mutableCopy];
	}

	self.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
	self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	self.collectionViewLayout.itemSize = CGSizeMake(frame.size.width - 2.5, 150);
	self.collectionViewLayout.estimatedItemSize = CGSizeMake(frame.size.width - 2.5, 150);
	self.collectionViewLayout.minimumLineSpacing = 2.5;

	self.collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.collectionViewLayout];
	self.collectionView.dataSource = self;
	self.collectionView.delegate = self;

	self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.collectionView.layer.cornerRadius = 13;
	self.collectionView.layer.masksToBounds = true;
	self.collectionView.pagingEnabled = YES;
	self.collectionView.contentSize = CGSizeMake(([widgetIdentifiers count] * 355) + 100, 150);
	self.collectionView.contentInset = UIEdgeInsetsMake(0, 2.5, 0, 2.5);

	[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"WidgetCell"];

	[self addSubview:self.collectionView];

	[NSLayoutConstraint activateConstraints:@[
		[self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor],
		[self.collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
		[self.collectionView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
		[self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
	]];

	return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"WidgetCell" forIndexPath:indexPath];

	NSError *error;
	NSString *identifier = [widgetIdentifiers objectAtIndex:indexPath.row];
	NSExtension *extension = [NSExtension extensionWithIdentifier:identifier error:&error];

	WGWidgetInfo *widgetInfo = [[NSClassFromString(@"WGWidgetInfo") alloc] initWithExtension:extension];
	WGWidgetHostingViewController *widgetHost = [[NSClassFromString(@"WGWidgetHostingViewController") alloc] initWithWidgetInfo:widgetInfo delegate:nil host:nil];
	WGWidgetPlatterView *platterView = [[NSClassFromString(@"WGWidgetPlatterView") alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 2.5, 150)];

	[platterView setWidgetHost:widgetHost];

	for (UIView *view in cell.contentView.subviews) {
		[view removeFromSuperview];
	}

	[cell.contentView addSubview:platterView];

	if (@available(iOS 13.0, *)) {
		// Fix on iOS 13 for the dark header being the old style
		MTMaterialView *header = MSHookIvar<MTMaterialView *>(platterView, "_headerBackgroundView");
		[header removeFromSuperview];
	}

	[platterView setWidgetHost:[[NSClassFromString(@"WGWidgetHostingViewController") alloc] initWithWidgetInfo:widgetInfo delegate:nil host:nil]];

	return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return [widgetIdentifiers count];
}

- (BOOL)_canShowWhileLocked {
	return YES;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
								 layout:(UICollectionViewLayout *)collectionViewLayout
	minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 2.5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	return UIEdgeInsetsMake(0, 2.5, 0, 2.5);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	return CGSizeMake(self.frame.size.width - 2.5, 150);
}

@end