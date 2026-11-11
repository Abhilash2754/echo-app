import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/session_manager.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    setState(() {
      isLoading = true;
    });

    final userId = await SessionManager.getUserId();

    if (userId == null) {
      setState(() {
        notifications = [];
        isLoading = false;
      });
      return;
    }

    final data = await DatabaseHelper.instance
        .getNotificationsByUser(userId);

    if (!mounted) return;

    setState(() {
      notifications = data;
      isLoading = false;
    });
  }

  Future<void> markAsRead(int notificationId) async {
    await DatabaseHelper.instance
        .markNotificationAsRead(notificationId);

    await loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF7),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B3D2E),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: loadNotifications,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : notifications.isEmpty
                ? ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 160),
                      Icon(
                        Icons.notifications_none,
                        size: 70,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'No notifications',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Your notifications will appear here.',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification =
                          notifications[index];

                      final int notificationId =
                          notification['id'] as int;

                      final String title =
                          notification['title']
                                  ?.toString() ??
                              '';

                      final String message =
                          notification['message']
                                  ?.toString() ??
                              '';

                      final int isRead =
                          notification['is_read'] as int? ??
                              0;

                      final String createdAt =
                          notification['created_at']
                                  ?.toString() ??
                              '';

                      final bool unread =
                          isRead == 0;

                      return GestureDetector(
                        onTap: () {
                          if (unread) {
                            markAsRead(notificationId);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 14,
                          ),
                          padding:
                              const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: unread
                                ? const Color(0xFFEAF7F0)
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration:
                                    const BoxDecoration(
                                  color:
                                      Color(0xFFE4F4EC),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  unread
                                      ? Icons
                                          .notifications_active_outlined
                                      : Icons
                                          .notifications_none,
                                  color:
                                      const Color(0xFF168A55),
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            title,
                                            style:
                                                const TextStyle(
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              color: Color(
                                                  0xFF0B3D2E),
                                            ),
                                          ),
                                        ),

                                        if (unread)
                                          Container(
                                            width: 9,
                                            height: 9,
                                            decoration:
                                                const BoxDecoration(
                                              color: Color(
                                                  0xFF168A55),
                                              shape: BoxShape
                                                  .circle,
                                            ),
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      message,
                                      style:
                                          const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                        height: 1.4,
                                      ),
                                    ),

                                    if (createdAt
                                        .isNotEmpty) ...[
                                      const SizedBox(
                                          height: 8),
                                      Text(
                                        createdAt
                                            .replaceFirst(
                                                'T', ' ')
                                            .split('.')
                                            .first,
                                        style:
                                            const TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}