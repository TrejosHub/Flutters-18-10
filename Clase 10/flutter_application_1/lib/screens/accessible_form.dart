import 'package:flutter/material.dart';
import '../widgets/accessible_button.dart';
import '../utils/accessibility_utils.dart' as a11y;

class AccessibleFormScreen extends StatefulWidget {
  const AccessibleFormScreen({super.key});

  @override
  State<AccessibleFormScreen> createState() => _AccessibleFormScreenState();
}

class _AccessibleFormScreenState extends State<AccessibleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController(); // ✅ Nuevo campo

  bool _isLoading = false;
  double _fontSize = 16.0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose(); // ✅ Se libera correctamente
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        a11y.AccessibilityUtils.showAccessibleSnackBar(
          context,
          'Formulario enviado correctamente',
        );
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear(); // ✅ Se limpia también dirección
    a11y.AccessibilityUtils.showAccessibleSnackBar(
      context,
      'Formulario limpiado',
    );
  }

  void _increaseFontSize() {
    setState(() {
      _fontSize += 2.0;
      if (_fontSize > 24.0) _fontSize = 24.0;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize -= 2.0;
      if (_fontSize < 14.0) _fontSize = 14.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('Formulario Accesible'),
        ),
        actions: [
          IconButton(
            onPressed: _increaseFontSize,
            icon: const Icon(Icons.zoom_in),
            tooltip: 'Aumentar tamaño de texto',
          ),
          IconButton(
            onPressed: _decreaseFontSize,
            icon: const Icon(Icons.zoom_out),
            tooltip: 'Disminuir tamaño de texto',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Semantics(
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: const Text(
                    'Complete sus datos',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),

                // ===== Campo de Nombre =====
                _buildTextField(
                  controller: _nameController,
                  label: 'Nombre Completo',
                  hint: 'Ingrese su nombre y apellido',
                  icon: Icons.person,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Ingrese su nombre'
                              : null,
                ),

                const SizedBox(height: 16),

                // ===== Campo de Email =====
                _buildTextField(
                  controller: _emailController,
                  label: 'Correo Electrónico',
                  hint: 'ejemplo@correo.com',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Ingrese un email válido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ===== Campo de Teléfono =====
                _buildTextField(
                  controller: _phoneController,
                  label: 'Teléfono',
                  hint: '+1234567890',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Ingrese su teléfono'
                              : null,
                ),

                const SizedBox(height: 16),

                // ===== Campo de Dirección ===== ✅ Nuevo
                Semantics(
                  textField: true,
                  label: 'Campo de dirección',
                  hint: 'Ingrese su dirección completa (mínimo 10 caracteres)',
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Dirección',
                      hintText: 'Calle 123 #45-67, Ciudad',
                      prefixIcon: const Icon(Icons.location_on),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: TextStyle(fontSize: _fontSize),
                    validator: a11y.AccessibilityUtils.validateAddress,
                  ),
                ),

                const SizedBox(height: 32),

                AccessibleButton(
                  onPressed: _isLoading ? null : _submitForm,
                  text: _isLoading ? 'Enviando...' : 'Enviar Formulario',
                  icon: _isLoading ? Icons.hourglass_top : Icons.send,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: _fontSize,
                ),
                const SizedBox(height: 16),

                _buildAccessibilityInfo(),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: Semantics(
        button: true,
        label: 'Limpiar formulario',
        child: FloatingActionButton(
          onPressed: _clearForm,
          tooltip: 'Limpiar formulario',
          backgroundColor: Colors.orange,
          child: const Icon(Icons.cleaning_services),
        ),
      ),
    );
  }

  // ====== Widgets auxiliares ======

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Semantics(
      textField: true,
      label: label,
      hint: hint,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: keyboardType,
        style: TextStyle(fontSize: _fontSize),
        validator: validator,
      ),
    );
  }

  Widget _buildAccessibilityInfo() {
    return Semantics(
      container: true,
      label:
          'Información sobre accesibilidad. Esta aplicación incluye características '
          'para usuarios con discapacidades visuales y motoras.',
      child: Card(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Características Accesibles:',
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              _buildFeatureItem('✓ Tamaño de texto ajustable'),
              _buildFeatureItem('✓ Navegación por voz compatible'),
              _buildFeatureItem('✓ Alto contraste disponible'),
              _buildFeatureItem('✓ Etiquetas descriptivas'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text, style: TextStyle(fontSize: _fontSize - 2)),
    );
  }
}
