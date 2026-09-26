import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/employee.dart';
import '../providers/employee_providers.dart';
import '../../data/repositories/employee_repository_impl.dart';

class AddEditEmployeePage extends StatefulWidget {
  final Employee? employee;

  const AddEditEmployeePage({super.key, this.employee});

  @override
  State<AddEditEmployeePage> createState() => _AddEditEmployeePageState();
}

class _AddEditEmployeePageState extends State<AddEditEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name);
    _emailController = TextEditingController(text: widget.employee?.email);
    _mobileController = TextEditingController(text: widget.employee?.mobile);
    _countryController = TextEditingController(text: widget.employee?.country);
    _stateController = TextEditingController(text: widget.employee?.state);
    _districtController = TextEditingController(text: widget.employee?.district);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final employee = Employee(
        id: widget.employee?.id ?? '',
        name: _nameController.text,
        email: _emailController.text,
        mobile: _mobileController.text,
        country: _countryController.text,
        state: _stateController.text,
        district: _districtController.text,
        avatar: widget.employee?.avatar ?? '',
      );

      final repository = Provider.of<EmployeeRepositoryImpl>(context, listen: false);
      
      if (widget.employee == null) {
        await repository.createEmployee(employee);
      } else {
        await repository.updateEmployee(employee);
      }

      if (mounted) {
        Provider.of<EmployeeProvider>(context, listen: false).fetchEmployees();
        
        Navigator.pop(context);
        if (widget.employee != null) {
          // If editing, pop twice to go back to dashboard so data refreshes correctly
          Navigator.pop(context); 
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.employee != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Employee' : 'Add Employee'),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter an email';
                        if (!value.contains('@')) return 'Please enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mobileController,
                      decoration: const InputDecoration(labelText: 'Mobile', border: OutlineInputBorder()),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a mobile number' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(labelText: 'Country', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a country' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(labelText: 'State', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a state' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _districtController,
                      decoration: const InputDecoration(labelText: 'District', border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a district' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _saveForm,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                      child: const Text('Save Employee'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
