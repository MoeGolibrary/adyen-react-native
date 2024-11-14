import {Platform, NativeModules} from 'react-native';
export const DEVICE_LOCALE = (
  Platform.OS === 'ios'
    ? NativeModules.SettingsManager.settings.AppleLocale ||
      NativeModules.SettingsManager.settings.AppleLanguages[0] //iOS 13
    : NativeModules.I18nManager.localeIdentifier
).replace('_', '-');

export const CHANNEL = Platform.select({
  ios: () => 'iOS',
  android: () => 'Android',
})();

export const DEFAULT_CONFIGURATION = {
  countryCode: 'NL',
  currency: 'EUR',
  amount: 1000, // The amount value in minor units.
  merchantAccount: 'MoeGoAccountECOM',
  merchantName: 'MyStore',
  shopperLocale: DEVICE_LOCALE,
  shopperReference: 'Checkout Shopper',
};

// For test purposes only! Do not call Adyen API from your mobile app on LIVE.
export const ENVIRONMENT = {
  /** @type {import('@adyen/react-native').Environment} */
  environment: 'test',
  apiKey: 'AQEuhmfxLo/LbxVAw0m/n3Q5qf3VZYRIKpxrW2ZZ03a/USoDi7vjtK8PhFRN7uVM7RDBXVsNvuR83LVYjEgiTGAH-8CQVRhmIucdhZDWWVAwx+XFjhLzxqU6VzDtE7mLVWYg=-i1iB7:s()H,ZZJ..x(j',
  url: 'https://checkout-test.adyen.com/v71/',
  publicKey: '{YOUR_PUBLIC_KEY}',
  clientKey: 'test_QDOO22PU5FA7LE76ASPQJNKWGAILVO4C',
  returnUrl: 'myapp://payment', // Only used for iOS
  applepayMerchantID: '{YOUR_APPLE_MERCHANT_ID}',
};
