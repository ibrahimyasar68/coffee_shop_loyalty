import 'package:coffee_shop_loyalty/l10n/app_localizations.dart';
import 'package:coffee_shop_loyalty/screens/admin_screen.dart';
import 'package:coffee_shop_loyalty/theme/app_theme.dart';
import 'package:coffee_shop_loyalty/widgets/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

/// Admin paneline erişmeden önce gösterilen PIN kapısı.
///
/// İlk açılışta PIN tanımlı değilse kullanıcı 4 haneli bir PIN belirler
/// (onaylı kurulum). Sonraki girişlerde aynı PIN sorulur. PIN doğruysa
/// [AdminScreen] ile değiştirilir (pushReplacement), böylece geri tuşu
/// doğrudan admin paneline düşürmez.
///
/// Not: Bu yerel-yalnızca bir uygulama olduğundan PIN, cihazdaki Hive
/// kutusunda saklanır. Kriptografik bir koruma değildir; amaç gündelik
/// erişimi (yetkisiz ürün/üye değişikliği) engellemektir.
class AdminGateScreen extends StatefulWidget {
  const AdminGateScreen({super.key});

  @override
  State<AdminGateScreen> createState() => _AdminGateScreenState();
}

class _AdminGateScreenState extends State<AdminGateScreen> {
  static const _pinKey = 'admin_pin';
  static const _pinLength = 4;

  /// PIN unutulduğunda sıfırlamayı yetkilendiren kurtarma kodu.
  /// Arka uç olmadığından bu sabit, "ana anahtar" görevi görür —
  /// işletme bunu kuruluma özel bir değerle değiştirmelidir.
  static const _recoveryCode = 'COFFEE-RESET-2024';

  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  Box get _settings => Hive.box('settings_box');

  bool get _isSetupMode => _settings.get(_pinKey) == null;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final l = AppLocalizations.of(context);
    final pin = _pinController.text.trim();

    if (pin.length != _pinLength) {
      setState(() => _error = l.pinLengthError(_pinLength));
      return;
    }

    if (_isSetupMode) {
      // Kurulum: PIN + onay eşleşmeli
      if (pin != _confirmController.text.trim()) {
        setState(() => _error = l.pinMismatch);
        return;
      }
      _settings.put(_pinKey, pin);
      _enterAdmin();
      return;
    }

    // Doğrulama
    if (pin == _settings.get(_pinKey)) {
      _enterAdmin();
    } else {
      setState(() {
        _error = l.pinWrong;
        _pinController.clear();
      });
    }
  }

  void _enterAdmin() {
    Navigator.pushReplacement(
      context,
      fadeThroughRoute(const AdminScreen()),
    );
  }

  // PIN sıfırlama — kurtarma kodu doğrulanırsa kayıtlı PIN silinir ve
  // ekran kurulum moduna döner (kullanıcı yeni PIN belirler).
  Future<void> _resetPin() async {
    final l = AppLocalizations.of(context);
    final codeCtrl = TextEditingController();

    final reset = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        String? error;
        return StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: Text(l.resetPinTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l.recoveryPrompt,
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: codeCtrl,
                  autofocus: true,
                  decoration: InputDecoration(labelText: l.recoveryCode),
                ),
                if (error != null) ...[
                  const SizedBox(height: 8),
                  Text(error!,
                      style: const TextStyle(
                          color: Colors.redAccent, fontSize: 13)),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l.cancel),
              ),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(88, 40)),
                onPressed: () {
                  if (codeCtrl.text.trim() == _recoveryCode) {
                    Navigator.pop(ctx, true);
                  } else {
                    setLocal(() => error = l.recoveryCodeWrong);
                  }
                },
                child: Text(l.reset),
              ),
            ],
          ),
        );
      },
    );

    if (reset == true) {
      await _settings.delete(_pinKey);
      if (!mounted) return;
      setState(() {
        _pinController.clear();
        _confirmController.clear();
        _error = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.pinResetDone)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final setup = _isSetupMode;

    return Scaffold(
      appBar:
          AppBar(title: Text(setup ? l.adminCreatePin : l.adminLogin)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline,
                  size: 64, color: AppColors.mocha),
              const SizedBox(height: 16),
              Text(
                setup ? l.pinSetupPrompt : l.pinEnterPrompt,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted, fontSize: 14),
              ),
              const SizedBox(height: 28),
              _pinField(
                controller: _pinController,
                label: setup ? l.newPin : l.pin,
                autofocus: true,
                onSubmitted: setup ? null : (_) => _submit(),
              ),
              if (setup) ...[
                const SizedBox(height: 16),
                _pinField(
                  controller: _confirmController,
                  label: l.pinRepeat,
                  onSubmitted: (_) => _submit(),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style: const TextStyle(
                        color: Colors.redAccent, fontSize: 13)),
              ],
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: _submit,
                child: Text(setup ? l.createAndEnter : l.signIn),
              ),
              if (!setup) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _resetPin,
                  child: Text(l.forgotPin),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _pinField({
    required TextEditingController controller,
    required String label,
    bool autofocus = false,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      obscureText: true,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: _pinLength,
      style: const TextStyle(fontSize: 22, letterSpacing: 8),
      decoration: InputDecoration(labelText: label, counterText: ''),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (_) {
        if (_error != null) setState(() => _error = null);
      },
      onSubmitted: onSubmitted,
    );
  }
}
