import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/session_manager.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() =>
      _MyComplaintsScreenState();
}

class _MyComplaintsScreenState
    extends State<MyComplaintsScreen> {
  List<Map<String, dynamic>> complaints = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadComplaints();
  }

  Future<void> loadComplaints() async {
    setState(() {
      isLoading = true;
    });

    final userId = await SessionManager.getUserId();

    if (userId == null) {
      setState(() {
        complaints = [];
        isLoading = false;
      });
      return;
    }

    final data =
        await DatabaseHelper.instance.getComplaintsByUser(userId);

    if (!mounted) return;

    setState(() {
      complaints = data;
      isLoading = false;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Resolved':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return const Color(0xFF168A55);
    }
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
          'My Complaints',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: RefreshIndicator(
        onRefresh: loadComplaints,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : complaints.isEmpty
                ? ListView(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 150),
                      Icon(
                        Icons.report_problem_outlined,
                        size: 70,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'No complaints yet',
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
                          'Your submitted complaints will appear here.',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      final complaint = complaints[index];

                      final status =
                          complaint['status']?.toString() ??
                              'Submitted';

                      final complaintId =
                          complaint['id'] as int;

                      final title =
                          complaint['title']?.toString() ??
                              'Environmental Complaint';

                      final category =
                          complaint['category']?.toString() ??
                              '';

                      final location =
                          complaint['location']?.toString() ??
                              '';

                      final description =
                          complaint['description']?.toString() ??
                              '';

                      final createdAt =
                          complaint['created_at']?.toString() ??
                              '';

                      return Container(
                        margin:
                            const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                  child: const Icon(
                                    Icons.report_problem_outlined,
                                    color:
                                        Color(0xFF168A55),
                                  ),
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        title,
                                        style:
                                            const TextStyle(
                                          fontSize: 17,
                                          fontWeight:
                                              FontWeight.bold,
                                          color:
                                              Color(0xFF0B3D2E),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Complaint #${complaintId.toString().padLeft(5, '0')}',
                                        style:
                                            const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(
                                            status)
                                        .withValues(alpha: 0.1),
                                    borderRadius:
                                        BorderRadius.circular(
                                            20),
                                  ),
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          getStatusColor(
                                              status),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            Row(
                              children: [
                                const Icon(
                                  Icons.category_outlined,
                                  size: 19,
                                  color:
                                      Color(0xFF168A55),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    category,
                                    style:
                                        const TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 19,
                                  color:
                                      Color(0xFF168A55),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    location,
                                    style:
                                        const TextStyle(
                                      fontSize: 14,
                                      color:
                                          Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            Text(
                              description,
                              maxLines: 3,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                height: 1.4,
                              ),
                            ),

                            if (createdAt.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Submitted: ${createdAt.replaceFirst('T', ' ').split('.').first}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}