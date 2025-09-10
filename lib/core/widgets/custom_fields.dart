import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slumber/core/utils/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final bool? enabled;
  final bool isPassword;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final ValueSetter<String>? onSaved;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.inputType,
    this.isPassword = false,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.enabled,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final colors =
        brightness == Brightness.dark ? AppColors.dark : AppColors.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label Text (فوق الفيلد)
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colors.text,
          ),
        ),
        const SizedBox(height: 6),

        /// Input Field
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.inputType,
          obscureText: widget.isPassword ? _obscurePassword : false,
          style: GoogleFonts.inter(fontSize: 16, color: colors.text),
          validator: widget.validator,
          enabled: widget.enabled ?? true,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: colors.secondaryText,
                      ),
                      onPressed:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                    )
                    : null,
          ),
        ),
      ],
    );
  }
}
