import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../services/session_manager.dart';
import 'complaint_submitted_screen.dart';

class ReviewComplaintScreen extends StatefulWidget {
  final String title;
  final String category;
  final String location;
  final String description;

  const ReviewComplaintScreen({
    super.key,
    required this.title,
    required this.category,
    required this.location,
    required this.description,
  });

  @override
  State<ReviewComplaintScreen> createState() =>
      _ReviewComplaintScreenState();
}

class _ReviewComplaintScreenState
    extends State<ReviewComplaintScreen> {
  bool isSubmitting = false;

  Future<void> submitComplaint() async {
    if (isSubmitting) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      final userId = await SessionManager.getUserId();

      if (userId == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please login before submitting a complaint.',
            ),
          ),
        );

        setState(() {
          isSubmitting = false;
        });

        return;
      }

      // Save complaint to SQLite
      final complaintId =
          await DatabaseHelper.instance.addComplaint(
        userId: userId,
        title: widget.title,
        category: widget.category,
        location: widget.location,
        description: widget.description,
      );

      // Create a real notification in SQLite
      await DatabaseHelper.instance.addNotification(
        userId: userId,
        title: 'Complaint Submitted',
        message:
            'Your complaint "${widget.title}" has been successfully submitted.',
      );

      if (!mounted) return;

      // Move to submitted screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ComplaintSubmittedScreen(
            complaintId: complaintId,
            title: widget.title,
            category: widget.category,
            location: widget.location,
            description: widget.description,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to submit complaint: $e',
          ),
        ),
      );
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
          'Review Complaint',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Review Your Complaint',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B3D2E),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Please check the information before submitting '
                'your complaint.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 25),

              _ReviewCard(
                icon: Icons.title_outlined,
                title: 'Title',
                value: widget.title,
              ),

              const SizedBox(height: 15),

              _ReviewCard(
                icon: Icons.category_outlined,
                title: 'Category',
                value: widget.category,
              ),

              const SizedBox(height: 15),

              _ReviewCard(
                icon: Icons.location_on_outlined,
                title: 'Location',
                value: widget.location,
              ),

              const SizedBox(height: 15),

              _ReviewCard(
                icon: Icons.description_outlined,
                title: 'Description',
                value: widget.description,
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      color: Color(0xFF168A55),
                      size: 30,
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        'No photo added',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed:
                      isSubmitting ? null : submitComplaint,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.send_outlined,
                        ),
                  label: Text(
                    isSubmitting
                        ? 'Submitting...'
                        : 'Submit Complaint',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF168A55),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        const Color(0xFF168A55),
                    disabledForegroundColor:
                        Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  icon: const Icon(
                    Icons.edit_outlined,
                  ),
                  label: const Text(
                    'Edit Complaint',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        const Color(0xFF168A55),
                    side: const BorderSide(
                      color: Color(0xFF168A55),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ReviewCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Color(0xFFE4F4EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF168A55),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}