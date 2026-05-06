import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    required this.api,
    required this.onAuthenticated,
    super.key,
  });

  final ApiService api;
  final VoidCallback onAuthenticated;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _role = UserRole.admin;
  var _isSignup = false;
  var _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      if (_isSignup) {
        await widget.api.signup(
          username: _username.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
          role: _role.value,
        );
      }
      await widget.api.login(_username.text.trim(), _password.text);
      widget.onAuthenticated();
    } catch (error) {
      setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Truck & Trailer Repair',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _username,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 12),
                    if (_isSignup) ...[
                      TextField(
                        controller: _email,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<UserRole>(
                        value: _role,
                        decoration: const InputDecoration(labelText: 'Role'),
                        items: UserRole.values
                            .map(
                              (role) => DropdownMenuItem(
                                value: role,
                                child: Text(role.value),
                              ),
                            )
                            .toList(),
                        onChanged: (role) {
                          if (role != null) setState(() => _role = role);
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                    TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _isLoading ? null : _submit,
                      child: Text(_isSignup ? 'Create account' : 'Sign in'),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isSignup = !_isSignup),
                      child: Text(_isSignup ? 'Use existing account' : 'Create account'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
