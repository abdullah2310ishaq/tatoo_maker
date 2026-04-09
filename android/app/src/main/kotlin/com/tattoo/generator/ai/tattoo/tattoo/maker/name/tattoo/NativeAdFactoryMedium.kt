package com.tattoo.generator.ai.tattoo.tattoo.maker.name.tattoo

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class NativeAdFactoryMedium(
    private val context: Context,
) : GoogleMobileAdsPlugin.NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: Map<String, Any?>?,
    ): NativeAdView {
        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ads_medium, null) as NativeAdView

        // No main image/video slot — icon + text only (avoids tiny MediaView warnings).
        adView.mediaView = null

        val headlineView = adView.findViewById<TextView>(R.id.native_ad_headline)
        adView.headlineView = headlineView
        headlineView.text = nativeAd.headline.orEmpty()

        val bodyView = adView.findViewById<TextView>(R.id.native_ad_body)
        adView.bodyView = bodyView
        val body = nativeAd.body
        if (body.isNullOrBlank()) {
            bodyView.visibility = View.GONE
        } else {
            bodyView.visibility = View.VISIBLE
            bodyView.text = body
        }

        val iconView = adView.findViewById<ImageView>(R.id.native_ad_icon)
        adView.iconView = iconView
        val icon = nativeAd.icon
        if (icon != null) {
            iconView.setImageDrawable(icon.drawable)
            iconView.visibility = View.VISIBLE
        } else {
            iconView.visibility = View.GONE
        }

        val callToActionView = adView.findViewById<Button>(R.id.native_ad_button)
        adView.callToActionView = callToActionView
        val cta = nativeAd.callToAction
        if (cta.isNullOrBlank()) {
            callToActionView.visibility = View.GONE
        } else {
            callToActionView.visibility = View.VISIBLE
            callToActionView.text = cta
        }

        adView.setNativeAd(nativeAd)

        return adView
    }
}

