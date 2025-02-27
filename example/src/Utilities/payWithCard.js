import {AdyenCSE, AdyenAction} from '@adyen/react-native';
import {ENVIRONMENT} from '../Configuration';
import ApiClient from './APIClient';
import {checkoutConfiguration} from './AppContext';

export async function payWithCard(unencryptedCard, configuration) {
  const encryptedCard = await AdyenCSE.encryptCard(
    unencryptedCard,
    ENVIRONMENT.publicKey,
  );
  const paymentData = {
    paymentMethod: {
      type: 'scheme',
      encryptedCardNumber: encryptedCard.number,
      encryptedExpiryMonth: encryptedCard.expiryMonth,
      encryptedExpiryYear: encryptedCard.expiryYear,
      encryptedSecurityCode: encryptedCard.cvv,
      threeDS2SdkVersion: AdyenAction.threeDS2SdkVersion,
    },
  };

  let result = await ApiClient.payments(
    paymentData,
    configuration,
    ENVIRONMENT.returnUrl,
  );
  if (result.action) {
    const actionConfiguration = checkoutConfiguration(configuration);
    const actionData = await AdyenAction.handle(
      result.action,
      actionConfiguration,
    );
    result = await ApiClient.paymentDetails(actionData);
  }
  return result;
}
