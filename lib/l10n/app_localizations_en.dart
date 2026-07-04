// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Coffee Shop & Loyalty';

  @override
  String get appTitle => 'Coffee Shop';

  @override
  String get guest => 'Guest';

  @override
  String get member => 'Member';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get signIn => 'Sign In';

  @override
  String get language => 'Language';

  @override
  String get welcomeBrand => '☕   L O Y A L T Y';

  @override
  String get welcomeTitle => 'Coffee\nAroma';

  @override
  String get welcomeSubtitle =>
      'Earn points with every sip,\nreach the coffee of your dreams.';

  @override
  String get welcomeHeading => 'Welcome';

  @override
  String get welcomeHint => 'Sign in to your account or continue as a guest';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get noAccountPrefix => 'No account?   ';

  @override
  String get signUpArrow => 'Sign Up →';

  @override
  String get navHome => 'Home';

  @override
  String get navProfile => 'Profile';

  @override
  String get navCart => 'Cart';

  @override
  String get searchHint => 'Search coffee...';

  @override
  String get menu => 'Menu';

  @override
  String get noProducts => 'No products found';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String pointsShort(int points) {
    return '$points P';
  }

  @override
  String addedToCart(Object name, Object size) {
    return '$name ($size) added to cart!';
  }

  @override
  String addedToCartQty(int quantity, Object name, Object size) {
    return '$quantity× $name ($size) added to cart!';
  }

  @override
  String get sizeSmall => 'Small';

  @override
  String get sizeMedium => 'Medium';

  @override
  String get sizeLarge => 'Large';

  @override
  String get categoryHot => 'Hot';

  @override
  String get categoryCold => 'Cold';

  @override
  String get categoryDessert => 'Dessert';

  @override
  String get cartTitle => 'My Cart';

  @override
  String get cartEmpty => 'Your cart is empty ☕';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get pointsToEarn => 'Points to Earn';

  @override
  String get completeOrder => 'Place Order';

  @override
  String get orderPlaced => '✅ Order placed, points added!';

  @override
  String get orderSuccessTitle => 'Order Placed! 🎉';

  @override
  String get orderSuccessSubtitle => 'It\'s being prepared, enjoy ☕';

  @override
  String pointsEarnedMsg(int points) {
    return 'You earned +$points points';
  }

  @override
  String get backToHome => 'Back to Home';

  @override
  String get badgeMaster => 'Coffee Master ☕';

  @override
  String get badgeLover => 'Coffee Lover 🥇';

  @override
  String get badgeRegular => 'Regular Customer ⭐';

  @override
  String get badgeNew => 'New Member 🌱';

  @override
  String get totalPoints => 'My Total Points';

  @override
  String get loyaltyTag => '☕ Loyalty';

  @override
  String pointsToNextLevel(int points) {
    return '$points points to the next level';
  }

  @override
  String get maxLevel => 'You\'re at the highest level! 🏆';

  @override
  String get rewardGoal => 'Reward Goal';

  @override
  String pointsToFreeCoffee(int points) {
    return '$points points to a free coffee';
  }

  @override
  String get freeCoffeeReady => 'Your free coffee is ready! 🎉';

  @override
  String get accountInfo => 'Account Info';

  @override
  String get manageSection => 'Management & Settings';

  @override
  String get fullName => 'Full Name';

  @override
  String get phone => 'Phone';

  @override
  String get note => 'Note';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get noNote => 'No note';

  @override
  String get orderHistory => 'Order History';

  @override
  String get logout => 'Log Out';

  @override
  String get logoutConfirmMessage =>
      'You will be signed out and returned to the welcome screen. Are you sure?';

  @override
  String get selectSize => 'Select Size';

  @override
  String get quantity => 'Quantity';

  @override
  String get baseLabel => 'base';

  @override
  String pointsValue(int points) {
    return '+$points pts';
  }

  @override
  String willEarnPoints(int points) {
    return 'you\'ll earn +$points points';
  }

  @override
  String get clearHistory => 'Clear History';

  @override
  String get clearHistoryConfirm =>
      'All order history will be deleted. Are you sure?';

  @override
  String get clear => 'Clear';

  @override
  String get noOrders => 'You have no orders yet';

  @override
  String get noOrdersHint =>
      'Place your first order and\nsee your history here ☕';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String itemTypes(int count) {
    return '$count item types';
  }

  @override
  String quantityUnit(int count) {
    return '$count pcs';
  }

  @override
  String pointsEarned(int points) {
    return '+$points P';
  }

  @override
  String get newProduct => 'Add New Product';

  @override
  String get productName => 'Product Name';

  @override
  String get priceTl => 'Price (TL)';

  @override
  String get points => 'Points';

  @override
  String get category => 'Category';

  @override
  String get imageUrlOptional => 'Image URL (optional)';

  @override
  String get photoUrlOptional => 'Photo URL (optional)';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get saveProduct => 'Save Product';

  @override
  String get requiredField => 'Required field';

  @override
  String get enterValidNumber => 'Enter a valid number';

  @override
  String get cannotBeNegative => 'Cannot be negative';

  @override
  String get mustBePositive => 'Must be greater than 0';

  @override
  String get productNameRequired => 'Product name is required';

  @override
  String get newUser => 'Create New Account';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String fieldRequired(Object field) {
    return '$field is required';
  }

  @override
  String get phoneRequired => 'Phone is required';

  @override
  String get phoneMinLength => 'Phone must be at least 10 digits';

  @override
  String get registerSuccess => 'Registration successful! You can sign in.';

  @override
  String get phoneAlreadyRegistered =>
      'This phone number is already registered!';

  @override
  String get selectMember => 'Select Member';

  @override
  String get signUp => 'Sign Up';

  @override
  String get tapMemberToLogin => 'Tap a member to sign in';

  @override
  String get adminCreatePin => 'Create Admin PIN';

  @override
  String get adminLogin => 'Admin Login';

  @override
  String get pinSetupPrompt => 'Set a 4-digit PIN to protect the admin panel.';

  @override
  String get pinEnterPrompt => 'Enter your admin PIN to continue.';

  @override
  String get newPin => 'New PIN';

  @override
  String get pin => 'PIN';

  @override
  String get pinRepeat => 'PIN (Repeat)';

  @override
  String get createAndEnter => 'Create & Enter';

  @override
  String pinLengthError(int length) {
    return 'PIN must be $length digits.';
  }

  @override
  String get pinMismatch => 'PIN and confirmation do not match.';

  @override
  String get pinWrong => 'Wrong PIN.';

  @override
  String get forgotPin => 'Forgot your PIN?';

  @override
  String get resetPinTitle => 'Reset PIN';

  @override
  String get recoveryPrompt =>
      'Enter the recovery code to reset. This code is held by the business manager.';

  @override
  String get recoveryCode => 'Recovery Code';

  @override
  String get reset => 'Reset';

  @override
  String get recoveryCodeWrong => 'Wrong recovery code.';

  @override
  String get pinResetDone => 'PIN reset. Set a new PIN.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get userGuide => 'User Guide';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get guidePurposeTitle => 'Purpose of the App';

  @override
  String get guidePurposeBody =>
      'Coffee Shop & Loyalty presents a coffee shop\'s menu and rewards customers with points on every purchase. Its goal is to boost customer loyalty and streamline the ordering process.';

  @override
  String get guideUsageTitle => 'What Is It For?';

  @override
  String get guideUsageBody =>
      'Customers pick items from the menu, choose a size and add them to the cart. When an order is completed, the earned points are credited to their account. Registered members accumulate points and level up; guests can order quickly. The business owner can manage products and members.';

  @override
  String get guideFeaturesTitle => 'Features & Options';

  @override
  String get guideFeatureHome =>
      'Home: Browse the menu, search for coffee, choose a size and add to cart.';

  @override
  String get guideFeatureCart =>
      'Cart: See your selected items, check the total and points to earn, and place the order.';

  @override
  String get guideFeatureProfile =>
      'Profile: View your points, membership level and account details.';

  @override
  String get guideFeatureOrders =>
      'Order History: Review past orders with dates and details.';

  @override
  String get guideFeatureAdmin =>
      'Admin Panel: PIN-protected management screen — add/edit products and members, view stats.';

  @override
  String get guideFeatureSettings =>
      'Settings: Change language (TR/EN) and theme (System/Light/Dark) preferences.';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get changePin => 'Change PIN';

  @override
  String get currentPin => 'Current PIN';

  @override
  String get newPin4 => 'New PIN (4 digits)';

  @override
  String get currentPinWrong => 'Current PIN is wrong.';

  @override
  String get newPin4Error => 'New PIN must be 4 digits.';

  @override
  String get pinUpdated => 'PIN updated.';

  @override
  String get tabSummary => 'Summary';

  @override
  String get tabProducts => 'Products';

  @override
  String get tabMembers => 'Members';

  @override
  String get statProducts => 'Products';

  @override
  String get statMembers => 'Members';

  @override
  String get statMenuTotal => 'Menu Total';

  @override
  String get statPointsGiven => 'Points Given';

  @override
  String get loyalCustomers => '🏆 Most Loyal Customers';

  @override
  String get noMembersYet => 'No members yet';

  @override
  String get productsByCategory => '📊 Products by Category';

  @override
  String get noProductsYet => 'No products added yet';

  @override
  String get noRegisteredMembers => 'No registered members yet';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get deleteMember => 'Delete Member';

  @override
  String deleteConfirm(Object name) {
    return '$name will be deleted. Are you sure?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get phoneNone => 'No phone';

  @override
  String get nameAndPriceRequired => 'Product name and price are required!';

  @override
  String get nameSurnameRequired => 'First and last name are required!';

  @override
  String productAdded(Object name) {
    return '$name added!';
  }

  @override
  String nameUpdated(Object name) {
    return '$name updated!';
  }

  @override
  String get editProduct => 'Edit Product';

  @override
  String get editMember => 'Edit Member';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get photoUrl => 'Photo URL';

  @override
  String get update => 'Update';

  @override
  String productCount(int count) {
    return '$count products';
  }
}
