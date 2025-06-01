// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// This file contains a prototype for a hospital interface that could be
/// integrated with the hospital's existing systems. It demonstrates how the
/// jaundice diagnosis app could be used in a clinical setting.

class HospitalInterface extends StatefulWidget {
  const HospitalInterface({super.key});

  @override
  _HospitalInterfaceState createState() => _HospitalInterfaceState();
}

class _HospitalInterfaceState extends State<HospitalInterface> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  
  // Mock data for demonstration purposes
  final List<Patient> _patients = [
    Patient(
      id: "P001",
      name: "Baby Smith",
      dob: DateTime.now().subtract(const Duration(days: 5)),
      motherName: "Jane Smith",
      roomNumber: "N-203",
      jaundiceTests: [
        JaundiceTest(
          date: DateTime.now().subtract(const Duration(hours: 12)),
          result: JaundiceResult.positive,
          bilirubinLevel: 15.2,
          notes: "Mild jaundice detected. Scheduled for phototherapy.",
          imageUrl: "assets/images/baby_icon.jpeg",
        ),
      ],
    ),
    Patient(
      id: "P002",
      name: "Baby Johnson",
      dob: DateTime.now().subtract(const Duration(days: 3)),
      motherName: "Mary Johnson",
      roomNumber: "N-105",
      jaundiceTests: [
        JaundiceTest(
          date: DateTime.now().subtract(const Duration(hours: 24)),
          result: JaundiceResult.negative,
          bilirubinLevel: 8.4,
          notes: "No jaundice detected. Regular monitoring advised.",
          imageUrl: "assets/images/baby_icon.jpeg",
        ),
      ],
    ),
    Patient(
      id: "P003",
      name: "Baby Williams",
      dob: DateTime.now().subtract(const Duration(days: 7)),
      motherName: "Sarah Williams",
      roomNumber: "N-118",
      jaundiceTests: [
        JaundiceTest(
          date: DateTime.now().subtract(const Duration(days: 2)),
          result: JaundiceResult.positive,
          bilirubinLevel: 18.7,
          notes: "Moderate jaundice. Currently under phototherapy.",
          imageUrl: "assets/images/baby_icon.jpeg",
        ),
        JaundiceTest(
          date: DateTime.now().subtract(const Duration(hours: 6)),
          result: JaundiceResult.positive,
          bilirubinLevel: 16.2,
          notes: "Improvement noted. Continue phototherapy.",
          imageUrl: "assets/images/baby_icon.jpeg",
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Patient> get _filteredPatients {
    if (_searchQuery.isEmpty) {
      return _patients;
    }
    
    return _patients.where((patient) {
      return patient.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             patient.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             patient.motherName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             patient.roomNumber.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Jaundice Management System'),
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Patients'),
            Tab(icon: Icon(Icons.assessment), text: 'Analytics'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
          indicatorColor: Colors.black,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              _showNotifications(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              _showUserProfile(context);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPatientsTab(),
          _buildAnalyticsTab(),
          _buildSettingsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPatientDialog(context);
        },
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPatientsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search patients...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = "";
                  });
                },
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        Expanded(
          child: _filteredPatients.isEmpty
              ? const Center(child: Text('No patients found'))
              : ListView.builder(
                  itemCount: _filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = _filteredPatients[index];
                    return PatientListItem(
                      patient: patient,
                      onTap: () {
                        _navigateToPatientDetails(context, patient);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jaundice Analytics Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildStatCards(),
          const SizedBox(height: 20),
          _buildWeeklyChart(),
          const SizedBox(height: 20),
          _buildRecentTestsTable(),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total Patients',
            value: _patients.length.toString(),
            icon: Icons.people,
            color: Colors.blue,
          ),
        ),
        Expanded(
          child: _buildStatCard(
            title: 'Positive Cases',
            value: _patients
                .where((p) => p.jaundiceTests.any((t) => t.result == JaundiceResult.positive))
                .length
                .toString(),
            icon: Icons.sick,
            color: Colors.orange,
          ),
        ),
        Expanded(
          child: _buildStatCard(
            title: 'Tests Today',
            value: _patients
                .expand((p) => p.jaundiceTests)
                .where((t) => t.date.day == DateTime.now().day)
                .length
                .toString(),
            icon: Icons.calendar_today,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Weekly Jaundice Cases',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildChartBar('Mon', 0.3, Colors.blue),
                    _buildChartBar('Tue', 0.5, Colors.blue),
                    _buildChartBar('Wed', 0.7, Colors.blue),
                    _buildChartBar('Thu', 0.4, Colors.blue),
                    _buildChartBar('Fri', 0.6, Colors.blue),
                    _buildChartBar('Sat', 0.3, Colors.blue),
                    _buildChartBar('Sun', 0.2, Colors.blue),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartBar(String label, double height, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: 150 * height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  Widget _buildRecentTestsTable() {
    final allTests = _patients
        .expand((p) => p.jaundiceTests.map((t) => MapEntry(p, t)))
        .toList()
      ..sort((a, b) => b.value.date.compareTo(a.value.date));
    
    final recentTests = allTests.take(5).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Tests',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DataTable(
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('Patient')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Result')),
                DataColumn(label: Text('Level')),
              ],
              rows: recentTests.map((entry) {
                final patient = entry.key;
                final test = entry.value;
                return DataRow(
                  cells: [
                    DataCell(Text(patient.name)),
                    DataCell(Text(DateFormat('MM/dd HH:mm').format(test.date))),
                    DataCell(
                      Text(
                        test.result == JaundiceResult.positive ? 'Positive' : 'Negative',
                        style: TextStyle(
                          color: test.result == JaundiceResult.positive
                              ? Colors.red
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataCell(Text('${test.bilirubinLevel} mg/dL')),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Settings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildSettingsSection(
            title: 'Hospital Integration',
            children: [
              _buildSettingItem(
                title: 'Connect to EHR System',
                subtitle: 'Integrate with hospital electronic health records',
                icon: Icons.link,
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              _buildSettingItem(
                title: 'Auto-sync Patient Data',
                subtitle: 'Automatically sync patient data with hospital database',
                icon: Icons.sync,
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            title: 'Notifications',
            children: [
              _buildSettingItem(
                title: 'Critical Alerts',
                subtitle: 'Receive alerts for critical jaundice levels',
                icon: Icons.notifications_active,
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              _buildSettingItem(
                title: 'Daily Reports',
                subtitle: 'Receive daily summary reports',
                icon: Icons.summarize,
                trailing: Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            title: 'Data Management',
            children: [
              _buildSettingItem(
                title: 'Export Data',
                subtitle: 'Export patient data and test results',
                icon: Icons.download,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Show export options dialog
                },
              ),
              _buildSettingItem(
                title: 'Backup Settings',
                subtitle: 'Configure automatic data backups',
                icon: Icons.backup,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Show backup settings dialog
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsSection(
            title: 'System',
            children: [
              _buildSettingItem(
                title: 'Algorithm Sensitivity',
                subtitle: 'Adjust jaundice detection sensitivity',
                icon: Icons.tune,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Show sensitivity adjustment dialog
                },
              ),
              _buildSettingItem(
                title: 'About',
                subtitle: 'Version 1.0.0',
                icon: Icons.info_outline,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Show about dialog
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _navigateToPatientDetails(BuildContext context, Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsScreen(patient: patient),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final motherNameController = TextEditingController();
    final roomController = TextEditingController();
    DateTime? selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Patient'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Baby Name',
                    icon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: motherNameController,
                  decoration: const InputDecoration(
                    labelText: 'Mother Name',
                    icon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: roomController,
                  decoration: const InputDecoration(
                    labelText: 'Room Number',
                    icon: Icon(Icons.meeting_room),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Date of Birth'),
                  subtitle: Text(
                    selectedDate != null
                        ? DateFormat('MM/dd/yyyy').format(selectedDate!)
                        : 'Select date',
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != selectedDate) {
                      selectedDate = picked;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add new patient logic would go here
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Notifications'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildNotificationItem(
                  title: 'Critical Jaundice Level',
                  message: 'Baby Williams has a critical bilirubin level of 18.7 mg/dL',
                  time: '2 hours ago',
                  isUrgent: true,
                ),
                _buildNotificationItem(
                  title: 'New Patient Admitted',
                  message: 'Baby Johnson has been admitted to room N-105',
                  time: '5 hours ago',
                  isUrgent: false,
                ),
                _buildNotificationItem(
                  title: 'Test Results Available',
                  message: 'Jaundice test results for Baby Smith are now available',
                  time: '12 hours ago',
                  isUrgent: false,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required bool isUrgent,
  }) {
    return ListTile(
      leading: Icon(
        isUrgent ? Icons.warning : Icons.notifications,
        color: isUrgent ? Colors.red : Colors.blue,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      isThreeLine: true,
    );
  }

  void _showUserProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('User Profile'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              SizedBox(height: 16),
              Text(
                'Dr. Sarah Johnson',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Pediatrician'),
              SizedBox(height: 16),
              Divider(),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('Email'),
                subtitle: Text('sarah.johnson@hospital.org'),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Phone'),
                subtitle: Text('(555) 123-4567'),
              ),
              ListTile(
                leading: Icon(Icons.badge),
                title: Text('ID'),
                subtitle: Text('DOC-2023-456'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Log out logic would go here
                Navigator.of(context).pop();
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}

class PatientListItem extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;

  const PatientListItem({
    super.key,
    required this.patient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final latestTest = patient.jaundiceTests.isNotEmpty
        ? patient.jaundiceTests.reduce((a, b) => a.date.isAfter(b.date) ? a : b)
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: latestTest?.result == JaundiceResult.positive
              ? Colors.orange
              : Colors.green,
          child: Text(
            patient.name.substring(0, 1),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(patient.name),
        subtitle: Text(
          'ID: ${patient.id} • Room: ${patient.roomNumber} • Age: ${_calculateAge(patient.dob)}',
        ),
        trailing: latestTest != null
            ? Chip(
                label: Text(
                  latestTest.result == JaundiceResult.positive
                      ? 'Positive'
                      : 'Negative',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: latestTest.result == JaundiceResult.positive
                    ? Colors.red
                    : Colors.green,
              )
            : const Text('No tests'),
        onTap: onTap,
      ),
    );
  }

  String _calculateAge(DateTime dob) {
    final now = DateTime.now();
    final difference = now.difference(dob);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours';
    } else {
      return '${difference.inMinutes} minutes';
    }
  }
}

class PatientDetailsScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailsScreen({
    super.key,
    required this.patient,
  });

  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name),
        backgroundColor: Colors.blue[800],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Test History'),
            Tab(text: 'Treatment'),
          ],
          indicatorColor: Colors.white,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildTestHistoryTab(),
          _buildTreatmentTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTestDialog(context);
        },
        backgroundColor: Colors.blue[800],
        tooltip: 'New Jaundice Test',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPatientInfoCard(),
          const SizedBox(height: 16),
          _buildLatestTestCard(),
          const SizedBox(height: 16),
          _buildVitalSignsCard(),
          const SizedBox(height: 16),
          _buildNotesCard(),
        ],
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Patient ID', widget.patient.id),
            _buildInfoRow('Date of Birth', DateFormat('MM/dd/yyyy').format(widget.patient.dob)),
            _buildInfoRow('Age', _calculateAge(widget.patient.dob)),
            _buildInfoRow('Mother\'s Name', widget.patient.motherName),
            _buildInfoRow('Room Number', widget.patient.roomNumber),
            _buildInfoRow('Admission Date', DateFormat('MM/dd/yyyy').format(widget.patient.dob)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestTestCard() {
    final latestTest = widget.patient.jaundiceTests.isNotEmpty
        ? widget.patient.jaundiceTests.reduce((a, b) => a.date.isAfter(b.date) ? a : b)
        : null;

    if (latestTest == null) {
      return const Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No jaundice tests recorded'),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Latest Test Result',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    latestTest.result == JaundiceResult.positive
                        ? 'Positive'
                        : 'Negative',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: latestTest.result == JaundiceResult.positive
                      ? Colors.red
                      : Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Date', DateFormat('MM/dd/yyyy HH:mm').format(latestTest.date)),
                      _buildInfoRow('Bilirubin Level', '${latestTest.bilirubinLevel} mg/dL'),
                      _buildInfoRow('Notes', latestTest.notes),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    latestTest.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalSignsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vital Signs',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Temperature', '36.8°C'),
            _buildInfoRow('Heart Rate', '120 bpm'),
            _buildInfoRow('Respiratory Rate', '40 breaths/min'),
            _buildInfoRow('Weight', '3.2 kg'),
            _buildInfoRow('Last Updated', DateFormat('MM/dd/yyyy HH:mm').format(DateTime.now())),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Clinical Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Add new note logic
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildNoteItem(
              author: 'Dr. Sarah Johnson',
              date: DateTime.now().subtract(const Duration(hours: 2)),
              content: 'Patient showing signs of mild jaundice. Scheduled for phototherapy starting today.',
            ),
            _buildNoteItem(
              author: 'Nurse Michael Brown',
              date: DateTime.now().subtract(const Duration(hours: 6)),
              content: 'Vital signs stable. Patient feeding well.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteItem({
    required String author,
    required DateTime date,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                author,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('MM/dd/yyyy HH:mm').format(date),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(content),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildTestHistoryTab() {
    final sortedTests = List<JaundiceTest>.from(widget.patient.jaundiceTests)
      ..sort((a, b) => b.date.compareTo(a.date));

    return sortedTests.isEmpty
        ? const Center(child: Text('No test history available'))
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: sortedTests.length,
            itemBuilder: (context, index) {
              final test = sortedTests[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Test #${widget.patient.jaundiceTests.length - index}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            label: Text(
                              test.result == JaundiceResult.positive
                                  ? 'Positive'
                                  : 'Negative',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: test.result == JaundiceResult.positive
                                ? Colors.red
                                : Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Date', DateFormat('MM/dd/yyyy HH:mm').format(test.date)),
                                _buildInfoRow('Bilirubin Level', '${test.bilirubinLevel} mg/dL'),
                                _buildInfoRow('Notes', test.notes),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              test.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget _buildTreatmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCurrentTreatmentCard(),
          const SizedBox(height: 16),
          _buildTreatmentHistoryCard(),
          const SizedBox(height: 16),
          _buildRecommendationsCard(),
        ],
      ),
    );
  }

  Widget _buildCurrentTreatmentCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current Treatment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    'Active',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Treatment Type', 'Phototherapy'),
            _buildInfoRow('Started', DateFormat('MM/dd/yyyy HH:mm').format(DateTime.now().subtract(const Duration(hours: 6)))),
            _buildInfoRow('Duration', '6 hours (ongoing)'),
            _buildInfoRow('Intensity', 'Medium'),
            _buildInfoRow('Location', 'NICU Room ${widget.patient.roomNumber}'),
            _buildInfoRow('Attending Physician', 'Dr. Sarah Johnson'),
            const SizedBox(height: 16),
            const Text(
              'Notes:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Patient responding well to phototherapy. Continue treatment for 24 hours and reassess.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentHistoryCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Treatment History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTreatmentHistoryItem(
              type: 'Blood Test',
              date: DateTime.now().subtract(const Duration(hours: 12)),
              notes: 'Initial blood test to measure bilirubin levels.',
              status: 'Completed',
            ),
            _buildTreatmentHistoryItem(
              type: 'Clinical Assessment',
              date: DateTime.now().subtract(const Duration(hours: 8)),
              notes: 'Visual assessment of jaundice by pediatrician.',
              status: 'Completed',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentHistoryItem({
    required String type,
    required DateTime date,
    required String notes,
    required String status,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Chip(
                label: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: status == 'Completed' ? Colors.green : Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Date: ${DateFormat('MM/dd/yyyy HH:mm').format(date)}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(notes),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecommendationItem(
              title: 'Continue Phototherapy',
              description: 'Continue phototherapy for 24 hours and reassess bilirubin levels.',
              priority: 'High',
            ),
            _buildRecommendationItem(
              title: 'Increase Feeding Frequency',
              description: 'Increase feeding frequency to help eliminate bilirubin through stool.',
              priority: 'Medium',
            ),
            _buildRecommendationItem(
              title: 'Monitor Hydration',
              description: 'Monitor hydration status and ensure adequate fluid intake.',
              priority: 'Medium',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem({
    required String title,
    required String description,
    required String priority,
  }) {
    Color priorityColor;
    switch (priority) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 12, color: priorityColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                priority,
                style: TextStyle(
                  color: priorityColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(description),
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _showAddTestDialog(BuildContext context) {
    final notesController = TextEditingController();
    double bilirubinLevel = 10.0;
    JaundiceResult result = JaundiceResult.negative;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Jaundice Test'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Bilirubin Level (mg/dL)'),
                    Slider(
                      value: bilirubinLevel,
                      min: 0,
                      max: 25,
                      divisions: 50,
                      label: bilirubinLevel.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          bilirubinLevel = value;
                          result = bilirubinLevel > 12.0
                              ? JaundiceResult.positive
                              : JaundiceResult.negative;
                        });
                      },
                    ),
                    Text(
                      '${bilirubinLevel.toStringAsFixed(1)} mg/dL',
                      style: TextStyle(
                        color: bilirubinLevel > 12.0 ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Result:'),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            result == JaundiceResult.positive
                                ? 'Positive'
                                : 'Negative',
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: result == JaundiceResult.positive
                              ? Colors.red
                              : Colors.green,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Logic to take a photo would go here
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Add new test logic would go here
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _calculateAge(DateTime dob) {
    final now = DateTime.now();
    final difference = now.difference(dob);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours';
    } else {
      return '${difference.inMinutes} minutes';
    }
  }
}

// Data Models
enum JaundiceResult { positive, negative }

class JaundiceTest {
  final DateTime date;
  final JaundiceResult result;
  final double bilirubinLevel;
  final String notes;
  final String imageUrl;

  JaundiceTest({
    required this.date,
    required this.result,
    required this.bilirubinLevel,
    required this.notes,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'result': result == JaundiceResult.positive ? 'positive' : 'negative',
      'bilirubinLevel': bilirubinLevel,
      'notes': notes,
      'imageUrl': imageUrl,
    };
  }

  factory JaundiceTest.fromJson(Map<String, dynamic> json) {
    return JaundiceTest(
      date: DateTime.parse(json['date']),
      result: json['result'] == 'positive' ? JaundiceResult.positive : JaundiceResult.negative,
      bilirubinLevel: json['bilirubinLevel'],
      notes: json['notes'],
      imageUrl: json['imageUrl'],
    );
  }
}

class Patient {
  final String id;
  final String name;
  final DateTime dob;
  final String motherName;
  final String roomNumber;
  final List<JaundiceTest> jaundiceTests;

  Patient({
    required this.id,
    required this.name,
    required this.dob,
    required this.motherName,
    required this.roomNumber,
    required this.jaundiceTests,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dob': dob.toIso8601String(),
      'motherName': motherName,
      'roomNumber': roomNumber,
      'jaundiceTests': jaundiceTests.map((test) => test.toJson()).toList(),
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      dob: DateTime.parse(json['dob']),
      motherName: json['motherName'],
      roomNumber: json['roomNumber'],
      jaundiceTests: (json['jaundiceTests'] as List)
          .map((testJson) => JaundiceTest.fromJson(testJson))
          .toList(),
    );
  }
}