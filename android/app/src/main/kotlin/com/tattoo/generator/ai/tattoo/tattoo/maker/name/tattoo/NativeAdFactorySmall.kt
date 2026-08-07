package com.tattoo.generator.ai.tattoo.tattoo.maker.name.tattoo

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.core.graphics.ColorUtils
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.NativeAdFactory

class NativeAdFactorySmall(
    private val context: Context,
) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: Map<String, Any>,
    ): NativeAdView {
        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ads_small, null) as NativeAdView

        val bgColor = (customOptions?.get("bgColor") as? Number)?.toInt()
        if (bgColor != null) {
            adView.setBackgroundColor(bgColor)
        }

        // Icon
        val iconView = adView.findViewById<ImageView>(R.id.native_ad_icon)
        adView.iconView = iconView
        if (nativeAd.icon != null) {
            iconView.setImageDrawable(nativeAd.icon!!.drawable)
            iconView.visibility = View.VISIBLE
        } else {
            iconView.visibility = View.GONE
        }

        // Headline
        val headlineView = adView.findViewById<TextView>(R.id.native_ad_headline)
        adView.headlineView = headlineView
        headlineView.text = nativeAd.headline.orEmpty()

        // Body
        val bodyView = adView.findViewById<TextView>(R.id.native_ad_body)
        adView.bodyView = bodyView
        if (nativeAd.body != null) {
            bodyView.visibility = View.VISIBLE
            bodyView.text = nativeAd.body
        } else {
            bodyView.visibility = View.GONE
        }

        // Dark / light text colors only
        val optionIsDark = customOptions?.get("isDark") as? Boolean
        val isDark = optionIsDark
            ?: bgColor?.let { ColorUtils.calculateLuminance(it) < 0.45 }
            ?: false
        if (isDark) {
            headlineView.setTextColor(Color.WHITE)
            bodyView.setTextColor(Color.parseColor("#D1D5DB"))
        } else {
            headlineView.setTextColor(Color.parseColor("#FF000000"))
            bodyView.setTextColor(Color.parseColor("#FF666666"))
        }

        // CTA Button
        val callToActionView = adView.findViewById<Button>(R.id.native_ad_button)
        adView.callToActionView = callToActionView
        if (nativeAd.callToAction != null) {
            callToActionView.visibility = View.VISIBLE
            callToActionView.text = nativeAd.callToAction
        } else {
            callToActionView.visibility = View.GONE
        }

        adView.setNativeAd(nativeAd)

        return adView
    }
}
