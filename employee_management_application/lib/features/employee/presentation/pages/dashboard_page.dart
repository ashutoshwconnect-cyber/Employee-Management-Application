import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/employee_providers.dart';
import 'add_edit_employee_page.dart';
import 'employee_detail_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => employeeProvider.fetchEmployees(),
        child: _buildBody(employeeProvider),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditEmployeePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(EmployeeProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    }

    if (provider.employees.isEmpty) {
      return const Center(child: Text('No employees found.'));
    }

    return ListView.builder(
      itemCount: provider.employees.length,
      itemBuilder: (context, index) {
        final emp = provider.employees[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: (emp.avatar.isNotEmpty && emp.avatar.startsWith('http')) 
                ? NetworkImage(emp.avatar) 
                : null,
            child: (emp.avatar.isEmpty || !emp.avatar.startsWith('http')) 
                ? Text(emp.name.isNotEmpty ? emp.name[0].toUpperCase() : '?') 
                : null,
          ),
          title: Text(emp.name),
          subtitle: Text(emp.email),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeDetailPage(employee: emp),
              ),
            );
          },
        );
      },
    );
  }
}
