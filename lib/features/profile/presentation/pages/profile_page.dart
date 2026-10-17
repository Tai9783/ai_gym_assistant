import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_profile.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _primaryColor = Color(0xFF5C63F6);
  static const _backgroundColor = Color(0xFFF8F9FC);
  static const _borderColor = Color(0xFFE8EAF0);

  static const _goalNames = {
    'muscleGain': 'Tăng cơ',
    'fatLoss': 'Giảm mỡ',
    'strength': 'Tăng sức mạnh',
  };

  final _formKey = GlobalKey<FormState>();

  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  UserProfile? _profile;
  String? _selectedGoal;

  bool _hasLoaded = false;
  bool _isEditing = false;
  bool _goalError = false;

  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(const ProfileLoadRequested());
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _setProfile(UserProfile? profile) {
    _profile = profile;
    _selectedGoal = profile?.goal;

    _weightController.text = profile?.weightKg?.toString() ?? '';

    _heightController.text = profile?.heightCm?.toString() ?? '';

    _ageController.text = profile?.age?.toString() ?? '';

    _goalError = false;
  }

  void _startEditing() {
    setState(() {
      _setProfile(_profile);
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _setProfile(_profile);
      _isEditing = false;
    });
  }

  double? _parseDouble(String value) {
    final text = value.trim().replaceAll(',', '.');

    if (text.isEmpty) return null;

    return double.tryParse(text);
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final number = _parseDouble(value);

    if (number == null || !number.isFinite || number <= 0) {
      return 'Vui lòng nhập số hợp lệ';
    }

    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final age = int.tryParse(value.trim());

    if (age == null || age <= 0) {
      return 'Vui lòng nhập tuổi hợp lệ';
    }

    return null;
  }

  void _saveProfile() {
    final isValid = _formKey.currentState!.validate();

    setState(() {
      _goalError = _selectedGoal == null;
    });

    if (!isValid || _selectedGoal == null) {
      return;
    }

    FocusScope.of(context).unfocus();

    final profile = UserProfile(
      goal: _selectedGoal!,
      weightKg: _parseDouble(_weightController.text),
      heightCm: _parseDouble(_heightController.text),
      age: _ageController.text.trim().isEmpty
          ? null
          : int.parse(_ageController.text.trim()),
    );

    context.read<ProfileBloc>().add(ProfileSaveRequested(profile));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text(
          'AI Gym Assistant',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            setState(() {
              _setProfile(state.profile);
              _hasLoaded = true;
              _isEditing = state.profile == null;
            });
          }

          if (state is ProfileSaved) {
            setState(() {
              _setProfile(state.profile);
              _isEditing = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã lưu hồ sơ thành công')),
            );
          }

          if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _hasLoaded ? 'Không thể lưu hồ sơ' : 'Không thể tải hồ sơ',
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (!_hasLoaded) {
            if (state is ProfileFailure) {
              return Center(
                child: FilledButton(
                  onPressed: () {
                    context.read<ProfileBloc>().add(
                      const ProfileLoadRequested(),
                    );
                  },
                  child: const Text('Thử lại'),
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }

          final isSaving = state is ProfileSaving;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                _isEditing
                    ? (_profile == null ? 'Thiết lập hồ sơ' : 'Chỉnh sửa hồ sơ')
                    : 'Hồ sơ cá nhân',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF252836),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                _isEditing
                    ? 'Cập nhật thông tin để AI đề xuất '
                          'buổi tập phù hợp với bạn.'
                    : 'Thông tin cá nhân và mục tiêu '
                          'tập luyện của bạn.',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),

              const SizedBox(height: 20),

              if (_isEditing)
                _buildEditForm(isSaving)
              else
                _buildProfileDetails(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileDetails() {
    final profile = _profile!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF0EFFF),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 36,
                  color: _primaryColor,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Mục tiêu tập luyện',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),

              const SizedBox(height: 6),

              Text(
                _goalNames[profile.goal] ?? profile.goal,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF35338F),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _buildSection(
          title: 'Thông tin cơ bản',
          icon: Icons.badge_outlined,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Cân nặng',
                    value: profile.weightKg?.toString() ?? '--',
                    unit: 'kg',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.height_rounded,
                    label: 'Chiều cao',
                    value: profile.heightCm?.toString() ?? '--',
                    unit: 'cm',
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.cake_outlined,
                    label: 'Tuổi',
                    value: profile.age?.toString() ?? '--',
                    unit: 'tuổi',
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 20),

        SizedBox(
          height: 50,
          child: FilledButton.icon(
            onPressed: _startEditing,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Chỉnh sửa hồ sơ'),
            style: FilledButton.styleFrom(
              backgroundColor: _primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'Thông tin này giúp AI hiểu mục tiêu '
          'và cá nhân hóa bài tập cho bạn.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildEditForm(bool isSaving) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSection(
            title: 'Mục tiêu tập luyện',
            icon: Icons.flag_outlined,
            children: [
              const Text(
                'Bạn muốn đạt được điều gì?',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _goalNames.entries.map((entry) {
                  final selected = _selectedGoal == entry.key;

                  return ChoiceChip(
                    label: Text(entry.value),
                    selected: selected,
                    selectedColor: const Color(0xFFECEBFF),
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: selected ? _primaryColor : _borderColor,
                    ),
                    labelStyle: TextStyle(
                      color: selected ? _primaryColor : const Color(0xFF333544),
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    onSelected: isSaving
                        ? null
                        : (_) {
                            setState(() {
                              _selectedGoal = entry.key;
                              _goalError = false;
                            });
                          },
                  );
                }).toList(),
              ),

              if (_goalError) ...[
                const SizedBox(height: 8),
                const Text(
                  'Vui lòng chọn mục tiêu',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),

          const SizedBox(height: 14),

          _buildSection(
            title: 'Thông tin cơ bản',
            icon: Icons.person_outline,
            children: [
              _buildNumberField(
                controller: _weightController,
                label: 'Cân nặng (kg)',
                hint: 'Ví dụ: 65.5',
                icon: Icons.monitor_weight_outlined,
                isSaving: isSaving,
                validator: _validateNumber,
              ),

              const SizedBox(height: 14),

              _buildNumberField(
                controller: _heightController,
                label: 'Chiều cao (cm)',
                hint: 'Ví dụ: 170',
                icon: Icons.height_rounded,
                isSaving: isSaving,
                validator: _validateNumber,
              ),

              const SizedBox(height: 14),

              _buildNumberField(
                controller: _ageController,
                label: 'Tuổi',
                hint: 'Ví dụ: 22',
                icon: Icons.cake_outlined,
                isSaving: isSaving,
                isInteger: true,
                validator: _validateAge,
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            'Cân nặng, chiều cao và tuổi có thể '
            'để trống nếu bạn chưa muốn cung cấp.',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),

          const SizedBox(height: 22),

          SizedBox(
            height: 50,
            child: FilledButton.icon(
              onPressed: isSaving ? null : _saveProfile,
              icon: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(isSaving ? 'Đang lưu...' : 'Lưu thông tin'),
              style: FilledButton.styleFrom(
                backgroundColor: _primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          if (_profile != null) ...[
            const SizedBox(height: 10),
            TextButton(
              onPressed: isSaving ? null : _cancelEditing,
              child: const Text('Hủy chỉnh sửa'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 19, color: _primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: _primaryColor, size: 22),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            unit,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isSaving,
    required String? Function(String?) validator,
    bool isInteger = false,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !isSaving,
      keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }
}
