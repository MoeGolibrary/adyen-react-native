import { PartialPaymentComponent } from '../../wrappers/PartialPaymentsComponentWrapper';
import { Balance, Order, PaymentMethodData } from '../types';

export interface PartialPaymentConfiguration {
  /**
   * Invoked when the payment component needs a balance check call to be performed. Call /balance API.
   * @param paymentData The collection that contains the type of the payment method and its specific information.
   * @param resolve Provide balance object.
   * @param reject Reject with error.
   */
  onBalanceCheck(
    paymentData: PaymentMethodData,
    resolve: (balance: Balance) => void,
    reject: (error: Error) => void
  ): void;

  /**
   * Invoked when the payment component needs a partial payment order object. Call /orders API.
   * @param resolve Provide order object.
   * @param reject Reject with error.
   */
  onOrderRequest(
    resolve: (order: Order) => void,
    reject: (error: Error) => void
  ): void;

  /**
   * Invoked when the payment component needs to cancel the order. Call orders/cancel API.
   * The shouldUpdatePaymentMethods flag indicates the next step you should take after the API call is made:
   *  - true means that Drop-in is still showing and you might want to call / paymentMethods with the new payment amount. Update Drop-in with the new list of payment methods.
   *  - false means that Drop-in is being dismissed by the user so there is no need to make any further calls. Call `.hide(false)` to clear the UI.
   * @param order The order request object that contains a pspReference that represents the order and the matching encrypted order data.
   * @param shouldUpdatePaymentMethods The flag that indicates indicates the next step.
   * @param component The native component that used for this payment.
   */
  onOrderCancel(
    order: Order,
    shouldUpdatePaymentMethods: Boolean,
    component: PartialPaymentComponent
  ): void;
}
