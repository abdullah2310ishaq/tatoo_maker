package com.tattoo.generator.ai.tattoo.tattoo.maker.name.tattoo

import android.content.Context
import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.core.graphics.ColorUtils
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.NativeAdFactory

class NativeAdFactoryLanguageFullScreen(
    private val context: Context,
) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: Map<String, Any>,
    ): NativeAdView {
        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ads_language_fullscreen, null) as NativeAdView

        val bgColor = (customOptions["bgColor"] as? Number)?.toInt()
        val resolvedBg: Int =
            bgColor ?: ContextCompat.getColor(context, R.color.native_ad_background)
        adView.setBackgroundColor(resolvedBg)
        adView.findViewById<LinearLayout>(R.id.native_ad_content)?.setBackgroundColor(resolvedBg)

        val mediaView = adView.findViewById<MediaView>(R.id.ad_media)
        adView.mediaView = mediaView
        mediaView.setBackgroundColor(resolvedBg)
        if (nativeAd.mediaContent == null) {
            mediaView.visibility = View.GONE
        } else {
            mediaView.visibility = View.VISIBLE
        }

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

        val labelView = adView.findViewById<TextView>(R.id.ad_label)

        val optionIsDark = customOptions["isDark"] as? Boolean
        val isDark = optionIsDark ?: run {
            ColorUtils.calculateLuminance(resolvedBg) < 0.45
        }
        if (isDark) {
            labelView.setTextColor(Color.parseColor("#D1D5DB"))
            headlineView.setTextColor(Color.WHITE)
            bodyView.setTextColor(Color.parseColor("#D1D5DB"))
        } else {
            labelView.setTextColor(Color.parseColor("#FF666666"))
            headlineView.setTextColor(Color.parseColor("#FF000000"))
            bodyView.setTextColor(Color.parseColor("#FF666666"))
        }

        val callToActionView = adView.findViewById<Button>(R.id.ad_call_to_action)
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
