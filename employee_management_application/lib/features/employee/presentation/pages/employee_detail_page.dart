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
    final theme = Theme.of(context);
    final isNetworkImage = employee.avatar.isNotEmpty && employee.avatar.startsWith('http');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        elevation: 0,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Employee',
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
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Employee',
            color: theme.colorScheme.error,
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Delete Employee'),
                  content: Text('Are you sure you want to permanently delete ${employee.name}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                      ),
                      onPressed: () async {
                        final employeeProvider = Provider.of<EmployeeProvider>(context, listen: false);
                        final success = await employeeProvider.deleteEmployee(employee.id);
                        if (success && context.mounted) {
                          Navigator.pop(dialogContext); // Close dialog
                          Navigator.pop(context); // Close details page
                        }
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Profile Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              padding: const EdgeInsets.only(bottom: 32, top: 16),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.onPrimaryContainer, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: theme.colorScheme.surface,
                      backgroundImage: isNetworkImage ? NetworkImage(employee.avatar) : null,
                      child: !isNetworkImage 
                          ? Icon(Icons.person, size: 60, color: theme.colorScheme.primary) 
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    employee.name.isNotEmpty ? employee.name : 'Unknown Employee',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee.email.isNotEmpty ? employee.email : 'No email provided',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Detailed Info Card
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    _buildInfoTile(Icons.phone_outlined, 'Mobile Number', employee.mobile),
                    const Divider(height: 1, indent: 64, endIndent: 16),
                    _buildInfoTile(Icons.public_outlined, 'Country', employee.country),
                    const Divider(height: 1, indent: 64, endIndent: 16),
                    _buildInfoTile(Icons.map_outlined, 'State', employee.state),
                    const Divider(height: 1, indent: 64, endIndent: 16),
                    _buildInfoTile(Icons.location_city_outlined, 'District', employee.district),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.blue.shade700),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          value.isNotEmpty ? value : 'Not provided',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
