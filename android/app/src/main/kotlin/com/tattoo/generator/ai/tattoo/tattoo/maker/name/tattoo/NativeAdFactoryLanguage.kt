package com.tattoo.generator.ai.tattoo.tattoo.maker.name.tattoo

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeAdFactoryLanguage(
    private val context: Context,
) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: Map<String, Any?>?,
    ): NativeAdView {
        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ads_language, null) as NativeAdView

        adView.mediaView = null

        val iconView = adView.findViewById<ImageView>(R.id.ad_app_icon)
        adView.iconView = iconView
        val icon = nativeAd.icon
        if (icon != null) {
            iconView.setImageDrawable(icon.drawable)
            iconView.visibility = View.VISIBLE
        } else {
            iconView.visibility = View.GONE
        }

        val headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        adView.headlineView = headlineView
        headlineView.text = nativeAd.headline.orEmpty()

        val bodyView = adView.findViewById<TextView>(R.id.ad_body)
        adView.bodyView = bodyView
        val body = nativeAd.body
        if (body.isNullOrBlank()) {
            bodyView.visibility = View.GONE
        } else {
            bodyView.visibility = View.VISIBLE
            bodyView.text = body
        }

        val ctaBar = adView.findViewById<View>(R.id.buttonlayout)
        val callToActionView = adView.findViewById<TextView>(R.id.ad_call_to_action)
        adView.callToActionView = callToActionView
        val cta = nativeAd.callToAction
        if (cta.isNullOrBlank()) {
            ctaBar.visibility = View.GONE
            callToActionView.visibility = View.GONE
        } else {
            ctaBar.visibility = View.VISIBLE
            callToActionView.visibility = View.VISIBLE
            callToActionView.text = cta
        }

        adView.setNativeAd(nativeAd)

        return adView
    }
}
