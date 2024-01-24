package io.spacet.gogo.gogo_mvp

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initNotificationChannel()
    }

    private fun initNotificationChannel() {
        createNotificationChannel("chat", "채팅 알림을 위한 채널입니다.")
        createNotificationChannel("invite", "ㄱㄱ 초대 알림을 위한 채널입니다.")
        createNotificationChannel(
            "cancel_invite",
            "ㄱㄱ 초대 취소 알림을 위한 채널입니다.",
            NotificationManager.IMPORTANCE_LOW,
        )
    }

    private fun createNotificationChannel(
        name: String,
        descriptionText: String,
        importance: Int = NotificationManager.IMPORTANCE_HIGH,
    ) {
        notificationManager.createNotificationChannel(
            NotificationChannel("gogo_$name", name, importance).apply {
                description = descriptionText
            })
    }

    private val notificationManager: NotificationManager
        get() = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
}
