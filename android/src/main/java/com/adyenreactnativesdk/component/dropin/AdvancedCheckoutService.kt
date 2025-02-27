/*
 * Copyright (c) 2021 Adyen N.V.
 *
 * This file is open source and available under the MIT license. See the LICENSE file for more info.
 */

package com.adyenreactnativesdk.component.dropin

import android.util.Log
import com.adyen.checkout.components.core.ActionComponentData
import com.adyen.checkout.components.core.LookupAddress
import com.adyen.checkout.components.core.Order
import com.adyen.checkout.components.core.PaymentComponentState
import com.adyen.checkout.dropin.DropInService
import com.adyenreactnativesdk.AdyenCheckout
import com.adyenreactnativesdk.component.CheckoutProxy

open class AdvancedCheckoutService : DropInService() {

    override fun onCreate() {
        super.onCreate()
        CheckoutProxy.shared.advancedService = this
    }

    override fun onSubmit(state: PaymentComponentState<*>) {
        val listener = CheckoutProxy.shared.componentListener
        listener?.onSubmit(state)
            ?: Log.e(
                TAG,
                "Invalid state: DropInServiceListener is missing"
            )
    }

    override fun onAdditionalDetails(actionComponentData: ActionComponentData) {
        val listener = CheckoutProxy.shared.componentListener
        listener?.onAdditionalDetails(actionComponentData)
            ?: Log.e(
                TAG,
                "Invalid state: DropInServiceListener is missing"
            )
    }

    override fun onAddressLookupQueryChanged(query: String) {
        CheckoutProxy.shared.addressLookupCallback?.onQueryChanged(query)
    }

    override fun onAddressLookupCompletion(lookupAddress: LookupAddress): Boolean {
        return CheckoutProxy.shared.addressLookupCallback?.onLookupCompletion(lookupAddress) ?: false
    }

    override fun onBalanceCheck(paymentComponentState: PaymentComponentState<*>) {
        val listener = CheckoutProxy.shared.componentListener
        listener?.onBalanceCheck(paymentComponentState)
    }

    override fun onOrderRequest() {
        val listener = CheckoutProxy.shared.componentListener
        listener?.onOrderRequest()
    }

    override fun onOrderCancel(order: Order, shouldUpdatePaymentMethods: Boolean) {
        val listener = CheckoutProxy.shared.componentListener
        listener?.onOrderCancel(order, shouldUpdatePaymentMethods)
    }

    companion object {
        private const val TAG = "AdyenDropInService"
        private const val MESSAGE_KEY = "message"
    }
}