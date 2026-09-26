import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/employee.dart';
import '../providers/employee_providers.dart';
import 'add_edit_employee_page.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(employee.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditEmployeePage(employee: employee),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Delete Employee'),
                  content: Text('Are you sure you want to delete ${employee.name}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
                        final success = await employeeProvider.deleteEmployee(employee.id);
                        if (success && context.mounted) {
                          Navigator.pop(dialogContext); // Close dialog
                          Navigator.pop(context); // Close details page
                        }
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: (employee.avatar.isNotEmpty && employee.avatar.startsWith('http')) 
                  ? NetworkImage(employee.avatar) 
                  : null,
              child: (employee.avatar.isEmpty || !employee.avatar.startsWith('http')) 
                  ? const Icon(Icons.person, size: 50) 
                  : null,
            ),
            const SizedBox(height: 24),
            _buildInfoTile('Email', employee.email),
            _buildInfoTile('Mobile', employee.mobile),
            _buildInfoTile('Country', employee.country),
            _buildInfoTile('State', employee.state),
            _buildInfoTile('District', employee.district),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value.isNotEmpty ? value : 'N/A'),
          ),
        ],
      ),
    );
  }
}
