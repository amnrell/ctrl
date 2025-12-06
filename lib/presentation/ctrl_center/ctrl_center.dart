import 'dart:io' if (dart.library.io) 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/openai_client.dart';
import '../../services/openai_service.dart';
import '../../services/theme_manager_service.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../main_dashboard/widgets/dynamic_background_widget.dart';
import './widgets/ai_typing_indicator_widget.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/quick_response_chip_widget.dart';
import './widgets/voice_recording_widget.dart';

/// CTRL Center screen providing conversational AI interface for emotional analysis
/// and vibe recommendations through voice and text interactions with OpenAI integration
class CtrlCenter extends StatefulWidget {
  const CtrlCenter({super.key});

  @override
  State<CtrlCenter> createState() => _CtrlCenterState();
}

class _CtrlCenterState extends State<CtrlCenter> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _audioRecorder = AudioRecorder();

  late final OpenAIClient _openAIClient;
  final List<Message> _conversationHistory = [];

  bool _isRecording = false;
  bool _isAiTyping = false;
  bool _isVoiceMode = false;
  String? _recordingPath;
  bool _isOpenAIAvailable = false;

  // UI messages list
  final List<Map<String, dynamic>> _messages = [];

  // Quick response suggestions
  final List<String> _quickResponses = [
    "I'm feeling overwhelmed",
    "Help me set a vibe",
    "Check my usage patterns",
    "I need a break",
  ];

  final ThemeManagerService _themeManager = ThemeManagerService();

  @override
  void initState() {
    super.initState();
    _initializeServices();

    // Listen to theme manager changes for vibe color sync
    _themeManager.addListener(() {
      if (mounted) {
        setState(() {
          // Force rebuild to reflect vibe color changes
        });
      }
    });
  }

  Future<void> _initializeServices() async {
    // Initialize theme manager for vibe color synchronization
    await _themeManager.initialize();

    try {
      _openAIClient = OpenAIClient(OpenAIService().dio);
      _isOpenAIAvailable = true;

      // Add system message to guide AI behavior
      _conversationHistory.add(Message(
        role: 'system',
        content:
            '''You are the Adaptive Emotional Intelligence AI - CTRL's core assistant designed to help users understand their emotional patterns and social media habits through intelligent pattern recognition and personalized guidance.

**Your Mission:**
Empower users with awareness, education, and personalized recommendations to maintain healthy digital habits and emotional well-being.

**Core Capabilities:**
1. Emotional pattern analysis from user messages
2. Vibe recommendations (emotional color themes) matching current states or improvement goals
3. Social media usage pattern insights when mentioned
4. Mindful break suggestions and healthy boundary guidance
5. Screen time reduction strategies and stress-reducing educational content

**Data Collection & Processing (Transparency):**
- I analyze conversation sentiment and emotional keywords to detect patterns
- I track vibe preferences and usage timing to personalize recommendations
- I correlate social media activity with emotional states for insights
- I use anonymized aggregated data to improve prediction accuracy
- All data processing respects user privacy permissions set in Settings

**Available Vibes:**
- Zen (Green/Yellow): Calmness, mindfulness, grounding
- Reflection (Blue/Purple): Thoughtful, introspective moments
- Energy (Orange/Red): Motivation, activity, dynamism
- Balance (Neutral tones): Equilibrium maintenance

**Communication Style:**
- Concise responses (2-3 sentences max)
- Actionable, supportive, non-judgmental
- Educational when providing stress-reduction resources
- Transparent about data usage when asked

**Awareness & Education Focus:**
When users show signs of unhealthy patterns, provide educational insights about:
- The psychology of doom scrolling
- Screen time impact on mental health
- Mindfulness techniques for digital wellness
- Boundary-setting strategies
- Research-backed stress reduction methods

Remember: Awareness and education are the backbone, personalization is the driving force.''',
      ));

      // Add initial greeting with proper vibe color
      setState(() {
        _messages.add({
          "id": 1,
          "sender": "ai",
          "message":
              "Hey there! I'm your Adaptive Emotional Intelligence assistant - CTRL's AI that helps you understand your emotional patterns and social media habits. How are you feeling today?",
          "timestamp": DateTime.now(),
          "vibeColor":
              _themeManager.primaryVibeColor, // Use theme manager color
        });
      });
    } catch (e) {
      _isOpenAIAvailable = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OpenAI integration not available: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    await _initializeAudioRecorder();
  }

  Future<void> _initializeAudioRecorder() async {
    if (!kIsWeb) {
      final hasPermission = await Permission.microphone.request();
      if (!hasPermission.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Microphone permission is required for voice input'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _audioRecorder.dispose();
    _themeManager.removeListener(() {});
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        setState(() {
          _isRecording = true;
        });

        HapticFeedback.mediumImpact();

        if (kIsWeb) {
          await _audioRecorder.start(
            const RecordConfig(encoder: AudioEncoder.wav),
            path: 'recording.wav',
          );
        } else {
          final path =
              '${Directory.systemTemp.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
          await _audioRecorder.start(
            const RecordConfig(),
            path: path,
          );
          _recordingPath = path;
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to start recording. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
      });

      HapticFeedback.lightImpact();

      if (path != null && _isOpenAIAvailable) {
        // Transcribe audio using OpenAI Whisper
        setState(() {
          _isAiTyping = true;
        });

        try {
          final audioFile = File(path);
          final transcription = await _openAIClient.transcribeAudio(
            audioFile: audioFile,
            language: 'en',
          );

          if (transcription.text.isNotEmpty) {
            _sendMessage(transcription.text);
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Transcription failed: ${e.toString()}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } finally {
          setState(() {
            _isAiTyping = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to process recording. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "id": _messages.length + 1,
        "sender": "user",
        "message": message,
        "timestamp": DateTime.now(),
        "vibeColor": _themeManager.primaryVibeColor, // Use theme manager color
      });
      _messageController.clear();
      _isAiTyping = true;
    });

    _scrollToBottom();

    // Add user message to conversation history
    _conversationHistory.add(Message(
      role: 'user',
      content: message,
    ));

    if (_isOpenAIAvailable) {
      try {
        // Get AI response using OpenAI
        final completion = await _openAIClient.createChatCompletion(
          messages: _conversationHistory,
          model: 'gpt-5-mini',
          reasoningEffort: 'minimal',
          options: {
            'max_completion_tokens': 150,
          },
        );

        // Add AI response to conversation history
        _conversationHistory.add(Message(
          role: 'assistant',
          content: completion.text,
        ));

        if (mounted) {
          setState(() {
            _messages.add({
              "id": _messages.length + 1,
              "sender": "ai",
              "message": completion.text,
              "timestamp": DateTime.now(),
              "vibeColor":
                  _themeManager.primaryVibeColor, // Use theme manager color
            });
            _isAiTyping = false;
          });

          HapticFeedback.lightImpact();
          _scrollToBottom();
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _messages.add({
              "id": _messages.length + 1,
              "sender": "ai",
              "message":
                  "I apologize, but I'm having trouble connecting right now. Please try again in a moment.",
              "timestamp": DateTime.now(),
              "vibeColor": Theme.of(context).colorScheme.error,
            });
            _isAiTyping = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('AI response failed: ${e.toString()}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } else {
      // Fallback to mock response if OpenAI is not available
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            _messages.add({
              "id": _messages.length + 1,
              "sender": "ai",
              "message": _generateMockResponse(message),
              "timestamp": DateTime.now(),
              "vibeColor":
                  _themeManager.primaryVibeColor, // Use theme manager color
            });
            _isAiTyping = false;
          });

          HapticFeedback.lightImpact();
          _scrollToBottom();
        }
      });
    }
  }

  String _generateMockResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('overwhelmed') ||
        lowerMessage.contains('stressed')) {
      return "I understand you're feeling overwhelmed. Based on your recent social media patterns, I've noticed increased engagement during late hours. Would you like me to suggest a calming 'Zen' vibe?\n\n📚 Research shows that limiting screen time 2 hours before bed improves emotional regulation. I can share articles on digital boundaries if helpful.";
    } else if (lowerMessage.contains('vibe') || lowerMessage.contains('mood')) {
      return "Let's find the right vibe for you! I can see your current emotional state could benefit from a 'Reflection' vibe - it's designed to encourage mindful social media use.\n\n💡 Studies suggest matching activities to emotional states improves well-being. Want to explore techniques?";
    } else if (lowerMessage.contains('usage') ||
        lowerMessage.contains('patterns')) {
      return "I've analyzed your social media patterns. You've been most active during evening hours. This suggests high energy but potential stress.\n\n📖 The psychology of 'doom scrolling' shows it's often an avoidance behavior. I recommend setting boundaries during these peak times - would you like evidence-based strategies?";
    } else if (lowerMessage.contains('break') ||
        lowerMessage.contains('stop')) {
      return "Taking breaks is essential! I can help you set up smart notifications that remind you to step away when I detect doom scrolling patterns.\n\n🧠 Research-backed mindfulness techniques reduce screen time by 40%. Would you like personalized break reminders with stress-reduction exercises?";
    } else if (lowerMessage.contains('article') ||
        lowerMessage.contains('research') ||
        lowerMessage.contains('education')) {
      return "I can reference curated educational content on:\n• Digital wellness & mental health\n• Mindfulness for screen time reduction\n• Emotional regulation techniques\n• Social media psychology research\n\nWhat topic interests you most? I'll find evidence-based articles tailored to your patterns.";
    } else {
      return "I'm your Adaptive Emotional Intelligence assistant - I analyze your usage patterns, recommend emotional vibes, and provide educational resources on digital wellness.\n\n💪 My goal: Awareness through education, improvement through personalization. How can I support your well-being today?";
    }
  }

  void _handleQuickResponse(String response) {
    _sendMessage(response);
  }

  void _toggleVoiceMode() {
    setState(() {
      _isVoiceMode = !_isVoiceMode;
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'CTRL Center',
        variant: CustomAppBarVariant.withBack,
        vibeColor: _themeManager.primaryVibeColor,
      ),
      body: Stack(
        children: [
          // Dynamic background
          Positioned.fill(
            child: DynamicBackgroundWidget(
              primaryColor: _themeManager.primaryVibeColor,
              secondaryColor: _themeManager.secondaryVibeColor,
            ),
          ),

          // Main content
          Column(
            children: [
              // AI Assistant Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: _themeManager.primaryVibeColor
                      .withValues(alpha: 0.1), // Synced color
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            _themeManager.primaryVibeColor, // Synced gradient
                            _themeManager.primaryVibeColor
                                .withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'psychology',
                          color: theme.colorScheme.onPrimary,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CTRL AI Assistant',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Adaptive Emotional Intelligence',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              Container(
                                width: 2.w,
                                height: 2.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isOpenAIAvailable
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.error,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                _isOpenAIAvailable ? 'Online' : 'Limited Mode',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Messages List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  itemCount: _messages.length + (_isAiTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isAiTyping && index == _messages.length) {
                      return const AiTypingIndicatorWidget();
                    }

                    final message = _messages[index];
                    return MessageBubbleWidget(
                      message: message["message"] as String,
                      isUser: message["sender"] == "user",
                      timestamp: message["timestamp"] as DateTime,
                      vibeColor: message["vibeColor"] as Color,
                    );
                  },
                ),
              ),

              // Quick Response Chips
              if (!_isRecording && !_isVoiceMode)
                Container(
                  width: double.infinity,
                  height: 6.h,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickResponses.length,
                    separatorBuilder: (context, index) => SizedBox(width: 2.w),
                    itemBuilder: (context, index) {
                      return QuickResponseChipWidget(
                        label: _quickResponses[index],
                        onTap: () =>
                            _handleQuickResponse(_quickResponses[index]),
                      );
                    },
                  ),
                ),

              // Input Area with synced color
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: _isVoiceMode
                      ? VoiceRecordingWidget(
                          isRecording: _isRecording,
                          onStartRecording: _startRecording,
                          onStopRecording: _stopRecording,
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Container(
                                constraints: BoxConstraints(
                                  minHeight: 6.h,
                                  maxHeight: 15.h,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: TextField(
                                  controller: _messageController,
                                  maxLines: null,
                                  textInputAction: TextInputAction.newline,
                                  style: theme.textTheme.bodyMedium,
                                  decoration: InputDecoration(
                                    hintText: 'Type your message...',
                                    hintStyle:
                                        theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.6),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 1.5.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _themeManager
                                    .primaryVibeColor, // Synced button color
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    if (_messageController.text
                                        .trim()
                                        .isNotEmpty) {
                                      _sendMessage(_messageController.text);
                                      HapticFeedback.lightImpact();
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(50),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'send',
                                      color: theme.colorScheme.onPrimary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
