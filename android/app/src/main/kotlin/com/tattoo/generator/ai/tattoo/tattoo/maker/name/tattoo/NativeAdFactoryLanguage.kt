package com.tattoo.generator.ai.tattoo.tattoo.maker.name.tattoo

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.core.graphics.ColorUtils
import com.google.android.gms.ads.nativead.MediaView
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

        val bgColor = (customOptions?.get("bgColor") as? Number)?.toInt()
        if (bgColor != null) {
            adView.setBackgroundColor(bgColor)
        }

        val mediaView = adView.findViewById<MediaView>(R.id.native_ad_media)
        adView.mediaView = mediaView
        // Keep MediaView background consistent with the card to avoid white flashes
        // while video is buffering / loading.
        mediaView.setBackgroundColor(bgColor ?: Color.TRANSPARENT)
        if (nativeAd.mediaContent == null) {
            mediaView.visibility = View.GONE
        } else {
            mediaView.visibility = View.VISIBLE
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

        val optionIsDark = customOptions?.get("isDark") as? Boolean
        val isDark = optionIsDark ?: bgColor?.let { ColorUtils.calculateLuminance(it) < 0.45 } ?: false
        if (isDark) {
            headlineView.setTextColor(Color.WHITE)
            bodyView.setTextColor(Color.parseColor("#D1D5DB"))
        } else {
            headlineView.setTextColor(Color.parseColor("#FF000000"))
            bodyView.setTextColor(Color.parseColor("#FF666666"))
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
